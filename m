Return-Path: <linux-kernel-owner+w=401wt.eu-S938664AbXFHHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938664AbXFHHkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938237AbXFHHYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:20 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55168 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938207AbXFHHYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:18 -0400
Message-Id: <20070608072213.788213000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Antonino A Daplas <adaplas@gmail.com>, penberg@cs.helsinki.fi,
       teanropo@jyu.fi, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 30/54] neofb: Fix pseudo_palette array overrun in neofb_setcolreg
Content-Disposition: inline; filename=neofb-fix-pseudo_palette-array-overrun-in-neofb_setcolreg.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Antonino A Daplas <adaplas@gmail.com>

The pseudo_palette has room for 16 entries only, but in truecolor mode, it
attempts to write 256.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Tero Roponen <teanropo@jyu.fi>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
This fixes the following regression/bug reported as follows:

Subject    : tty-related oops in latest kernel(s)
References : http://lkml.org/lkml/2007/5/27/104
Submitter  : Tero Roponen <teanropo@jyu.fi>
Status     : problem is being debugged

According to Tero, this is also reproducible with 2.6.21.3.

(Resending, wrong email address for stable@kernel.org)

Tony

 drivers/video/neofb.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- linux-2.6.21.4.orig/drivers/video/neofb.c
+++ linux-2.6.21.4/drivers/video/neofb.c
@@ -1285,34 +1285,36 @@ static int neofb_setcolreg(u_int regno, 
 	if (regno >= fb->cmap.len || regno > 255)
 		return -EINVAL;
 
-	switch (fb->var.bits_per_pixel) {
-	case 8:
+	if (fb->var.bits_per_pixel <= 8) {
 		outb(regno, 0x3c8);
 
 		outb(red >> 10, 0x3c9);
 		outb(green >> 10, 0x3c9);
 		outb(blue >> 10, 0x3c9);
-		break;
-	case 16:
-		((u32 *) fb->pseudo_palette)[regno] =
+	} else if (regno < 16) {
+		switch (fb->var.bits_per_pixel) {
+		case 16:
+			((u32 *) fb->pseudo_palette)[regno] =
 				((red & 0xf800)) | ((green & 0xfc00) >> 5) |
 				((blue & 0xf800) >> 11);
-		break;
-	case 24:
-		((u32 *) fb->pseudo_palette)[regno] =
+			break;
+		case 24:
+			((u32 *) fb->pseudo_palette)[regno] =
 				((red & 0xff00) << 8) | ((green & 0xff00)) |
 				((blue & 0xff00) >> 8);
-		break;
+			break;
 #ifdef NO_32BIT_SUPPORT_YET
-	case 32:
-		((u32 *) fb->pseudo_palette)[regno] =
+		case 32:
+			((u32 *) fb->pseudo_palette)[regno] =
 				((transp & 0xff00) << 16) | ((red & 0xff00) << 8) |
 				((green & 0xff00)) | ((blue & 0xff00) >> 8);
-		break;
+			break;
 #endif
-	default:
-		return 1;
+		default:
+			return 1;
+		}
 	}
+
 	return 0;
 }
 

-- 
