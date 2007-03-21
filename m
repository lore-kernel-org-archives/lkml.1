Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXCUQuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXCUQuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXCUQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:50:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38198 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXCUQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:50:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow per-cpu variables to be page-aligned
References: <1174457426.11680.132.camel@localhost.localdomain>
	<m1ejnjc5qa.fsf@ebiederm.dsl.xmission.com>
	<1174477457.11680.170.camel@localhost.localdomain>
Date: Wed, 21 Mar 2007 10:49:25 -0600
In-Reply-To: <1174477457.11680.170.camel@localhost.localdomain> (Rusty
	Russell's message of "Wed, 21 Mar 2007 22:44:16 +1100")
Message-ID: <m11wjiczje.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Wed, 2007-03-21 at 03:21 -0600, Eric W. Biederman wrote:
>> Do we really want to allow modules to be able to allocate page sized
>> per cpu memory.
>
> Hi Eric!
>
> 	They always could, of course, they just wouldn't get correct alignment.
> I think the principle of least surprise says that if we support this, it
> will also work in modules...

The module load would fail.

>>   If my memory servers on how this code works we will wind
>> up allocating 1 page of per cpu memory for every module that allocates a
>> per cpu variable.  128 bytes sucks 4k is an order of magnitude worse.
>
> Not quite.  We allocate a total amount of per-cpu memory at boot, then
> anything left over gets used for per-cpu vars in modules.
>
> Looking at the module per-cpu code again, the rounding up of the memory
> used by the kernel seems unnecessary though.  I'll try ripping that
> out...

I want to say that when dealing with cpu stuff aligning to a cache
line makes sense as it prevents multiple variables from sharing
the same cache line.  However we rarely access per cpu variables from
other cpus (the point) so the extra alignment doesn't seem to have
a justification in this context.

Although I'm not quite certain what this will do to the per cpu
memory allocator...

>> On x86_64 we are only reserving 8K for modules...
>
> Really?  I can't see that.

Look at how we define PERCPU_MODULE_RESERVE and PERCPU_ENOUGH_ROOM.

> It did look like the x86-64 setup_per_cpu_areas should be moved into
> common code though (it's numa-aware).  Maybe that breaks some platforms.

After increasing NR_IRQS on x86_64 to (NR_CPUS*32) the per cpu irq
stats got much bigger especially as NR_CPUS went up.  The only
reasonable way I could see to fix this at the time was to just make
PER_CPU_ENOUGH_ROOM do the right thing and change size dynamically
with the size of the per cpu section.  I added PERCPU_MODULE_RESERVE
to allocate the amount that we did not have compile information on.
8K was roughly what we had left over for modules before I made the
change so I just preserved that.

We do have to be careful though as some architectures have fixed sized
areas they are putting the per cpu stats into.

> It means the x86 cpu_pda initialization would have to be done in
> smp_prepare_boot_cpu tho...

Well that is earlier than trap_init so it shouldn't be a problem...

Eric
