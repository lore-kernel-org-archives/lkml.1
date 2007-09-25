Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbXIYNP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbXIYNP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbXIYNPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:15:20 -0400
Received: from s200aog11.obsmtp.com ([207.126.144.125]:37118 "EHLO
	s200aog11.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbXIYNPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:15:19 -0400
Message-ID: <46F909CA.3030101@st.com>
Date: Tue, 25 Sep 2007 15:14:50 +0200
From: Richard MUSIL <richard.musil@st.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] - TPM device driver layer (tpm.c|h) - repost
References: <46CD497F.8030207@st.com> <20070823092604.GA6057@kroah.com>
In-Reply-To: <20070823092604.GA6057@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

sometime ago I submitted patch to TPM layer, originally I thought this
patch could be accepted into kernel (see below). However,
since this did not happen, I wonder, if there are some problems with the
patch or whether I am expected to do/provide something else, in order to
have it accepted.

The patch follows even more below.

Thanks,
Richard

Greg KH wrote:
> On Thu, Aug 23, 2007 at 10:46:55AM +0200, Richard MUSIL wrote:
>> Dear all,
>>
>> I am currently writing virtual TPM device driver. This driver exposes
>> itself and behaves like regular TPM device (i.e. uses TPM layer which is
>> already present in kernel), but instead of talking to hardware it talks
>> to user space.
> 
> Heh, I like the idea, I can imagine what it could be used for :)
> 
>> What I present below is rather quickfix with least impact on other TPM
>> parts (drivers). The patch uses device->remove callback (of
>> platform_device device) and reroutes this to itself. In this
>> callback it eventually calls vendor callback and finally kfrees all
>> memory resources allocated on its own.
> 
> It looks sane to me, nice fixup.
> 
> thanks,
> 
> greg k-h
> 

>From bd80b63ca2e1edb761a3ffcf87bd86c30a44ca5f Mon Sep 17 00:00:00 2001
From: Richard Musil <richard.musil@st.com>
Date: Tue, 21 Aug 2007 16:46:06 +0200
Subject: [PATCH] Change in TPM module:

The clean up procedure now uses platform device "release" callback to
handle memory clean up. For this purpose "release" function callback was
added to struct tpm_vendor_specific, so hw device driver provider can get
called when it is safe to remove all allocated resources.

This is supposed to fix a bug in device removal, where device while in
receive function (waiting on timeout) was prone to segfault, if the
tpm_chip struct was unallocated before the timeout expired (in
tpm_remove_hardware).
---
 drivers/char/tpm/tpm.c |   46 +++++++++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm.h |    2 ++
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9bb5429..41eba7e 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1031,18 +1031,13 @@ void tpm_remove_hardware(struct device *dev)
 
 	spin_unlock(&driver_lock);
 
-	dev_set_drvdata(dev, NULL);
 	misc_deregister(&chip->vendor.miscdev);
-	kfree(chip->vendor.miscdev.name);
 
 	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
 	tpm_bios_log_teardown(chip->bios_dir);
 
-	clear_bit(chip->dev_num, dev_mask);
-
-	kfree(chip);
-
-	put_device(dev);
+	/* write it this way to be explicit (chip->dev == dev) */
+	put_device(chip->dev);
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
@@ -1083,6 +1078,28 @@ int tpm_pm_resume(struct device *dev)
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 /*
+ * Once all references to platform device are down to 0,
+ * release all allocated structures.
+ * In case vendor provided release function,
+ * call it too.
+ */
+static void tpm_dev_release(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	/* call vendor release, if defined */
+	if (chip->vendor.release)
+		chip->vendor.release(dev);
+
+	/* it *should* be: chip->release != NULL */
+	if (likely(chip->release))
+		chip->release(dev);
+
+	clear_bit(chip->dev_num, dev_mask);
+	kfree(chip->vendor.miscdev.name);
+	kfree(chip);
+}
+
+/*
  * Called from tpm_<specific>.c probe function only for devices 
  * the driver has determined it should claim.  Prior to calling
  * this function the specific probe function has called pci_enable_device
@@ -1136,23 +1153,21 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
 
 	chip->vendor.miscdev.parent = dev;
 	chip->dev = get_device(dev);
+	chip->release = dev->release;
+	dev->release = tpm_dev_release;
+	dev_set_drvdata(dev, chip);
 
 	if (misc_register(&chip->vendor.miscdev)) {
 		dev_err(chip->dev,
 			"unable to misc_register %s, minor %d\n",
 			chip->vendor.miscdev.name,
 			chip->vendor.miscdev.minor);
-		put_device(dev);
-		clear_bit(chip->dev_num, dev_mask);
-		kfree(chip);
-		kfree(devname);
+		put_device(chip->dev);
 		return NULL;
 	}
 
 	spin_lock(&driver_lock);
 
-	dev_set_drvdata(dev, chip);
-
 	list_add(&chip->list, &tpm_chip_list);
 
 	spin_unlock(&driver_lock);
@@ -1160,10 +1175,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
 	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
 		list_del(&chip->list);
 		misc_deregister(&chip->vendor.miscdev);
-		put_device(dev);
-		clear_bit(chip->dev_num, dev_mask);
-		kfree(chip);
-		kfree(devname);
+		put_device(chip->dev);
 		return NULL;
 	}
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b2e2b00..f1c265e 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -74,6 +74,7 @@ struct tpm_vendor_specific {
 	int (*send) (struct tpm_chip *, u8 *, size_t);
 	void (*cancel) (struct tpm_chip *);
 	u8 (*status) (struct tpm_chip *);
+	void (*release) (struct device *);
 	struct miscdevice miscdev;
 	struct attribute_group *attr_group;
 	struct list_head list;
@@ -106,6 +107,7 @@ struct tpm_chip {
 	struct dentry **bios_dir;
 
 	struct list_head list;
+	void (*release) (struct device *);
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
-- 1.5.3.rc5 
