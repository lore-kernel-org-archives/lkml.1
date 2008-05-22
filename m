Return-Path: <linux-kernel-owner+w=401wt.eu-S1764699AbYEVVmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764699AbYEVVmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbYEVVlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:41:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55615 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756151AbYEVVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:41:49 -0400
Date: Thu, 22 May 2008 22:29:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: perex@perex.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] tea575x: Switch to unlocked_ioctl
Message-ID: <20080522222920.33732923@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure why this is hiding in the sound directory or why it has an
ancient and buggy V4L1 interface on it but it is and it needs to use
unlocked_ioctl.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 87e3aef..c1d6184 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <sound/core.h>
+#include <linux/smp_lock.h>
 #include <sound/tea575x-tuner.h>
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
@@ -84,12 +85,14 @@ static void snd_tea575x_set_freq(struct snd_tea575x *tea)
  * Linux Video interface
  */
 
-static int snd_tea575x_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long data)
+static long snd_tea575x_ioctl(struct file *file, unsigned int cmd,
+						unsigned long data)
 {
 	struct video_device *dev = video_devdata(file);
 	struct snd_tea575x *tea = video_get_drvdata(dev);
 	void __user *arg = (void __user *)data;
+
+#warning "Video4Linux 1 is obsolete. Please update this driver"
 	
 	switch(cmd) {
 		case VIDIOCGCAP:
@@ -103,7 +106,9 @@ static int snd_tea575x_ioctl(struct inode *inode, struct file *file,
 			v.maxheight = 0;
 			v.minwidth = 0;
 			v.minheight = 0;
+			lock_kernel();
 			strcpy(v.name, tea->tea5759 ? "TEA5759" : "TEA5757");
+			unlock_kernel();
 			if (copy_to_user(arg,&v,sizeof(v)))
 				return -EFAULT;
 			return 0;
@@ -136,13 +141,16 @@ static int snd_tea575x_ioctl(struct inode *inode, struct file *file,
 			return 0;
 		}
 		case VIDIOCGFREQ:
+			/* FIXME: freq locking is needed ?? */
 			if(copy_to_user(arg, &tea->freq, sizeof(tea->freq)))
 				return -EFAULT;
 			return 0;
 		case VIDIOCSFREQ:
 			if(copy_from_user(&tea->freq, arg, sizeof(tea->freq)))
 				return -EFAULT;
+			lock_kernel();
 			snd_tea575x_set_freq(tea);
+			unlock_kernel();
 			return 0;
 		case VIDIOCGAUDIO:
 		{	
@@ -158,16 +166,18 @@ static int snd_tea575x_ioctl(struct inode *inode, struct file *file,
 			struct video_audio v;
 			if(copy_from_user(&v, arg, sizeof(v))) 
 				return -EFAULT;	
+			lock_kernel();
 			if (tea->ops->mute)
 				tea->ops->mute(tea,
 					       (v.flags &
 						VIDEO_AUDIO_MUTE) ? 1 : 0);
+			unlock_kernel();
 			if(v.audio) 
 				return -EINVAL;
 			return 0;
 		}
 		default:
-			return -ENOIOCTLCMD;
+			return -ENOTTY;
 	}
 }
 
@@ -198,7 +208,7 @@ void snd_tea575x_init(struct snd_tea575x *tea)
 	tea->fops.owner = tea->card->module;
 	tea->fops.open = video_exclusive_open;
 	tea->fops.release = video_exclusive_release;
-	tea->fops.ioctl = snd_tea575x_ioctl;
+	tea->fops.unlocked_ioctl = snd_tea575x_ioctl;
 	if (video_register_device(&tea->vd, VFL_TYPE_RADIO, tea->dev_nr - 1) < 0) {
 		snd_printk(KERN_ERR "unable to register tea575x tuner\n");
 		return;
