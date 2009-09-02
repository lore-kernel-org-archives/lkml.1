Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZIBO4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZIBO4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZIBO4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:56:14 -0400
Received: from stinky.trash.net ([213.144.137.162]:48197 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZIBO4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:56:13 -0400
Message-ID: <4A9E8788.1090901@trash.net>
Date: Wed, 02 Sep 2009 16:56:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Hannes Eder <heder@google.com>
CC: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       =?ISO-8859-15?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>,
       Jan Engelhardt <jengelh@medozas.de>,
       Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>,
       Julian Anastasov <ja@ssi.bg>, Julius Volz <julius.volz@gmail.com>,
       Laurent Grawet <laurent.grawet@uclouvain.be>,
       Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>
Subject: Re: [PATCH 2/3] IPVS: make friends with nf_conntrack
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com> <20090902101538.11561.11911.stgit@jazzy.zrh.corp.google.com>
In-Reply-To: <20090902101538.11561.11911.stgit@jazzy.zrh.corp.google.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Update the nf_conntrack tuple in reply direction, as we will see
> traffic from the real server (RIP) to the client (CIP).  Once this is
> done we can use netfilters SNAT in POSTROUTING, especially with
> xt_ipvs, to do source NAT, e.g.:
> 
> % iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 --vport 8080 \
>> -j SNAT --to-source 192.168.10.10
> 

> +static void
> +ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp)
> +{
> +	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
> +
> +	if (ct == NULL || ct == &nf_conntrack_untracked ||
> +	    nf_ct_is_confirmed(ct))
> +		return;
> +
> +	/*
> +	 * The connection is not yet in the hashtable, so we update it.
> +	 * CIP->VIP will remain the same, so leave the tuple in
> +	 * IP_CT_DIR_ORIGINAL untouched.  When the reply comes back from the
> +	 * real-server we will see RIP->DIP.
> +	 */
> +	ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3 = cp->daddr;
> +	/*
> +	 * This will also take care of UDP and other protocols.
> +	 */
> +	ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port = cp->dport;
> +}

How does IPVS interact with conntrack helpers? If it does actually
intend to use them (which will happen automatically), it might make
sense to use nf_conntrack_alter_reply(), which will perform a new
helper lookup based on the changed tuple.

