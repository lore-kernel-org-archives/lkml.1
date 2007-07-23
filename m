Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbXGWKjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbXGWKjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXGWKi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:38:57 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33025 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbXGWKiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:38:55 -0400
Date: Mon, 23 Jul 2007 14:38:32 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 1/1] lro: Generic Large Receive Offload for TCP traffic
Message-ID: <20070723103832.GB22877@2ka.mipt.ru>
References: <200707201741.49290.ossthema@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200707201741.49290.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan-Bernd.

On Fri, Jul 20, 2007 at 05:41:48PM +0200, Jan-Bernd Themann (ossthema@de.ibm.com) wrote:
> Generic LRO patch
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

Besides couple trivial codyng/formatting nits I did not found any
problematic places after review. Details below.

Thanks.

> +#define TCP_PAYLOAD_LENGTH(iph, tcph) \
> +(ntohs(iph->tot_len) - IP_HDR_LEN(iph) - TCP_HDR_LEN(tcph))

A tab?

> +static void lro_add_common(struct net_lro_desc *lro_desc, struct iphdr *iph,
> +			   struct tcphdr *tcph, int tcp_data_len)
> +{
> +	struct sk_buff *parent = lro_desc->parent;
> +	u32 *topt;
> +
> +	lro_desc->pkt_aggr_cnt++;
> +	lro_desc->ip_tot_len += tcp_data_len;
> +	lro_desc->tcp_next_seq += tcp_data_len;
> +	lro_desc->tcp_window = tcph->window;
> +	lro_desc->tcp_ack = tcph->ack_seq;
> +
> +	/* don't update tcp_rcv_tsval, would not work with PAWS */
> +	if (lro_desc->tcp_saw_tstamp) {
> +		topt = (u32 *) (tcph + 1);
> +		lro_desc->tcp_rcv_tsecr = *(topt + 2);
> +	}
> +
> +	parent->len += tcp_data_len;
> +	parent->data_len += tcp_data_len;
> +
> +	lro_desc->data_csum = csum_add(lro_desc->data_csum,
> +				       lro_tcp_data_csum(iph, tcph,
> +							 tcp_data_len));
> +	return;
> +}

return from void? And in other places too.

> +int __lro_proc_skb(struct net_lro_mgr *lro_mgr, struct sk_buff *skb,
> +		   struct vlan_group *vgrp, u16 vlan_tag, void *priv)
> +{
> +	struct net_lro_desc *lro_desc;
> +        struct iphdr *iph;
> +        struct tcphdr *tcph;
> +	u64 flags;

Broken tab and spaces.

> +struct sk_buff *lro_gen_skb(struct net_lro_mgr *lro_mgr,
> +			    struct skb_frag_struct *frags,
> +			    int len, int true_size,
> +			    void *mac_hdr,
> +			    int hlen)
> +{
> +	struct sk_buff *skb;
> +        struct skb_frag_struct *skb_frags;
> +	int data_len = len;

The same.

> +	skb = netdev_alloc_skb(lro_mgr->dev, hlen);
> +	if (!skb)
> +		return NULL;
> +
> +        skb->len = len;
> +	skb->data_len = len - hlen;

Here too.
There is number of such places, ommitted others.


-- 
	Evgeniy Polyakov
