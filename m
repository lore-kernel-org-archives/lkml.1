Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYLTXFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYLTXFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 18:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYLTXFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 18:05:10 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:40717 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751529AbYLTXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 18:05:09 -0500
X-YMail-OSG: JAlJgTwVM1n0kuYSSQ6R8ha6VjB0RG94VBITu5pqJJ.Dcqqj_A8YOvYI1HCemPKkLJ_SI2RVBhdIJSQDD3aZljf88LwCv_3YL8gN_dbZXyweDF3Q7dNVWACRz1oDqpIifqVUSl2TuA1xQYYBlOu3ku3JJVg5BBLaeFirTOi3AaqQQdjkXuKtFJb.RISUZEn8pNAHLCoLA3RJx0IVi.nF0sDjHtZU2v4xI6tKu01Vux6yfEr4s14-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 8/8] [LIO-Target]: Fix leakage of ISCSI_INIT_LOGOUT_CMND
	for CLOSESESSION or same CID CLOSECONNECTION cases
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 15:04:23 -0800
Message-Id: <1229814263.4560.208.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e6e756fa5a7381731d2a11a6eafe0af32ad16f65 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 14:19:23 -0800
Subject: [PATCH 8/8] [LIO-Target]: Fix leakage of ISCSI_INIT_LOGOUT_CMND for CLOSESESSION or same CID CLOSECONNECTION cases

This patch remove the a incorrect special case in iscsi_release_commands_from_conn()
where ISCSI_INIT_LOGOUT_CMND for CLOSESESSION or same CID CLOSECONNECTION was leaking
iscsi_cmd_t assuming that (according to the comment) iscsi_logout_post_handler() would
be releasing iscsi_cmd_t (it never does).

In any event, because of the way that iscsi_handle_logout_cmd() works (it sleeps on
iscsi_conn_t->conn_logout_sem in iscsi_target_rx_thread()), it means that for a
successful logout, iscsi_release_commands_from_conn() will always be called from
iSCSI TX thread context *AFTER* iscsi_logout_post_handler() has been called.

Given this logic, we can safely remove this incorrect special case check in
iscsi_release_commands_from_conn().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index d705871..d95a506 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -4730,19 +4730,8 @@ static void iscsi_release_commands_from_conn (iscsi_conn_t *conn)
 
 		if (!(SE_CMD(cmd)) ||
 		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)) {
-			/*
-			 * CLOSESESSION and CLOSECONNECTION with a matching
-			 * logout_cid will be freed in iscsi_logout_post_handler().
-			 */
-			if ((cmd->iscsi_opcode == ISCSI_INIT_LOGOUT_CMND) &&
-			   ((cmd->logout_reason == CLOSESESSION) ||
-			   ((cmd->logout_reason == CLOSECONNECTION) &&
-			   (cmd->logout_cid == conn->cid)))) {
-				cmd = cmd_next;
-				continue;
-			}
-			spin_unlock_bh(&conn->cmd_lock);
 
+			spin_unlock_bh(&conn->cmd_lock);
 			iscsi_increment_maxcmdsn(cmd, sess);
 			/*
 			 * Special case for transport_get_lun_for_cmd() failing
-- 
1.5.4.1



