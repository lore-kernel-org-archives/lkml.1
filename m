Return-Path: <linux-kernel-owner+w=401wt.eu-S1765628AbXJTQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765628AbXJTQEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 12:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXJTQEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 12:04:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbXJTQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:03:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] hiddev: simplify 32bit ioctl compatibilty
Date: Sat, 20 Oct 2007 18:03:35 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Philip Langdale <philipl@overt.org>, Jiri Kosina <jkosina@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
References: <47100864.2090208@overt.org> <20071013000221.GC8181@ftp.linux.org.uk> <200710201750.58521.arnd@arndb.de>
In-Reply-To: <200710201750.58521.arnd@arndb.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710201803.36478.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+As/HLJIRs6o2JopwHOD8zii7YF4AMyV23ojQ
 H+k5PVC+QqMKFn0OXYh47NcC5oC9uxuGFgcebDAmSKD2WYp2HS
 LLFeDZ+U2qUem0LyJlOyg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hiddev has both entries in fs/compat_ioctl.c and its own
compat_ioctl() handler. Remove both and use the new generic_compat_ioctl
helper instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/drivers/hid/hidraw.c
===================================================================
--- linux-2.6.orig/drivers/hid/hidraw.c
+++ linux-2.6/drivers/hid/hidraw.c
@@ -268,6 +268,7 @@ static const struct file_operations hidr
 	.open =         hidraw_open,
 	.release =      hidraw_release,
 	.ioctl =        hidraw_ioctl,
+	.compat_ioctl = generic_compat_ioctl,
 };
 
 void hidraw_report_event(struct hid_device *hid, u8 *data, int len)
Index: linux-2.6/drivers/hid/usbhid/hiddev.c
===================================================================
--- linux-2.6.orig/drivers/hid/usbhid/hiddev.c
+++ linux-2.6/drivers/hid/usbhid/hiddev.c
@@ -739,14 +739,6 @@ inval:
 	return -EINVAL;
 }
 
-#ifdef CONFIG_COMPAT
-static long hiddev_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct inode *inode = file->f_path.dentry->d_inode;
-	return hiddev_ioctl(inode, file, cmd, compat_ptr(arg));
-}
-#endif
-
 static const struct file_operations hiddev_fops = {
 	.owner =	THIS_MODULE,
 	.read =		hiddev_read,
@@ -756,9 +748,7 @@ static const struct file_operations hidd
 	.release =	hiddev_release,
 	.ioctl =	hiddev_ioctl,
 	.fasync =	hiddev_fasync,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= hiddev_compat_ioctl,
-#endif
+	.compat_ioctl = generic_compat_ioctl,
 };
 
 static struct usb_class_driver hiddev_class = {
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -102,8 +102,6 @@
 #include <linux/filter.h>
 #include <linux/pktcdvd.h>
 
-#include <linux/hiddev.h>
-
 #include <linux/dvb/audio.h>
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/frontend.h>
@@ -2575,23 +2573,6 @@ COMPATIBLE_IOCTL(SIOCSIWPOWER)
 COMPATIBLE_IOCTL(SIOCGIWPOWER)
 COMPATIBLE_IOCTL(SIOCSIWAUTH)
 COMPATIBLE_IOCTL(SIOCGIWAUTH)
-/* hiddev */
-COMPATIBLE_IOCTL(HIDIOCGVERSION)
-COMPATIBLE_IOCTL(HIDIOCAPPLICATION)
-COMPATIBLE_IOCTL(HIDIOCGDEVINFO)
-COMPATIBLE_IOCTL(HIDIOCGSTRING)
-COMPATIBLE_IOCTL(HIDIOCINITREPORT)
-COMPATIBLE_IOCTL(HIDIOCGREPORT)
-COMPATIBLE_IOCTL(HIDIOCSREPORT)
-COMPATIBLE_IOCTL(HIDIOCGREPORTINFO)
-COMPATIBLE_IOCTL(HIDIOCGFIELDINFO)
-COMPATIBLE_IOCTL(HIDIOCGUSAGE)
-COMPATIBLE_IOCTL(HIDIOCSUSAGE)
-COMPATIBLE_IOCTL(HIDIOCGUCODE)
-COMPATIBLE_IOCTL(HIDIOCGFLAG)
-COMPATIBLE_IOCTL(HIDIOCSFLAG)
-COMPATIBLE_IOCTL(HIDIOCGCOLLECTIONINDEX)
-COMPATIBLE_IOCTL(HIDIOCGCOLLECTIONINFO)
 /* dvb */
 COMPATIBLE_IOCTL(AUDIO_STOP)
 COMPATIBLE_IOCTL(AUDIO_PLAY)
