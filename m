Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbXD0TFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbXD0TFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbXD0S6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:58:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:35302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbXD0S6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/46] Driver core: make uevent-environment available in uevent-file
Date: Fri, 27 Apr 2007 11:53:45 -0700
Message-Id: <11777001521006-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700148815-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This allows sysfs to show the environment variables that are available
if the uevent happens.  This lets userspace not have to cache all of
this information as the kernel already knows it.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c34a4d8..72c6ee5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -246,6 +246,53 @@ static struct kset_uevent_ops device_uevent_ops = {
 	.uevent =	dev_uevent,
 };
 
+static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct kobject *top_kobj;
+	struct kset *kset;
+	char *envp[32];
+	char data[PAGE_SIZE];
+	char *pos;
+	int i;
+	size_t count = 0;
+	int retval;
+
+	/* search the kset, the device belongs to */
+	top_kobj = &dev->kobj;
+	if (!top_kobj->kset && top_kobj->parent) {
+		do {
+			top_kobj = top_kobj->parent;
+		} while (!top_kobj->kset && top_kobj->parent);
+	}
+	if (!top_kobj->kset)
+		goto out;
+	kset = top_kobj->kset;
+	if (!kset->uevent_ops || !kset->uevent_ops->uevent)
+		goto out;
+
+	/* respect filter */
+	if (kset->uevent_ops && kset->uevent_ops->filter)
+		if (!kset->uevent_ops->filter(kset, &dev->kobj))
+			goto out;
+
+	/* let the kset specific function add its keys */
+	pos = data;
+	retval = kset->uevent_ops->uevent(kset, &dev->kobj,
+					  envp, ARRAY_SIZE(envp),
+					  pos, PAGE_SIZE);
+	if (retval)
+		goto out;
+
+	/* copy keys to file */
+	for (i = 0; envp[i]; i++) {
+		pos = &buf[count];
+		count += sprintf(pos, "%s\n", envp[i]);
+	}
+out:
+	return count;
+}
+
 static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
@@ -621,10 +668,11 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_ADD_DEVICE, dev);
 
 	dev->uevent_attr.attr.name = "uevent";
-	dev->uevent_attr.attr.mode = S_IWUSR;
+	dev->uevent_attr.attr.mode = S_IRUGO | S_IWUSR;
 	if (dev->driver)
 		dev->uevent_attr.attr.owner = dev->driver->owner;
 	dev->uevent_attr.store = store_uevent;
+	dev->uevent_attr.show = show_uevent;
 	error = device_create_file(dev, &dev->uevent_attr);
 	if (error)
 		goto attrError;
-- 
1.5.1.2

