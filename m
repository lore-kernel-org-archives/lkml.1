Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZBKA3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZBKA3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbZBKA2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:08 -0500
Received: from kroah.org ([198.145.64.141]:50955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756074AbZBKA2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:06 -0500
Date: Tue, 10 Feb 2009 16:24:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>
Subject: [patch 05/56] agp/intel: Reduce extraneous PCI posting reads
	during init
Message-ID: <20090211002422.GF14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="agp-intel-reduce-extraneous-pci-posting-reads-during-init.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Keith Packard <keithp@keithp.com>

commit 44d494417278e49f5b42bd3ded1801b6d2254db8 upstream.

Instead of doing a posting read after each GTT entry update, do a single one
at the end of the writes. This should reduce boot time a tiny amount by
avoiding a lot of extra uncached reads.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -217,8 +217,8 @@ static int intel_i810_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = 0; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI posting. */
 		}
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI posting. */
 	}
 	global_cache_flush();
 	return 0;
@@ -778,8 +778,8 @@ static int intel_i830_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI Posting. */
 		}
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI Posting. */
 	}
 
 	global_cache_flush();
@@ -994,8 +994,8 @@ static int intel_i915_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.gtt+i);
-			readl(intel_private.gtt+i);	/* PCI Posting. */
 		}
+		readl(intel_private.gtt+i-1);	/* PCI Posting. */
 	}
 
 	global_cache_flush();

