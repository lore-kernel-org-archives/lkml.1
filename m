Return-Path: <linux-kernel-owner+w=401wt.eu-S1750839AbZLMEPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839AbZLMEPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 23:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZLMEPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 23:15:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:34069 "HELO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750733AbZLMEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 23:15:22 -0500
Message-ID: <4B2404C6.2050003@windriver.com>
Date: Sat, 12 Dec 2009 15:01:58 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - due
 to perf API changes
References: <4B227F2C.7050403@windriver.com> <20091212132428.GB22389@elte.hu> <20091212135216.GA18597@elte.hu>
In-Reply-To: <20091212135216.GA18597@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------030209090404000900020900"
X-OriginalArrivalTime: 12 Dec 2009 21:01:58.0448 (UTC) FILETIME=[57E14300:01CA7B6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030209090404000900020900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> Hm, the kgdb hw-breakpoint changes freshly put into v2.6.33 look 
>> pretty broken: [...]
>>     
>
> Sorry - i thought for a moment that it was introduced by this recent 
> change:
>
>   7f8b7ed: kgdb: Always process the whole breakpoint list on activate or deactivate
>
> but it's deeper than that indeed.
>
>   

Yes, the broken parts came from the perf merge.

> Basically we have two options:
>
>  A- change kgdb to use the hw-breakpoints highlevel APIs (i'd prefer 
>     that)
>
>   

Right now we can't because the high level code uses all sorts of mutexes
and sync points to get the hw breakpoints installs on the various
processors.  After I re-spun my RFC patch, I found another problem.  I
do use the high level code to create a block of 4 (struct perf_event **)
structures, but doing so ultimately calls the reserve hw breakpoint even
though they are marked as disabled when created.

Should I, or can I change that behavior?

The aim of the RFC patch was to allow kgdb to using the arch_install*
break point functions directly because they can be used atomically, and
the perf code at the high level will still not get a breakpoint if kgdb
is already using it that way, and kgdb won't squash a breakpoint that
the perf code is using.

In the ideal world the management routines could be the same, but the
problem is in the way we want to deal with the break points in kgdb
while the master and all slave cpus are effectively stopped.

>  B- or keep what we had so far: kgdb overrides existing GDB (and now 
>     perf) breakpoints
>   
This is broken today, because the perf installs itself as the lowest
priority.

If kgdb were to get a lower priority there is a way to make it work
again using the existing code. 

The RFC patch I made aligns things a little better in that at least
perf, user space, and kgdb are all pulling from the same low level
management code.  It has the desirable side effect of making user space
hw breakpoints work in conjunction with kernel space hw breakpoints
which is something that never worked before.

> I havent noticed that hw-breakpoints lock up under kgdb.
>   

I don't see the lockups all the time, it happens when using the kgdb
test suite from boot with the allyesconfig.  Or if you boot the kernel
with kgdbts=V1F100.

I think for now we might just consider turning off the hw breakpoint
code in kgdb so we don't hang kernels, until this is sorted out.  Patch
provided.

Jason.



--------------030209090404000900020900
Content-Type: text/x-diff;
 name="hw_off.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hw_off.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] x86,kgdb: disable kgdb hw breakpoints until they are fixed

Using hw breakpoints can hang the kgdb test suite or yeild unpredictable
results while debugging due to the recent hw_breakpoint changes in
2.6.33.  Until this is fixed, disable kgdb hw breakpoint support.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -576,7 +576,6 @@ unsigned long kgdb_arch_pc(int exception
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: */
 	.gdb_bpt_instr		= { 0xcc },
-	.flags			= KGDB_HW_BREAKPOINT,
 	.set_hw_breakpoint	= kgdb_set_hw_break,
 	.remove_hw_breakpoint	= kgdb_remove_hw_break,
 	.remove_all_hw_break	= kgdb_remove_all_hw_break,

--------------030209090404000900020900--
