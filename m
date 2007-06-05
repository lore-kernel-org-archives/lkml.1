Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXFELfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXFELfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXFELfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:35:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:54344 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbXFELfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uZGuIgJzVCCEhLkR2BZmVUsixGpJkK1aKhq/p1SIoyQxdZ2Hv3GO1X7Dvyr9NggQ2MjwCutoPkgp7Do/Uq2obERRhooai7/L9qSjAOhaUa3qLC111R06F25LttiZFjNZ/DrQ/qq38Wv46kj3O8jAYrXbx6e3CKZnNvTv2Btc3iE=
Message-ID: <46654A63.6000308@gmail.com>
Date: Tue, 05 Jun 2007 19:34:59 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tero Roponen <teanropo@jyu.fi>
Subject: [PATCH] [RESEND] neofb: Fix pseudo_palette array overrun in neofb_setcolreg
References: <465C188F.9000900@googlemail.com>	 <465C222A.8060003@googlemail.com>	 <alpine.LFD.0.98.0705301922560.26602@woody.linux-foundation.org>	 <1180587109.4570.25.camel@daplas> <Pine.LNX.4.64.0705310852400.8734@jalava.cc.jyu.fi>
In-Reply-To: <Pine.LNX.4.64.0705310852400.8734@jalava.cc.jyu.fi>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The pseudo_palette has room for 16 entries only, but in truecolor mode, it
attempts to write 256.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Tero Roponen <teanropo@jyu.fi>
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
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index bd30aba..731d7a5 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -1286,34 +1286,36 @@ static int neofb_setcolreg(u_int regno, 
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
 




