Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbXKTMyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbXKTMyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbXKTMx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:53:59 -0500
Received: from s200aog10.obsmtp.com ([207.126.144.124]:35418 "EHLO
	s200aog10.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbXKTMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:53:58 -0500
Message-ID: <4742D8D0.6060007@st.com>
Date: Tue, 20 Nov 2007 13:53:36 +0100
From: Richard MUSIL <richard.musil@st.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpm@selhorst.net>
Subject: Re: [PATCH] - TPM device driver layer (tpm.c|h) - 2nd repost
References: <46CD497F.8030207@st.com>	<20070823092604.GA6057@kroah.com>	<46F909CA.3030101@st.com> <20071119223746.5f0e938f.akpm@linux-foundation.org> <4742D3C6.5000101@st.com>
In-Reply-To: <4742D3C6.5000101@st.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen,

I am sorry for confusion, really do not have my day today :(.
In the last patch I mistakenly removed call to original release.
Now it should be OK.

Richard

>From 208991bcea7034202b9504c2e26c9b2edbf6e31d Mon Sep 17 00:00:00 2001
From: Richard Musil <richard.musil@st.com>
Date: Tue, 20 Nov 2007 14:47:27 +0100
Subject: [PATCH] Subject: [PATCH] TPM: fix for segfault in device removal

The clean up procedure now uses platform device "release" callback to
handle memory clean up.  For this purpose "release" function callback was
added to struct tpm_vendor_specific, so hw device driver provider can get
called when it is safe to remove all allocated resources.

This is supposed to fix a bug in device removal, where device while in
receive function (waiting on timeout) was prone to segfault, if the
tpm_chip struct was unallocated before the timeout expired (in
tpm_remove_hardware).

Signed-off-by: Richard Musil <richard.musil@st.com>
---
 drivers/char/tpm/tpm.c |   44 +++++++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm.h |    2 ++
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9bb5429..ba48a11 100644
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
 
@@ -1083,6 +1078,26 @@ int tpm_pm_resume(struct device *dev)
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
+
+	if (chip->vendor.release)
+		chip->vendor.release(dev);
+
+	chip->release(dev);
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
@@ -1136,23 +1151,21 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
 
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
@@ -1160,10 +1173,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
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
-- 
1.5.3.4

