Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYLSXeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYLSXeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYLSXeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:34:31 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:21070 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755630AbYLSXea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:34:30 -0500
X-YMail-OSG: k8Bxwm8VM1mVUppa5LrMus2esI3NPU2D1bpAEU16jqIENZR_PsX7QvzBDk.lX7VH3a4TME5LgpNEyddJI9COdTt6mP4dCTCcmO1iUDLbib7nvZsGAL2689LbanjLbvGpKyNKJaBjggKJpCQqy0kdRBHhrTdTAYftLwm9x8YTStgdhM72olBRbAvNa6ajbqfM9MKZ5o_EWbv7MSnKqXe32Fr00Bkqje4A2xAYo95IK9r0wfBMTU8-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [LIO-Target 7/14]: Make ErrorRecoveryLevel=0 code use
	generic se_portal_group_t locks
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 15:34:01 -0800
Message-Id: <1229729641.4560.114.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 74fad9414f9738af836f44a44fa6c858c078cc16 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:18:34 -0800
Subject: [PATCH] [LIO-Target]: Make ErrorRecoveryLevel=0 code use generic se_portal_group_t locks

This patch makes ERL=0 code use se_portal_group_t->session_lock.

Also, iscsi_fall_back_to_erl0() has been changed to accept iscsi_session_t
as a parameter.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_erl0.c |   22 ++++++++++++----------
 drivers/lio-core/iscsi_target_erl0.h |    2 +-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_erl0.c b/drivers/lio-core/iscsi_target_erl0.c
index ad2d393..4bd5c19 100644
--- a/drivers/lio-core/iscsi_target_erl0.c
+++ b/drivers/lio-core/iscsi_target_erl0.c
@@ -835,15 +835,16 @@ static void iscsi_handle_time2retain_timeout (unsigned long data)
 {
 	iscsi_session_t *sess = (iscsi_session_t *) data;
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
+	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
 	
-	spin_lock_bh(&tpg->session_lock);
+	spin_lock_bh(&se_tpg->session_lock);
 	if (sess->time2retain_timer_flags & T2R_TF_STOP) {
-		spin_unlock_bh(&tpg->session_lock);
+		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
 	if (atomic_read(&sess->session_reinstatement)) {
 		TRACE_ERROR("Exiting Time2Retain handler because session_reinstatement=1\n");
-		spin_unlock_bh(&tpg->session_lock);
+		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
 	sess->time2retain_timer_flags |= T2R_TF_EXPIRED;
@@ -866,7 +867,7 @@ static void iscsi_handle_time2retain_timeout (unsigned long data)
 	}
 #endif /* SNMP_SUPPORT */
 
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 	iscsi_close_session(sess);
 	
 	return;
@@ -909,11 +910,12 @@ extern void iscsi_start_time2retain_handler (iscsi_session_t *sess)
 
 /*	iscsi_stop_time2retain_timer():
  *
- *	Called with spin_lock_bh(&iscsi_portal_group_t->session_lock) held
+ *	Called with spin_lock_bh(&se_portal_group_t->session_lock) held
  */
 extern int iscsi_stop_time2retain_timer (iscsi_session_t *sess)
 {
 	iscsi_portal_group_t *tpg = ISCSI_TPG_S(sess);
+	se_portal_group_t *se_tpg = tpg->tpg_se_tpg;
 	
 	if (sess->time2retain_timer_flags & T2R_TF_EXPIRED)
 		return(-1);
@@ -922,11 +924,11 @@ extern int iscsi_stop_time2retain_timer (iscsi_session_t *sess)
 		return(0);
 	
 	sess->time2retain_timer_flags |= T2R_TF_STOP;
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&se_tpg->session_lock);
 
 	del_timer_sync(&sess->time2retain_timer);
 
-	spin_lock_bh(&tpg->session_lock);
+	spin_lock_bh(&se_tpg->session_lock);
 	sess->time2retain_timer_flags &= ~T2R_TF_RUNNING;
 	TRACE(TRACE_TIMER, "Stopped Time2Retain Timer for SID: %u\n", sess->sid);
 
@@ -1006,12 +1008,12 @@ extern void iscsi_cause_connection_reinstatement (iscsi_conn_t *conn, int sleep)
  *
  *
  */
-extern void iscsi_fall_back_to_erl0 (iscsi_conn_t *conn)
+extern void iscsi_fall_back_to_erl0 (iscsi_session_t *sess)
 {
 	TRACE(TRACE_ERL0, "Falling back to ErrorRecoveryLevel=0 for SID:"
-			" %u\n", SESS(conn)->sid);
+			" %u\n", sess->sid);
 		
-	atomic_set(&SESS(conn)->session_fall_back_to_erl0, 1); 
+	atomic_set(&sess->session_fall_back_to_erl0, 1); 
 
 	return;
 }
diff --git a/drivers/lio-core/iscsi_target_erl0.h b/drivers/lio-core/iscsi_target_erl0.h
index ffcf45b..d4fcd24 100644
--- a/drivers/lio-core/iscsi_target_erl0.h
+++ b/drivers/lio-core/iscsi_target_erl0.h
@@ -37,7 +37,7 @@ extern void iscsi_start_time2retain_handler (iscsi_session_t *);
 extern int iscsi_stop_time2retain_timer (iscsi_session_t *);
 extern void iscsi_connection_reinstatement_rcfr (iscsi_conn_t *);
 extern void iscsi_cause_connection_reinstatement (iscsi_conn_t *, int);
-extern void iscsi_fall_back_to_erl0 (iscsi_conn_t *);
+extern void iscsi_fall_back_to_erl0 (iscsi_session_t *);
 extern void iscsi_take_action_for_connection_exit (iscsi_conn_t *);
 extern int iscsi_recover_from_unknown_opcode (iscsi_conn_t *);
 
-- 
1.5.4.1



