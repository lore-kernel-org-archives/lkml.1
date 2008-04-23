Return-Path: <linux-kernel-owner+w=401wt.eu-S1751702AbYDWGrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbYDWGrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYDWGrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:47:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:44699 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYDWGrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:47:36 -0400
Message-ID: <480ED9D5.1010906@parallels.com>
Date: Wed, 23 Apr 2008 10:40:21 +0400
From: Kirill Korotaev <dev@parallels.com>
Organization: Parallels
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       containers@lists.linux-foundation.org, nick@nick-andrew.net,
       Nadia.Derbey@bull.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object	creation
 with a specified id)
References: <20080418054459.891481000@bull.net>	<20080422193612.GA15835@martell.zuzino.mipt.ru>	<1208890580.17117.14.camel@nimitz.home.sr71.net>	<20080422210130.GA15937@martell.zuzino.mipt.ru> <1208904967.17117.51.camel@nimitz.home.sr71.net>
In-Reply-To: <1208904967.17117.51.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the current interface is insufficient, we should first expand it in
> such a way that it can be used for checkpoint.  That certainly won't
> work in all cases.  fork(), for instance, doesn't take any arguments and
> is going to be awfully hard to expand. :)
> 
> I'd love to hear some of your insights about how things like the current
> iptables interfaces are insufficient for checkpoint/restart.

iptables is a bad example. Luckily for checkpointing - it always had an interface
"load full state", "dump full state".

But even iptables are not working in current form for checkpointing - they can't
save/restore state of conntracks. Do you think netdev@/netfilter@ guys will be happy
to have APIs allowing to set conntracks and have all the pain related
to API stability - cause conntrack state changed a couple of times during last 2 years.

Consider more intimate kernel states like:
a. task statistics
b. task start time
c. load average
d. skb state and it's data.
e. mount tree.

If you think over, e.g. (b) is a bad thing. It was used to be accounted in jiffies, then in timespec.
(a) is another example of dataset which we can't predict. task statistics change over a time.
Why bother with such intimate data in user-space at all?
Why the hell user-space should know about it and be ABLE to modify it?

Why do we need to export ability to set IDs for some objects which none of the
operating systems do and then to have a burden to support it for application compatibility
the rest of our lifes? Do you really believe none of the applications except for checkpointing
will be using it?

My personal vision is that:
1. user space must initialize checkpointing/restore state via some system call,
   supply file descriptor from where data can be read/written to.
2. must call the syscall asking kernel to restore/save different subsytems one by one.
3. finalize cpt/restore state via the syscall
But user-space MUST NOT bother about data content. At least not about the data supplied by the kernel.
It can add additional sections if needed, e.g. about iptables state.

Having all this functionality in a signle syscall we specifically CLAIM a black box,
and that no one can use this interfaces for something different from checkpoint/restore.

So I think we have to know what other maintainers think before we can go.


>> These next ids are suitable, well, only for ids which is very, very small
>> part of kernel state needed to restore group of processes.
> 
> I couldn't agree more.  This id setting mechanism would only be useful
> for a small subset of the things we need during a restart.
> 
> -- Dave
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
