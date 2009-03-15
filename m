Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbZCOXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbZCOXFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZCOXFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 19:05:12 -0400
Received: from n27.bullet.mail.mud.yahoo.com ([68.142.206.222]:46399 "HELO
	n27.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750761AbZCOXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 19:05:09 -0400
X-Yahoo-Newman-Id: 468226.2483.bm@omp413.mail.mud.yahoo.com
X-YMail-OSG: BETt4YgVM1kTcNJJdt_C4nTd_nCQcgK0dnRZCEMQ8abnYJLq2SfJeHXeMSRhS_Nz0ZCw_UrwQ57dg.GtH4IHnRck0Aism1Ld.jY1YJ_fU2a4IGMuO1zxzZulGqdULNYyLHhKESzfHt9gkHYFfJwRXpEo9dKSh.7iFsiaLF6A0tyaXG1_RFxZmgQYUvGscgaocS7L2P_QsmY4JAh4LCMngm.y_RroSvRR0pYLQhiEvI8aJYHidZE4cFAKERrAHd5F7Jb483jAQdE3CXwbdP3aEmn9gTYzGHFy
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [Target_Core_Mod/Persistent_Reservations]: Enable
	PR_*_REGONLY and PR_*_ALLREG logic
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
       Douglas Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 15 Mar 2009 16:04:41 -0700
Message-Id: <1237158281.11120.1228.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

This patch enables the remaining SPC-3 compliant persistent reservation for PR TYPEs:
PR_TYPE_WRITE_EXCLUSIVE_REGONLY, PR_TYPE_EXCLUSIVE_ACCESS_REGONLY,
PR_TYPE_WRITE_EXCLUSIVE_ALLREG and PR_TYPE_EXCLUSIVE_ACCESS_ALLREG.

This patch hooks up the CDB restriction logic following spc4r17 for *all* PR TYPEs in
core_scsi3_pr_seq_non_holder().  It also enables all PR TYPEs emulation in
core_scsi3_emulate_pro_reserve(), For PR OUT, the patch updates
core_scsi3_pri_read_reservation() for PR_*_ALL_REG reservations to return zero (following spc4r17).

This patch leaves debug code ON for the restricted, non reservation holding path, so
that we can see what CDBs the client side setups are generating for PR bringup.  This means
that for those folks interested in testing PR_*_ALL_REG types, this will generate alot of
dmesg output for non reservation (but registered) initiator ports generation bulk I/O in
core_scsi3_pr_seq_non_holder().  The verbose debug output will be disabled once things
PR_*_ALL_REG gets a bit more testing.

Also, note that unit attention condition for PR_TYPE_*_REG_ONLY and PR_TYPE_*_ALLREG of
ASC type RESERVATION RELEASED is not supported in this patch, and is a WIP.

This patch are made against lio-core-2.6.git/master and tested on v2.6.29-rc8 x86
32-bit HVM. The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

*) Here is the client side setup, sdg and sdk are the same IBLOCK LUN available
across two different LIO-Target Endpoints (TargetName+TPGT) using an x86 HVM
Open/iSCSI Initiator.

