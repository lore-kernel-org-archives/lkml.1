Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbZDEKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbZDEKBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 06:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbZDEKBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 06:01:20 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48190 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbZDEKBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:01:18 -0400
Message-ID: <49D88162.5040809@cosmosbay.com>
Date: Sun, 05 Apr 2009 12:01:06 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: graham@gmurray.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free counters"
References: <20090329234702.4988017f@desktop.r000n.info>	<8763hja8cy.fsf@newton.gmurray.org.uk> <20090405.012237.198610462.davem@davemloft.net>
In-Reply-To: <20090405.012237.198610462.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 05 Apr 2009 12:01:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Graham Murray <graham@gmurray.org.uk>
> Date: Sun, 05 Apr 2009 08:05:17 +0100
> 
> Please CC the appropriate mailing lists (as I have now) when reporting
> this incredibly useful information.  The networking and netfilter
> developers largely do not read linux-kernel.
> 
>> Roman Mindalev <r000n@r000n.net> writes:
>>
>>> Result of the bisection:
>>>
>>> 784544739a25c30637397ace5489eeb6e15d7d49 is first bad commit
>>> commit 784544739a25c30637397ace5489eeb6e15d7d49             
>> I am seeing a different problem which also bisects to this commit. There are
>> no kernel messages but ip6tables fails to run.
>>
>> newton ~ # ip6tables -L -v
>> FATAL: Module ip6_tables not found.
>> ip6tables v1.4.3.1: can't initialize ip6tables table `filter': Memory allocation problem
>> Perhaps ip6tables or your kernel needs to be upgraded.
>>
>> I get this error no matter which ip6tables sub-command I run. Ip6tables
>> is built into the kernel, not as modules.
>>
>> An strace shows the failure to be 
>> socket(PF_INET6, SOCK_RAW, IPPROTO_RAW) = 3
>> getsockopt(3, SOL_IPV6, 0x40 /* IPV6_??? */, "filter\0\305\0w~\300\0wb\305P\24\312\t\0009b\305\216\23\0\0\310\341/g\16"..., [84]) = 0
>> brk(0)                                  = 0x8273000
>> brk(0x8294000)                          = 0x8294000

so ip6tables allocates about 128 Kbytes of ram in order to get rules from kernel.

>> getsockopt(3, SOL_IPV6, 0x41 /* IPV6_??? */, 0x8273090, 0xbfd23628) = -1 ENOMEM (Cannot allocate memory)
>> close(3)                                = 0
>>


This is a big problem yes, since "iptables|ip6tables" -L needs to allocate kernel memory
to perform the momentary swap.

On x86, this is potentially a problem if vmalloc space is exhausted or fragmented,
(or lowmem exhausted) and/or many cpus are online/possible.

Graham, could you please give us :

# cat /proc/vmallocinfo
# cat /proc/meminfo

I wonder if your machine is in a state where even an "ip6tables -A ..." would fail anyway
since it should allocate same amount of memory than "ip6tables -L "


This could probably be solved using a single "table" containing rules only, that could
be shared for every cpus. Only counters should be percpu. This should save a lot of ram,
over previous situation (2.6.29 or current one)

(current scheme is to allocate a copy of all rules logic *and* counters per cpu)

Then if we want to be sure "iptables -L" cannot fail, we should reserve this extra space
at load time (iptables -{A|I}", instead.

Other possibility is to use a percpu seqlock as Stephen did in one of his patch, and not swap tables
when doing "iptables -L".
This would slowdown fast path a litle bit (one spinlock/spinunlock) per ipt_do_table() call. 


