Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbXEaGFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbXEaGFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbXEaGFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:05:07 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:9619 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbXEaGFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rZYWcDjH6NCJqxWFqLzEWnKmI6R/b+yarnGcqrb0TBTBioFeFAqGG0HD2kHyMEi7LMXlKZjcRWHvJzp5DdOVCjnmrvUC6TDKRn9SUCML4pqc5ReNBGTRsf0d8exGtnaWfnuIAVeLaKmab0zknZRCSRUAdYgJmSgFeQvPySovEr0=
Message-ID: <465E6589.5040903@gmail.com>
Date: Thu, 31 May 2007 14:04:57 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Tero Roponen <teanropo@jyu.fi>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>
Subject: [PATCH] neofb: Fix pseudo_palette array overrun in neofb_setcolreg
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

Tero Roponen wrote:
> On Thu, 31 May 2007, Antonino A. Daplas wrote:
> 
>> On Wed, 2007-05-30 at 19:33 -0700, Linus Torvalds wrote:
>>> On Tue, 29 May 2007, Michal Piotrowski wrote:
>>>> TTY
>>>>
>>>> Subject    : tty-related oops in latest kernel(s)
>>>> References : http://lkml.org/lkml/2007/5/27/104
>>>> Submitter  : Tero Roponen <teanropo@jyu.fi>
>>>> Status     : problem is being debugged
>>> People seem to have debugged this to neofb palette handling, but I haven't 
>>> seen a patch. Antonino?
>>>
>> Already posted one for testing. I'm waiting for Tero to confirm.
>>
>> Tony
>>
> 
> Ok, I tested all the cases I have reported: no corruption
> and nothing in slabinfo -v. This seems to be the right fix.
> 

Okay, thanks for testing.

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
 

