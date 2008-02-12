Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYBLXJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYBLXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYBLXJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:09:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253AbYBLXJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:09:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=aPsmdF6SLz608qaGZoYsUMwCl1mn7z5jPbL4CReCuuXMhZI2OEGcyravqoHV4MttotU6p2RJ+o4YN37y2QcSnpQsjB6quB0+TPl8vf6lLkYzT3tTVVw9zWahO/lY8yJvaEGKC2TVteeT5cNdU0UwevKWWQr2HtQd4euAmN+cWr8=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-scsi@vger.kernel.org,
       aacraid@adaptec.com, James.Bottomley@HansenPartnership.com
Subject: [PATCH] scsi: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:13 +0100
Message-Id: <1202857582-15450-9-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com
Cc: James.Bottomley@HansenPartnership.com
---
 drivers/scsi/aacraid/commsup.c |    2 +-
 drivers/scsi/ips.c             |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 81b3692..3ac8c82 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -594,7 +594,7 @@ void aac_consumer_free(struct aac_dev * dev, struct aac_queue *q, u32 qid)
 	if (le32_to_cpu(*q->headers.consumer) >= q->entries)
 		*q->headers.consumer = cpu_to_le32(1);
 	else
-		*q->headers.consumer = cpu_to_le32(le32_to_cpu(*q->headers.consumer)+1);
+		le32_add_cpu(q->headers.consumer, 1);
 
 	if (wasfull) {
 		switch (qid) {
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bb152fb..f45770a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3696,9 +3696,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
@@ -3744,9 +3742,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
-- 
1.5.3.7

