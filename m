Return-Path: <linux-kernel-owner+w=401wt.eu-S1423672AbXEAVdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423672AbXEAVdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423682AbXEAVdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:33:09 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:43002 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423672AbXEAVdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:33:08 -0400
Message-ID: <4637B210.5040302@simon.arlott.org.uk>
Date: Tue, 01 May 2007 22:33:04 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux DVB <linux-dvb@linuxtv.org>
CC: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [linux-dvb] [PATCH] dvb-core: Handle failures to create devices
References: <463774FE.9030104@simon.arlott.org.uk> <Pine.LNX.4.58.0705011418130.309@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0705011418130.309@shell2.speakeasy.net>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dvb-core is not started early enough when device drivers that use dvb are 
compiled in so device_register_device fails (silently) since dvb_class is 
NULL, this runs dvb_init using subsys_initcall instead of module_init.

dvb_register_device will now check the return value of class_device_create.
All the printks had missing level prefixes so I've fixed these too.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
On 01/05/07 22:21, Trent Piepho wrote:
> On Tue, 1 May 2007, Simon Arlott wrote:
>> dvb-core is not started early enough when device drivers that use dvb are
>> compiled in so device_register_device fails (silently) since dvb_class is
>> NULL, this runs dvb_init using subsys_initclass instead of module_init.
>>
>> dvb_register_device will now check the return value of class_device_create.
> 
> Good catch.

Thanks, it's only been 11 months since I first pointed it out.

>> +		printk("%s: failed to create device dvb%d.%s%d (%ld)\n", __FUNCTION__,
>> +			adap->num, dnames[type], id, PTR_ERR(clsdev));
>> +		return PTR_ERR(clsdev);
> 
> printk(KERN_ERR "...."

I copied another printk from that file without thinking.

 drivers/media/dvb/dvb-core/dvbdev.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 7683983..297da62 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -201,6 +201,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	struct dvb_device *dvbdev;
 	struct file_operations *dvbdevfops;
 
+	struct class_device *clsdev;
 	int id;
 
 	mutex_lock(&dvbdev_register_lock);
@@ -208,7 +209,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if ((id = dvbdev_get_free_id (adap, type)) < 0){
 		mutex_unlock(&dvbdev_register_lock);
 		*pdvbdev = NULL;
-		printk ("%s: could get find free device id...\n", __FUNCTION__);
+		printk(KERN_ERR "%s: could get find free device id...\n", __FUNCTION__);
 		return -ENFILE;
 	}
 
@@ -242,10 +243,16 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 
 	mutex_unlock(&dvbdev_register_lock);
 
-	class_device_create(dvb_class, NULL, MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
+	clsdev = class_device_create(dvb_class, NULL, MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
 			    adap->device, "dvb%d.%s%d", adap->num, dnames[type], id);
 
-	dprintk("DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
+	if (IS_ERR(clsdev)) {
+		printk(KERN_ERR "%s: failed to create device dvb%d.%s%d (%ld)\n", __FUNCTION__,
+			adap->num, dnames[type], id, PTR_ERR(clsdev));
+		return PTR_ERR(clsdev);
+	}
+
+	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, nums2minor(adap->num, type, id),
 		nums2minor(adap->num, type, id));
 
@@ -304,7 +311,7 @@ int dvb_register_adapter(struct dvb_adapter *adap, const char *name, struct modu
 	memset (adap, 0, sizeof(struct dvb_adapter));
 	INIT_LIST_HEAD (&adap->device_list);
 
-	printk ("DVB: registering new adapter (%s).\n", name);
+	printk(KERN_INFO "DVB: registering new adapter (%s).\n", name);
 
 	adap->num = num;
 	adap->name = name;
@@ -400,13 +407,13 @@ static int __init init_dvbdev(void)
 	dev_t dev = MKDEV(DVB_MAJOR, 0);
 
 	if ((retval = register_chrdev_region(dev, MAX_DVB_MINORS, "DVB")) != 0) {
-		printk("dvb-core: unable to get major %d\n", DVB_MAJOR);
+		printk(KERN_ERR "dvb-core: unable to get major %d\n", DVB_MAJOR);
 		return retval;
 	}
 
 	cdev_init(&dvb_device_cdev, &dvb_device_fops);
 	if ((retval = cdev_add(&dvb_device_cdev, dev, MAX_DVB_MINORS)) != 0) {
-		printk("dvb-core: unable to get major %d\n", DVB_MAJOR);
+		printk(KERN_ERR "dvb-core: unable to get major %d\n", DVB_MAJOR);
 		goto error;
 	}
 
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
09F911029D74E35BD84156C5635688C0
