Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYLTXNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYLTXNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 18:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYLTXN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 18:13:26 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:31432 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751792AbYLTXNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 18:13:25 -0500
X-YMail-OSG: 5wTRvyQVM1nBaecaGXpNCf1Jt4sA18Fgc9tACyTFkwq7isS_JBtGwXUQlHSnVfgexQqRIIWc28mpt9jJ_2zpDDHEmbWYqeU4CkldOXU6w_xCN5wP2OSfgd.prpOV_S6e9MNXjKRYCoby4qXQ25LM61_1fJVH.6Fk1o04heSkX.OORg2I6wNXmsFmJ0T2G5FEEH9yioLrgZPrxl5EFga8VQzF9FxqWGrOj0oydlAwPFVaqgaB.PA-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 2/8] [LIO-Target]: Properly release se_cmd_t w/
	CHECK_CONDITION exception during iSCSI session recovery
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 15:06:15 -0800
Message-Id: <1229814375.4560.210.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c7e5c1224267c6eac41863b78d0a907dc55944be Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 02:05:54 -0800
Subject: [PATCH 2/8] [LIO-Target]: Properly release se_cmd_t w/ CHECK_CONDITION exception during iSCSI session recovery

This patch fixes v3.0 breakage that was leaking a se_cmd_t w/ CHECK_CONDITION
after hitting a NON_EXISTENT se_lun_t exception.  This patch adds the special
case in iscsi_release_commands_from_conn() and calls transport_release_cmd_to_pool()
on the se_cmd_t in question.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index d234fe0..d705871 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -4744,7 +4744,14 @@ static void iscsi_release_commands_from_conn (iscsi_conn_t *conn)
 			spin_unlock_bh(&conn->cmd_lock);
 
 			iscsi_increment_maxcmdsn(cmd, sess);
-			__iscsi_release_cmd_to_pool(cmd, sess);
+			/*
+			 * Special case for transport_get_lun_for_cmd() failing
+			 * from iscsi_get_lun_for_cmd() in iscsi_handle_scsi_cmd().
+			 */
+			if (SE_CMD(cmd))
+				transport_release_cmd_to_pool(SE_CMD(cmd));	
+			else
+				__iscsi_release_cmd_to_pool(cmd, sess);
 
 			spin_lock_bh(&conn->cmd_lock);
 			cmd = cmd_next;
-- 
1.5.4.1



