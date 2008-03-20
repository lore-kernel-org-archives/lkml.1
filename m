Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYCTVvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYCTVvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYCTVvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:51:33 -0400
Received: from mail2.neteffect.com ([204.57.75.68]:1194 "EHLO
	mail2.neteffect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbYCTVvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:51:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 3/3] Infiniband: don't use task_struct.tgid in make_cm_node()
Date: Thu, 20 Mar 2008 16:51:31 -0500
Message-ID: <5E701717F2B2ED4EA60F87C8AA57B7CC0795008A@venom2>
In-Reply-To: <adad4pqjugp.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] Infiniband: don't use task_struct.tgid in make_cm_node()
Thread-Index: AciKBO2lhmAP8/CERcmOs34WMEEnhAAzwF5Q
From: "Glenn Streiff" <gstreiff@NetEffect.com>
To: "Roland Dreier" <rdreier@cisco.com>, "Pavel Emelyanov" <xemul@openvz.org>
Cc: "Sean Hefty" <sean.hefty@intel.com>,
       "Hal Rosenstock" <hal.rosenstock@gmail.com>,
       "Faisal Latif" <flatif@NetEffect.com>,
       "Nishi Gupta" <ngupta@NetEffect.com>, <general@lists.openfabrics.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by Glenn Streiff <gstreiff@neteffect.com>

> From: Roland Dreier [mailto:rdreier@cisco.com]
> The patch
> below compiles and links fine for me, so is the simplest fix?  (I
> don't think hardware is looking at session_id behind our back, is it?)
> 
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c 
> b/drivers/infiniband/hw/nes/nes_cm.c
> index c1a85f3..31a28e9 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -365,7 +365,6 @@ static void print_core(struct nes_cm_core *core)
>  	if (!core)
>  		return;
>  	nes_debug(NES_DBG_CM, 
> "---------------------------------------------\n");
> -	nes_debug(NES_DBG_CM, "Session ID    : %u \n", 
> atomic_read(&core->session_id));
>  
>  	nes_debug(NES_DBG_CM, "State         : %u \n",  core->state);
>  
> @@ -1100,8 +1099,6 @@ static struct nes_cm_node 
> *make_cm_node(struct nes_cm_core *cm_core,
>  	cm_node->tcp_cntxt.rcv_nxt = 0;
>  	/* get a unique session ID , add thread_id to an 
> upcounter to handle race */
>  	atomic_inc(&cm_core->node_cnt);
> -	atomic_inc(&cm_core->session_id);
> -	cm_node->session_id = 
> (u32)(atomic_read(&cm_core->session_id) + current->tgid);
>  	cm_node->conn_type = cm_info->conn_type;
>  	cm_node->apbvt_set = 0;
>  	cm_node->accept_pend = 0;
> @@ -1628,9 +1625,7 @@ static struct nes_cm_listener 
> *mini_cm_listen(struct nes_cm_core *cm_core,
>  	listener->cm_core = cm_core;
>  	listener->nesvnic = nesvnic;
>  	atomic_inc(&cm_core->node_cnt);
> -	atomic_inc(&cm_core->session_id);
>  
> -	listener->session_id = 
> (u32)(atomic_read(&cm_core->session_id) + current->tgid);
>  	listener->conn_type = cm_info->conn_type;
>  	listener->backlog = cm_info->backlog;
>  	listener->listener_state = NES_CM_LISTENER_ACTIVE_STATE;
> @@ -1943,7 +1938,6 @@ static struct nes_cm_core 
> *nes_cm_alloc_core(void)
>  	cm_core->state = NES_CM_STATE_INITED;
>  	cm_core->free_tx_pkt_max = NES_CM_DEFAULT_FREE_PKTS;
>  
> -	atomic_set(&cm_core->session_id, 0);
>  	atomic_set(&cm_core->events_posted, 0);
>  
>  	/* init the packet lists */
> diff --git a/drivers/infiniband/hw/nes/nes_cm.h 
> b/drivers/infiniband/hw/nes/nes_cm.h
> index 980fb67..7717cb2 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.h
> +++ b/drivers/infiniband/hw/nes/nes_cm.h
> @@ -225,7 +225,6 @@ enum nes_cm_listener_state {
>  
>  struct nes_cm_listener {
>  	struct list_head           list;
> -	u64                        session_id;
>  	struct nes_cm_core         *cm_core;
>  	u8                         loc_mac[ETH_ALEN];
>  	nes_addr_t                 loc_addr;
> @@ -242,7 +241,6 @@ struct nes_cm_listener {
>  
>  /* per connection node and node state information */
>  struct nes_cm_node {
> -	u64                       session_id;
>  	u32                       hashkey;
>  
>  	nes_addr_t                loc_addr, rem_addr;
> @@ -327,7 +325,6 @@ struct nes_cm_event {
>  
>  struct nes_cm_core {
>  	enum nes_cm_node_state  state;
> -	atomic_t                session_id;
>  
>  	atomic_t                listen_node_cnt;
>  	struct nes_cm_node      listen_list;
> 
