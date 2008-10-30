Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYJ3Avz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYJ3Avz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYJ3Avr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:51:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:26684 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbYJ3Avq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:51:46 -0400
Subject: V4L: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 01:51:46 +0100
Message-Id: <1225327906.5970.44.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: V4L: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/media/video/bt8xx/bttv-gpio.c b/drivers/media/video/bt8xx/bttv-gpio.c
index dce6dae..74c325e 100644
--- a/drivers/media/video/bt8xx/bttv-gpio.c
+++ b/drivers/media/video/bt8xx/bttv-gpio.c
@@ -42,7 +42,7 @@ static int bttv_sub_bus_match(struct device *dev, struct device_driver *drv)
 	struct bttv_sub_driver *sub = to_bttv_sub_drv(drv);
 	int len = strlen(sub->wanted);
 
-	if (0 == strncmp(dev->bus_id, sub->wanted, len))
+	if (0 == strncmp(dev_name(dev), sub->wanted, len))
 		return 1;
 	return 0;
 }
@@ -91,15 +91,14 @@ int bttv_sub_add_device(struct bttv_core *core, char *name)
 	sub->dev.parent  = &core->pci->dev;
 	sub->dev.bus     = &bttv_sub_bus_type;
 	sub->dev.release = release_sub_device;
-	snprintf(sub->dev.bus_id,sizeof(sub->dev.bus_id),"%s%d",
-		 name, core->nr);
+	dev_set_name(&sub->dev, "%s%d", name, core->nr);
 
 	err = device_register(&sub->dev);
 	if (0 != err) {
 		kfree(sub);
 		return err;
 	}
