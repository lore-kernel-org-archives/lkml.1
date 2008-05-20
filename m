Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbYETSOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbYETSOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbYETSHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:07:14 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:3485 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbYETSHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uZyxwFU27fmENci+Mh8cj18stRTtT+wsdKm2iOl9lkkYXn3P3geHHfZ3BmvTOxUe4ZEX8pvADM+dswxGZOJCq3YVGvZ0qRPBFe3xu/iBjyTooSDck6q3AkBxemjxfYuJDLLUKoVMxikAQrbw0FU2Y/SfaOiKx9vxd2TSe89+hYk=
Subject: [PATCH 08/21] ata: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:21 -0700
Message-Id: <1211306782.5915.187.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/pdc_adma.c   |   11 +++++------
 drivers/ata/sata_qstor.c |   10 +++++-----
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index be53545..12675f3 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -284,11 +284,11 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 		u32 len;
 
 		addr = (u32)sg_dma_address(sg);
-		*(__le32 *)(buf + i) = cpu_to_le32(addr);
+		put_le32(addr, buf + i);
 		i += 4;
 
 		len = sg_dma_len(sg) >> 3;
-		*(__le32 *)(buf + i) = cpu_to_le32(len);
+		put_le32(len, buf + i);
 		i += 4;
 
 		last_buf = &buf[i];
@@ -297,8 +297,7 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 		buf[i++] = 0;	/* pPKLW */
 		buf[i++] = 0;	/* reserved */
 
-		*(__le32 *)(buf + i) =
-			(pFLAGS & pEND) ? 0 : cpu_to_le32(pp->pkt_dma + i + 4);
+		put_le32((pFLAGS & pEND) ? 0 : (pp->pkt_dma + i + 4), buf + i);
 		i += 4;
 
 		VPRINTK("PRD[%u] = (0x%lX, 0x%X)\n", i/4,
@@ -331,7 +330,7 @@ static void adma_qc_prep(struct ata_queued_cmd *qc)
 	buf[i++] = cVLD | cDAT | cIEN;
 	i++;		/* cLEN, gets filled in below */
 
-	*(__le32 *)(buf+i) = cpu_to_le32(pkt_dma);	/* cNCPB */
+	put_le32(pkt_dma, buf + i);	/* cNCPB */
 	i += 4;		/* cNCPB */
 	i += 4;		/* cPRD, gets filled in below */
 
@@ -369,7 +368,7 @@ static void adma_qc_prep(struct ata_queued_cmd *qc)
 	buf[i++] = ADMA_REGS_COMMAND | rEND;
 
 	buf[3] = (i >> 3) - 2;				/* cLEN */
-	*(__le32 *)(buf+8) = cpu_to_le32(pkt_dma + i);	/* cPRD */
+	put_le32(pkt_dma + i, buf + 8);	/* cPRD */
 
 	i = adma_fill_sg(qc);
 	wmb();	/* flush PRDs and pkt to memory */
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 1600107..b7f9d4f 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -277,11 +277,11 @@ static unsigned int qs_fill_sg(struct ata_queued_cmd *qc)
 		u32 len;
 
 		addr = sg_dma_address(sg);
-		*(__le64 *)prd = cpu_to_le64(addr);
+		put_le64(addr, prd);
 		prd += sizeof(u64);
 
 		len = sg_dma_len(sg);
-		*(__le32 *)prd = cpu_to_le32(len);
+		put_le32(len, prd);
 		prd += sizeof(u64);
 
 		VPRINTK("PRD[%u] = (0x%llX, 0x%X)\n", si,
@@ -317,10 +317,10 @@ static void qs_qc_prep(struct ata_queued_cmd *qc)
 	/* host control block (HCB) */
 	buf[ 0] = QS_HCB_HDR;
 	buf[ 1] = hflags;
-	*(__le32 *)(&buf[ 4]) = cpu_to_le32(qc->nbytes);
-	*(__le32 *)(&buf[ 8]) = cpu_to_le32(nelem);
+	put_le32(qc->nbytes, &buf[4]);
+	put_le32(nelem, &buf[8]);
 	addr = ((u64)pp->pkt_dma) + QS_CPB_BYTES;
-	*(__le64 *)(&buf[16]) = cpu_to_le64(addr);
+	put_le64(addr, &buf[16]);
 
 	/* device control block (DCB) */
 	buf[24] = QS_DCB_HDR;
-- 
1.5.5.1.570.g26b5e


