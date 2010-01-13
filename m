Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286Ab0AMJuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0AMJuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666Ab0AMJuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:50:17 -0500
Received: from mail-gx0-f228.google.com ([209.85.217.228]:55146 "EHLO
	mail-gx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0AMJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=diTrJS5gUYnn1vL1qgdULFkS9YDXMLYeNeW3nnYan3yA2kXvmWSzR/phtMKlO0a3YE
         BSUG22V8Iylm9FZQU3JYliyfQ9Y93Bmn+Cl+g4NepVREvl6RYxJF6V+5pTckgX2YXPB9
         PvYpnBs7OEm1+c8tUxXDuCHQwPfAkaYZ07nCQ=
Message-ID: <4B4D9754.9070902@gmail.com>
Date: Wed, 13 Jan 2010 04:50:12 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] tcp: harmonize tcp_vx_rcv header length assumptions
References: <4B49D001.4000302@gmail.com> <4B4C4962.8040207@gmail.com> <4B4C52EA.6070705@gmail.com> <4B4CAD45.5080606@gmail.com>
In-Reply-To: <4B4CAD45.5080606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote:
> Eric Dumazet wrote:
>> Seems fine, but :
>>
>> 1) What means the "Transformed ?" you wrote several times ?
>>
> The only reason that I've been able to figure out for having the
> skb->len test in those places is the preceding xfrm4_policy_check()
> or xfrm6_policy_check() must be able to shrink the skb->len?
> 
> When I did the original transform stuff in other code circa 1995, I'd
> envisioned IP length or link layer (PPP) length shrinking (removing
> padding after block ciphers) -- and apparently this implementation
> extended that concept to transport layer, too.
> 
> Personally, I'd prefer that a single test be placed in the appropriate
> spot in the xfrm* functions, instead.  Anybody know where?
> 
I've spent another day staring at the xfrm* functions.  Since nobody
familiar with them has answered my recent questions, it seems I'm on my
own....  So, here are my conclusions:

The current xfrm* code shouldn't change the TCP header.  If anything did,
the current tests wouldn't work anyway.  For example:

tcp_ipv4:
tcp_v4_rcv()
...
1645 no_tcp_socket:
1646         if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
1647                 goto discard_it;
1648
1649         if (skb->len < (th->doff << 2) || tcp_checksum_complete(skb)) {

This code depends on the *th pointer remaining unchanged.  A pullup or
skb clone could make the pointer invalid.

Likewise, the checksum occurs after the xfrm* code.  Thus, the xfrm*
cannot alter, decrypt, or tunnel the input data.

Therefore, I'll remove those existing extraneous skb->len tests.  And
I'll add these criteria to the include/net/xfrm.h for future reference.
