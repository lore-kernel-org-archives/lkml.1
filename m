Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYJCUts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYJCUts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYJCUtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:49:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:23131 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbYJCUti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Leu8QeDBSW5c0t+V9T3/L7fvRezFx8NszXCdH4MQ47GF4OZHpKjhlZW9+YJ6FGIU8i
         16NQbIWxVVhrA+0SNCJhsKWzAsohDGz0syNAOOEun0mqfanopUcIAPr+PAlHBCvnQmQ2
         52aiiif6NNf91/MBbJYUlW4DMQqYH/GbQKct8=
Subject: [PATCH] scsi: remove private implementation of get_unaligned_be32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:49:35 -0700
Message-Id: <1223066975.6512.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/libsas/sas_expander.c |    9 +++++----
 include/scsi/scsi.h                |    6 ------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 3da02e4..d8a34b5 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -24,6 +24,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
+#include <asm/unaligned.h>
 
 #include "sas_internal.h"
 
@@ -541,10 +542,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 	if (!res)
 		goto out;
 
-	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
-	phy->running_disparity_error_count = scsi_to_u32(&resp[16]);
-	phy->loss_of_dword_sync_count = scsi_to_u32(&resp[20]);
-	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
+	phy->invalid_dword_count = get_unaligned_be32(&resp[12]);
+	phy->running_disparity_error_count = get_unaligned_be32(&resp[16]);
+	phy->loss_of_dword_sync_count = get_unaligned_be32(&resp[20]);
+	phy->phy_reset_problem_count = get_unaligned_be32(&resp[24]);
 
  out:
 	kfree(resp);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 192f871..66be589 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -521,10 +521,4 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
-static inline __u32 scsi_to_u32(__u8 *ptr)
-{
-	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
-}
-
 #endif /* _SCSI_SCSI_H */
-- 
1.6.0.2.471.g47a76

