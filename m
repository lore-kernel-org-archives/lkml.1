Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbYEXCQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbYEXCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 22:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbYEXCQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 22:16:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:25133 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbYEXCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 22:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=XSvvJpD5ggpM0ret+Vd8IdlpQmK38+WhpfbKcTzt14SrdN8NNZeqLM4kfgYh8PUAha8cmYIR2hdwresUQ9pnTRzFqG1Z0mKeLmxVKp6KdMJYlwW1SyDU8VU3Tuxx5S/WiNrGY/2gPM/FqsWTnInv1Az6+MLex1tmrVvlwe4ES5g=
Date: Sat, 24 May 2008 11:05:05 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Domsch <Matt_Domsch@Dell.com>
Subject: [PATCH] edd: consolidate error checks
Message-ID: <20080524020503.GB3470@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many show operations in edd_attribute have same error checks at the head.
This patch consolidates these error checks to callee function.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>
---
 drivers/firmware/edd.c |   74 ++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 43 deletions(-)

Index: 2.6-git/drivers/firmware/edd.c
===================================================================
--- 2.6-git.orig/drivers/firmware/edd.c
+++ 2.6-git/drivers/firmware/edd.c
@@ -115,11 +115,14 @@ edd_attr_show(struct kobject * kobj, str
 {
 	struct edd_device *dev = to_edd_device(kobj);
 	struct edd_attribute *edd_attr = to_edd_attr(attr);
-	ssize_t ret = -EIO;
 
-	if (edd_attr->show)
-		ret = edd_attr->show(dev, buf);
-	return ret;
+	if (!edd_attr->show)
+		return -EIO;
+
+	if (!dev || !buf)
+		return -EINVAL;
+
+	return edd_attr->show(dev, buf);
 }
 
 static struct sysfs_ops edd_attr_ops = {
@@ -133,10 +136,8 @@ edd_show_host_bus(struct edd_device *ede
 	char *p = buf;
 	int i;
 
-	if (!edev)
-		return -EINVAL;
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	for (i = 0; i < 4; i++) {
@@ -179,10 +180,8 @@ edd_show_interface(struct edd_device *ed
 	char *p = buf;
 	int i;
 
-	if (!edev)
-		return -EINVAL;
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	for (i = 0; i < 8; i++) {
@@ -243,10 +242,9 @@ edd_show_raw_data(struct edd_device *ede
 {
 	struct edd_info *info;
 	ssize_t len = sizeof (info->params);
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	if (!(info->params.key == 0xBEDD || info->params.key == 0xDDBE))
@@ -265,10 +263,9 @@ edd_show_version(struct edd_device *edev
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "0x%02x\n", info->version);
@@ -288,10 +285,9 @@ edd_show_extensions(struct edd_device *e
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	if (info->interface_support & EDD_EXT_FIXED_DISK_ACCESS) {
@@ -314,10 +310,9 @@ edd_show_info_flags(struct edd_device *e
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	if (info->params.info_flags & EDD_INFO_DMA_BOUNDARY_ERROR_TRANSPARENT)
@@ -344,10 +339,9 @@ edd_show_legacy_max_cylinder(struct edd_
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_max_cylinder);
@@ -359,10 +353,9 @@ edd_show_legacy_max_head(struct edd_devi
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_max_head);
@@ -374,10 +367,9 @@ edd_show_legacy_sectors_per_track(struct
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += snprintf(p, left, "%u\n", info->legacy_sectors_per_track);
@@ -389,10 +381,9 @@ edd_show_default_cylinders(struct edd_de
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.num_default_cylinders);
@@ -404,10 +395,9 @@ edd_show_default_heads(struct edd_device
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.num_default_heads);
@@ -419,10 +409,9 @@ edd_show_default_sectors_per_track(struc
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%u\n", info->params.sectors_per_track);
@@ -434,10 +423,9 @@ edd_show_sectors(struct edd_device *edev
 {
 	struct edd_info *info;
 	char *p = buf;
-	if (!edev)
-		return -EINVAL;
+
 	info = edd_dev_get_info(edev);
-	if (!info || !buf)
+	if (!info)
 		return -EINVAL;
 
 	p += scnprintf(p, left, "%llu\n", info->params.number_of_sectors);
