Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbZICTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbZICTyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZICTyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:54:17 -0400
Received: from ja.ssi.bg ([217.79.71.194]:48058 "EHLO u.domain.uli"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756196AbZICTyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:54:15 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 15:54:14 EDT
Date: Thu, 3 Sep 2009 22:50:58 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@u.domain.uli
To: Hannes Eder <heder@google.com>
cc: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       =?ISO-8859-1?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>,
       Jan Engelhardt <jengelh@medozas.de>,
       Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>,
       Julius Volz <julius.volz@gmail.com>,
       Laurent Grawet <laurent.grawet@uclouvain.be>,
       Patrick McHardy <kaber@trash.net>, Simon Horman <horms@verge.net.au>,
       Wensong Zhang <wensong@linux-vs.org>
Subject: Re: [PATCH 2/3] IPVS: make friends with nf_conntrack
In-Reply-To: <20090902101538.11561.11911.stgit@jazzy.zrh.corp.google.com>
Message-ID: <Pine.LNX.4.58.0909032235350.2940@u.domain.uli>
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com>
 <20090902101538.11561.11911.stgit@jazzy.zrh.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 2 Sep 2009, Hannes Eder wrote:

> Update the nf_conntrack tuple in reply direction, as we will see
> traffic from the real server (RIP) to the client (CIP).  Once this is
> done we can use netfilters SNAT in POSTROUTING, especially with
> xt_ipvs, to do source NAT, e.g.:
> 
> % iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 --vport 8080 \
> > -j SNAT --to-source 192.168.10.10
> 
> Signed-off-by: Hannes Eder <heder@google.com>
> ---

	The following changes in ip_vs_core.c may be break normal
ip_vs_ftp users. Somehow you decided that this POST_ROUTING code is not
needed and deleted it. This code should be present by default.

	From http://www.ssi.bg/~ja/LVS.txt:

===
	Now after  many changes in  latest kernels  I'm not sure
	what  happens if  netfilter sees  IPVS traffic  in POST_ROUTING.
	Such  change require  testing of  ip_vs_ftp in  both passive and
	active  LVS-NAT mode,  with different length  of IP address:port
	representation  in FTP  commands, to check  if resulting packets
	survive double NAT when payload size is changed.  It is the best
	test  for  IPVS to  see  if netfilter  additionally  changes FTP
	packets  leading to  wrong payload.	
===

	So, you have to check the ip_vs_ftp case because double
NAT for IPs and Ports usually works but double changing of SEQs
and payload may be not.

	You can also check NFCT for IPVS (http://www.ssi.bg/~ja/nfct/)
for using netfilter functions and structures (ip_vs_nfct.c)

	most recent rediff:
http://www.ssi.bg/~ja/nfct/ipvs-nfct-2.6.28-1.diff

> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index b227750..27bd002 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -521,26 +521,6 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
>  	return NF_DROP;
>  }
>  
> -
> -/*
> - *      It is hooked before NF_IP_PRI_NAT_SRC at the NF_INET_POST_ROUTING
> - *      chain, and is used for VS/NAT.
> - *      It detects packets for VS/NAT connections and sends the packets
> - *      immediately. This can avoid that iptable_nat mangles the packets
> - *      for VS/NAT.
> - */
> -static unsigned int ip_vs_post_routing(unsigned int hooknum,
> -				       struct sk_buff *skb,
> -				       const struct net_device *in,
> -				       const struct net_device *out,
> -				       int (*okfn)(struct sk_buff *))
> -{
> -	if (!skb->ipvs_property)
> -		return NF_ACCEPT;
> -	/* The packet was sent from IPVS, exit this chain */
> -	return NF_STOP;
> -}
> -
>  __sum16 ip_vs_checksum_complete(struct sk_buff *skb, int offset)
>  {
>  	return csum_fold(skb_checksum(skb, offset, skb->len - offset, 0));
> @@ -1431,14 +1411,6 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
>  		.hooknum        = NF_INET_FORWARD,
>  		.priority       = 99,
>  	},
> -	/* Before the netfilter connection tracking, exit from POST_ROUTING */
> -	{
> -		.hook		= ip_vs_post_routing,
> -		.owner		= THIS_MODULE,
> -		.pf		= PF_INET,
> -		.hooknum        = NF_INET_POST_ROUTING,
> -		.priority       = NF_IP_PRI_NAT_SRC-1,
> -	},
>  #ifdef CONFIG_IP_VS_IPV6
>  	/* After packet filtering, forward packet through VS/DR, VS/TUN,
>  	 * or VS/NAT(change destination), so that filtering rules can be
> @@ -1467,14 +1439,6 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
>  		.hooknum        = NF_INET_FORWARD,
>  		.priority       = 99,
>  	},
> -	/* Before the netfilter connection tracking, exit from POST_ROUTING */
> -	{
> -		.hook		= ip_vs_post_routing,
> -		.owner		= THIS_MODULE,
> -		.pf		= PF_INET6,
> -		.hooknum        = NF_INET_POST_ROUTING,
> -		.priority       = NF_IP6_PRI_NAT_SRC-1,
> -	},
>  #endif
>  };

Regards

--
Julian Anastasov <ja@ssi.bg>
