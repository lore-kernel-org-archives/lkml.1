Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbXCCFfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbXCCFfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 00:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXCCFfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 00:35:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:45478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933374AbXCCFfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 00:35:02 -0500
Date: Fri, 2 Mar 2007 21:34:11 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Re: Linux 2.6.19.7
Message-ID: <20070303053411.GB28614@kroah.com>
References: <20070303053342.GA28614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303053342.GA28614@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 5335f17..10a3416 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 19
-EXTRAVERSION = .6
+EXTRAVERSION = .7
 NAME=Avast! A bilge rat!
 
 # *DOCUMENTATION*
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 40774fe..af35f30 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -200,6 +200,8 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			const struct dvb_device *template, void *priv, int type)
 {
 	struct dvb_device *dvbdev;
+	struct file_operations *dvbdevfops;
+
 	int id;
 
 	if (mutex_lock_interruptible(&dvbdev_register_lock))
@@ -219,12 +221,22 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		return -ENOMEM;
 	}
 
+	dvbdevfops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
+
+	if (!dvbdevfops) {
+		kfree (dvbdev);
+		mutex_unlock(&dvbdev_register_lock);
+		return -ENOMEM;
+	}
+
 	memcpy(dvbdev, template, sizeof(struct dvb_device));
 	dvbdev->type = type;
 	dvbdev->id = id;
 	dvbdev->adapter = adap;
 	dvbdev->priv = priv;
+	dvbdev->fops = dvbdevfops;
 
+	memcpy(dvbdev->fops, template->fops, sizeof(struct file_operations));
 	dvbdev->fops->owner = adap->module;
 
 	list_add_tail (&dvbdev->list_head, &adap->device_list);
@@ -252,6 +264,7 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 					dvbdev->type, dvbdev->id)));
 
 	list_del (&dvbdev->list_head);
+	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
 EXPORT_SYMBOL(dvb_unregister_device);
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 43f3906..848dc4f 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -471,8 +471,8 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev, const
 	if (fw->data[BLUEBIRD_01_ID_OFFSET] == (USB_VID_DVICO & 0xff) &&
 	    fw->data[BLUEBIRD_01_ID_OFFSET + 1] == USB_VID_DVICO >> 8) {
 
-		fw->data[BLUEBIRD_01_ID_OFFSET + 2] = udev->descriptor.idProduct + 1;
-		fw->data[BLUEBIRD_01_ID_OFFSET + 3] = udev->descriptor.idProduct >> 8;
+		fw->data[BLUEBIRD_01_ID_OFFSET + 2] = le16_to_cpu(udev->descriptor.idProduct) + 1;
+		fw->data[BLUEBIRD_01_ID_OFFSET + 3] = le16_to_cpu(udev->descriptor.idProduct) >> 8;
 
 		return usb_cypress_load_firmware(udev,fw,CYPRESS_FX2);
 	}
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index 8fb3437..ea7df29 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -119,6 +119,8 @@ static int digitv_nxt6000_tuner_set_params(struct dvb_frontend *fe, struct dvb_f
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	u8 b[5];
 	dvb_usb_tuner_calc_regs(fe,fep,b, 5);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 	return digitv_ctrl_msg(adap->dev, USB_WRITE_TUNER, 0, &b[1], 4, NULL, 0);
 }
 
