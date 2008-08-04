Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYHDSVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYHDSVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYHDSUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:20:36 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47384 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528AbYHDSUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:20:34 -0400
Date: Mon, 4 Aug 2008 21:19:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix mm/mm_init.c compilation
Message-ID: <20080804181915.GA12558@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error with gcc 3.2:

<--  snip  -->

...
  CC      mm/mm_init.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:77:1: directives may not be used inside a macro argument
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:76:47: unterminated argument list invoking macro "mminit_dprintk"
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c: In function `mminit_verify_pageflags_layout':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: `mminit_dprintk' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: syntax error before numeric constant
make[2]: *** [mm/mm_init.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 mm/mm_init.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -63,6 +63,13 @@ void __init mminit_verify_pageflags_layout(void)
 {
 	int shift, width;
 	unsigned long or_mask, add_mask;
+	int sections_shift;
+
+#ifdef SECTIONS_SHIFT
+	sections_shift = SECTIONS_SHIFT;
+#else
+	sections_shift = 0;
+#endif
 
 	shift = 8 * sizeof(unsigned long);
 	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH;
@@ -74,11 +81,7 @@ void __init mminit_verify_pageflags_layout(void)
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
 		"Section %d Node %d Zone %d\n",
-#ifdef SECTIONS_SHIFT
-		SECTIONS_SHIFT,
-#else
-		0,
-#endif
+		sections_shift,
 		NODES_SHIFT,
 		ZONES_SHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",

