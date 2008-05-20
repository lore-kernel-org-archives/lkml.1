Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbYETSOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbYETSOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbYETSHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:07:11 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:37884 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869AbYETSHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=op32DHWEiFtbTd5nR5Ph2XanuRQadQT+yzZaevKeX+k3omV0cZfvQTN9SQlyOyVRq+pCzbqBa9szp7lkn0bDclj4G7gWeD+6A2oeVNc3/9azLRznzK2M3mIxqInRAKBjLW4Pqg6F0k4abQNnQazRNOWnrfRqi9W50xH9XnZhR/8=
Subject: [PATCH 07/21] scsi: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:21 -0700
Message-Id: <1211306781.5915.186.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/aacraid/commsup.c      |    8 ++++----
 drivers/scsi/aic94xx/aic94xx_scb.c  |    4 ++--
 drivers/scsi/aic94xx/aic94xx_task.c |    8 ++++----
 drivers/scsi/stex.c                 |    2 +-
 include/scsi/sas.h                  |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 289304a..2dcdaf0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -839,13 +839,13 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32(aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32(aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
@@ -979,13 +979,13 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32(aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32(aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 4664331..5ad357d 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -156,10 +156,10 @@ static void asd_get_attached_sas_addr(struct asd_phy *phy, u8 *sas_addr)
 	    && phy->sas_phy.oob_mode == SATA_OOB_MODE) {
 		struct asd_ha_struct *asd_ha = phy->sas_phy.ha->lldd_ha;
 		/* FIS device-to-host */
-		u64 addr = be64_to_cpu(*(__be64 *)phy->phy_desc->sas_addr);
+		u64 addr = get_be64(phy->phy_desc->sas_addr);
 
 		addr += asd_ha->hw_prof.sata_name_base + ord_phy(asd_ha, phy);
-		*(__be64 *)sas_addr = cpu_to_be64(addr);
+		put_be64(addr, sas_addr);
 	} else {
 		struct sas_identify_frame *idframe =
 			(void *) phy->sas_phy.frame_rcvd;
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 326765c..78b75db 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -191,16 +191,16 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 		struct ssp_response_iu *iu =
 			r + 16 + sizeof(struct ssp_frame_hdr);
 
-		ts->residual = le32_to_cpu(*(__le32 *)r);
+		ts->residual = get_le32(r);
 
 		sas_ssp_task_response(&asd_ha->pcidev->dev, task, iu);
 	}  else {
 		struct ata_task_resp *resp = (void *) &ts->buf[0];
 
-		ts->residual = le32_to_cpu(*(__le32 *)r);
+		ts->residual = get_le32(r);
 
 		if (SAS_STATUS_BUF_SIZE >= sizeof(*resp)) {
-			resp->frame_len = le16_to_cpu(*(__le16 *)(r+6));
+			resp->frame_len = get_le16(r + 6);
 			memcpy(&resp->ending_fis[0], r+16, 24);
 			ts->buf_valid_size = sizeof(*resp);
 		}
@@ -228,7 +228,7 @@ Again:
 	case TC_UNDERRUN:
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
-		ts->residual = le32_to_cpu(*(__le32 *)dl->status_block);
+		ts->residual = get_le32(dl->status_block);
 		break;
 	case TC_OVERRUN:
 		ts->resp = SAS_TASK_COMPLETE;
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f308a03..5c0eccd 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -660,7 +660,7 @@ static void stex_ys_commands(struct st_hba *hba,
 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
 		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
 		scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
-			le32_to_cpu(*(__le32 *)&resp->variable[0]));
+			get_le32(&resp->variable[0]));
 		return;
 	}
 
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index e9fd022..a0ff89a 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -31,7 +31,7 @@
 
 #define SAS_ADDR_SIZE        8
 #define HASHED_SAS_ADDR_SIZE 3
-#define SAS_ADDR(_sa) ((unsigned long long) be64_to_cpu(*(__be64 *)(_sa)))
+#define SAS_ADDR(_sa) ((unsigned long long)get_be64(_sa))
 
 #define SMP_REQUEST             0x40
 #define SMP_RESPONSE            0x41
-- 
1.5.5.1.570.g26b5e


