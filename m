Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYCQMv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYCQMv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYCQMvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:51:19 -0400
Received: from sacred.ru ([62.205.161.221]:45923 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYCQMvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:51:18 -0400
Message-ID: <47DE692F.5010600@openvz.org>
Date: Mon, 17 Mar 2008 15:50:55 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
CC: general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: [PATCH 3/3] Infiniband: don't use task_struct.tgid in make_cm_node()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 15:50:47 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The task_struct->tgid field is about to become deprecated, due to
pid namespaces make tasks have many pids, not one. There is one
place using it left to fix in infiniband - the make_cm_node().

This function uses the task tgid just to generate a session id,
so it's perfectly safe to use appropriate wrapper - task_tgid_nr().

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

 drivers/infiniband/hw/nes/nes_cm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 39adb26..7a06156 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1077,7 +1077,8 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	/* get a unique session ID , add thread_id to an upcounter to handle race */
 	atomic_inc(&cm_core->node_cnt);
 	atomic_inc(&cm_core->session_id);
-	cm_node->session_id = (u32)(atomic_read(&cm_core->session_id) + current->tgid);
+	cm_node->session_id = (u32)(atomic_read(&cm_core->session_id) +
+			task_tgid_nr(current));
 	cm_node->conn_type = cm_info->conn_type;
 	cm_node->apbvt_set = 0;
 	cm_node->accept_pend = 0;
@@ -1606,7 +1607,8 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 	atomic_inc(&cm_core->node_cnt);
 	atomic_inc(&cm_core->session_id);
 
-	listener->session_id = (u32)(atomic_read(&cm_core->session_id) + current->tgid);
+	listener->session_id = (u32)(atomic_read(&cm_core->session_id) +
+			task_tgid_nr(current));
 	listener->conn_type = cm_info->conn_type;
 	listener->backlog = cm_info->backlog;
 	listener->listener_state = NES_CM_LISTENER_ACTIVE_STATE;


