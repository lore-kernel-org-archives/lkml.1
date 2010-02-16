Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab0BPTef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 14:34:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:37147 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab0BPTed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 14:34:33 -0500
Message-ID: <4B7AF321.8060008@windriver.com>
Date: Tue, 16 Feb 2010 13:33:53 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 18/28] powerpc,kgdb: Introduce low level trap catching
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com> <1266014143-29444-19-git-send-email-jason.wessel@windriver.com> <1266190167.16346.70.camel@pasglop>
In-Reply-To: <1266190167.16346.70.camel@pasglop>
Content-Type: multipart/mixed;
 boundary="------------010905050100050005000904"
X-OriginalArrivalTime: 16 Feb 2010 19:33:52.0538 (UTC) FILETIME=[F87EE7A0:01CAAF3E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010905050100050005000904
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Benjamin Herrenschmidt wrote:
> On Fri, 2010-02-12 at 16:35 -0600, Jason Wessel wrote:
>
>   
>> @@ -115,7 +116,9 @@ void kgdb_roundup_cpus(unsigned long flags)
>>  /* KGDB functions to use existing PowerPC64 hooks. */
>>  static int kgdb_debugger(struct pt_regs *regs)
>>  {
>> -	return kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs);
>> +	if (kgdb_handle_exception(1, computeSignal(TRAP(regs)), DIE_OOPS, regs))
>> +		return 0;
>> +	return 1;
>>  }
>>     
>
> I'm no fan of logic inversions like that but I suppose you are trying to
> fit into existing hooks. However, I'd rather then do:
>
> 	return !kgdb...
>   

I agree and I made the change to return !kgdb...


>> +++ b/arch/powerpc/kernel/traps.c
>> @@ -809,12 +809,19 @@ void __kprobes program_check_exception(struct pt_regs *regs)
>>  		return;
>>  	}
>>  	if (reason & REASON_TRAP) {
>> +
>> +#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
>> +		if (debugger_bpt(regs))
>> +			return;
>> +#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
>>  		/* trap exception */
>>  		if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
>>  				== NOTIFY_STOP)
>>  			return;
>> +#ifndef CONFIG_KGDB_LOW_LEVEL_TRAP
>>  		if (debugger_bpt(regs))
>>  			return;
>> +#endif /* ! CONFIG_KGDB_LOW_LEVEL_TRAP */
>>  
>>  		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
>>  		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
>>
>>     
> No firm objection, but it -is- a bit ugly... Should we just
> unconditionally move the debugger_bpt() early on with a comment about
> why we do so ? Is there any drawback you can think of ?
>
>   

I took a peek at xmon, and it suffers from the same problem where you
can place a breakpoint in any part of rcu_lock, notify_die, or
atomic_notifier_call_chain and meet with recursive faults.  I also
checked that xmon appears to correctly return so as to continue if the
exception was not intended for xmon.

The reason I had not just moved the code block previously is that I was
not looking to break anything such as xmon, which is the the only other
user of this function.

I'll add your ack, if you agree with the new version of the patch.

Thanks,
Jason.

--------------010905050100050005000904
Content-Type: text/x-diff;
 name="ppc-dbg-traps.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ppc-dbg-traps.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] powerpc,kgdb: Introduce low level trap catching

The only way the debugger can handle a trap in inside rcu_lock,
notify_die, or atomic_notifier_call_chain without a recursive fault is
to allow the kernel debugger to handle the exception first in
program_check_exception().

The other change here is to make sure that kgdb_handle_exception() is
called with correct parameters when catching an oops, because kdb
needs to know if the entry was an oops, single step, or breakpoint
exception.

[benh@kernel.crashing.org: move debugger_bpt instead of #ifdef]

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/powerpc/kernel/kgdb.c  |    6 ++++--
 arch/powerpc/kernel/traps.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -20,6 +20,7 @@
 #include <linux/smp.h>
 #include <linux/signal.h>
 #include <linux/ptrace.h>
+#include <linux/kdebug.h>
 #include <asm/current.h>
 #include <asm/processor.h>
 #include <asm/machdep.h>
@@ -115,7 +116,8 @@ void kgdb_roundup_cpus(unsigned long fla
 /* KGDB functions to use existing PowerPC64 hooks. */
 static int kgdb_debugger(struct pt_regs *regs)
 {
-	return kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs);
+	return !kgdb_handle_exception(1, computeSignal(TRAP(regs)),
+				      DIE_OOPS, regs);
 }
 
 static int kgdb_handle_breakpoint(struct pt_regs *regs)
@@ -123,7 +125,7 @@ static int kgdb_handle_breakpoint(struct
 	if (user_mode(regs))
 		return 0;
 
-	if (kgdb_handle_exception(0, SIGTRAP, 0, regs) != 0)
+	if (kgdb_handle_exception(1, SIGTRAP, 0, regs) != 0)
 		return 0;
 
 	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -809,12 +809,14 @@ void __kprobes program_check_exception(s
 		return;
 	}
 	if (reason & REASON_TRAP) {
+		/* Debugger is first in line to stop recursive faults in
+		 * rcu_lock, notify_die, or atomic_notifier_call_chain */
+		if (debugger_bpt(regs))
+			return;
 		/* trap exception */
 		if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
 				== NOTIFY_STOP)
 			return;
-		if (debugger_bpt(regs))
-			return;
 
 		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
 		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {

--------------010905050100050005000904--
