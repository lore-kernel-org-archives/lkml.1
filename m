Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbXINAKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbXINAKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 20:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXINAJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 20:09:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbXINAJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 20:09:52 -0400
Date: Thu, 13 Sep 2007 17:09:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Luca Risolia <luca.risolia@studio.unibo.it>
cc: Andreas Herrmann <aherrman@arcor.de>, akpm@linux-foundation.org,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: fix build error for et61x251 driver
In-Reply-To: <200709140028.34661.luca.risolia@studio.unibo.it>
Message-ID: <alpine.LFD.0.999.0709131705070.16478@woody.linux-foundation.org>
References: <20070913123627.GD10348@devil> <200709131707.16666.luca.risolia@studio.unibo.it>
 <20070913222717.GC5764@devil>
 <200709140028.34661.luca.risolia@studio.unibo.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Sep 2007, Luca Risolia wrote:

> Hacked-by: Luca Risolia <luca.risolia@studio.unibo.it>
> 
> On Friday 14 September 2007 00:27:17 Andreas Herrmann wrote:
> > This fixes a kernel build problem and
> > should make it into 2.6.23, I think.
> >
> >
> > Regards,
> >
> > Andreas
> >
> > --
> >
> > Get rid of some v4l1 remainders to avoid kernel build errors if
> > V4L1_COMPAT is not selected:
> >
> >   drivers/media/video/et61x251/et61x251_core.c: In et61x251_show_:
> >   drivers/media/video/et61x251/et61x251_core.c:718: error: implicit
> >     declaration of to_video_device
> >
> > Fix as suggested by  Luca Risolia <luca.risolia@studio.unibo.it>

This patch is really ugly.

Why can't the "to_video_device()" macro be used? Just move it to a place 
where it's usable! IOW, what's wrong with the *much* simpler patch below?

That "to_video_device()" macro has absolutely _nothing_ to do with 
CONFIG_VIDEO_V4L1_COMPAT, as far as I can tell!

			Linus
---
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index d62847f..17f8f3a 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -337,6 +337,9 @@ void *priv;
 	struct class_device class_dev; /* sysfs */
 };
 
+/* Class-dev to video-device */
+#define to_video_device(cd) container_of(cd, struct video_device, class_dev)
+
 /* Version 2 functions */
 extern int video_register_device(struct video_device *vfd, int type, int nr);
 void video_unregister_device(struct video_device *);
@@ -354,11 +357,9 @@ extern int video_usercopy(struct inode *inode, struct file *file,
 			  int (*func)(struct inode *inode, struct file *file,
 				      unsigned int cmd, void *arg));
 
-
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 #include <linux/mm.h>
 
-#define to_video_device(cd) container_of(cd, struct video_device, class_dev)
 static inline int __must_check
 video_device_create_file(struct video_device *vfd,
 			 struct class_device_attribute *attr)
