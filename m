Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXE3WOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXE3WOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbXE3WO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:14:28 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:22754 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbXE3WO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=kMCCvUM6528Grs1cBe3PWBBR1ENHZ6EmuuRToWM2AUershgVcPmGoPzx+ikDM/mPCnzfyybmuIFDuXymi6ULMy4+mNEj+u4H/6cqr90xHBPSQfHnNs8zPLEqPY+BDpqn5nctlYhn8VjXyeAzmm3mxSl1HNWwAqjyDs4Rkn2unv0=
Subject: Re: tty-related oops in latest kernel(s)?
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Tero Roponen <teanropo@jyu.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
	 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
	 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
	 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
	 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
	 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
	 <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
	 <Pine.LNX.4.64.0705301458400.4634@jalava.cc.jyu.fi>
	 <20070530083953.9909bcef.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
Content-Type: multipart/mixed; boundary="=-HGYVjjsiJz78Zg790Dl+"
Date: Thu, 31 May 2007 06:14:18 +0800
Message-Id: <1180563258.4570.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HGYVjjsiJz78Zg790Dl+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2007-05-30 at 19:01 +0300, Tero Roponen wrote:
> On Wed, 30 May 2007, Andrew Morton wrote:
> 
> > On Wed, 30 May 2007 15:02:49 +0300 (EEST) Tero Roponen <teanropo@jyu.fi> wrote:
> > 
> > > On Wed, 30 May 2007, Pekka Enberg wrote:
> > > 
> > > > On 5/30/07, Tero Roponen <teanropo@jyu.fi> wrote:

> [root@terrop ~]# cat oops.c
> #include <sys/ioctl.h>
> #include <stdio.h>
> #include <linux/fb.h>
> #include <fcntl.h>
> 
> int main(void)
> {
>         struct fb_var_screeninfo fbinfo;
>         int fd = open("/dev/fb0", O_RDWR);
>         if (fd < 0)
>                 return 1;
> 
>         /* Get screeninfo */
>         ioctl(fd, FBIOGET_VSCREENINFO, &fbinfo);
> 
>         /* Change depth from current 16 to 24. */
>         fbinfo.bits_per_pixel = 24;
>         ioctl(fd, FBIOPUT_VSCREENINFO, &fbinfo);
> 
>         return 0;
> }
> 
> So this seems to be a framebuffer error.

It's a fb_setcolreg() bug in neofb.  Try this patch?

Tony



--=-HGYVjjsiJz78Zg790Dl+
Content-Disposition: attachment; filename=18-neofb_array_overrun
Content-Type: text/plain; name=18-neofb_array_overrun; charset=utf-8
Content-Transfer-Encoding: 7bit

neofb: Fix pseudo_palette array overrun in neofb_setcolreg

The pseudo_palette has room for 16 entries only, but in truecolor mode, it
attempts to add 256.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---

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
 

--=-HGYVjjsiJz78Zg790Dl+--

