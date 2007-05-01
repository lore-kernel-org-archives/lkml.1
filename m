Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbXEARMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbXEARMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbXEARMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:12:34 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38228 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbXEARMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:12:32 -0400
Message-ID: <463774FE.9030104@simon.arlott.org.uk>
Date: Tue, 01 May 2007 18:12:30 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-dvb@linuxtv.org
Subject: [PATCH] dvb-core: Handle failures to create devices
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dvb-core is not started early enough when device drivers that use dvb are 
compiled in so device_register_device fails (silently) since dvb_class is 
NULL, this runs dvb_init using subsys_initclass instead of module_init.

dvb_register_device will now check the return value of class_device_create.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/media/dvb/dvb-core/dvbdev.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 7683983..b859a60 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -201,6 +201,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	struct dvb_device *dvbdev;
 	struct file_operations *dvbdevfops;
 
+	struct class_device *clsdev;
 	int id;
 
 	mutex_lock(&dvbdev_register_lock);
@@ -242,9 +243,15 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 
 	mutex_unlock(&dvbdev_register_lock);
 
-	class_device_create(dvb_class, NULL, MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
+	clsdev = class_device_create(dvb_class, NULL, MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
 			    adap->device, "dvb%d.%s%d", adap->num, dnames[type], id);
 
+	if (IS_ERR(clsdev)) {
+		printk("%s: failed to create device dvb%d.%s%d (%ld)\n", __FUNCTION__,
+			adap->num, dnames[type], id, PTR_ERR(clsdev));
+		return PTR_ERR(clsdev);
+	}
+
 	dprintk("DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, nums2minor(adap->num, type, id),
 		nums2minor(adap->num, type, id));
@@ -431,7 +438,7 @@ static void __exit exit_dvbdev(void)
 	unregister_chrdev_region(MKDEV(DVB_MAJOR, 0), MAX_DVB_MINORS);
 }
 
-module_init(init_dvbdev);
+subsys_initcall(init_dvbdev);
 module_exit(exit_dvbdev);
 
 MODULE_DESCRIPTION("DVB Core Driver");
-- 
1.5.0.1

-- 
Simon Arlott
