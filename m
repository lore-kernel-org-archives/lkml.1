Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXHNHyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXHNHyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXHNHqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:49 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55495 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXHNHqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:46:36 -0400
Date: Tue, 14 Aug 2007 00:29:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca, deller@gmx.de,
       adaplas@gmail.com
Subject: [patch 09/12] stifb: detect cards in double buffer mode more
	reliably
Message-ID: <20070814072950.GM15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="stifb-detect-cards-in-double-buffer-mode-more-reliably.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Helge Deller <deller@gmx.de>

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

---
 drivers/video/stifb.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -1100,13 +1100,18 @@ stifb_init_fb(struct sti_struct *sti, in
 	/* only supported cards are allowed */
 	switch (fb->id) {
 	case CRT_ID_VISUALIZE_EG:
-		/* look for a double buffering device like e.g. the 
-		   "INTERNAL_EG_DX1024" in the RDI precisionbook laptop
-		   which won't work. The same device in non-double 
-		   buffering mode returns "INTERNAL_EG_X1024". */
-		if (strstr(sti->outptr.dev_name, "EG_DX")) {
-		   printk(KERN_WARNING 
-			"stifb: ignoring '%s'. Disable double buffering in IPL menu.\n",
+		/* Visualize cards can run either in "double buffer" or
+ 		  "standard" mode. Depending on the mode, the card reports
+		  a different device name, e.g. "INTERNAL_EG_DX1024" in double
+		  buffer mode and "INTERNAL_EG_X1024" in standard mode.
+		  Since this driver only supports standard mode, we check
+		  if the device name contains the string "DX" and tell the
+		  user how to reconfigure the card. */
+		if (strstr(sti->outptr.dev_name, "DX")) {
+		   printk(KERN_WARNING "WARNING: stifb framebuffer driver does not "
+			"support '%s' in double-buffer mode.\n"
+			KERN_WARNING "WARNING: Please disable the double-buffer mode "
+			"in IPL menu (the PARISC-BIOS).\n",
 			sti->outptr.dev_name);
 		   goto out_err0;
 		}

-- 
