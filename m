Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZGAKUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZGAKUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZGAKU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:20:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:44682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZGAKU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:20:27 -0400
Message-ID: <4A4B38C5.1070504@kernel.org>
Date: Wed, 01 Jul 2009 19:21:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <4A4A9DC6.6020003@kernel.org> <20090701064250.GM6760@one.firstfloor.org>
In-Reply-To: <20090701064250.GM6760@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 10:20:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andi.

Andi Kleen wrote:
>> I don't think it will be too complex.  The necessary bits are already
>> there and they are necessary for other stuff too, so...
> 
> Are we looking at a different source base? Here's a random example
> using possible per cpu data I picked in current git: icmp.c

I was talking about percpu allocator proper.  Yeap, the major work
would be in auditing and converting for_each_possible_cpu() users.

> static int __net_init icmp_sk_init(struct net *net)
> {
>         int i, err;
> 
>         net->ipv4.icmp_sk =
>                 kzalloc(nr_cpu_ids * sizeof(struct sock *), GFP_KERNEL);
>         if (net->ipv4.icmp_sk == NULL)
>                 return -ENOMEM;
> 
>         for_each_possible_cpu(i) {
> 		... allocate per cpu socket and some other setup ...
> 	}
> } 
> 
> static void __net_exit icmp_sk_exit(struct net *net)
> {
>         int i;
> 
>         for_each_possible_cpu(i)
>                 inet_ctl_sock_destroy(net->ipv4.icmp_sk[i]);
>         kfree(net->ipv4.icmp_sk);
>         net->ipv4.icmp_sk = NULL;
> }
> 
> You would need to convert that to use a CPU notifier and callbacks
> setting up the sockets. Then make sure there are no races in all of
> this. And get it somehow tested (where is the user base who
> tests cpu hotplug?) 

Maybe it would be better to allocate percpu sockets as proper percpu
variables.  Initialization would still need callback mechanism tho.  I
was thinking about adding @init callback to percpu_alloc(), which
would be much simpler than doing full cpu hotplug callback.

> And there is lots of similar code all over the tree

For static percpu variables, it'll be mostly about converting
for_each_possible_cpu() to for_each_used_cpu() as both allocation and
initialization can be handled by percpu proper.  For dynamic areas,
allocation can be handled by percpu proper but cpus coming online
would need more work to convert.  It'll take some effort but there
aren't too many alloc_percpu() users yet and I don't think it will be
too difficult.  I wouldn't know for sure before I actually try tho.

Thanks.

-- 
tejun
