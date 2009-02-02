Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZBBGEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZBBGEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZBBGEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:04:30 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:48895 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751620AbZBBGE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:04:29 -0500
X-YMail-OSG: 0_ELClwVM1kHQAG_c_dz4CHgRDVQNS9gfindFloqjtD3fcVAn.1z6S54EwpvKnJ7Uvbd6CvlIadc_0Fkn4UKmB7lMTAcBB90M3nP8zvIJSdQ4pc4M1h5IQaiZCro5OlfkBALbb3vQB.03zuiPt92Tj4gkBFkm1cO8CfqzkmkF2mzTGmN7bFbVD9NlkeaBj7lrT9H2i9eBfNaok6aaGVu6yplt3QpYZSZdERtAU_.VBSCDvyqwFk-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 4/4] [LIO-Target]: Add iscsi_get_fabric_proto_ident() for
	EVPD PIV=1 usage
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ming Zhang <blackmagic02881@gmail.com>,
       Arne Redlich <agr@powerkom-dd.de>,
       "Ross S. W. Walker" <rswwalker@gmail.com>,
       Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 22:03:22 -0800
Message-Id: <1233554602.12375.47.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b68717b2b25af169ef52b16d796f120c2819eaae Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sun, 1 Feb 2009 21:46:52 -0800
Subject: [PATCH 4/4] [LIO-Target]: Add iscsi_get_fabric_proto_ident() for EVPD PIV=1 usage

This patch adds the SPC-4 defined PROTOCOL IDENTIFIER value for
iSCSI (0x5) in iscsi_get_fabric_proto_ident(), which is attached to
struct target_core_fabric_ops->get_fabric_proto_ident() during
LIO-Target v3.0 module registration with Target_Core_Mod/ConfigFS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c          |    9 +++++++++
 drivers/lio-core/iscsi_target.h          |    1 +
 drivers/lio-core/iscsi_target_configfs.c |    1 +
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 2a952d6..f800a27 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -1326,6 +1326,15 @@ extern char *iscsi_get_fabric_name (void)
 	return("iSCSI");
 }
 
+extern u8 iscsi_get_fabric_proto_ident (void)
+{
+	/*
+	 * This value is defined for "Internet SCSI (iSCSI)"
+	 * in spc4r17 section 7.5.1 Table 362
+	 */
+	return(0x5);
+}
+
 extern iscsi_cmd_t *iscsi_get_cmd (se_cmd_t *se_cmd)
 {
         return((iscsi_cmd_t *)se_cmd->se_fabric_cmd_ptr);
diff --git a/drivers/lio-core/iscsi_target.h b/drivers/lio-core/iscsi_target.h
index 91b3cb5..d0cf724 100644
--- a/drivers/lio-core/iscsi_target.h
+++ b/drivers/lio-core/iscsi_target.h
@@ -47,6 +47,7 @@ extern struct iscsi_np_s *core_add_np (iscsi_np_addr_t *, int, int *);
 extern int core_reset_np_thread (struct iscsi_np_s *, struct iscsi_tpg_np_s *, struct iscsi_portal_group_s *, int);
 extern int core_del_np (iscsi_np_t *);
 extern char *iscsi_get_fabric_name (void);
+extern u8 iscsi_get_fabric_proto_ident (void);
 extern iscsi_cmd_t *iscsi_get_cmd (struct se_cmd_s *);
 extern u32 iscsi_get_task_tag (struct se_cmd_s *);
 extern int iscsi_get_cmd_state (struct se_cmd_s *);
diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 0d91c7d..696f117 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -2300,6 +2300,7 @@ extern int iscsi_target_register_configfs (void)
 	 * Temporary OPs function pointers used by target_core_mod..
 	 */
 	fabric->tf_ops.get_fabric_name = &iscsi_get_fabric_name;
+	fabric->tf_ops.get_fabric_proto_ident = &iscsi_get_fabric_proto_ident;
 	fabric->tf_ops.tpg_get_wwn = &lio_tpg_get_endpoint_wwn;
 	fabric->tf_ops.tpg_get_tag = &lio_tpg_get_tag;
 	fabric->tf_ops.tpg_get_default_depth = &lio_tpg_get_default_depth;
-- 
1.5.4.1



