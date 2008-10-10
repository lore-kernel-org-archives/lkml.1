Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbYJJUvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbYJJUvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760103AbYJJUuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:50:50 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:1865 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbYJJUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FZ581YktfS3qY0nrLDgzNfo30ypzgvzhqAIYmV71vLsu8K1oytViNhCCDYF03m1eIE
         ThQ3Gj1EiMQUGN0YOnmtc6HvK1mMId9BUewi42IRW6hSf1p1AUrJq8lbQMluXowTlPfb
         l1w+FYtOvqIyYD2RHZktjKD/uAHHhG/ZsRm2I=
Message-ID: <9b2db90b0810101350o52d79ecka27409bfd3eaf1f8@mail.gmail.com>
Date: Fri, 10 Oct 2008 22:50:47 +0200
From: "Nir Tzachar" <nir.tzachar@gmail.com>
To: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
In-Reply-To: <9b2db90b0810101349y7e357ef7g9c53f2ecf19fe3eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b2db90b0810101349y7e357ef7g9c53f2ecf19fe3eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 10:49 PM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
> Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> Nir Tzachar wrote:
>>>> Hello.
>>>>
>>>> The following warning is reproducible with the code below on 2.6.25.6,
>>>> which uses sendmsg on a udp socket using two iovecs:
>>>>
>>>> ....
>>>> And I always get  the following warning twice:
>>>>
>>>> [ 6658.338116] ------------[ cut here ]------------
>>>> [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
>>>> nf_nat_fn+0x33/0x155()
>>>
>>> Thanks for the report. Does this patch fix it?
>>
>> Actually, this can't be it. Let me look again.
>
>>Found it - we lost an ifdef during the transition to nf_conntrack
>>guarding an exception from defragmentation on loopback input.
>
>>This patch should fix the warning.
>
>

Yes, the patch below fixes the problem.
10x.

> ["x" (text/plain)]
>
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c \
> b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c index 5a955c4..7eb0b61 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -150,10 +150,12 @@ static unsigned int
> ipv4_conntrack_defrag(unsigned int hooknum,
>                                          const struct net_device *out,
>                                          int (*okfn)(struct sk_buff *))
>  {
> +#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
>        /* Previously seen (loopback)?  Ignore.  Do this before
>           fragment check. */
>        if (skb->nfct)
>                return NF_ACCEPT;
> +#endif
>
>        /* Gather fragments. */
>        if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {
>
