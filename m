Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbYCUV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbYCUV3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbYCUV3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:29:35 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33240 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757667AbYCUV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:29:34 -0400
Subject: [PATCH 2/2] scsi_transport_spi: fix the attribute settings
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 16:29:29 -0500
Message-Id: <1206134969.2961.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now take advantage of the mode_t return of is_valid, and also
update the attributes when the target is configured.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_transport_spi.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index bc12b5d..3a26f74 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1374,11 +1374,11 @@ static int spi_host_configure(struct transport_container *tc,
  * overloads the return by setting 1<<1 if the attribute should
  * be writeable */
 #define TARGET_ATTRIBUTE_HELPER(name) \
-	(si->f->show_##name ? 1 : 0) + \
-	(si->f->set_##name ? 2 : 0)
+	(si->f->show_##name ? S_IRUGO : 0) | \
+	(si->f->set_##name ? S_IWUSR : 0)
 
-static int target_attribute_is_visible(struct kobject *kobj,
-				       struct attribute *attr, int i)
+static mode_t target_attribute_is_visible(struct kobject *kobj,
+					  struct attribute *attr, int i)
 {
 	struct device *cdev = container_of(kobj, struct device, kobj);
 	struct scsi_target *starget = transport_class_to_starget(cdev);
@@ -1428,7 +1428,7 @@ static int target_attribute_is_visible(struct kobject *kobj,
 		 spi_support_ius(starget))
 		return TARGET_ATTRIBUTE_HELPER(hold_mcs);
 	else if (attr == &dev_attr_revalidate.attr)
-		return 1;
+		return S_IWUSR;
 
 	return 0;
 }
@@ -1462,25 +1462,9 @@ static int spi_target_configure(struct transport_container *tc,
 				struct device *cdev)
 {
 	struct kobject *kobj = &cdev->kobj;
-	int i;
-	struct attribute *attr;
-	int rc;
-
-	for (i = 0; (attr = target_attributes[i]) != NULL; i++) {
-		int j = target_attribute_group.is_visible(kobj, attr, i);
-
-		/* FIXME: as well as returning -EEXIST, which we'd like
-		 * to ignore, sysfs also does a WARN_ON and dumps a trace,
-		 * which is bad, so temporarily, skip attributes that are
-		 * already visible (the revalidate one) */
-		if (j && attr != &dev_attr_revalidate.attr)
-			rc = sysfs_add_file_to_group(kobj, attr,
-						target_attribute_group.name);
-		/* and make the attribute writeable if we have a set
-		 * function */
-		if ((j & 1))
-			rc = sysfs_chmod_file(kobj, attr, attr->mode | S_IWUSR);
-	}
+
+	/* force an update based on parameters read from the device */
+	sysfs_update_group(kobj, &target_attribute_group);
 
 	return 0;
 }
-- 
1.5.4.3



