Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYAWX2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYAWX2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 18:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYAWX17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 18:27:59 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11258 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYAWX15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 18:27:57 -0500
To: Christoph Hellwig <hch@infradead.org>,
       "Glenn Streiff" <gstreiff@NetEffect.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.25
X-Message-Flag: Warning: May contain useful information
References: <ada7ii8xaao.fsf@cisco.com> <20080121100151.GD5333@infradead.org>
	<adad4rttthr.fsf@cisco.com> <20080123055014.GA9256@infradead.org>
	<ada1w88qlrd.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 23 Jan 2008 15:27:43 -0800
In-Reply-To: <ada1w88qlrd.fsf@cisco.com> (Roland Dreier's message of "Wed, 23 Jan 2008 13:23:34 -0800")
Message-ID: <adave5kp1g0.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jan 2008 23:27:44.0466 (UTC) FILETIME=[8E4BF320:01C85E17]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than arguing over whether we have to have sparse clean code, I
decided to annotate the code myself.  Here's a patch that fixes most
of the sparse warnings in the nes driver.  There's still some stuff
that actually looks buggy, like the way hte_index stuff is handled.
You initialize hte_index_mask as:

	hte_index_mask = ((u32)1 << ((u32temp & 0x001f)+1))-1;
	nesadapter->hte_index_mask = hte_index_mask;

but then compute hte_index stuff with:

	nesqp->hte_index = cpu_to_be32(
			crc32c(~0, (void *)&nes_quad, sizeof(nes_quad)) ^ 0xffffffff);

and then do:

	nesqp->hte_index &= nesadapter->hte_index_mask;

which seems odd to say the least (hte_index is big-endian,
hte_index_mask is cpu-endian).

And also, there's code with the loc_addr/rem_addr etc that seem very
confused.  For example

	cm_info->loc_addr = htonl(cm_info->loc_addr);
	cm_info->rem_addr = htonl(cm_info->rem_addr);
	cm_info->loc_port = htons(cm_info->loc_port);
	cm_info->rem_port = htons(cm_info->rem_port);

which is obviously impossible to annotate correctly, and I couldn't
keep track of the endianness stuff elsewhere.

Anyway this is what I have in case the promised cleanups don't turn up
in time...

Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 7a2f596..365ebaa 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -231,10 +231,10 @@ static int nes_net_event(struct notifier_block *notifier,
 					} else {
 						if (neigh->nud_state & NUD_VALID) {
 							nes_manage_arp_cache(neigh->dev, neigh->ha,
-									ntohl(*(u32 *)neigh->primary_key), NES_ARP_ADD);
+									ntohl(*(__be32 *)neigh->primary_key), NES_ARP_ADD);
 						} else {
 							nes_manage_arp_cache(neigh->dev, neigh->ha,
-									ntohl(*(u32 *)neigh->primary_key), NES_ARP_DELETE);
+									ntohl(*(__be32 *)neigh->primary_key), NES_ARP_DELETE);
 						}
 					}
 					return NOTIFY_OK;
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 31d3cf5..d50eb49 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -203,6 +203,7 @@ extern u32 cm_packets_retrans;
 extern u32 cm_listens_created;
 extern u32 cm_listens_destroyed;
 extern u32 cm_backlog_drops;
+extern atomic_t cm_loopbacks;
 extern atomic_t cm_nodes_created;
 extern atomic_t cm_nodes_destroyed;
 extern atomic_t cm_accel_dropped_pkts;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index d0153e2..4bb5833 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -187,7 +187,7 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 len)
 	}
 
 	mpa_frame = (struct ietf_mpa_frame *)buffer;
