Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYLSXbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYLSXbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbYLSXb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:31:28 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:44976 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752959AbYLSXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:31:26 -0500
X-YMail-OSG: 1fuT8MoVM1nfbty4aJuwuTcjrwrAbFWlYC.wB4GH8SnUKlUnEHQK6ZVQjDAH8_mxh0v2NVsYxCiJuzGMejkIlvWGclVgj2LWV9P764Otj.YyY1hs8keHEkywk9bbFq92Z5JEoXrtwfOQml9dmLP2HCgBVeWvKAf8tbWjj3DcDBSc3OAHAhqP39sEr3WAftBdVd5lVjN4zUINlWpCncOxADKGUfApxOnvLSptDmKE.hLfNcSUM9g-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [LIO-Target 2/14]: Make iscsi_handle_authentication() use
	se_node_acl_t
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 15:30:57 -0800
Message-Id: <1229729457.4560.104.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b8564cdaefbfa40510ac6c8afb37b97d195a5c4c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:51:27 -0800
Subject: [PATCH] [LIO-Target]: Make iscsi_handle_authentication() use se_node_acl_t

Replace iSCSI specific ACLs in iscsi_handle_authentication() to use generic
se_node_acl_t->initiatorname[].

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_auth_kernel.h |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/lio-core/iscsi_auth_kernel.h b/drivers/lio-core/iscsi_auth_kernel.h
index cf789dd..2b385b0 100644
--- a/drivers/lio-core/iscsi_auth_kernel.h
+++ b/drivers/lio-core/iscsi_auth_kernel.h
@@ -45,6 +45,7 @@ extern u32 iscsi_handle_authentication (
 	u32			rc = 0, ret = 0;
 	auth_daemon_t		*iscsi_auth = NULL;
 	mm_segment_t		oldfs;
+	se_node_acl_t		*se_nacl;
 	struct iovec 		iov;
 	struct msghdr		msg;
 	struct sockaddr_in 	s_addr;
@@ -52,12 +53,11 @@ extern u32 iscsi_handle_authentication (
 
 	down(&iscsi_global->auth_sem);
 
-	if (!(iscsi_auth = (auth_daemon_t *) kmalloc(sizeof(auth_daemon_t), GFP_KERNEL))) {
+	if (!(iscsi_auth = (auth_daemon_t *) kzalloc(sizeof(auth_daemon_t), GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate memory for iscsi_auth\n");
 		up(&iscsi_global->auth_sem);
 		return(2);
 	}
-	memset(iscsi_auth, 0, sizeof(auth_daemon_t));
 
 	if (authtype) {
 		memcpy(iscsi_auth->type, authtype, sizeof(iscsi_auth->type)); 
@@ -79,23 +79,20 @@ extern u32 iscsi_handle_authentication (
 	iscsi_auth->cid = conn->cid;
 	iscsi_auth->sid = SESS(conn)->sid;
 	iscsi_auth->auth_id = conn->auth_id;
-#ifdef _INITIATOR
-	iscsi_auth->channel_id = SESS(conn)->channel->channel_id;
-#else
 	iscsi_auth->tpgt = SESS(conn)->tpg->tpgt;
-	if (!SESS(conn)->node_acl) {
+
+	if (!(se_nacl = SESS(conn)->se_sess->se_node_acl)) {
 		ret = -1;
 		goto out;
 	}
-	strncpy(iscsi_auth->initiatorname, SESS(conn)->node_acl->initiatorname,
-		strlen(SESS(conn)->node_acl->initiatorname) + 1);
+	strncpy(iscsi_auth->initiatorname, se_nacl->initiatorname,
+		strlen(se_nacl->initiatorname) + 1);
 #ifdef SNMP_SUPPORT
 	if (strstr("CHAP", iscsi_auth->type))
 		strcpy(SESS(conn)->auth_type, "CHAP");
 	else
 		strcpy(SESS(conn)->auth_type, NONE);
 #endif /* SNMP_SUPPORT */
-#endif
 
 	s_addr.sin_family	= AF_INET;
 	s_addr.sin_addr.s_addr	= htonl(INADDR_LOOPBACK);
-- 
1.5.4.1



