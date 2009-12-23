Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZLWAaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZLWAaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZLWAaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:30:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42936 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZLWAaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:30:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o1iIxkiKgSFe1Xyu+/j6mFGxcNuNf5A8GM6EtYVKt4oMrtlzlHdbqAmAy4ZUNsr0e0
         SCdVNDxUxFUKrA4Xu6VBBmOR5LWk5Mz6XpAsmC1LesAp6F97DyTVb//0Y0EVK2j/yITs
         JKDuWOP6Iqw+VFNjI/AyzBSiWscSGn7nJvAEk=
MIME-Version: 1.0
In-Reply-To: <20091222135124.GR4489@kernel.dk>
References: <20091222024755.GA5725@orion> <20091222135124.GR4489@kernel.dk>
Date: Wed, 23 Dec 2009 03:30:08 +0300
Message-ID: <a4423d670912221630u689ad0d4j2dd2f2dd4bb4140c@mail.gmail.com>
Subject: Re: 2.6.33-rc1: NULL pointer dereference at wb_do_writeback()
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/22 Jens Axboe <jens.axboe@oracle.com>:
> On Tue, Dec 22 2009, Alexander Beregalov wrote:
>> Hi Jens
>>
>> The kernel is v2.6.33-rc1-154-gf7b84a6ba with few patches from
>> Frederic's reiserbkl/reiserfs/kill-bkl tree, seems unrelated.
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000001
>> IP: [<c10aec3b>] wb_do_writeback+0x6b/0x1a0
>> *pde = 00000000
>> Oops: 0000 [#1]
>> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
>> Modules linked in: hwmon_vid sata_sil i2c_nforce2
>>
>> Pid: 993, comm: <AB>lush-8: Not tainted 2.6.33-rc1-00160-gdaa84dd #1 NF7-S/NF7,NF7-V (nVidia-nForce2)/
>> EIP: 0060:[<c10aec3b>] EFLAGS: 00010246 CPU: 0
>> EIP is at wb_do_writeback+0x6b/0x1a0
>> EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 00000000
>> ESI: ffff94e5 EDI: f6ad024c EBP: f608bf70 ESP: f608bf38
>>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>> Process <AB>lush-8: (pid: 993, ti=f608a000 task=f65914f0 task.ti=f608a000)
>> Stack:
>>  00000002 00000001 00000000 c10aebf0 00000000 00000000 f6ad01a4 00000f1b
>> <0> 00000292 000001f4 ffff94e5 000001f4 ffff94e5 f6ad01a4 f608bf84 c10aedbb
>> <0> f6ad0120 f6ad01a4 c107a010 f608bf9c c107a067 00000000 f70a9eec f6ad01a4
>> Call Trace:
>>  [<c10aebf0>] ? wb_do_writeback+0x20/0x1a0
>>  [<c10aedbb>] ? bdi_writeback_task+0x4b/0x80
>>  [<c107a010>] ? bdi_start_fn+0x0/0xb0
>>  [<c107a067>] ? bdi_start_fn+0x57/0xb0
>>  [<c107a010>] ? bdi_start_fn+0x0/0xb0
>>  [<c103decc>] ? kthread+0x6c/0x80
>>  [<c103de60>] ? kthread+0x0/0x80
>>  [<c100303a>] ? kernel_thread_helper+0x6/0x1c
>> Code: 00 c7 04 24 02 00 00 00 e8 53 1f fa ff 8b 1f 8b 03 0f 18 00 90 39 fb 74
>> 1c 8b 55 e0 8b 42 0c 0f a3 43 10 19 d2 85 d2 75 77 8b 1b <8b> 13 0f 18 02 90 39
>> df 75 ea 31 db 90 b9 48 ec 0a c1 ba 01 00
>> EIP: [<c10aec3b>] wb_do_writeback+0x6b/0x1a0 SS:ESP 0068:f608bf38
>> CR2: 0000000000000001
>> ---[ end trace 6a300b1deaf502c3 ]---
>
> Hmm, this looks really funky.
>
>> wb_do_writeback+0x6b is 0x115b
>> it is in get_next_work_item():
>> %ebx = list_entry_rcu(work->list.next, struct bdi_work, list) = 1
>
> Isn't it rather
>
>        list_entry_rcu(bdi->work_list.next, ...)
>
> and points at wb->bdi not being valid. Are you using any debugging
> options in the kernel config?
>
> Also, this:
>
> Process <AB>lush-8: (pid: 993, ti=f608a000 task=f65914f0 task.ti=f608a000)
>
> looks veeeery fishy, that should be flush-8. Looks like some memory
> corruption possibly.

Do you suspect a hardware problem ?

Debug options:

# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=0
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
