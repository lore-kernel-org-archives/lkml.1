Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZDNIdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZDNIdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZDNIc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:32:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZDNIc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:32:57 -0400
Date: Tue, 14 Apr 2009 10:32:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -tip build failure: trace_clock_global undefined
Message-ID: <20090414083239.GD27003@elte.hu>
References: <49E4413F.7070700@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4413F.7070700@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I'm seeing linker errors:
>
>  LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `ds_take_timestamp':
> /home/jeremy/git/linux/arch/x86/kernel/ds.c:1380: undefined reference to `trace_clock_global'
> /home/jeremy/git/linux/arch/x86/kernel/ds.c:1380: undefined reference to `trace_clock_global'
> make[2]: *** [.tmp_vmlinux1] Error 1
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
>
>
> .config attached.

Thanks - i pushed out the fix into latest -tip, please re-check it 
works fine for you.

Steve: the reason why randconfig testing had little chance to find 
this was that to trigger the build failure one needs:

 CONFIG_X86_DS=y
 CONFIG_X86_PTRACE_BTS=y
 # CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_PREEMPT_TRACER is not set
 # CONFIG_SYSPROF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
 # CONFIG_EVENT_TRACER is not set
 # CONFIG_FTRACE_SYSCALLS is not set
 # CONFIG_BOOT_TRACER is not set
 # CONFIG_TRACE_BRANCH_PROFILING is not set
 # CONFIG_POWER_TRACER is not set
 # CONFIG_STACK_TRACER is not set
 # CONFIG_HW_BRANCH_TRACER is not set
 # CONFIG_KMEMTRACE is not set
 # CONFIG_WORKQUEUE_TRACER is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_MMIOTRACE is not set

It can be seen that this needs 2^17 - in excess of 100,000 
randconfig steps to have a 50% chance of discovery. In the window of 
breakage so far i did 10,000-20,000 randconfig builds so i had no 
realistic chance to see this.

But the real problem is the flatness of the Kconfig space here and 
the loss of a global switch over tracing: IMO we should have a 
global interactive control over CONFIG_TRACING. It's clearly 
something users want and do (like Jeremy did).

We already have a "Tracers" sub-menu under "Kernel Hacking" - it 
should also be dependent on an interactive switch.

( that switch can be default-y so this wont impact visiblity - but
  it will sure improve configurability and testability. )

	Ingo
