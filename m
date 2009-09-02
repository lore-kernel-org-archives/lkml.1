Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZIBOyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZIBOyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZIBOyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:54:16 -0400
Received: from stinky.trash.net ([213.144.137.162]:48151 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZIBOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:54:14 -0400
Message-ID: <4A9E8711.1070807@trash.net>
Date: Wed, 02 Sep 2009 16:54:09 +0200
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
Subject: Re: [PATCH 1/3] netfilter: xt_ipvs (netfilter matcher for IPVS)
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com> <20090902101527.11561.59498.stgit@jazzy.zrh.corp.google.com>
In-Reply-To: <20090902101527.11561.59498.stgit@jazzy.zrh.corp.google.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> This implements the kernel-space side of the netfilter matcher
> xt_ipvs.

Looks mostly fine to me, just one question:

> +bool ipvs_mt(const struct sk_buff *skb, const struct xt_match_param *par)
> +{
> +	const struct xt_ipvs *data = par->matchinfo;
> +	const u_int8_t family = par->family;
> +	struct ip_vs_iphdr iph;
> +	struct ip_vs_protocol *pp;
> +	struct ip_vs_conn *cp;
> +	int af;
> +	bool match = true;
> +
> +	if (data->bitmask == XT_IPVS_IPVS_PROPERTY) {
> +		match = skb->ipvs_property ^
> +			!!(data->invert & XT_IPVS_IPVS_PROPERTY);
> +		goto out;
> +	}
> +
> +	/* other flags than XT_IPVS_IPVS_PROPERTY are set */
> +	if (!skb->ipvs_property) {
> +		match = false;
> +		goto out;
> +	}
> +
> +	switch (skb->protocol) {
> +	case  htons(ETH_P_IP):
> +		af = AF_INET;
> +		break;
> +#ifdef CONFIG_IP_VS_IPV6
> +	case  htons(ETH_P_IPV6):
> +		af = AF_INET6;
> +		break;
> +#endif
> +	default:
> +		match = false;
> +		goto out;
> +	}

In the NF_INET_LOCAL_OUT hook skb->protocol is invalid. So if you
don't need this, it would make sense to restrict the match to the
other hooks.

Even easier would be to use par->family, which contains the address
family and doesn't need any translation.
