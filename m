Return-Path: <linux-kernel-owner+w=401wt.eu-S937741AbXG0Vnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937741AbXG0Vnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbXG0Vn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:43:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:3953 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXG0Vn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=GTmRlQM3GGWklfpCMztsq2z4tDaekIypEVcW7iTROKgRrFBu2/m1Vfkz3BkJSc2yv1cxFbRjRJB3xxu7oSRs2BLifHLAfzu8DVOsUsQpOG6ldk7Pz+B1Lbegvy1EmdG5YFw2BcSp58nmfDJe7RZorgAu1e95gs3fJXFQvfxwVf4=
Subject: Re: Problems with framebuffer in 2.6.22-git17
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-yMkR/8gTH042OtLgDHeN"
Date: Sat, 28 Jul 2007 05:43:20 +0800
Message-Id: <1185572600.26603.10.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yMkR/8gTH042OtLgDHeN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-07-27 at 20:47 +0100, Adrian McMenamin wrote:
> On 26/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> 
> >
> > I'm also confused. Can you change the color depth to 32 bpp ('fbset
> > -depth 32')?  I'm thinking of a possible pseudo_palette overrun.
> >
> 
> The code behaves in exactly the same way with the bit depth set to 32
> and without the patch reversion (ie forces a reboot).
> 
> With the parch reverted there is a flicker of output on the screen
> before a reboot is forced (it will boot with 16bpp though the colour
> is a bit iffy)
> 
> With the patch reverted and 24bpp, it oopses before freezing (with two
> odd looking boot logos on the screen):

Can you try the attached patch? It's just a clean-up patch: uses
framebuffer_alloc/release instead of kmalloc. 

Tony

--=-yMkR/8gTH042OtLgDHeN
Content-Disposition: attachment; filename=pvr2_cleanup.diff
Content-Type: text/x-patch; name=pvr2_cleanup.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
index f930026..a72921b 100644
--- a/drivers/video/pvr2fb.c
+++ b/drivers/video/pvr2fb.c
@@ -143,6 +143,7 @@ static struct pvr2fb_par {
 	unsigned char is_lowres;	/* Is horizontal pixel-doubling enabled? */
 
 	unsigned long mmio_base;	/* MMIO base */
+	u32 palette[16];
 } *currentpar;
 
 static struct fb_info *fb_info;
@@ -790,7 +791,7 @@ static int __devinit pvr2fb_common_init(
 	fb_info->fbops		= &pvr2fb_ops;
 	fb_info->fix		= pvr2_fix;
 	fb_info->par		= currentpar;
-	fb_info->pseudo_palette	= (void *)(fb_info->par + 1);
+	fb_info->pseudo_palette	= currentpar->palette;
 	fb_info->flags		= FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 
 	if (video_output == VO_VGA)
@@ -1082,14 +1083,15 @@ #ifndef MODULE
 #endif
 	size = sizeof(struct fb_info) + sizeof(struct pvr2fb_par) + 16 * sizeof(u32);
 
-	fb_info = kzalloc(size, GFP_KERNEL);
+	fb_info = framebuffer_alloc(sizeof(struct pvr2fb_par), NULL);
+
 	if (!fb_info) {
 		printk(KERN_ERR "Failed to allocate memory for fb_info\n");
 		return -ENOMEM;
 	}
 
 
-	currentpar = (struct pvr2fb_par *)(fb_info + 1);
+	currentpar = fb_info->par;
 
 	for (i = 0; i < ARRAY_SIZE(board_driver); i++) {
 		struct pvr2_board *pvr_board = board_driver + i;
@@ -1102,7 +1104,7 @@ #endif
 		if (ret != 0) {
 			printk(KERN_ERR "pvr2fb: Failed init of %s device\n",
 				pvr_board->name);
-			kfree(fb_info);
+			framebuffer_release(fb_info);
 			break;
 		}
 	}
@@ -1126,7 +1128,7 @@ #ifdef CONFIG_SH_STORE_QUEUES
 #endif
 
 	unregister_framebuffer(fb_info);
-	kfree(fb_info);
+	framebuffer_release(fb_info);
 }
 
 module_init(pvr2fb_init);

--=-yMkR/8gTH042OtLgDHeN--

