Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZBAJZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZBAJZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 04:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZBAJYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 04:24:49 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:62826 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZBAJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 04:24:42 -0500
Message-ID: <49856A54.1020105@freemail.hu>
Date: Sun, 01 Feb 2009 10:24:36 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.28 + Trust 610 LCD PowerC@m Zoom, webcam mode?
Content-Type: multipart/mixed;
 boundary="------------090204010807050502050303"
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32712; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090204010807050502050303
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit

Hello Jean-Francois,

I have a Trust 610 LCD PowerC@m Zoom camera which can operate in webcam mode
also (USB ID=06d6:0031). I tried to use it together with Linux 2.6.28 and with
xawtv-3.95.dfsg.1 and with gqcam 0.9.1. The /dev/video0 appeared, but no usable
picture was visible.

However, I downloaded http://mxhaard.free.fr/spca50x/Download/gspcav1-20071224.tar.gz
and applied the attached patch (which might be incorrect for some aspects).
So I was able to compile the module and both xawtv and gqcam showed the good
picture.

Do you have any idea why the gspcav1 diver is working and the one which is included
in Linux 2.6.28 not?

Here is the output of v4l-info with the patched working gspcav1 driver:
$ v4l-info

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "Trust 610 LCD PowerC@m Zoom"
        type                    : 0x1 [CAPTURE]
        channels                : 1
        audios                  : 0
        maxwidth                : 464
        maxheight               : 480
        minwidth                : 176
        minheight               : 144

channels
    VIDIOCGCHAN(0)
        channel                 : 0
        name                    : "SPCA533"
        tuners                  : 0
        flags                   : 0x0 []
        type                    : CAMERA
        norm                    : 0

tuner
ioctl VIDIOCGTUNER: Invalid argument

audio
ioctl VIDIOCGAUDIO: Invalid argument

picture
    VIDIOCGPICT
        brightness              : 32768
        hue                     : 0
        colour                  : 4096
        contrast                : 8192
        whiteness               : 0
        depth                   : 24
        palette                 : RGB24

buffer
    VIDIOCGFBUF
        base                    : (nil)
        height                  : 0
        width                   : 0
        depth                   : 0
        bytesperline            : 0

window
    VIDIOCGWIN
        x                       : 0
        y                       : 0
        width                   : 384
        height                  : 288
        chromakey               : 0
        flags                   : 0



Regards,

	Márton Németh

--------------090204010807050502050303
Content-Type: text/x-diff;
 name="gspcav1_Trust_610_LCD_PowerC@m_Zoom-2.6.28.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspcav1_Trust_610_LCD_PowerC@m_Zoom-2.6.28.patch"

diff -upr gspcav1-20071224.orig/gspca_core.c gspcav1-20071224/gspca_core.c
--- gspcav1-20071224.orig/gspca_core.c	2007-12-24 17:56:47.000000000 +0100
+++ gspcav1-20071224/gspca_core.c	2009-02-01 09:59:56.000000000 +0100
@@ -51,10 +51,11 @@ static const char gspca_version[] = GSPC
 #include <linux/pagemap.h>
 #include <linux/usb.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <asm/page.h>
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
+#include <media/v4l2-ioctl.h>
 /* only on 2.6.x */
 #include <linux/jiffies.h>
 #include <linux/param.h>
@@ -2606,9 +2607,7 @@ static struct file_operations spca5xx_fo
 	.llseek = no_llseek,
 };
 static struct video_device spca50x_template = {
-	.owner = THIS_MODULE,
 	.name = "GSPCA USB Camera",
-	.type = VID_TYPE_CAPTURE,
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,23)	
 	.hardware = VID_HARDWARE_GSPCA,
 #endif
@@ -2765,24 +2764,7 @@ static DEVICE_ATTR(pictsetting, S_IRUGO,
 static int
 spca50x_create_sysfs(struct video_device *vdev)
 {
-	int rc = 0;
-	rc = video_device_create_file(vdev, &dev_attr_stream_id);
-	if (rc)
-		goto err_stream_id;
-	rc = video_device_create_file(vdev, &dev_attr_model);
-	if (rc)
-		goto err_model;
-	rc = video_device_create_file(vdev, &dev_attr_pictsetting);
-	if (rc)
-		goto err_pictsetting;
 	return 0;
-      err_pictsetting:
-	video_device_remove_file(vdev, &dev_attr_pictsetting);
-      err_model:
-	video_device_remove_file(vdev, &dev_attr_model);
-      err_stream_id:
-	video_device_remove_file(vdev, &dev_attr_stream_id);
-	return rc;
 }
 #endif 
 
@@ -4298,7 +4280,6 @@ spca5xx_probe(struct usb_interface *intf
 	if (!spca50x->vdev)
 		goto error;
 	memcpy(spca50x->vdev, &spca50x_template, sizeof (spca50x_template));
-	spca50x->vdev->dev = &dev->dev;
 	video_set_drvdata(spca50x->vdev, spca50x);
 	PDEBUG(2, "setting video device = %p, spca50x = %p", spca50x->vdev,
 	       spca50x);

--------------090204010807050502050303--
