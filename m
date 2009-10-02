Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZJBBdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZJBBdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbZJBBda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:30 -0400
Received: from kroah.org ([198.145.64.141]:33221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbZJBBdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:16 2009
Message-Id: <20091002012416.480930720@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Anholt <eric@anholt.net>, Brice Goglin <Brice.Goglin@ens-lyon.org>
Subject: [066/136] agp/intel: Fix the pre-9xx chipset flush.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=agp-intel-fix-the-pre-9xx-chipset-flush.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Anholt <eric@anholt.net>

commit e517a5e97080bbe52857bd0d7df9b66602d53c4d upstream.

Ever since we enabled GEM, the pre-9xx chipsets (particularly 865) have had
serious stability issues.  Back in May a wbinvd was added to the DRM to
work around much of the problem.  Some failure remained -- easily visible
by dragging a window around on an X -retro desktop, or by looking at bugzilla.

The chipset flush was on the right track -- hitting the right amount of
memory, and it appears to be the only way to flush on these chipsets, but the
flush page was mapped uncached.  As a result, the writes trying to clear the
writeback cache ended up bypassing the cache, and not flushing anything!  The
wbinvd would flush out other writeback data and often cause the data we wanted
to get flushed, but not always.  By removing the setting of the page to UC
and instead just clflushing the data we write to try to flush it, we get the
desired behavior with no wbinvd.

This exports clflush_cache_range(), which was laying around and happened to
basically match the code I was otherwise going to copy from the DRM.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Brice Goglin <Brice.Goglin@ens-lyon.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr.c          |    1 +
 drivers/char/agp/intel-agp.c    |   30 +++++++++++++++++++++++-------
 drivers/gpu/drm/i915/i915_gem.c |   10 ----------
 3 files changed, 24 insertions(+), 17 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -143,6 +143,7 @@ void clflush_cache_range(void *vaddr, un
 
 	mb();
 }
+EXPORT_SYMBOL_GPL(clflush_cache_range);
 
 static void __cpa_flush_all(void *arg)
 {
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -679,23 +679,39 @@ static void intel_i830_setup_flush(void)
 	if (!intel_private.i8xx_page)
 		return;
 
-	/* make page uncached */
-	map_page_into_agp(intel_private.i8xx_page);
-
 	intel_private.i8xx_flush_page = kmap(intel_private.i8xx_page);
 	if (!intel_private.i8xx_flush_page)
 		intel_i830_fini_flush();
 }
 
+static void
+do_wbinvd(void *null)
+{
+	wbinvd();
+}
+
+/* The chipset_flush interface needs to get data that has already been
+ * flushed out of the CPU all the way out to main memory, because the GPU
+ * doesn't snoop those buffers.
+ *
+ * The 8xx series doesn't have the same lovely interface for flushing the
+ * chipset write buffers that the later chips do. According to the 865
+ * specs, it's 64 octwords, or 1KB.  So, to get those previous things in
+ * that buffer out, we just fill 1KB and clflush it out, on the assumption
+ * that it'll push whatever was in there out.  It appears to work.
+ */
 static void intel_i830_chipset_flush(struct agp_bridge_data *bridge)
 {
 	unsigned int *pg = intel_private.i8xx_flush_page;
-	int i;
 
-	for (i = 0; i < 256; i += 2)
-		*(pg + i) = i;
+	memset(pg, 0, 1024);
 
-	wmb();
+	if (cpu_has_clflush) {
+		clflush_cache_range(pg, 1024);
+	} else {
+		if (on_each_cpu(do_wbinvd, NULL, 1) != 0)
+			printk(KERN_ERR "Timed out waiting for cache flush.\n");
+	}
 }
 
 /* The intel i830 automatically initializes the agp aperture during POST.
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2505,16 +2505,6 @@ i915_gem_clflush_object(struct drm_gem_o
 	if (obj_priv->pages == NULL)
 		return;
 
-	/* XXX: The 865 in particular appears to be weird in how it handles
-	 * cache flushing.  We haven't figured it out, but the
-	 * clflush+agp_chipset_flush doesn't appear to successfully get the
-	 * data visible to the PGU, while wbinvd + agp_chipset_flush does.
-	 */
-	if (IS_I865G(obj->dev)) {
-		wbinvd();
-		return;
-	}
-
 	drm_clflush_pages(obj_priv->pages, obj->size / PAGE_SIZE);
 }
 