-	cm_node->mpa_frame_size = (u32)ntohs(mpa_frame->priv_data_len);
+	cm_node->mpa_frame_size = ntohs(mpa_frame->priv_data_len);
 
 	if (cm_node->mpa_frame_size + sizeof(struct ietf_mpa_frame) != len) {
 		nes_debug(NES_DBG_CM, "The received ietf buffer was not right"
@@ -271,7 +271,7 @@ struct sk_buff *form_cm_frame(struct sk_buff *skb, struct nes_cm_node *cm_node,
 	buf += sizeof(*tcph);
 
 	skb->ip_summed = CHECKSUM_PARTIAL;
-	skb->protocol = ntohs(0x800);
+	skb->protocol = htons(0x800);
 	skb->data_len = 0;
 	skb->mac_len = ETH_HLEN;
 
@@ -285,7 +285,7 @@ struct sk_buff *form_cm_frame(struct sk_buff *skb, struct nes_cm_node *cm_node,
 	iph->tot_len = htons(packetsize);
 	iph->id = htons(++cm_node->tcp_cntxt.loc_id);
 
-	iph->frag_off = ntohs(0x4000);
+	iph->frag_off = htons(0x4000);
 	iph->ttl = 0x40;
 	iph->protocol= 0x06;	/* IPPROTO_TCP */
 
@@ -394,7 +394,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	}
 
 	if (type == NES_TIMER_TYPE_SEND) {
-		new_send->seq_num = htonl(tcp_hdr(skb)->seq);
+		new_send->seq_num = ntohl(tcp_hdr(skb)->seq);
 		atomic_inc(&new_send->skb->users);
 
 		ret = nes_nic_cm_xmit(new_send->skb, cm_node->netdev);
@@ -419,7 +419,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
 	}
 	if (type == NES_TIMER_TYPE_RECV) {
-		new_send->seq_num = htonl(tcp_hdr(skb)->seq);
+		new_send->seq_num = ntohl(tcp_hdr(skb)->seq);
 		new_send->timetosend = jiffies;
 		spin_lock_irqsave(&cm_node->recv_list_lock, flags);
 		list_add_tail(&new_send->list, &cm_node->recv_list);
@@ -1245,7 +1245,7 @@ static int process_options(struct nes_cm_node *cm_node, u8 *optionsloc, u32 opti
 				if (all_options->as_mss.length != 4) {
 					return 1;
 				} else {
-					tmp = htons(all_options->as_mss.mss);
+					tmp = ntohs(all_options->as_mss.mss);
 					if (tmp > 0 && tmp < cm_node->tcp_cntxt.mss)
 						cm_node->tcp_cntxt.mss = tmp;
 				}
@@ -1369,7 +1369,7 @@ int process_packet(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	else if (tcph->syn)
 		cm_node->tcp_cntxt.mss = NES_CM_DEFAULT_MSS;
 
-	cm_node->tcp_cntxt.snd_wnd = htons(tcph->window) <<
+	cm_node->tcp_cntxt.snd_wnd = ntohs(tcph->window) <<
 			cm_node->tcp_cntxt.snd_wscale;
 
 	if (cm_node->tcp_cntxt.snd_wnd > cm_node->tcp_cntxt.max_snd_wnd) {
@@ -1621,7 +1621,7 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 
 	nes_debug(NES_DBG_CM, "Api - listen(): addr=0x%08X, port=0x%04x,"
 			" listener = %p, backlog = %d, cm_id = %p.\n",
-			ntohl(cm_info->loc_addr), ntohs(cm_info->loc_port),
+			htonl(cm_info->loc_addr), htons(cm_info->loc_port),
 			listener, listener->backlog, listener->cm_id);
 
 	return listener;
@@ -1827,7 +1827,7 @@ int mini_cm_recv_pkt(struct nes_cm_core *cm_core, struct nes_vnic *nesvnic,
 	tcph = (struct tcphdr *)(skb->data + sizeof(struct iphdr));
 	skb_reset_network_header(skb);
 	skb_set_transport_header(skb, sizeof(*tcph));
-	skb->len = htons(iph->tot_len);
+	skb->len = ntohs(iph->tot_len);
 
 	nfo.loc_addr = ntohl(iph->daddr);
 	nfo.loc_port = ntohs(tcph->dest);
@@ -2832,7 +2832,7 @@ void cm_event_connected(struct nes_cm_event *event)
 	nesqp->hte_index = cpu_to_be32(
 			crc32c(~0, (void *)&nes_quad, sizeof(nes_quad)) ^ 0xffffffff);
 	nes_debug(NES_DBG_CM, "HTE Index = 0x%08X, After CRC = 0x%08X\n",
-			nesqp->hte_index, nesqp->hte_index & nesadapter->hte_index_mask);
+		  be32_to_cpu(nesqp->hte_index), be32_to_cpu(nesqp->hte_index) & nesadapter->hte_index_mask);
 
 	nesqp->hte_index &= nesadapter->hte_index_mask;
 	nesqp->nesqp_context->hte_index = cpu_to_le32(nesqp->hte_index);
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 46f1dea..6109fdf 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -55,7 +55,7 @@ struct ietf_mpa_frame {
 	u8 key[IETF_MPA_KEY_SIZE];
 	u8 flags;
 	u8 rev;
-	u16 priv_data_len;
+	__be16 priv_data_len;
 	u8 priv_data[0];
 };
 
@@ -63,9 +63,9 @@ struct ietf_mpa_frame {
 
 struct nes_v4_quad {
 	u32 rsvd0;
-	u32 DstIpAdrIndex;	/* Only most significant 5 bits are valid */
-	u32 SrcIpadr;
-	u16 TcpPorts[2];		/* src is low, dest is high */
+	__le32 DstIpAdrIndex;	/* Only most significant 5 bits are valid */
+	__be32 SrcIpadr;
+	__be16 TcpPorts[2];		/* src is low, dest is high */
 };
 
 struct nes_cm_node;
@@ -101,7 +101,7 @@ enum option_numbers {
 struct option_mss {
 	u8 optionnum;
 	u8 length;
-	u16 mss;
+	__be16 mss;
 };
 
 struct option_windowscale {
diff --git a/drivers/infiniband/hw/nes/nes_context.h b/drivers/infiniband/hw/nes/nes_context.h
index 114553f..3c4b06f 100644
--- a/drivers/infiniband/hw/nes/nes_context.h
+++ b/drivers/infiniband/hw/nes/nes_context.h
@@ -34,50 +34,50 @@
 #define NES_CONTEXT_H
 
 struct nes_qp_context {
-	u32   misc;
-	u32   cqs;
-	u32   sq_addr_low;
-	u32   sq_addr_high;
-	u32   rq_addr_low;
-	u32   rq_addr_high;
-	u32   misc2;
-	u16   tcpPorts[2];
-	u32   ip0;
-	u32   ip1;
-	u32   ip2;
-	u32   ip3;
-	u32   mss;
-	u32   arp_index_vlan;
-	u32   tcp_state_flow_label;
-	u32   pd_index_wscale;
-	u32   keepalive;
+	__le32 misc;
+	__le32 cqs;
+	__le32 sq_addr_low;
+	__le32 sq_addr_high;
+	__le32 rq_addr_low;
+	__le32 rq_addr_high;
+	__le32 misc2;
+	__le16 tcpPorts[2];
+	__le32 ip0;
+	__le32 ip1;
+	__le32 ip2;
+	__le32 ip3;
+	__le32 mss;
+	__le32 arp_index_vlan;
+	__le32 tcp_state_flow_label;
+	__le32 pd_index_wscale;
+	__le32 keepalive;
 	u32   ts_recent;
 	u32   ts_age;
-	u32   snd_nxt;
-	u32   snd_wnd;
-	u32   rcv_nxt;
-	u32   rcv_wnd;
-	u32   snd_max;
-	u32   snd_una;
+	__le32 snd_nxt;
+	__le32 snd_wnd;
+	__le32 rcv_nxt;
+	__le32 rcv_wnd;
+	__le32 snd_max;
+	__le32 snd_una;
 	u32   srtt;
-	u32   rttvar;
-	u32   ssthresh;
-	u32   cwnd;
-	u32   snd_wl1;
-	u32   snd_wl2;
-	u32   max_snd_wnd;
-	u32   ts_val_delta;
+	__le32 rttvar;
+	__le32 ssthresh;
+	__le32 cwnd;
+	__le32 snd_wl1;
+	__le32 snd_wl2;
+	__le32 max_snd_wnd;
+	__le32 ts_val_delta;
 	u32   retransmit;
 	u32   probe_cnt;
-	u32   hte_index;
-	u32   q2_addr_low;
-	u32   q2_addr_high;
-	u32   ird_index;
+	__le32 hte_index;
+	__le32 q2_addr_low;
+	__le32 q2_addr_high;
+	__le32 ird_index;
 	u32   Rsvd3;
-	u32   ird_ord_sizes;
+	__le32 ird_ord_sizes;
 	u32   mrkr_offset;
-	u32   aeq_token_low;
-	u32   aeq_token_high;
+	__le32 aeq_token_low;
+	__le32 aeq_token_high;
 };
 
 /* QP Context Misc Field */
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index b9cebfa..73c3a6c 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2199,7 +2199,7 @@ void nes_nic_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
 	struct nes_hw_nic_sq_wqe *nic_sqe;
 	struct sk_buff *skb;
 	struct sk_buff *rx_skb;
-	u16 *wqe_fragment_length;
+	__le16 *wqe_fragment_length;
 	unsigned long flags;
 	u32 head;
 	u32 cq_size;
@@ -2227,7 +2227,7 @@ void nes_nic_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
 				wqe_fragment_index = 1;
 				nic_sqe = &nesnic->sq_vbase[nesnic->sq_tail];
 				skb = nesnic->tx_skb[nesnic->sq_tail];
-				wqe_fragment_length = (u16 *)&nic_sqe->wqe_words[NES_NIC_SQ_WQE_LENGTH_0_TAG_IDX];
+				wqe_fragment_length = (__le16 *)&nic_sqe->wqe_words[NES_NIC_SQ_WQE_LENGTH_0_TAG_IDX];
 				/* bump past the vlan tag */
 				wqe_fragment_length++;
 				if (le16_to_cpu(wqe_fragment_length[wqe_fragment_index]) != 0) {
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 2efb55e..b1fea65 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -1106,7 +1106,7 @@ struct nes_adapter {
 };
 
 struct nes_pbl {
-	u64              *pbl_vbase;
+	__le64           *pbl_vbase;
 	dma_addr_t       pbl_pbase;
 	struct page      *page;
 	unsigned long    user_base;
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index bd3f9e8..30a9696 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -92,42 +92,6 @@ static const u32 default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK
 		| NETIF_MSG_IFUP | NETIF_MSG_IFDOWN;
 static int debug = -1;
 
-extern atomic_t cm_connects;
-extern atomic_t cm_accepts;
-extern atomic_t cm_disconnects;
-extern atomic_t cm_closes;
-extern atomic_t cm_connecteds;
-extern atomic_t cm_connect_reqs;
-extern atomic_t cm_rejects;
-extern atomic_t mod_qp_timouts;
-extern atomic_t qps_created;
-extern atomic_t qps_destroyed;
-extern atomic_t sw_qps_destroyed;
-extern u32 mh_detected;
-extern u32 mh_pauses_sent;
-extern u32 cm_packets_sent;
-extern u32 cm_packets_bounced;
-extern u32 cm_packets_created;
-extern u32 cm_packets_received;
-extern u32 cm_packets_dropped;
-extern u32 cm_packets_retrans;
-extern u32 cm_listens_created;
-extern u32 cm_listens_destroyed;
-extern u32 cm_backlog_drops;
-extern atomic_t cm_loopbacks;
-extern atomic_t cm_nodes_created;
-extern atomic_t cm_nodes_destroyed;
-extern atomic_t cm_accel_dropped_pkts;
-extern atomic_t cm_resets_recvd;
-extern u32 int_mod_timer_init;
-extern u32 int_mod_cq_depth_256;
-extern u32 int_mod_cq_depth_128;
-extern u32 int_mod_cq_depth_32;
-extern u32 int_mod_cq_depth_24;
-extern u32 int_mod_cq_depth_16;
-extern u32 int_mod_cq_depth_4;
-extern u32 int_mod_cq_depth_1;
-
 static int nes_netdev_open(struct net_device *);
 static int nes_netdev_stop(struct net_device *);
 static int nes_netdev_start_xmit(struct sk_buff *, struct net_device *);
@@ -350,21 +314,21 @@ static int nes_nic_send(struct sk_buff *skb, struct net_device *netdev)
 	struct nes_hw_nic *nesnic = &nesvnic->nic;
 	struct nes_hw_nic_sq_wqe *nic_sqe;
 	struct tcphdr *tcph;
-	u16 *wqe_fragment_length;
+	__le16 *wqe_fragment_length;
 	u32 wqe_misc;
 	u16 wqe_fragment_index = 1;	/* first fragment (0) is used by copy buffer */
 	u16 skb_fragment_index;
 	dma_addr_t bus_address;
 
 	nic_sqe = &nesnic->sq_vbase[nesnic->sq_head];
-	wqe_fragment_length = (u16 *)&nic_sqe->wqe_words[NES_NIC_SQ_WQE_LENGTH_0_TAG_IDX];
+	wqe_fragment_length = (__le16 *)&nic_sqe->wqe_words[NES_NIC_SQ_WQE_LENGTH_0_TAG_IDX];
 
 	/* setup the VLAN tag if present */
 	if (vlan_tx_tag_present(skb)) {
 		nes_debug(NES_DBG_NIC_TX, "%s: VLAN packet to send... VLAN = %08X\n",
 				netdev->name, vlan_tx_tag_get(skb));
 		wqe_misc = NES_NIC_SQ_WQE_TAGVALUE_ENABLE;
-		wqe_fragment_length[0] = vlan_tx_tag_get(skb);
+		wqe_fragment_length[0] = (__force __le16) vlan_tx_tag_get(skb);
 	} else
 		wqe_misc = 0;
 
@@ -475,7 +439,7 @@ static int nes_netdev_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	u32 send_rc;
 	struct iphdr *iph;
 	unsigned long flags;
-	u16 *wqe_fragment_length;
+	__le16 *wqe_fragment_length;
 	u32 nr_frags;
 	u32 original_first_length;
 //	u64 *wqe_fragment_address;
@@ -577,13 +541,13 @@ tso_sq_no_longer_full:
 				tso_wqe_length = 0;
 				nic_sqe = &nesnic->sq_vbase[nesnic->sq_head];
 				wqe_fragment_length =
-						(u16 *)&nic_sqe->wqe_words[NES_NIC_SQ_WQE_LENGTH_0_TAG_IDX];
+						(__le16 *)&nic_sqe->wqe_words[NES_NIC_SQ_WQE_LENGTH_0_TAG_IDX];
 				/* setup the VLAN tag if present */
 				if (vlan_tx_tag_present(skb)) {
 					nes_debug(NES_DBG_NIC_TX, "%s: VLAN packet to send... VLAN = %08X\n",
 							netdev->name, vlan_tx_tag_get(skb) );
 					wqe_misc = NES_NIC_SQ_WQE_TAGVALUE_ENABLE;
-					wqe_fragment_length[0] = vlan_tx_tag_get(skb);
+					wqe_fragment_length[0] = (__force __le16) vlan_tx_tag_get(skb);
 				} else
 					wqe_misc = 0;
 
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index efdd629..24e2326 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -610,8 +610,8 @@ void nes_post_cqp_request(struct nes_device *nesdev,
 		nes_debug(NES_DBG_CQP, "CQP request %p (opcode 0x%02X), line 1 = 0x%08X"
 				" put on the pending queue.\n",
 				cqp_request,
-				cqp_request->cqp_wqe.wqe_words[NES_CQP_WQE_OPCODE_IDX]&0x3f,
-				cqp_request->cqp_wqe.wqe_words[NES_CQP_WQE_ID_IDX]);
+				le32_to_cpu(cqp_request->cqp_wqe.wqe_words[NES_CQP_WQE_OPCODE_IDX]) & 0x3f,
+				le32_to_cpu(cqp_request->cqp_wqe.wqe_words[NES_CQP_WQE_ID_IDX]));
 		list_add_tail(&cqp_request->list, &nesdev->cqp_pending_reqs);
 	}
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index ebe1a17..e218cac 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -298,10 +298,8 @@ static int nes_bind_mw(struct ib_qp *ibqp, struct ib_mw *ibmw,
 			cpu_to_le32((u32)((u64temp)>>32));
 	wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_HIGH_IDX] =
 			cpu_to_le32((u32)(upper_32_bits((unsigned long)nesqp)));
-	wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX] = (u32)((unsigned long)nesqp);
-	wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX] |= head;
-	wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX] =
-			cpu_to_le32(wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX]);
+	wqe->wqe_words[NES_IWARP_SQ_WQE_COMP_CTX_LOW_IDX] = 
+			cpu_to_le32(head | (u32)(unsigned long) nesqp);
 	wqe_misc = NES_IWARP_SQ_OP_BIND;
 
 	wqe_misc |= NES_IWARP_SQ_WQE_LOCAL_FENCE;
@@ -1072,9 +1070,9 @@ static int nes_setup_virt_qp(struct nes_qp *nesqp, struct nes_pbl *nespbl,
 {
 	unsigned long flags;
 	void *mem;
-	u64 *pbl = NULL;
-	u64 *tpbl;
-	u64 *pblbuffer;
+	__le64 *pbl = NULL;
+	__le64 *tpbl;
+	__le64 *pblbuffer;
 	struct nes_device *nesdev = nesvnic->nesdev;
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	u32 pbl_entries;
@@ -1091,7 +1089,7 @@ static int nes_setup_virt_qp(struct nes_qp *nesqp, struct nes_pbl *nespbl,
 	/* the first pbl to be fro the rq_vbase... */
 	rq_pbl_entries = (rq_size * sizeof(struct nes_hw_qp_wqe)) >> 12;
 	sq_pbl_entries = (sq_size * sizeof(struct nes_hw_qp_wqe)) >> 12;
-	nesqp->hwqp.sq_pbase  = (le32_to_cpu (((u32 *)pbl)[0]) ) | ((u64)((le32_to_cpu (((u32 *)pbl)[1]))) << 32);
+	nesqp->hwqp.sq_pbase  = (le32_to_cpu (((__le32 *)pbl)[0]) ) | ((u64)((le32_to_cpu (((__le32 *)pbl)[1]))) << 32);
 	if (!nespbl->page) {
 		nes_debug(NES_DBG_QP, "QP nespbl->page is NULL \n");
 		kfree(nespbl);
@@ -1109,7 +1107,7 @@ static int nes_setup_virt_qp(struct nes_qp *nesqp, struct nes_pbl *nespbl,
 	/* Now to get to sq.. we need to calculate how many */
 	/* PBL entries were used by the rq.. */
 	pbl += sq_pbl_entries;
-	nesqp->hwqp.rq_pbase  = (le32_to_cpu (((u32 *)pbl)[0]) ) | ((u64)((le32_to_cpu (((u32 *)pbl)[1]))) << 32);
+	nesqp->hwqp.rq_pbase  = (le32_to_cpu (((__le32 *)pbl)[0]) ) | ((u64)((le32_to_cpu (((__le32 *)pbl)[1]))) << 32);
 	/* nesqp->hwqp.rq_vbase = bus_to_virt(*pbl); */
 	/*nesqp->hwqp.rq_vbase = phys_to_virt(*pbl); */
 
@@ -2405,7 +2403,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		u64 virt, int acc, struct ib_udata *udata)
 {
 	u64 iova_start;
-	u64 *pbl;
+	__le64 *pbl;
 	u64 region_length;
 	dma_addr_t last_dma_addr = 0;
 	dma_addr_t first_dma_addr = 0;
@@ -2729,15 +2727,15 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 					chunk_pages += (sg_dma_len(&chunk->page_list[nmap_index]) & (4096-1)) ? 1 : 0;
 					nespbl->page = sg_page(&chunk->page_list[0]);
 					for (page_index=0; page_index<chunk_pages; page_index++) {
-						((u32 *)pbl)[0] = cpu_to_le32((u32)
+						((__le32 *)pbl)[0] = cpu_to_le32((u32)
 								(sg_dma_address(&chunk->page_list[nmap_index])+
 								(page_index*4096)));
-						((u32 *)pbl)[1] = cpu_to_le32(((u64)
+						((__le32 *)pbl)[1] = cpu_to_le32(((u64)
 								(sg_dma_address(&chunk->page_list[nmap_index])+
 								(page_index*4096)))>>32);
 						nes_debug(NES_DBG_MR, "pbl=%p, *pbl=0x%016llx, 0x%08x%08x\n", pbl,
 								(unsigned long long)*pbl,
-								le32_to_cpu(((u32 *)pbl)[1]), le32_to_cpu(((u32 *)pbl)[0]));
+								le32_to_cpu(((__le32 *)pbl)[1]), le32_to_cpu(((__le32 *)pbl)[0]));
 						pbl++;
 					}
 				}
@@ -3730,10 +3728,10 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 				/* Working on a SQ Completion*/
 				wq_tail = wqe_index;
 				nesqp->hwqp.sq_tail = (wqe_index+1)&(nesqp->hwqp.sq_size - 1);
-				wrid = (((u64)(cpu_to_le32((u32)nesqp->hwqp.sq_vbase[wq_tail].
+				wrid = (((u64)(le32_to_cpu(nesqp->hwqp.sq_vbase[wq_tail].
 						wqe_words[NES_IWARP_SQ_WQE_COMP_SCRATCH_HIGH_IDX]))) << 32) |
-						((u64)(cpu_to_le32((u32)nesqp->hwqp.sq_vbase[wq_tail].
-						wqe_words[NES_IWARP_SQ_WQE_COMP_SCRATCH_LOW_IDX])));
+						le32_to_cpu(nesqp->hwqp.sq_vbase[wq_tail].
+						wqe_words[NES_IWARP_SQ_WQE_COMP_SCRATCH_LOW_IDX]);
 				entry->byte_len = le32_to_cpu(nesqp->hwqp.sq_vbase[wq_tail].
 						wqe_words[NES_IWARP_SQ_WQE_TOTAL_PAYLOAD_IDX]);
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index c5ee39d..d4cdc6e 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -77,8 +77,8 @@ struct nes_mr {
 };
 
 struct nes_hw_pb {
-	u32 pa_low;
-	u32 pa_high;
+	__le32 pa_low;
+	__le32 pa_high;
 };
 
 struct nes_vpbl {
@@ -139,7 +139,7 @@ struct nes_qp {
 	struct work_struct    ae_work;
 	enum ib_qp_state      ibqp_state;
 	u32                   iwarp_state;
-	u32                   hte_index;
+	__be32                hte_index;
 	u32                   last_aeq;
 	u32                   qp_mem_size;
 	atomic_t              refcount;
