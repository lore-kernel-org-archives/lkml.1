Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZA0Cnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZA0Cnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 21:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZA0Cng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 21:43:36 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35318 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752164AbZA0Cnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 21:43:35 -0500
X-YMail-OSG: 4JBwHV4VM1lebnvMc2VN5gm5EmofeeKwCN_Jws3P80Nj.BkXhdtwtDdvGKud9qc1nIi_36BtKhJ92RSxCc.9cZOMteZYSJf2W0c0UJ3s9bSOn3lwagh_v9JNms61n6W5m.f1iBJ.sYuznAp3GYyJdhhxRM_K0Gy.2T5wvdBnXyNJcxFlB9bxN2Fxt6IQRGSxbEqrlpAp2NfUnZXcsXzoFEt2PVtMB67bIe3DDSdW7ou4JUCNovs-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH]  [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service
	Action REPORT_CAPABILITIES
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Christoph Hellwig <hch@lst.de>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Rafiu Fakunle <rafiu@openfiler.com>,
       Ming Zhang <blackmagic02881@gmail.com>,
       "Ross S. W. Walker" <rswwalker@gmail.com>,
       Arne Redlich <agr@powerkom-dd.de>, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 18:42:18 -0800
Message-Id: <1233024138.6442.65.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e384da701c0b29c40c8dca9e078cf48d273aa405 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 18:26:21 -0800
Subject: [PATCH]  [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service Action REPORT_CAPABILITIES

This patch adds initial support for PRIN Service Action REPORT_CAPABILITIES support,
and a basic set of PERSISTENT_RESERVATION features for bringup, with the complete
set defined (but mostly disabled or not implemented yet) for long term usage
Target_Core_Mod SPC-3 Compatible Persistent Reservations support.

Using sg_persist from the sg3_utils package, here is what an Target_Core_Mod/IBLOCK
SPC_3 + REPORT_CAPABILITIES response data looks like from LIO-Target v3.0 across
Linux/SCTP:

root@ubuntu:~# sg_persist --in --report-capabilities -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation In cmd: 5e 02 00 00 00 00 00 20 00 00
Report capabilities response:
  Compatible Reservation Handling(CRH): 0
  Specify Initiator Ports Capable(SIP_C): 0
  All Target Ports Capable(ATP_C): 0
  Persist Through Power Loss Capable(PTPL_C): 0
  Type Mask Valid(TMV): 1
  Allow commands: 1
  Persist Through Power Loss Active(PTPL_A): 0
    Support indicated in Type mask:
      Write Exclusive, all registrants: 0
      Exclusive Access, registrants only: 0
      Write Exclusive, registrants only: 0
      Exclusive Access: 1
      Write Exclusive: 1
      Exclusive Access, all registrants: 0

These should be enough to get up and running for now.  In following with
previous Target_Core_Mod/ConfigFS commits, All Target Ports Capable=1 and
Compatible Reservation Handling(CRH)=1 will be added first as PROUT SA:
REGISTER/RELEASE emulation is brought online.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pr.c |   45 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index ce1a5d3..41fdf89 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -787,8 +787,51 @@ static int core_scsi3_pri_read_reservation (se_cmd_t *cmd)
 	return(0);
 }
 
+/*
+ * PERSISTENT_RESERVE_IN Service Action REPORT_CAPABILITIES
+ *
+ * See spc4r17 section 6.13.4 Table 165
+ */
 static int core_scsi3_pri_report_capabilities (se_cmd_t *cmd)
 {
+	se_device_t *se_dev = SE_DEV(cmd);
+	se_subsystem_dev_t *su_dev = SU_DEV(se_dev);
+	t10_pr_registration_t *pr_reg;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	u16 add_len = 8; /* Hardcoded to 8. */
+
+	buf[0] = ((add_len << 8) & 0xff);
+	buf[1] = (add_len & 0xff);
+	/*
+	 * FIXME: Leave these features disabled for now..
+	 */
+//	buf[2] |= 0x10; /* CRH: Compatible Reservation Hanlding bit. */
+//	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
+//	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */ 
+//	buf[2] |= 0x01; /* PTPL_C: Persistence across Target Power Loss Capable bit */
+	/*
+	 * We are filling in the PERSISTENT RESERVATION TYPE MASK below, so
+	 * set the TMV: Task Mask Valid bit.
+	 */
+	buf[3] |= 0x80; 
+	/*
+	 * Change ALLOW COMMANDs to 0x20 or 0x40 later from Table 166
+	 */
+	buf[3] |= 0x10; /* ALLOW COMMANDs field 001b */
+	/*
+	 * PTPL_A: Persistence across Target Power Loss Active bit
+	 */
+//	buf[3] |= 0x01;
+	/*
+	 * Setup the PERSISTENT RESERVATION TYPE MASK from Table 167
+	 */
+//	buf[4] |= 0x80; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
+//	buf[4] |= 0x40; /* PR_TYPE_EXCLUSIVE_ACCESS_REGONLY */
+//	buf[4] |= 0x20; /* PR_TYPE_WRITE_EXCLUSIVE_REGONLY */
+	buf[4] |= 0x08; /* PR_TYPE_EXCLUSIVE_ACCESS */
+	buf[4] |= 0x02; /* PR_TYPE_WRITE_EXCLUSIVE */
+//	buf[5] |= 0x01; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
+
 	return(0);
 }
 
@@ -804,9 +847,9 @@ static int core_scsi3_emulate_pr_in (se_cmd_t *cmd, unsigned char *cdb)
 		return(core_scsi3_pri_read_keys(cmd));
 	case PRI_READ_RESERVATION:
 		return(core_scsi3_pri_read_reservation(cmd));
-#if 0
 	case PRI_REPORT_CAPABILITIES:
 		return(core_scsi3_pri_report_capabilities(cmd));
+#if 0
 	case PRI_READ_FULL_STATUS:
 		return(core_scsi3_pri_read_full_status(cmd));
 #endif
-- 
1.5.4.1