initiator# lsscsi --transport
[0:0:0:0]    disk                                    /dev/sda
[0:0:1:0]    disk                                    /dev/sdb
[0:0:2:0]    disk                                    /dev/sdc
[1:0:0:0]    disk                                    /dev/sdd
[10:0:0:0]   disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x1  /dev/sdg
[10:0:0:1]   disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x1  /dev/sdh
[10:0:0:2]   disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x1  /dev/sdi
[10:0:0:3]   disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x1  /dev/sdj
[12:0:0:0]   disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x1  /dev/sdk
initiator# lsscsi
[0:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda
[0:0:1:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sdb
[0:0:2:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sdc
[1:0:0:0]    disk    ATA      VMware Virtual I 0000  /dev/sdd
[10:0:0:0]   disk    LIO-ORG  IBLOCK           3.0   /dev/sdg
[10:0:0:1]   disk    VMware,  VMware Virtual S 1.0   /dev/sdh
[10:0:0:2]   disk    LIO-ORG  RAMDISK-MCP      3.0   /dev/sdi
[10:0:0:3]   disk    LIO-ORG  FILEIO           3.0   /dev/sdj
[12:0:0:0]   disk    LIO-ORG  IBLOCK           3.0   /dev/sdk

*) Here is what it looks like against sg_persist:

initiator# sg_persist --out --register-ignore --param-sark=0x1234dcba -Y -v /dev/sdg
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 06 00 00 00 00 00 00 18 00 
PR out: command (Register and ignore existing key) successful

initiator# sg_persist --out --register-ignore --param-sark=0x5678ffff -Y -v /dev/sdk
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 06 00 00 00 00 00 00 18 00 
PR out: command (Register and ignore existing key) successful

initiator# sg_persist --out --reserve --param-rk=0x1234dcba --prout-type=5 -v /dev/sdg
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 01 05 00 00 00 00 00 18 00 
PR out: command (Reserve) successful

initiator# sg_persist --in --read-full-status /dev/sdg -v
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation In cmd: 5e 03 00 00 00 00 00 20 00 00 
  PR generation=0x2
    Key=0x1234dcba
      All target ports bit set
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive, registrants only
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef
    Key=0x5678ffff
      All target ports bit set
      not reservation holder
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef

initiator# sg_persist --in --report-capabilities /dev/sdg -v
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
    Persistent Reservation In cmd: 5e 02 00 00 00 00 00 20 00 00 
Report capabilities response:
  Compatible Reservation Handling(CRH): 0
  Specify Initiator Ports Capable(SIP_C): 0
  All Target Ports Capable(ATP_C): 1
  Persist Through Power Loss Capable(PTPL_C): 0
  Type Mask Valid(TMV): 1
  Allow commands: 1
  Persist Through Power Loss Active(PTPL_A): 0
    Support indicated in Type mask:
      Write Exclusive, all registrants: 1
      Exclusive Access, registrants only: 1
      Write Exclusive, registrants only: 1
      Exclusive Access: 1
      Write Exclusive: 1
      Exclusive Access, all registrants: 1

*) cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
SPC-3 Reservation: iSCSI Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 Reservation: All Target Ports registration
0x00000004
SPC-3 Reservation: iSCSI Target Node Endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
SPC-3 Reservation: Relative Port Identifer Tag: 1 iSCSI Portal Group Tag: 1 iSCSI Logical Unit: 0
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000001234dcba PRgen: 0x00000003
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678ffff PRgen: 0x00000001
SPC-3 Reservation Type: Write Exclusive Access, Registrants Only

*) dmesg output

Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x00 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x25 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x1a for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x1a for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x1a for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x00 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x25 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x1a for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x1a for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x1a for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0xa0 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
PSCSI Status Byte exception at task: df3bf000 CDB: 0x12 Result: 0x08000002
PSCSI Status Byte exception at task: df3bf000 CDB: 0x12 Result: 0x08000002
TARGET_CORE[iSCSI]: Expected Transfer Length: 512 does not match SCSI CDB Length: 4096 for SAM Opcode: 0x28
Failing OVERFLOW/UNDERFLOW for LBA op CDB on non 512-byte sector setup subsystem plugin: rd_mcp
TARGET_CORE[iSCSI]: Expected Transfer Length: 512 does not match SCSI CDB Length: 4096 for SAM Opcode: 0x28
Failing OVERFLOW/UNDERFLOW for LBA op CDB on non 512-byte sector setup subsystem plugin: fileio
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x00 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0xa3 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x00 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0xa3 for NON Write Exclusive Access, Registrants Only reservation holder
TARGET_CORE[iSCSI]: Expected Transfer Length: 512 does not match SCSI CDB Length: 4096 for SAM Opcode: 0x28
Failing OVERFLOW/UNDERFLOW for LBA op CDB on non 512-byte sector setup subsystem plugin: rd_mcp
TARGET_CORE[iSCSI]: Expected Transfer Length: 512 does not match SCSI CDB Length: 4096 for SAM Opcode: 0x28
Failing OVERFLOW/UNDERFLOW for LBA op CDB on non 512-byte sector setup subsystem plugin: fileio
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Allowing CDB: 0x5f for NON Write Exclusive Access, Registrants Only reservation holder
SPC-3 PR [iSCSI] REGISTER_AND_IGNORE_EXISTING_KEY: Changed Reservation Key for iqn.1993-08.org.debian:01:2dadf92d
0ef to: 0x000000005678ffff PRgeneration: 0x00000002
Allowing CDB: 0x28 for Write Exclusive Access, Registrants Only reservation
Conflict for WRITE CDB: 0x2a to Write Exclusive Access, Registrants Only reservation
SPC-3 PR RESERVE: Received res_key: 0x000000001234abcd does not match existing SA REGISTER res_key: 0x000000005678ffff
SPC-3 PR [iSCSI] REGISTER_AND_IGNORE_EXISTING_KEY: Changed Reservation Key for iqn.1993-08.org.debian:01:2dadf92d0ef to: 0x000000001234dcba PRgeneration: 0x00000003
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Conflict for WRITE CDB: 0x5f to Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x5e for Write Exclusive Access, Registrants Only reservation
Allowing CDB: 0x12 for NON Write Exclusive Access, Registrants Only reservation holder
Conflict for WRITE CDB: 0x5f to Write Exclusive Access, Registrants Only reservation

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |   30 ++--
 drivers/lio-core/target_core_pr.c        |  262 +++++++++++++++++++++---------
 drivers/lio-core/target_core_transport.c |    6 +-
 3 files changed, 203 insertions(+), 95 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 54c0ede..55c38c2 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -279,6 +279,19 @@ typedef enum {
 
 struct se_cmd_s;
 
+typedef struct t10_pr_registration_s {
+	int pr_reg_all_tg_pt; /* Reservation effects all target ports */
+	int pr_res_holder;
+	int pr_res_type;
+	int pr_res_scope;
+	u32 pr_res_generation;
+	u64 pr_res_key;
+	struct se_node_acl_s *pr_reg_nacl;
+	struct se_dev_entry_s *pr_reg_deve;
+	struct se_lun_s *pr_reg_tg_pt_lun;
+	struct list_head pr_reg_list;
+} t10_pr_registration_t;
+
 typedef struct t10_reservation_template_s {
 	/* Reservation effects all target ports */
 	int pr_all_tg_pt;
@@ -288,27 +301,14 @@ typedef struct t10_reservation_template_s {
 	/* Reservation holder when pr_all_tg_pt=1 */
 	struct se_node_acl_s *pr_res_holder;
 	struct list_head registration_list;
-	int (*t10_reservation_check)(struct se_cmd_s *);
+	int (*t10_reservation_check)(struct se_cmd_s *, u32 *);
 	int (*t10_reserve)(struct se_cmd_s *);
 	int (*t10_release)(struct se_cmd_s *);
-	int (*t10_seq_non_holder)(struct se_cmd_s *, unsigned char *);
+	int (*t10_seq_non_holder)(struct se_cmd_s *, unsigned char *, u32);
 	int (*t10_pr_register)(struct se_cmd_s *);
 	int (*t10_pr_clear)(struct se_cmd_s *);
 } ____cacheline_aligned t10_reservation_template_t;
 
-typedef struct t10_pr_registration_s {
-	int pr_reg_all_tg_pt; /* Reservation effects all target ports */
-	int pr_res_holder;
-	int pr_res_type;
-	int pr_res_scope;
-	u32 pr_res_generation;
-	u64 pr_res_key;
-	struct se_node_acl_s *pr_reg_nacl;
-	struct se_dev_entry_s *pr_reg_deve;
-	struct se_lun_s *pr_reg_tg_pt_lun;
-	struct list_head pr_reg_list;
-} t10_pr_registration_t;
-
 typedef struct se_queue_req_s {
 	int			state;
 	void			*queue_se_obj_ptr;
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index a980e3a..b35f06a 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -46,7 +46,8 @@
 
 int core_scsi2_reservation_seq_non_holder(
 	se_cmd_t *cmd,
-	unsigned char *cdb)
+	unsigned char *cdb,
+	u32 pr_reg_type)
 {
 	switch (cdb[0]) {
 	case INQUIRY:
@@ -60,7 +61,7 @@ int core_scsi2_reservation_seq_non_holder(
 	return 1;
 }
 
-int core_scsi2_reservation_check(se_cmd_t *cmd)
+int core_scsi2_reservation_check(se_cmd_t *cmd, u32 *pr_reg_type)
 {
 	se_device_t *dev = cmd->se_dev;
 	se_session_t *sess = cmd->se_sess;
@@ -161,29 +162,82 @@ EXPORT_SYMBOL(core_scsi2_reservation_reserve);
 
 /*
  * Begin SPC-3/SPC-4 Persistent Reservations emulation support
+ *
+ * This function is called by those initiator ports who are *NOT*
+ * the active PR reservation holder when a reservation is present.
  */
 static int core_scsi3_pr_seq_non_holder(
 	se_cmd_t *cmd,
-	unsigned char *cdb)
+	unsigned char *cdb,
+	u32 pr_reg_type)
 {
-	int registered_nexus = 0; /* FIXME: Table 46 */
+	se_dev_entry_t *se_deve;
+	se_session_t *se_sess = SE_SESS(cmd);
+	se_lun_t *se_lun = SE_LUN(cmd);
+	int other_cdb = 0;
+	int registered_nexus = 0, ret = 1; /* Conflict by default */
+	int all_reg = 0; /* ALL_REG */
 	int we = 0; /* Write Exclusive */
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
+
+	se_deve = &se_sess->se_node_acl->device_list[se_lun->unpacked_lun];
+
+	switch (pr_reg_type) {
+	case PR_TYPE_WRITE_EXCLUSIVE:
+		we = 1;
+	case PR_TYPE_EXCLUSIVE_ACCESS:
+		/*
+		 * Some commands are only allowed for the persistent reservation
+		 * holder.
+		 */
+		break;
+	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
+		we = 1;
+	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
+		/*
+		 * Some commands are only allowed for registered I_T Nexuses.
+		 */
+		if (se_deve->deve_flags & DEF_PR_REGISTERED)
+			registered_nexus = 1;
+		break;
+	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
+		we = 1;
+	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
+		/*
+		 * Each registered I_T Nexus is a reservation holder.
+		 */
+		all_reg = 1;
+		if (se_deve->deve_flags & DEF_PR_REGISTERED)
+			registered_nexus = 1;
+		break;
+	default:
+		return -1;
+	}
 	/*
 	 * Referenced from spc4r17 table 45 for *NON* PR holder access
 	 */
 	switch (cdb[0]) {
 	case SECURITY_PROTOCOL_IN:
-		return (we) ? 0 : 1;
+		if (registered_nexus)
+			return 0;
+		ret = (we) ? 0 : 1;
+		break;
 	case MODE_SENSE:
 	case MODE_SENSE_10:
 	case READ_ATTRIBUTE:
 	case READ_BUFFER:
 	case RECEIVE_DIAGNOSTIC:
-		if (legacy)
-			return 1;
-		return (we) ? 0 : 1; /* Allowed Write Exclusive */
+		if (legacy) {
+			ret = 1;
+			break;
+		}
+		if (registered_nexus) {
+			ret = 0;
+			break;
+		}
+		ret = (we) ? 0 : 1; /* Allowed Write Exclusive */
+		break;
 	case PERSISTENT_RESERVE_OUT:
 		/*
 		 * This follows PERSISTENT_RESERVE_OUT service actions that
@@ -194,49 +248,71 @@ static int core_scsi3_pr_seq_non_holder(
 		case PRO_CLEAR:
 		case PRO_PREEMPT:
 		case PRO_PREEMPT_AND_ABORT:
-			return (registered_nexus) ? 0 : 1;
+			ret = (registered_nexus) ? 0 : 1;
+			break;
 		case PRO_REGISTER:
 		case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
-			return 0;
+			ret = 0;
+			break;
 		case PRO_REGISTER_AND_MOVE:
 		case PRO_RESERVE:
-			return 1;
+			ret = 1;
+			break;
 		case PRO_RELEASE:
-			return (registered_nexus) ? 0 : 1;
+			ret = (registered_nexus) ? 0 : 1;
+			break;
 		default:
 			printk(KERN_ERR "Unknown PERSISTENT_RESERVE_OUT service"
 				" action: 0x%02x\n", cdb[1] & 0x1f);
 			return -1;
 		}
+		break;
 	/* FIXME PR + legacy RELEASE + RESERVE */
 	case RELEASE:
 	case RELEASE_10:
-		return 1; /* Conflict */
+		ret = 1; /* Conflict */
+		break;
 	case RESERVE:
 	case RESERVE_10:
-		return 1; /* Conflict */
+		ret = 1; /* Conflict */
+		break;
 	case TEST_UNIT_READY:
-		return (legacy) ? 1 : 0; /* Conflict for legacy */
+		ret = (legacy) ? 1 : 0; /* Conflict for legacy */
+		break;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_MANAGEMENT_PROTOCOL_IN:
-			return (we) ? 0 : 1; /* Allowed Write Exclusive */
+			if (registered_nexus) {
+				ret = 0;
+				break;
+			}
+			ret = (we) ? 0 : 1; /* Allowed Write Exclusive */
+			break;
 		case MI_REPORT_SUPPORTED_OPERATION_CODES:
 		case MI_REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS:
-			if (legacy)
-				return 1;
-			return (we) ? 0 : 1; /* Allowed Write Exclusive */
+			if (legacy) {
+				ret = 1;
+				break;
+			}
+			if (registered_nexus) {
+				ret = 0;
+				break;
+			}
+			ret = (we) ? 0 : 1; /* Allowed Write Exclusive */
+			break;
 		case MI_REPORT_ALIASES:
 		case MI_REPORT_IDENTIFYING_INFORMATION:
 		case MI_REPORT_PRIORITY:
 		case MI_REPORT_TARGET_PGS:
 		case MI_REPORT_TIMESTAMP:
-			return 0; /* Allowed */
+			ret = 0; /* Allowed */
+			break;
 		default:
 			printk(KERN_ERR "Unknown MI Service Action: 0x%02x\n",
 				(cdb[1] & 0x1f));
 			return -1;
 		}
+		break;
 	case ACCESS_CONTROL_IN:
 	case ACCESS_CONTROL_OUT:
 	case INQUIRY:
@@ -244,12 +320,61 @@ static int core_scsi3_pr_seq_non_holder(
 	case READ_MEDIA_SERIAL_NUMBER:
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
-		return 0; /*/ Allowed CDBs */
+		ret = 0; /*/ Allowed CDBs */
+		break;
 	default:
-		return 1; /* Conflift by default */
+		other_cdb = 1;
+		break;
+	}
+	/*
+	 * Case where the CDB is explictly allowed in the above switch
+	 * statement.
+	 */
+	if (!(ret) && !(other_cdb)) {
+		printk("Allowing CDB: 0x%02x for NON %s reservation holder\n",
+			cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
+		return ret;
 	}
+	/*
+	 * Check if write exclusive initiator ports *NOT* holding the
+	 * WRITE_EXCLUSIVE_* reservation.
+	 */
+	if (we) {
+		if ((cmd->data_direction == SE_DIRECTION_WRITE) ||
+		    (cmd->data_direction == SE_DIRECTION_BIDI)) {
+			/*
+			 * Conflict for write exclusive
+			 */
+			printk(KERN_INFO "Conflict for WRITE CDB: 0x%02x"
+				" to %s reservation\n", cdb[0],
+				core_scsi3_pr_dump_type(pr_reg_type));
+			return 1;
+		} else if (registered_nexus) {
+			/*
+			 * Allow non WRITE CDBs for PR_*_REG_ONLY and
+			 * PR_*_ALL_REG to pass for registered_nexuxes.
+			 */
+			printk(KERN_INFO "Allowing CDB: 0x%02x for %s"
+				" reservation\n", cdb[0],
+				core_scsi3_pr_dump_type(pr_reg_type));
+			return 0;
+		}
+	} else if (all_reg) {
+		if (registered_nexus) {
+			/*
+			 * For PR_*_ALL_REG reservation, treat all registered
+			 * nexuses as the reservation holder.
+			 */
+			printk(KERN_INFO "Allowing CDB: 0x%02x for %s"
+				" reservation\n", cdb[0],
+				core_scsi3_pr_dump_type(pr_reg_type));
+			return 0;
+		}
+	}
+	printk(KERN_INFO "Conflict for CDB: 0x%2x for %s reservation\n",
+		cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 
-	return 1;
+	return 1; /* Conflict by default */
 }
 
 static u32 core_scsi3_pr_generation(se_device_t *dev)
@@ -272,7 +397,9 @@ static u32 core_scsi3_pr_generation(se_device_t *dev)
 	return prg;
 }
 
-static int core_scsi3_pr_reservation_check(se_cmd_t *cmd)
+static int core_scsi3_pr_reservation_check(
+	se_cmd_t *cmd,
+	u32 *pr_reg_type)
 {
 	se_device_t *dev = cmd->se_dev;
 	se_session_t *sess = cmd->se_sess;
@@ -286,11 +413,12 @@ static int core_scsi3_pr_reservation_check(se_cmd_t *cmd)
 		spin_unlock(&dev->dev_reservation_lock);
 		return 0;
 	}
+	*pr_reg_type = dev->dev_pr_res_holder->pr_res_type;
 	ret = (dev->dev_pr_res_holder->pr_reg_nacl != sess->se_node_acl) ?
 		-1 : 0;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	return 0;
+	return ret;
 }
 
 static int core_scsi3_legacy_reserve(se_cmd_t *cmd)
@@ -724,26 +852,6 @@ static int core_scsi3_pro_reserve(
 	return 0;
 }
 
-static int core_scsi3_pro_reserve_regonly(
-	se_cmd_t *cmd,
-	se_device_t *dev,
-	int type,
-	int scope,
-	u64 res_key)
-{
-	return 0;
-}
-
-static int core_scsi3_pro_reserve_allreg(
-	se_cmd_t *cmd,
-	se_device_t *dev,
-	int type,
-	int scope,
-	u64 res_key)
-{
-	return 0;
-}
-
 static int core_scsi3_emulate_pro_reserve(
 	se_cmd_t *cmd,
 	int type,
@@ -755,29 +863,13 @@ static int core_scsi3_emulate_pro_reserve(
 
 	switch (type) {
 	case PR_TYPE_WRITE_EXCLUSIVE:
-		ret = core_scsi3_pro_reserve(cmd, dev, type, scope, res_key);
-		break;
 	case PR_TYPE_EXCLUSIVE_ACCESS:
-		ret = core_scsi3_pro_reserve(cmd, dev, type, scope, res_key);
-		break;
-#if 0
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
-		ret = core_scsi3_pro_reserve_regonly(cmd, dev, type, scope,
-				res_key);
-		break;
 	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
-		ret = core_scsi3_pro_reserve_regonly(cmd, dev, type, scope,
-				res_key);
-		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
-		ret = core_scsi3_pro_reserve_allreg(cmd, dev, type, scope,
-				res_key);
-		break;
 	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
-		ret = core_scsi3_pro_reserve_allreg(cmd, dev, type, scope,
-				res_key);
+		ret = core_scsi3_pro_reserve(cmd, dev, type, scope, res_key);
 		break;
-#endif
 	default:
 		printk(KERN_ERR "SPC-3 PR: Unknown Service Action RESERVE Type:"
 			" 0x%02x\n", type);
@@ -1093,6 +1185,7 @@ static int core_scsi3_pri_read_reservation(se_cmd_t *cmd)
 	se_subsystem_dev_t *su_dev = SU_DEV(se_dev);
 	t10_pr_registration_t *pr_reg;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	u64 pr_res_key;
 	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
 
 	buf[0] = ((T10_RES(su_dev)->pr_generation >> 24) & 0xff);
@@ -1111,16 +1204,35 @@ static int core_scsi3_pri_read_reservation(se_cmd_t *cmd)
 		buf[6] = ((add_len >> 8) & 0xff);
 		buf[7] = (add_len & 0xff);
 		/*
-		 * Set the Reservation key
+		 * Set the Reservation key.
+		 *
+		 * From spc4r17, section 5.7.10:
+		 * A persistent reservation holder has its reservation key
+		 * returned in the parameter data from a PERSISTENT
+		 * RESERVE IN command with READ RESERVATION service action as
+		 * follows:
+		 * a) For a persistent reservation of the type Write Exclusive
+		 *    - All Registrants or Exclusive Access ­ All Regitrants,
+		 *      the reservation key shall be set to zero; or
+		 * b) For all other persistent reservation types, the
+		 *    reservation key shall be set to the registered
+		 *    reservation key for the I_T nexus that holds the
+		 *    persistent reservation.
 		 */
-		buf[8] = ((pr_reg->pr_res_key >> 56) & 0xff);
-		buf[9] = ((pr_reg->pr_res_key >> 48) & 0xff);
-		buf[10] = ((pr_reg->pr_res_key >> 40) & 0xff);
-		buf[11] = ((pr_reg->pr_res_key >> 32) & 0xff);
-		buf[12] = ((pr_reg->pr_res_key >> 24) & 0xff);
-		buf[13] = ((pr_reg->pr_res_key >> 16) & 0xff);
-		buf[14] = ((pr_reg->pr_res_key >> 8) & 0xff);
-		buf[15] = (pr_reg->pr_res_key & 0xff);
+		if ((pr_reg->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
+		    (pr_reg->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG))
+			pr_res_key = 0;
+		else
+			pr_res_key = pr_reg->pr_res_key;
+
+		buf[8] = ((pr_res_key >> 56) & 0xff);
+		buf[9] = ((pr_res_key >> 48) & 0xff);
+		buf[10] = ((pr_res_key >> 40) & 0xff);
+		buf[11] = ((pr_res_key >> 32) & 0xff);
+		buf[12] = ((pr_res_key >> 24) & 0xff);
+		buf[13] = ((pr_res_key >> 16) & 0xff);
+		buf[14] = ((pr_res_key >> 8) & 0xff);
+		buf[15] = (pr_res_key & 0xff);
 		/*
 		 * Set the SCOPE and TYPE
 		 */
@@ -1174,16 +1286,12 @@ static int core_scsi3_pri_report_capabilities(se_cmd_t *cmd)
 	/*
 	 * Setup the PERSISTENT RESERVATION TYPE MASK from Table 167
 	 */
-#if 0
 	buf[4] |= 0x80; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
 	buf[4] |= 0x40; /* PR_TYPE_EXCLUSIVE_ACCESS_REGONLY */
 	buf[4] |= 0x20; /* PR_TYPE_WRITE_EXCLUSIVE_REGONLY */
-#endif
 	buf[4] |= 0x08; /* PR_TYPE_EXCLUSIVE_ACCESS */
 	buf[4] |= 0x02; /* PR_TYPE_WRITE_EXCLUSIVE */
-#if 0
 	buf[5] |= 0x01; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
-#endif
 
 	return 0;
 }
@@ -1345,7 +1453,7 @@ int core_scsi3_emulate_pr(se_cmd_t *cmd)
 	       core_scsi3_emulate_pr_in(cmd, cdb);
 }
 
-static int core_pt_reservation_check(se_cmd_t *cmd)
+static int core_pt_reservation_check(se_cmd_t *cmd, u32 *pr_res_type)
 {
 	return 0;
 }
@@ -1360,7 +1468,7 @@ static int core_pt_release(se_cmd_t *cmd)
 	return 0;
 }
 
-static int core_pt_seq_non_holder(se_cmd_t *cmd, unsigned char *cdb)
+static int core_pt_seq_non_holder(se_cmd_t *cmd, unsigned char *cdb, u32 pr_reg_type)
 {
 	return 0;
 }
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 8227337..44f6b6d 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4667,10 +4667,10 @@ static int transport_generic_cmd_sequencer(
 	se_device_t *dev = SE_DEV(cmd);
 	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
 	int ret = 0, sector_ret = 0;
-	u32 sectors = 0, size = 0;
+	u32 sectors = 0, size = 0, pr_reg_type = 0;
 
-	if (T10_RES(su_dev)->t10_reservation_check(cmd) != 0) {
-		if (T10_RES(su_dev)->t10_seq_non_holder(cmd, cdb) != 0) {
+	if (T10_RES(su_dev)->t10_reservation_check(cmd, &pr_reg_type) != 0) {
+		if (T10_RES(su_dev)->t10_seq_non_holder(cmd, cdb, pr_reg_type) != 0) {
 			cmd->transport_wait_for_tasks =
 					&transport_nop_wait_for_tasks;
 			transport_get_maps(cmd);
-- 
1.5.4.1




