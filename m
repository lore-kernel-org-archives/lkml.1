Return-Path: <linux-kernel-owner+w=401wt.eu-S1761989AbYFDMRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761989AbYFDMRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbYFDMLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:11:24 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692AbYFDMLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=RavtfBJYyx/SvA3GR0WdsEwk1vSDYfmxzBmFdsN4FfliMQNGKj7JXcKF/K01lzuZ6q
         a3ZMcvRprCInjqf6TgQfo75jK55OEzPYykqjRAlETvSnxByJX7SCSCZUUXiwP/2YdeWx
         +p6bQnhx0LuFrM7aOcDTF4PZC2UqAaYWBAPy8=
Message-Id: <20080604115859.351267641@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:55 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Andrew Vasquez <linux-driver@qlogic.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org
Subject: [patch -v3 22/22] qla2xxx: use memory_read_from_buffer
Content-Disposition: inline; filename=scsi-qla2xxx-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/qla2xxx/qla_attr.c |   45 ++++++++--------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

Index: 2.6-git/drivers/scsi/qla2xxx/qla_attr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/qla2xxx/qla_attr.c
+++ 2.6-git/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,6 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
+#include <linux/fs.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
@@ -20,18 +21,12 @@ qla2x00_sysfs_read_fw_dump(struct kobjec
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	char *rbuf = (char *)ha->fw_dump;
 
 	if (ha->fw_dump_reading == 0)
 		return 0;
-	if (off > ha->fw_dump_len)
-                return 0;
-	if (off + count > ha->fw_dump_len)
-		count = ha->fw_dump_len - off;
 
-	memcpy(buf, &rbuf[off], count);
-
-	return (count);
+	return memory_read_from_buffer(buf, count, &off, ha->fw_dump,
+					ha->fw_dump_len);
 }
 
 static ssize_t
@@ -91,20 +86,13 @@ qla2x00_sysfs_read_nvram(struct kobject 
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	int		size = ha->nvram_size;
-	char		*nvram_cache = ha->nvram;
 
-	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
+	if (!capable(CAP_SYS_ADMIN))
 		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
 
 	/* Read NVRAM data from cache. */
-	memcpy(buf, &nvram_cache[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->nvram,
+					ha->nvram_size);
 }
 
 static ssize_t
@@ -172,14 +160,9 @@ qla2x00_sysfs_read_optrom(struct kobject
 
 	if (ha->optrom_state != QLA_SREADING)
 		return 0;
-	if (off > ha->optrom_region_size)
-		return 0;
-	if (off + count > ha->optrom_region_size)
-		count = ha->optrom_region_size - off;
 
-	memcpy(buf, &ha->optrom_buffer[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->optrom_buffer,
+					ha->optrom_region_size);
 }
 
 static ssize_t
@@ -371,20 +354,12 @@ qla2x00_sysfs_read_vpd(struct kobject *k
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	int           size = ha->vpd_size;
-	char          *vpd_cache = ha->vpd;
 
-	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
+	if (!capable(CAP_SYS_ADMIN))
 		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
 
 	/* Read NVRAM data from cache. */
-	memcpy(buf, &vpd_cache[off], count);
-
-	return count;
+	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
 }
 
 static ssize_t

-- 
