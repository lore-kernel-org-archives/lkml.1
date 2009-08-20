Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZHTTmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZHTTmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZHTTmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:42:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZHTTmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:42:33 -0400
Message-ID: <4A8DA7CE.2040702@redhat.com>
Date: Thu, 20 Aug 2009 15:45:18 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [TOOL] kprobestest : Kprobe stress test tool
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <4A847E30.9050903@redhat.com> <20090820184331.GA6078@nowhere>
In-Reply-To: <20090820184331.GA6078@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 13, 2009 at 04:57:20PM -0400, Masami Hiramatsu wrote:
>> This script tests kprobes to probe on all symbols in the kernel and finds
>> symbols which must be blacklisted.
>>
>>
>> Usage
>> -----
>>    kprobestest [-s SYMLIST] [-b BLACKLIST] [-w WHITELIST]
>>       Run stress test. If SYMLIST file is specified, use it as
>>       an initial symbol list (This is useful for verifying white list
>>       after diagnosing all symbols).
>>
>>    kprobestest cleanup
>>       Cleanup all lists
>>
>>
>> How to Work
>> -----------
>> This tool list up all symbols in the kernel via /proc/kallsyms, and sorts
>> it into groups (each of them including 64 symbols in default). And then,
>> it tests each group by using kprobe-tracer. If a kernel crash occurred,
>> that group is moved into 'failed' dir. If the group passed the test, this
>> script moves it into 'passed' dir and saves kprobe_profile into
>> 'passed/profiles/'.
>> After testing all groups, all 'failed' groups are merged and sorted into
>> smaller groups (divided by 4, in default). And those are tested again.
>> This loop will be repeated until all group has just 1 symbol.
>>
>> Finally, the script sorts all 'passed' symbols into 'tested', 'untested',
>> and 'missed' based on profiles.
>>
>>
>> Note
>> ----
>>   - This script just gives us some clues to the blacklisted functions.
>>     In some cases, a combination of probe points will cause a problem, but
>>     each of them doesn't cause the problem alone.
>>
>> Thank you,
>>
>
>
> This script makes my x86-64 dual core easily and hardly locking-up
> on the 1st batch of symbols to test.
> I have one sym list in the failed and unset directories:
>
> int_very_careful
> int_signal
> int_restore_rest
> stub_clone
> stub_fork
> stub_vfork
> stub_sigaltstack
> stub_iopl
> ptregscall_common
> stub_execve
> stub_rt_sigreturn
> irq_entries_start
> common_interrupt
> ret_from_intr
> exit_intr
> retint_with_reschedule
> retint_check
> retint_swapgs
> retint_restore_args
> restore_args
> irq_return
> retint_careful
> retint_signal
> retint_kernel
> irq_move_cleanup_interrupt
> reboot_interrupt
> apic_timer_interrupt
> generic_interrupt
> invalidate_interrupt0
> invalidate_interrupt1
> invalidate_interrupt2
> invalidate_interrupt3
> invalidate_interrupt4
> invalidate_interrupt5
> invalidate_interrupt6
> invalidate_interrupt7
> threshold_interrupt
> thermal_interrupt
> mce_self_interrupt
> call_function_single_interrupt
> call_function_interrupt
> reschedule_interrupt
> error_interrupt
> spurious_interrupt
> perf_pending_interrupt
> divide_error
> overflow
> bounds
> invalid_op
> device_not_available
> double_fault
> coprocessor_segment_overrun
> invalid_TSS
> segment_not_present
> spurious_interrupt_bug
> coprocessor_error
> alignment_check
> simd_coprocessor_error
> native_load_gs_index
> gs_change
> kernel_thread
> child_rip
> kernel_execve
> call_softirq
>
>
> I don't have a crash log because I was running with X.
> But it also happened with other batch of symbols.

Thank you for reporting, here, I also have a result
tested on KVM@x86-64.

native_read_tscp
native_read_msr_safe
native_read_msr_amd_safe
native_write_msr_safe
vmalloc_fault
spurious_fault
search_exception_tables
notify_die
trace_hardirqs_off_caller
ident_complete
lock_acquire
lock_release
bad_address
secondary_startup_64
stack_start
bad_address
restore_args
irq_return
restore
trace_hardirqs_off_thunk
init_level4_pgt
level3_ident_pgt
level3_kernel_pgt
level2_fixmap_pgt
_text
startup_64
level1_fixmap_pgt
level2_ident_pgt
level2_kernel_pgt
level2_spare_pgt
native_get_debugreg
native_set_debugreg
native_set_iopl_mask
native_load_sp0
debug_show_all_locks
debug_check_no_locks_held
valid_state
mark_lock
mark_held_locks
lockdep_trace_alloc
trace_softirqs_on
trace_hardirqs_on_caller
__down_write
__down_read
trace_hardirqs_on_thunk
lockdep_sys_exit_thunk

Most of them can be fixed just by adding __kprobes.
Some of them which are already in the another section, kprobes
should check the symbols are in the section.

> The problem is that I don't have any serial line in this
> box then I can't catch any crash log.
> My K7 testbox also died in my arms this afternoon.
>
> But I still have two other testboxes (one P2 and one P3),
> hopefully I could reproduce the problem in these boxes
> in which I can connect a serial line.

Thank you for helping me to find it!

> I've pushed your patches in the following git tree:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/fgrederic/random-tracing.git \
> 	tracing/kprobes
>
> So you can send patches on top of this one.

Great! I've found another trivial bugs, so I'll fix those on it.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

