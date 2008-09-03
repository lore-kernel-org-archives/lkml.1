Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYICRcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYICRcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYICRcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:32:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:50258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbYICRcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:32:41 -0400
Date: Wed, 3 Sep 2008 10:25:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ian Campbell <ijc@hellion.org.uk>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [patch 04/42] fbdefio: add set_page_dirty handler to deferred IO FB
Message-ID: <20080903172522.GE7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fbdefio-add-set_page_dirty-handler-to-deferred-io-fb.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ijc@hellion.org.uk>

commit d847471d063663b9f36927d265c66a270c0cfaab upstream

Fixes kernel BUG at lib/radix-tree.c:473.

Previously the handler was incidentally provided by tmpfs but this was
removed with:

  commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
  Author: Hugh Dickins <hugh@veritas.com>
  Date:   Mon Jul 28 15:46:19 2008 -0700

    tmpfs: fix kernel BUG in shmem_delete_inode

relying on this behaviour was incorrect in any case and the BUG also
appeared when the device node was on an ext3 filesystem.

v2: override a_ops at open() time rather than mmap() time to minimise
races per AKPM's concerns.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kel Modderman <kel@otaku42.de>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/fb_defio.c |   19 +++++++++++++++++++
 drivers/video/fbmem.c    |    4 ++++
 include/linux/fb.h       |    3 +++
 3 files changed, 26 insertions(+)

--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -114,6 +114,17 @@ static struct vm_operations_struct fb_de
 	.page_mkwrite	= fb_deferred_io_mkwrite,
 };
 
+static int fb_deferred_io_set_page_dirty(struct page *page)
+{
+	if (!PageDirty(page))
+		SetPageDirty(page);
+	return 0;
+}
+
+static const struct address_space_operations fb_deferred_io_aops = {
+	.set_page_dirty = fb_deferred_io_set_page_dirty,
+};
+
 static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_ops = &fb_deferred_io_vm_ops;
@@ -163,6 +174,14 @@ void fb_deferred_io_init(struct fb_info 
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_init);
 
+void fb_deferred_io_open(struct fb_info *info,
+			 struct inode *inode,
+			 struct file *file)
+{
+	file->f_mapping->a_ops = &fb_deferred_io_aops;
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_open);
+
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	void *screen_base = (void __force *) info->screen_base;
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1340,6 +1340,10 @@ fb_open(struct inode *inode, struct file
 		if (res)
 			module_put(info->fbops->owner);
 	}
+#ifdef CONFIG_FB_DEFERRED_IO
+	if (info->fbdefio)
+		fb_deferred_io_open(info, inode, file);
+#endif
 	return res;
 }
 
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -973,6 +973,9 @@ static inline void __fb_pad_aligned_buff
 
 /* drivers/video/fb_defio.c */
 extern void fb_deferred_io_init(struct fb_info *info);
+extern void fb_deferred_io_open(struct fb_info *info,
+				struct inode *inode,
+				struct file *file);
 extern void fb_deferred_io_cleanup(struct fb_info *info);
 extern int fb_deferred_io_fsync(struct file *file, struct dentry *dentry,
 				int datasync);

-- 
