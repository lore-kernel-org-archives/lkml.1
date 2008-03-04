Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYCDQdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYCDQdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765451AbYCDQaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:39 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48602 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765438AbYCDQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:36 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 08/11] memstick: add support for decoding "specfile" media attributes
Date: Wed,  5 Mar 2008 03:02:25 +1100
Message-Id: <1204646548-27466-9-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-8-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-5-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-6-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-7-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-8-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/mspro_block.c |   49 +++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 00e74ea..2381c5d 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -109,6 +109,17 @@ struct mspro_mbr {
 	unsigned int  sectors_per_partition;
 } __attribute__((packed));
 
+struct mspro_specfile {
+	char           name[8];
+	char           ext[3];
+	unsigned char  attr;
+	unsigned char  reserved[10];
+	unsigned short time;
+	unsigned short date;
+	unsigned short cluster;
+	unsigned int   size;
+} __attribute__((packed));
+
 struct mspro_devinfo {
 	unsigned short cylinders;
 	unsigned short heads;
@@ -397,6 +408,41 @@ static ssize_t mspro_block_attr_show_mbr(struct device *dev,
 	return rc;
 }
 
+static ssize_t mspro_block_attr_show_specfile(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buffer)
+{
+	struct mspro_sys_attr *x_attr = container_of(attr,
+						     struct mspro_sys_attr,
+						     dev_attr);
+	struct mspro_specfile *x_spfile = x_attr->data;
+	char name[9], ext[4];
+	ssize_t rc = 0;
+
+	memcpy(name, x_spfile->name, 8);
+	name[8] = 0;
+	memcpy(ext, x_spfile->ext, 3);
+	ext[3] = 0;
+
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "name: %s\n", name);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "ext: %s\n", ext);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "attribute: %x\n",
+			x_spfile->attr);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "time: %d:%d:%d\n",
+			x_spfile->time >> 11,
+			(x_spfile->time >> 5) & 0x3f,
+			(x_spfile->time & 0x1f) * 2);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "date: %d-%d-%d\n",
+			(x_spfile->date >> 9) + 1980,
+			(x_spfile->date >> 5) & 0xf,
+			x_spfile->date & 0x1f);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "start cluster: %x\n",
+			x_spfile->cluster);
+	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "size: %x\n",
+			x_spfile->size);
+	return rc;
+}
+
 static ssize_t mspro_block_attr_show_devinfo(struct device *dev,
 					     struct device_attribute *attr,
 					     char *buffer)
@@ -429,6 +475,9 @@ static sysfs_show_t mspro_block_attr_show(unsigned char tag)
 		return mspro_block_attr_show_modelname;
 	case MSPRO_BLOCK_ID_MBR:
 		return mspro_block_attr_show_mbr;
+	case MSPRO_BLOCK_ID_SPECFILEVALUES1:
+	case MSPRO_BLOCK_ID_SPECFILEVALUES2:
+		return mspro_block_attr_show_specfile;
 	case MSPRO_BLOCK_ID_DEVINFO:
 		return mspro_block_attr_show_devinfo;
 	default:
-- 
1.5.3.6

