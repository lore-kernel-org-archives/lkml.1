Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZIBPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZIBPgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 11:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIBPgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 11:36:12 -0400
Received: from stinky.trash.net ([213.144.137.162]:49005 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZIBPgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 11:36:11 -0400
Message-ID: <4A9E90E4.9080805@trash.net>
Date: Wed, 02 Sep 2009 17:36:04 +0200
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
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com>	 <20090902101527.11561.59498.stgit@jazzy.zrh.corp.google.com>	 <4A9E8711.1070807@trash.net> <b5ddba180909020833w1739bd54t11fded8150007abc@mail.gmail.com>
In-Reply-To: <b5ddba180909020833w1739bd54t11fded8150007abc@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> On Wed, Sep 2, 2009 at 16:54, Patrick McHardy<kaber@trash.net> wrote:
>> Hannes Eder wrote:
>>> This implements the kernel-space side of the netfilter matcher
>>> xt_ipvs.
>> Looks mostly fine to me, just one question:
>>
>>> +bool ipvs_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>>> +{
>>> +     const struct xt_ipvs *data = par->matchinfo;
>>> +     const u_int8_t family = par->family;
>>> +     struct ip_vs_iphdr iph;
>>> +     struct ip_vs_protocol *pp;
>>> +     struct ip_vs_conn *cp;
>>> +     int af;
>>> +     bool match = true;
>>> +
>>> +     if (data->bitmask == XT_IPVS_IPVS_PROPERTY) {
>>> +             match = skb->ipvs_property ^
>>> +                     !!(data->invert & XT_IPVS_IPVS_PROPERTY);
>>> +             goto out;
>>> +     }
>>> +
>>> +     /* other flags than XT_IPVS_IPVS_PROPERTY are set */
>>> +     if (!skb->ipvs_property) {
>>> +             match = false;
>>> +             goto out;
>>> +     }
>>> +
>>> +     switch (skb->protocol) {
>>> +     case  htons(ETH_P_IP):
>>> +             af = AF_INET;
>>> +             break;
>>> +#ifdef CONFIG_IP_VS_IPV6
>>> +     case  htons(ETH_P_IPV6):
>>> +             af = AF_INET6;
>>> +             break;
>>> +#endif
>>> +     default:
>>> +             match = false;
>>> +             goto out;
>>> +     }
>> In the NF_INET_LOCAL_OUT hook skb->protocol is invalid. So if you
>> don't need this, it would make sense to restrict the match to the
>> other hooks.
>>
>> Even easier would be to use par->family, which contains the address
>> family and doesn't need any translation.
> 
> Nice, I'll use par->family.
> 
> So in theory I do not even need a check like the following in the beginning?
> 
> 	if (family != NFPROTO_IPV4
> #ifdef CONFIG_IP_VS_IPV6
> 	    && family != NFPROTO_IPV6
> #endif
> 		) {
> 		match = false;
> 		goto out;
> 	}

With the AF_UNSPEC registration of your match, it might be used
with different families. But you could add two seperate IPV4/IPV6
registrations or catch an invalid family in ->checkentry() and
remove the runtime check.
