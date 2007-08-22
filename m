Return-Path: <linux-kernel-owner+w=401wt.eu-S1763758AbXHVJKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763758AbXHVJKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbXHVIxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:52 -0400
Received: from 1wt.eu ([62.212.114.60]:2173 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765AbXHVIxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:47 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084043.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:38 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Helge Deller <deller@gmx.de>, Antonino Daplas <adaplas@gmail.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 54/58] stifb: detect cards in double buffer mode more reliably
Content-Disposition: inline; filename=0054-stifb-detect-cards-in-double-buffer-mode-more-relia.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Visualize-EG, Graffiti and A4450A graphics cards on PARISC can
be configured in double-buffer and standard mode, but the stifb
driver supports standard mode only.
This patch detects double-buffered cards more reliable.

It is a real bugfix for a very nasty problem for all parisc users which have
wrongly configured their graphic card.  The problem: The stifb graphics driver
will not detect that the card is wrongly configured and then nevertheless just
enables the graphics mode, which it shouldn't.  In the end, the user will see
no further updates / boot messages on the screen.

We had documented this problem already on our FAQ
(http://parisc-linux.org/faq/index.html#viseg "Why do I get corrupted graphics
with my Vis-EG/Graffiti/A4450A card?") but people still run into this problem.
 So having this fix in as early as possible can help us.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/video/stifb.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
index 69f3b26..6074ae9 100644
--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -1101,13 +1101,18 @@ stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	/* only supported cards are allowed */
 	switch (fb->id) {
 	case CRT_ID_VISUALIZE_EG:
-		/* look for a double buffering device like e.g. the 
-		   "INTERNAL_EG_DX1024" in the RDI precisionbook laptop
-		   which won't work. The same device in non-double 
-		   buffering mode returns "INTERNAL_EG_X1024". */
-		if (strstr(sti->outptr.dev_name, "EG_DX")) {
-		   printk(KERN_WARNING 
-			"stifb: ignoring '%s'. Disable double buffering in IPL menu.
",
+		/* Visualize cards can run either in "double buffer" or
+ 		  "standard" mode. Depending on the mode, the card reports
+		  a different device name, e.g. "INTERNAL_EG_DX1024" in double
+		  buffer mode and "INTERNAL_EG_X1024" in standard mode.
+		  Since this driver only supports standard mode, we check
+		  if the device name contains the string "DX" and tell the
+		  user how to reconfigure the card. */
+		if (strstr(sti->outptr.dev_name, "DX")) {
+		   printk(KERN_WARNING "WARNING: stifb framebuffer driver does not "
+			"support '%s' in double-buffer mode.
"
+			KERN_WARNING "WARNING: Please disable the double-buffer mode "
+			"in IPL menu (the PARISC-BIOS).
",
 			sti->outptr.dev_name);
 		   goto out_err0;
 		}
-- 
1.5.2.5

-- 
