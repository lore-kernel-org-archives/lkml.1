Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYCVDHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYCVDHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYCVDHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:07:46 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33910 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYCVDHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:07:45 -0400
To: "Glenn Streiff" <gstreiff@NetEffect.com>
Cc: "Pavel Emelyanov" <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nishi Gupta <ngupta@NetEffect.com>, general@lists.openfabrics.org,
       Faisal Latif <flatif@NetEffect.com>
Subject: Re: [ofa-general] RE: [PATCH 3/3] Infiniband: don't use task_struct.tgid in make_cm_node()
X-Message-Flag: Warning: May contain useful information
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0795008A@venom2>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Mar 2008 20:07:40 -0700
In-Reply-To: <5E701717F2B2ED4EA60F87C8AA57B7CC0795008A@venom2> (Glenn Streiff's message of "Thu, 20 Mar 2008 16:51:31 -0500")
Message-ID: <adazlsrtq0z.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Mar 2008 03:07:42.0948 (UTC) FILETIME=[E529FA40:01C88BC9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I added this to my tree:

commit 0f9d8de35f49df534b79d656155d3cb1ff70f726
Author: Roland Dreier <rolandd@cisco.com>
Date:   Fri Mar 21 20:06:49 2008 -0700

    RDMA/nes: Remove session_id from nes_cm stuff
    
    The session_id members of struct nes_cm_listener and struct
    nes_cm_node are write-only, so remove them.  This allows the
    session_id member of struct nes_cm_core to be removed as well, since
    it is only used to write those other session_id values.
    
    This removes the use of current->tgid (which will be deprecated)
    pointed out by Pavel Emelyanov <xemul@openvz.org>.
    
    Acked-by: Glenn Streiff <gstreiff@neteffect.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index c1a85f3..31a28e9 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -365,7 +365,6 @@ static void print_core(struct nes_cm_core *core)
 	if (!core)
 		return;
 	nes_debug(NES_DBG_CM, "---------------------------------------------\n");
-	nes_debug(NES_DBG_CM, "Session ID    : %u \n", atomic_read(&core->session_id));
 
 	nes_debug(NES_DBG_CM, "State         : %u \n",  core->state);
 
@@ -1100,8 +1099,6 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->tcp_cntxt.rcv_nxt = 0;
 	/* get a unique session ID , add thread_id to an upcounter to handle race */
 	atomic_inc(&cm_core->node_cnt);
-	atomic_inc(&cm_core->session_id);
-	cm_node->session_id = (u32)(atomic_read(&cm_core->session_id) + current->tgid);
 	cm_node->conn_type = cm_info->conn_type;
 	cm_node->apbvt_set = 0;
 	cm_node->accept_pend = 0;
@@ -1628,9 +1625,7 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 	listener->cm_core = cm_core;
 	listener->nesvnic = nesvnic;
 	atomic_inc(&cm_core->node_cnt);
-	atomic_inc(&cm_core->session_id);
 
-	listener->session_id = (u32)(atomic_read(&cm_core->session_id) + current->tgid);
 	listener->conn_type = cm_info->conn_type;
 	listener->backlog = cm_info->backlog;
 	listener->listener_state = NES_CM_LISTENER_ACTIVE_STATE;
@@ -1943,7 +1938,6 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 	cm_core->state = NES_CM_STATE_INITED;
 	cm_core->free_tx_pkt_max = NES_CM_DEFAULT_FREE_PKTS;
 
-	atomic_set(&cm_core->session_id, 0);
 	atomic_set(&cm_core->events_posted, 0);
 
 	/* init the packet lists */
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 980fb67..7717cb2 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -225,7 +225,6 @@ enum nes_cm_listener_state {
 
 struct nes_cm_listener {
 	struct list_head           list;
-	u64                        session_id;
 	struct nes_cm_core         *cm_core;
 	u8                         loc_mac[ETH_ALEN];
 	nes_addr_t                 loc_addr;
@@ -242,7 +241,6 @@ struct nes_cm_listener {
 
 /* per connection node and node state information */
 struct nes_cm_node {
-	u64                       session_id;
 	u32                       hashkey;
 
 	nes_addr_t                loc_addr, rem_addr;
@@ -327,7 +325,6 @@ struct nes_cm_event {
 
 struct nes_cm_core {
 	enum nes_cm_node_state  state;
-	atomic_t                session_id;
 
 	atomic_t                listen_node_cnt;
 	struct nes_cm_node      listen_list;
