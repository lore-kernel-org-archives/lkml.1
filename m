Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbYHEPtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbYHEPtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYHEPtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:49:15 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:56661 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbYHEPtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:49:14 -0400
Message-ID: <39379.166.70.238.45.1217950104.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <489872C5.2040508@redhat.com>
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>
    <489872C5.2040508@redhat.com>
Date: Tue, 5 Aug 2008 09:28:24 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
From: jmerkey@wolfmountaingroup.com
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Jeffery,
>
> Could you explain what is MDB and how it works?


MDB is a kernel debugger that uses the same general architecture
as the kernel debugger in Netware.  Unlike the variants of GNU
debuggers, MDB is geared towards folks from the intel/microsoft worlds
who are more accustomed to the old school Intel assembler model and
not the GNU variant that looks like an angry typewriter cursing at
the screen (%#*&!, etc.).

MDB has some features not yet in this first patch, but I will be adding to
subsequent patches like the ability to create time based traces of
execution of code just like an ice does so you can set trigger breakpoints
(kdb does not, nor kgdb), then go back ad look what happened in windows of
time, as well as a much easier interface, smaller size, more flexible and
pluggable command architecture -- a best of all -- it works and does not
crash every other release or on every third vendors PC architecture like
kdb does all the time.

It has been in use by me since 1997, when I wrote it after I left Novell.
It is mature, hardened, and very stable -- and follows an architecture
prove in the industry for over 20 years on Netware.


> And please check your patch style by using scripts/checkpatch.pl.
> Your cording style seem to be different from linux coding style...
>
> Thank you,


I was unaware of checkpatch.pl, but will run it later today and submit a
git6 patch for any areas not in compliance with linux coding standards.

Jeff

>
> jmerkey@wolfmountaingroup.com wrote:
>> Centralized external definitions into include files and corrected
>> the file to conform to Linux coding practices.  fixed word wrap
>> problems with patches.
>>
>> Corrected kprobes section for int3 trap where CONFIG_MDB is always
>> true.
>>
>> Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)
>>
>> --- a/arch/x86/kernel/traps_32.c	2008-08-04 15:53:24.000000000 -0600
>> +++ b/arch/x86/kernel/traps_32.c	2008-08-04 16:00:25.000000000 -0600
>> @@ -46,6 +46,10 @@
>>  #include <linux/edac.h>
>>  #endif
>>
>> +#ifdef CONFIG_MDB
>> +#include <linux/mdb.h>
>> +#endif // CONFIG_MDB
>> +
>>  #include <asm/arch_hooks.h>
>>  #include <asm/stacktrace.h>
>>  #include <asm/processor.h>
>> @@ -452,8 +456,15 @@
>>   */
>>  void die(const char *str, struct pt_regs *regs, long err)
>>  {
>> -	unsigned long flags = oops_begin();
>> +#ifdef	CONFIG_MDB
>> +	unsigned long flags;
>>
>> +        mdb_oops = (unsigned char *)str;
>> +        mdb(SOFTWARE_EXCEPTION, err, regs);
>> +	flags = oops_begin();
>> +#else
>> +	unsigned long flags = oops_begin();
>> +#endif // CONFIG_MDB
>>  	if (die_nest_count < 3) {
>>  		report_bug(regs->ip, regs);
>>
>> @@ -573,9 +584,9 @@
>>  }
>>
>>  DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV,
>> regs->ip)
>> -#ifndef CONFIG_KPROBES
>> +#if !defined(CONFIG_KPROBES) && !defined(CONFIG_MDB)
>>  DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
>> -#endif
>> +#endif // CONFIG_MDB
>>  DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
>>  DO_VM86_ERROR(5, SIGSEGV, "bounds", bounds)
>>  DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN,
>> regs->ip, 0)
>> @@ -718,6 +729,9 @@
>>  {
>>  	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
>> NOTIFY_STOP)
>>  		return;
>> +#ifdef	CONFIG_MDB
>> +        mdb(NMI_EXCEPTION, reason, regs); // nmi is code 2
>> +#endif // CONFIG_MDB
>>  #ifdef CONFIG_MCA
>>  	/*
>>  	 * Might actually be able to figure out what the guilty party
>> @@ -756,6 +770,9 @@
>>  	printk(" on CPU%d, ip %08lx, registers:\n",
>>  		smp_processor_id(), regs->ip);
>>  	show_registers(regs);
>> +#ifdef	CONFIG_MDB
>> +        mdb(NMI_EXCEPTION, 0, regs); // nmi is code 2
>> +#endif // CONFIG_MDB
>>  	if (do_panic)
>>  		panic("Non maskable interrupt");
>>  	console_silent();
>> @@ -785,6 +802,10 @@
>>  	if (!cpu)
>>  		reason = get_nmi_reason();
>>
>> +#if defined(CONFIG_SMP) && defined(CONFIG_MDB)
>> +        if (mdb(NMI_EXCEPTION, 0, regs))
>> +           return;
>> +#endif // CONFIG_MDB
>>  	if (!(reason & 0xc0)) {
>>  		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
>>  								== NOTIFY_STOP)
>> @@ -850,6 +871,10 @@
>>  #ifdef CONFIG_KPROBES
>>  void __kprobes do_int3(struct pt_regs *regs, long error_code)
>>  {
>> +#ifdef	CONFIG_MDB
>> +        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
>> +           return;
>> +#endif // CONFIG_MDB
>>  	trace_hardirqs_fixup();
>>
>>  	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
>> @@ -865,6 +890,16 @@
>>  }
>>  #endif
>>
>> +#if !defined(CONFIG_KPROBES)
>> +fastcall void do_int3(struct pt_regs * regs, long error_code)
>> +{
>> +#if defined(CONFIG_MDB)
>> +        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
>> +           return;
>> +#endif // CONFIG_MDB
>> +	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
>> +}
>> +#endif
>>  /*
>>   * Our handling of the processor debug registers is non-trivial.
>>   * We do not clear them on entry and exit from the kernel. Therefore
>> @@ -895,6 +930,10 @@
>>  	trace_hardirqs_fixup();
>>
>>  	get_debugreg(condition, 6);
>> +#ifdef	CONFIG_MDB
>> +        if (mdb(DEBUGGER_EXCEPTION, error_code, regs))
>> +           return;
>> +#endif // CONFIG_MDB
>>
>>  	/*
>>  	 * The processor cleared BTF, so don't mark that we need it set.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
>
>


