Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYJJI0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYJJI0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYJJI0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:26:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYJJI0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:26:32 -0400
Date: Fri, 10 Oct 2008 10:26:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #6, misc
Message-ID: <20081010082612.GA25959@elte.hu>
References: <20081010000817.GA9266@elte.hu> <200810101443.48237.nickpiggin@yahoo.com.au> <48EED78F.9040608@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EED78F.9040608@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Nick Piggin wrote:
>> On Friday 10 October 2008 11:08, Ingo Molnar wrote:
>>
>>   
>>> out-of-topic modifications in x86-v28-for-linus-phase6:
>>> -------------------------------------------------------
>>> include/linux/kernel.h             # d974ae3: generic, memparse(): constify
>>> arg include/linux/mm.h                 # f7d0b92: mm: define
>>> USE_SPLIT_PTLOCKS rath # 59ea746: MM: virtual address debug
>>> include/linux/mm_types.h           # f7d0b92: mm: define USE_SPLIT_PTLOCKS
>>> rath include/linux/mmdebug.h            # 7aa413d: x86, MM: virtual address
>>> debug, c # 59ea746: MM: virtual address debug lib/cmdline.c           
>>>           # d974ae3: generic, memparse(): constify arg mm/vmalloc.c   
>>>                    # 7aa413d: x86, MM: virtual address debug, c # 
>>> 59ea746: MM:
>>> virtual address debug
>>>     
>>
>>
>> How come these kinds of things go into the x86 tree? Can't they
>> be sent to other maintainer first (probably Andrew, in the case
>> of random -mm stuff).
>>
>> OK, it's pretty trivial stuff, but just on principle I can't see
>> an advantage, and only disadvantages to doing this (and also I
>> see the vmalloc change clashed with the vmalloc rewrite in -mm).
>
> The memparse and split ptlocks changes went past Andrew.  They ended 
> up in Ingo's tree because 1) they're pretty trivial, and 2) there's 
> x86-specific stuff which depends on them.  Don't know about the 
> vmalloc change.

yeah, correct, as Jeremy already noted they had dependencies with PAT 
and other ioremap relevant changes in the x86 tree so it had to be 
layered.

Nevertheless they are in their separate tree as well: tip/x86/mm-debug. 
Here's the relevant commits:

 5f5ddc2: Merge branch 'x86/core' into x86/mm-debug
 daa9176: Merge branch 'linus' into x86/mm-debug
 7aa413d: x86, MM: virtual address debug, cleanups
 a1bf963: x86, MM: virtual address debug, v2
 59ea746: MM: virtual address debug

if you look at the diffstat:

 arch/x86/kernel/doublefault_32.c |    2 +-
 arch/x86/mm/ioremap.c            |   33 ++++++++++++++++++++++++++-------
 include/asm-x86/mmzone_64.h      |    3 +--
 include/asm-x86/page_32.h        |    5 +++++
 include/linux/mm.h               |    7 +------
 include/linux/mmdebug.h          |   18 ++++++++++++++++++
 lib/Kconfig.debug                |    9 +++++++++
 mm/vmalloc.c                     |    7 +++++++
 8 files changed, 68 insertions(+), 16 deletions(-)

it's 90% x86 relevant and we obviously wanted it well-tested, and as can 
be seen from the log our caution to keep this separated was prudent: the 
v1 version of this patch caused crashes.

Since this was rather trivial and was pending in the last cycle already 
so i didnt send a separate pull request - i already erred on the side of 
sending too many pull requests than too few.

If we sent a separate pull request for every tree we maintain we'd have 
to send 96 pull requests to Linus in this cycle (!), for all these topic 
trees:

 core/debug core/futexes core/lib core/locking core/misc core/percpu 
 core/printk core/rcu core/resources core/signal core/softirq 
 core/softlockup core/xen cpus4096 fastboot genirq irq/sparseirq 
 kmemcheck kmemcheck-bitfields kmemcheck2 oprofile out-of-tree 
 safe-poison-pointers sched/core sched/cpu-hotplug sched/cpusets 
 sched/devel sched/rt stackprotector timers/clockevents 
 timers/clocksource timers/hpet timers/hpet-percpu timers/hrtimers 
 timers/ntp timers/posixtimers tracing/core tracing/fastboot 
 tracing/ftrace tracing/markers tracing/mmiotrace tracing/nmisafe 
 tracing/pipe tracing/ring-buffer tracing/stack-tracer tracing/urgent 
 usb-for-greg x86/alternatives x86/apic x86/build x86/cleanups 
 x86/commandline x86/core x86/cpu x86/crashdump x86/debug x86/defconfig 
 x86/devel x86/doc x86/dumpstack x86/early-printk x86/exports x86/gart 
 x86/header-guards x86/idle x86/iommu x86/memory-corruption-check 
 x86/microcode x86/mm x86/mm-debug x86/mtrr x86/nmi-watchdog 
 x86/oprofile x86/paravirt x86/pat x86/pci-ioapic-boot-irq-quirks 
 x86/pebs x86/prototypes x86/ptrace x86/quirks x86/reboot x86/setup 
 x86/signal x86/sparse-fixes x86/spinlocks x86/time x86/tracehook 
 x86/traps x86/tsc x86/unify-cpu-detect x86/urgent x86/uv x86/vmalloc 
 x86/x2apic x86/xen x86/xsave

And Stephen and Andrew would have to resolve conflicts and dependencies 
between 96 separate trees.

So we try to settle for some reasonable middle ground.

	Ingo
