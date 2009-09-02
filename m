Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZIBPdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZIBPdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 11:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZIBPdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 11:33:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZIBPdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 11:33:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=mBMzzgmm8dZVuud5uUbeczH+EyrXNN1XqrgCj7Sq1Jwo1ygN+vNAhGlwg77moWt7m
	56XjgJODNE1fgsA4glhrg==
MIME-Version: 1.0
In-Reply-To: <4A9E8711.1070807@trash.net>
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com>
	 <20090902101527.11561.59498.stgit@jazzy.zrh.corp.google.com>
	 <4A9E8711.1070807@trash.net>
Date: Wed, 2 Sep 2009 17:33:12 +0200
Message-ID: <b5ddba180909020833w1739bd54t11fded8150007abc@mail.gmail.com>
Subject: Re: [PATCH 1/3] netfilter: xt_ipvs (netfilter matcher for IPVS)
From: Hannes Eder <heder@google.com>
To: Patrick McHardy <kaber@trash.net>
Cc: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       =?ISO-8859-1?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>,
       Jan Engelhardt <jengelh@medozas.de>,
       Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>,
       Julian Anastasov <ja@ssi.bg>, Julius Volz <julius.volz@gmail.com>,
       Laurent Grawet <laurent.grawet@uclouvain.be>,
       Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 16:54, Patrick McHardy<kaber@trash.net> wrote:
> Hannes Eder wrote:
>> This implements the kernel-space side of the netfilter matcher
>> xt_ipvs.
>
> Looks mostly fine to me, just one question:
>
>> +bool ipvs_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>> +{
>> +     const struct xt_ipvs *data = par->matchinfo;
>> +     const u_int8_t family = par->family;
>> +     struct ip_vs_iphdr iph;
>> +     struct ip_vs_protocol *pp;
>> +     struct ip_vs_conn *cp;
>> +     int af;
>> +     bool match = true;
>> +
>> +     if (data->bitmask == XT_IPVS_IPVS_PROPERTY) {
>> +             match = skb->ipvs_property ^
>> +                     !!(data->invert & XT_IPVS_IPVS_PROPERTY);
>> +             goto out;
>> +     }
>> +
>> +     /* other flags than XT_IPVS_IPVS_PROPERTY are set */
>> +     if (!skb->ipvs_property) {
>> +             match = false;
>> +             goto out;
>> +     }
>> +
>> +     switch (skb->protocol) {
>> +     case  htons(ETH_P_IP):
>> +             af = AF_INET;
>> +             break;
>> +#ifdef CONFIG_IP_VS_IPV6
>> +     case  htons(ETH_P_IPV6):
>> +             af = AF_INET6;
>> +             break;
>> +#endif
>> +     default:
>> +             match = false;
>> +             goto out;
>> +     }
>
> In the NF_INET_LOCAL_OUT hook skb->protocol is invalid. So if you
> don't need this, it would make sense to restrict the match to the
> other hooks.
>
> Even easier would be to use par->family, which contains the address
> family and doesn't need any translation.

Nice, I'll use par->family.

So in theory I do not even need a check like the following in the beginning?

	if (family != NFPROTO_IPV4
#ifdef CONFIG_IP_VS_IPV6
	    && family != NFPROTO_IPV6
#endif
		) {
		match = false;
		goto out;
	}

Thanks,
-Hannes
