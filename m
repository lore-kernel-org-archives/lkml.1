Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZAXB7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZAXB7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 20:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZAXB7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 20:59:23 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:39353 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754196AbZAXB7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 20:59:22 -0500
X-YMail-OSG: QRPJ.IUVM1mvuJdCkyn7bAoCaOnC4pdfGGKF.NUpTo2pYSpMlUxzsrQpLiqwTFQZP1qXReytaHO.LNgvG3MNsFCPwrCs6G49HSyqFLxS9qUlGBvLuMDU4jABg_0lB14DeaZQs4xERGf13r8qzZgK8nBcZX6VlFYArHYjyA8.CCsH5VswXHroKbaFHJVl2k5Sx9GBhxuoUkyOzyiFrIYGcREFGnFnqcj3dsRZYGSpwuHky1q5fr4-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 5/6] [Target_Core_Mod/pSCSI]: Update EVPD post processing
	logic
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 17:58:58 -0800
Message-Id: <1232762338.24642.22.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 22e2a8e5301d1637c14b214e74abeef3b7023e3d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 23 Jan 2009 17:28:14 -0800
Subject: [PATCH 5/6] [Target_Core_Mod/pSCSI]: Update EVPD post processing logic

This patch adds the usage of se_subsystem_dev_t->t10_wwn information to
the target_core_mod/pSCSI Linux/SCSI subsystem passthrough plugin.

This logic exists so that when using the Linux/SCSI subsystem plugin in
cases where the underlying hardware is not necessarily a complete SPC-3
compliant (or earlier) device, we emulate this logic so that when various
host OS dependent SCSI subsystems communication with target_core_mod
via $FABRIC_MOD, they are properly registered and able to provide stable
services for LIO-Target v3.0 code, and other $FABRIC_MODs

This code currently reproduces logic from
target_core_transport.c:transport_generic_emulate_inquiry(), and
will be replaced generically as real Parallel SCSI, Fibre Channel,
and Serial SCSI (SAS) firmware are tested and validated with this logic
for v3.0 code.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pscsi.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
index b0e0a89..3ff903c 100644
--- a/drivers/lio-core/target_core_pscsi.c
+++ b/drivers/lio-core/target_core_pscsi.c
@@ -617,6 +617,7 @@ extern int pscsi_transport_complete (se_task_t *task)
 		unsigned char *dst = (unsigned char *)
 				T_TASK(task->task_se_cmd)->t_task_buf;
 		unsigned char buf[EVPD_BUF_LEN], *iqn = NULL;
+		se_subsystem_dev_t *su_dev = TASK_DEV(task)->se_sub_dev;
 		se_hba_t *hba = task->se_dev->se_hba;
 
 		/*
@@ -628,9 +629,12 @@ extern int pscsi_transport_complete (se_task_t *task)
 		}
 			
 		/*
-		 * Assume the HBA did the right thing..
+		 * Assume the SCSI Device did the right thing if an EVPD length
+		 * is provided in the INQUIRY response payload.
 		 */
 		if (dst[3] != 0x00) {
+			su_dev->su_dev_flags |= SDF_FIRMWARE_EVPD_UNIT_SERIAL;
+			su_dev->su_dev_flags &= ~SDF_EMULATED_EVPD_UNIT_SERIAL;
 			task->task_scsi_status = GOOD;
 			return(0);
 		}
@@ -649,22 +653,35 @@ extern int pscsi_transport_complete (se_task_t *task)
 			len = 3;
 			break;
 		case 0x80:
-			iqn = transport_get_iqn_sn();
 			buf[1] = 0x80;
-			len += sprintf((unsigned char *)&buf[4], "%s:%u_%u_%u_%u",
-				iqn, hba->hba_id, sd->channel, sd->id, sd->lun);
+			if (su_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL)
+				len += sprintf((unsigned char *)&buf[4], "%s",
+					&su_dev->t10_wwn.unit_serial[0]);
+			else {
+				iqn = transport_get_iqn_sn();
+				len += sprintf((unsigned char *)&buf[4],
+					"%s:%u_%u_%u_%u", iqn, hba->hba_id,
+					sd->channel, sd->id, sd->lun);
+			}
 			buf[3] = len;
 			break;
 		case 0x83:
-			iqn = transport_get_iqn_sn();
 			buf[1] = 0x83;
 			/* Start Identifier Page */
 			buf[4] = 0x2; /* ASCII */
 			buf[5] = 0x1; 
 			buf[6] = 0x0;
-			len += sprintf((unsigned char *)&buf[8], "SBEi-INC");
-			len += sprintf((unsigned char *)&buf[16], "PSCSI:%s:%u_%u_%u_%u",
-					iqn, hba->hba_id, sd->channel, sd->id, sd->lun);
+			len += sprintf((unsigned char *)&buf[8], "LIO-ORG");
+
+			if (su_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL)
+				len += sprintf((unsigned char *)&buf[16],
+					"PSCSI:%s", &su_dev->t10_wwn.unit_serial[0]);
+			else {
+				iqn = transport_get_iqn_sn();
+				len += sprintf((unsigned char *)&buf[16],
+					"PSCSI:%s:%u_%u_%u_%u", iqn, hba->hba_id,
+					sd->channel, sd->id, sd->lun);
+			}
 			buf[7] = len; /* Identifer Length */
 			len += 4;
 			buf[3] = len; /* Page Length */
@@ -926,7 +943,6 @@ extern ssize_t pscsi_set_configfs_dev_params (se_hba_t *hba,
 			params++;
 		} else
 			cur = NULL;
-#warning FIXME: Add evpd_unit_serial= and evpd_dev_ident= parameter support for ConfigFS
 	}
 
 out:
-- 
1.5.4.1



