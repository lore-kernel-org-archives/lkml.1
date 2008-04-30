Return-Path: <linux-kernel-owner+w=401wt.eu-S934629AbYEAAC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629AbYEAAC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbYD3X6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:47488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762616AbYD3X6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/11] pcmcia: remove pccard_sysfs_interface warnings
Date: Wed, 30 Apr 2008 16:57:48 -0700
Message-Id: <1209599870-22919-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Make the PCMCIA core stop using class_interface to hide socket attribute
registration.  This removes the associated section mismatch warnings, and
helps get to the point where that mechanism can finally be removed.

Simplify that attribute registration by using an attribute_group.
This is a net shrink in object size.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pcmcia/cs.c           |   13 ++++------
 drivers/pcmcia/cs_internal.h  |    3 +-
 drivers/pcmcia/socket_sysfs.c |   52 ++++++++++++++++------------------------
 3 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 56230db..29276bd 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -652,6 +652,9 @@ static int pccardd(void *__skt)
 		complete(&skt->thread_done);
 		return 0;
 	}
+	ret = pccard_sysfs_add_socket(&skt->dev);
+	if (ret)
+		dev_warn(&skt->dev, "err %d adding socket attributes\n", ret);
 
 	add_wait_queue(&skt->thread_wait, &wait);
 	complete(&skt->thread_done);
@@ -694,6 +697,7 @@ static int pccardd(void *__skt)
 	remove_wait_queue(&skt->thread_wait, &wait);
 
 	/* remove from the device core */
+	pccard_sysfs_remove_socket(&skt->dev);
 	device_unregister(&skt->dev);
 
 	return 0;
@@ -940,20 +944,13 @@ EXPORT_SYMBOL(pcmcia_socket_class);
 
 static int __init init_pcmcia_cs(void)
 {
-	int ret;
-
 	init_completion(&pcmcia_unload);
-	ret = class_register(&pcmcia_socket_class);
-	if (ret)
-		return (ret);
-	return class_interface_register(&pccard_sysfs_interface);
+	return class_register(&pcmcia_socket_class);
 }
 
 static void __exit exit_pcmcia_cs(void)
 {
-	class_interface_unregister(&pccard_sysfs_interface);
 	class_unregister(&pcmcia_socket_class);
-
 	wait_for_completion(&pcmcia_unload);
 }
 
diff --git a/drivers/pcmcia/cs_internal.h b/drivers/pcmcia/cs_internal.h
index 9fa207e..e7d5d14 100644
--- a/drivers/pcmcia/cs_internal.h
+++ b/drivers/pcmcia/cs_internal.h
@@ -121,7 +121,8 @@ struct resource *pcmcia_find_mem_region(u_long base, u_long num, u_long align,
 void release_resource_db(struct pcmcia_socket *s);
 
 /* In socket_sysfs.c */
-extern struct class_interface pccard_sysfs_interface;
+extern int pccard_sysfs_add_socket(struct device *dev);
+extern void pccard_sysfs_remove_socket(struct device *dev);
 
 /* In cs.c */
 extern struct rw_semaphore pcmcia_socket_list_rwsem;
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index b440900..562384d 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -356,19 +356,23 @@ static ssize_t pccard_store_cis(struct kobject *kobj,
 }
 
 
-static struct device_attribute *pccard_socket_attributes[] = {
-	&dev_attr_card_type,
-	&dev_attr_card_voltage,
-	&dev_attr_card_vpp,
-	&dev_attr_card_vcc,
-	&dev_attr_card_insert,
-	&dev_attr_card_pm_state,
-	&dev_attr_card_eject,
-	&dev_attr_card_irq_mask,
-	&dev_attr_available_resources_setup_done,
+static struct attribute *pccard_socket_attributes[] = {
+	&dev_attr_card_type.attr,
+	&dev_attr_card_voltage.attr,
+	&dev_attr_card_vpp.attr,
+	&dev_attr_card_vcc.attr,
+	&dev_attr_card_insert.attr,
+	&dev_attr_card_pm_state.attr,
+	&dev_attr_card_eject.attr,
+	&dev_attr_card_irq_mask.attr,
+	&dev_attr_available_resources_setup_done.attr,
 	NULL,
 };
 
+static const struct attribute_group socket_attrs = {
+	.attrs = pccard_socket_attributes,
+};
+
 static struct bin_attribute pccard_cis_attr = {
 	.attr = { .name = "cis", .mode = S_IRUGO | S_IWUSR },
 	.size = 0x200,
@@ -376,35 +380,21 @@ static struct bin_attribute pccard_cis_attr = {
 	.write = pccard_store_cis,
 };
 
-static int __devinit pccard_sysfs_add_socket(struct device *dev,
-					     struct class_interface *class_intf)
+int pccard_sysfs_add_socket(struct device *dev)
 {
-	struct device_attribute **attr;
 	int ret = 0;
 
-	for (attr = pccard_socket_attributes; *attr; attr++) {
-		ret = device_create_file(dev, *attr);
+	ret = sysfs_create_group(&dev->kobj, &socket_attrs);
+	if (!ret) {
+		ret = sysfs_create_bin_file(&dev->kobj, &pccard_cis_attr);
 		if (ret)
-			break;
+			sysfs_remove_group(&dev->kobj, &socket_attrs);
 	}
-	if (!ret)
-		ret = sysfs_create_bin_file(&dev->kobj, &pccard_cis_attr);
-
 	return ret;
 }
 
-static void __devexit pccard_sysfs_remove_socket(struct device *dev,
-						 struct class_interface *class_intf)
+void pccard_sysfs_remove_socket(struct device *dev)
 {
-	struct device_attribute **attr;
-
 	sysfs_remove_bin_file(&dev->kobj, &pccard_cis_attr);
-	for (attr = pccard_socket_attributes; *attr; attr++)
-		device_remove_file(dev, *attr);
+	sysfs_remove_group(&dev->kobj, &socket_attrs);
 }
-
-struct class_interface pccard_sysfs_interface = {
-	.class = &pcmcia_socket_class,
-	.add_dev = &pccard_sysfs_add_socket,
-	.remove_dev = __devexit_p(&pccard_sysfs_remove_socket),
-};
-- 
1.5.5.1