-	printk("bttv%d: add subdevice \"%s\"\n", core->nr, sub->dev.bus_id);
+	printk("bttv%d: add subdevice \"%s\"\n", core->nr, dev_name(&sub->dev));
 	list_add_tail(&sub->list,&core->subs);
 	return 0;
 }
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/video/bt8xx/bttv.h
index 46cb90e..bc2c884 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -308,7 +308,7 @@ struct bttv_sub_device {
 
 struct bttv_sub_driver {
 	struct device_driver   drv;
-	char                   wanted[BUS_ID_SIZE];
+	char                   wanted[20];
 	int                    (*probe)(struct bttv_sub_device *sub);
 	void                   (*remove)(struct bttv_sub_device *sub);
 };
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index a1ab2ef..bbd59de 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1269,7 +1269,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
-	strlcpy(cap->bus_info, dev->udev->dev.bus_id, sizeof(cap->bus_info));
+	strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
 
 	cap->version = EM28XX_VERSION_CODE;
 
@@ -1422,7 +1422,7 @@ static int radio_querycap(struct file *file, void  *priv,
 
 	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
-	strlcpy(cap->bus_info, dev->udev->dev.bus_id, sizeof(cap->bus_info));
+	strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
 
 	cap->version = EM28XX_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_TUNER;
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index 9d0ef96..83c0711 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -1581,7 +1581,7 @@ et61x251_vidioc_querycap(struct et61x251_device* cam, void __user * arg)
 
 	strlcpy(cap.card, cam->v4ldev->name, sizeof(cap.card));
 	if (usb_make_path(cam->usbdev, cap.bus_info, sizeof(cap.bus_info)) < 0)
-		strlcpy(cap.bus_info, cam->usbdev->dev.bus_id,
+		strlcpy(cap.bus_info, dev_name(&cam->usbdev->dev),
 			sizeof(cap.bus_info));
 
 	if (copy_to_user(arg, &cap, sizeof(cap)))
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index efe8499..d4658c5 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -385,10 +385,10 @@ static int ir_attach(struct i2c_adapter *adap, int addr,
 		goto err_out_detach;
 	}
 
-	/* Phys addr can only be set after attaching (for ir->c.dev.bus_id) */
+	/* Phys addr can only be set after attaching (for ir->c.dev) */
 	snprintf(ir->phys, sizeof(ir->phys), "%s/%s/ir0",
-		 ir->c.adapter->dev.bus_id,
-		 ir->c.dev.bus_id);
+		 dev_name(&ir->c.adapter->dev),
+		 dev_name(&ir->c.dev));
 
 	/* init + register input device */
 	ir_input_init(input_dev, &ir->ir, ir_type, ir->ir_codes);
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 5b81ba4..4358079 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -2395,7 +2395,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 
 	scnprintf(hdw->bus_info,sizeof(hdw->bus_info),
 		  "usb %s address %d",
-		  hdw->usb_dev->dev.bus_id,
+		  dev_name(&hdw->usb_dev->dev),
 		  hdw->usb_dev->devnum);
 
 	ifnum = hdw->usb_intf->cur_altsetting->desc.bInterfaceNumber;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 733680f..e641cd9 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -628,10 +628,10 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 
 	class_dev->class = &class_ptr->class;
 	if (pvr2_hdw_get_sn(sfp->channel.hdw)) {
-		snprintf(class_dev->bus_id, BUS_ID_SIZE, "sn-%lu",
+		dev_set_name(class_dev, "sn-%lu",
 			 pvr2_hdw_get_sn(sfp->channel.hdw));
 	} else if (pvr2_hdw_get_unit_number(sfp->channel.hdw) >= 0) {
-		snprintf(class_dev->bus_id, BUS_ID_SIZE, "unit-%c",
+		dev_set_name(class_dev, "unit-%c",
 			 pvr2_hdw_get_unit_number(sfp->channel.hdw) + 'a');
 	} else {
 		kfree(class_dev);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2407607..4677e2c 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -609,7 +609,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 
 	/* request irq */
 	err = request_irq(pcdev->irq, sh_mobile_ceu_irq, IRQF_DISABLED,
-			  pdev->dev.bus_id, pcdev);
+			  dev_name(&pdev->dev), pcdev);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
 		goto exit_release_mem;
@@ -618,8 +618,8 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.priv = pcdev;
 	pcdev->ici.dev.parent = &pdev->dev;
 	pcdev->ici.nr = pdev->id;
-	pcdev->ici.drv_name = pdev->dev.bus_id,
-	pcdev->ici.ops = &sh_mobile_ceu_host_ops,
+	pcdev->ici.drv_name = dev_name(&pdev->dev);
+	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
 
 	err = soc_camera_host_register(&pcdev->ici);
 	if (err)
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index fcd2b62..01a8efb 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -2162,7 +2162,7 @@ sn9c102_vidioc_querycap(struct sn9c102_device* cam, void __user * arg)
 
 	strlcpy(cap.card, cam->v4ldev->name, sizeof(cap.card));
 	if (usb_make_path(cam->usbdev, cap.bus_info, sizeof(cap.bus_info)) < 0)
-		strlcpy(cap.bus_info, cam->usbdev->dev.bus_id,
+		strlcpy(cap.bus_info, dev_name(&cam->usbdev->dev),
 			sizeof(cap.bus_info));
 
 	if (copy_to_user(arg, &cap, sizeof(cap)))
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 66ebe59..28cf5c9 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -783,7 +783,7 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 		return -EINVAL;
 
 	/* Number might be equal to the platform device ID */
-	sprintf(ici->dev.bus_id, "camera_host%d", ici->nr);
+	dev_set_name(&ici->dev, "camera_host%d", ici->nr);
 
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
@@ -867,8 +867,7 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 
 	icd->devnum = num;
 	icd->dev.bus = &soc_camera_bus_type;
-	snprintf(icd->dev.bus_id, sizeof(icd->dev.bus_id),
-		 "%u-%u", icd->iface, icd->devnum);
+	dev_set_name(&icd->dev, "%u-%u", icd->iface, icd->devnum);
 
 	icd->dev.release = dummy_release;
 
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index d185b57..27f9f70 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -523,7 +523,7 @@ static int vidioc_querycap (struct file *file, void  *priv,
 	strlcpy(vc->card,
 		usbvision_device_data[usbvision->DevModel].ModelString,
 		sizeof(vc->card));
-	strlcpy(vc->bus_info, usbvision->dev->dev.bus_id,
+	strlcpy(vc->bus_info, dev_name(&usbvision->dev->dev),
 		sizeof(vc->bus_info));
 	vc->version = USBVISION_DRIVER_VERSION;
 	vc->capabilities = V4L2_CAP_VIDEO_CAPTURE |
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index ccd6566..78af624 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -339,7 +339,7 @@ int video_register_device_index(struct video_device *vfd, int type, int nr,
 	vfd->dev.devt = MKDEV(VIDEO_MAJOR, vfd->minor);
 	if (vfd->parent)
 		vfd->dev.parent = vfd->parent;
-	sprintf(vfd->dev.bus_id, "%s%d", name_base, nr);
+	dev_set_name(&vfd->dev, "%s%d", name_base, nr);
 	ret = device_register(&vfd->dev);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: device_register failed\n", __func__);
diff --git a/drivers/media/video/zc0301/zc0301_core.c b/drivers/media/video/zc0301/zc0301_core.c
index 9fc5817..9d00e60 100644
--- a/drivers/media/video/zc0301/zc0301_core.c
+++ b/drivers/media/video/zc0301/zc0301_core.c
@@ -1020,7 +1020,7 @@ zc0301_vidioc_querycap(struct zc0301_device* cam, void __user * arg)
 
 	strlcpy(cap.card, cam->v4ldev->name, sizeof(cap.card));
 	if (usb_make_path(cam->usbdev, cap.bus_info, sizeof(cap.bus_info)) < 0)
-		strlcpy(cap.bus_info, cam->usbdev->dev.bus_id,
+		strlcpy(cap.bus_info, dev_name(&cam->usbdev->dev),
 			sizeof(cap.bus_info));
 
 	if (copy_to_user(arg, &cap, sizeof(cap)))
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index c5de7bb..9231e2d 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -56,7 +56,7 @@ struct soc_camera_host {
 	struct device dev;
 	unsigned char nr;				/* Host number */
 	void *priv;
-	char *drv_name;
+	const char *drv_name;
 	struct soc_camera_host_ops *ops;
 };
 
@@ -107,7 +107,7 @@ extern int soc_camera_video_start(struct soc_camera_device *icd);
 extern void soc_camera_video_stop(struct soc_camera_device *icd);
 
 struct soc_camera_data_format {
-	char *name;
+	const char *name;
 	unsigned int depth;
 	__u32 fourcc;
 	enum v4l2_colorspace colorspace;


