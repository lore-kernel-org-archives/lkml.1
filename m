Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYHDDBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYHDDBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 23:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYHDDBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 23:01:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:41165 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbYHDDBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 23:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=it+NtiZ1t0waaw4rFBqKTHEx01CnGyW/bVNZG5TKcDW2iD5tSU9Cp9GlzqClZET21O
         C702QaCYxByRJakw2D0TY22PwTiOZW0norgHwcrk5CiTYVE2xO1QRXlyqcuaUhY6eRJ4
         ofSDJoPTejFtPWZDWL8RWlyk5zm5YCcEnr5UM=
Message-ID: <489670F6.3040805@gmail.com>
Date: Mon, 04 Aug 2008 06:01:10 +0300
From: Dmitri Gribenko <gribozavr@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc1 "BUG: unable to handle kernel NULL pointer dereference"
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got a HP Compaq 6720s laptop (Core 2 Duo 1.8 GHz, 2 Gb RAM).  When
I close the lid, I get a panic (see below).  First time I got it on
Debian 2.6.25 kernel.  Then I compiled vanilla 2.6.26 and 2.6.27-rc1
kernels and got the same panic.  With kernel config file for 2.6.27-rc1
(posted below) the problem is 100% reproducible (and it is 100%
reproducible on 2.6.26, too).

It is not only reproducible, but it is more or less "stable".  I have 
triggered it many times and I only got two "types" of oopses with this 
config.

(Unscientific observation: Depending on the config, oopses differ very 
much.  When many features are enabled, initial oops triggers some other 
error and oops doesn't even finish printing, but that error starts
printing, and that error triggers some other error, and so on until it
finally hangs, often with half-updated-scrolling screen; it dumps very
much information, but i can't make any sense of it.  When there are
little features enabled, the oops is pretty stable.)

I have discovered that if I turn off CONFIG_ACPI_VIDEO, the problem goes 
away and I can't trigger it anymore.  It also goes away if I disable SMP.
I have verified this on 2.6.26 and 2.6.27-rc1.  Let me rephrase: with any
config (feature-rich or not), it I turn off CONFIG_ACPI_VIDEO, problem goes
away.  No other option(s) I tried turning off didn't affect the oops (they
only affected how much useful information was printed... see "unscientific
observation" above)

"Type A" oops: NULL address 0000000000000046 is always the same, the 
first four qwords on stack are always the same, most of other registers are
the same, "Code:" is the same.

[   47.644300] BUG: unable to handle kernel NULL pointer dereference at 0000000000000046
[   47.644496] IP: [<ffff88007f15cd38>] 0xffff88007f15cd38
[   47.644622] PGD 7a81e067 PUD 37adb067 PMD 0
[   47.644856] Oops: 0000 [1] SMP
[   47.645030] CPU 1
[   47.645144] Modules linked in: loop iTCO_wdt intel_agp wmi ac battery video button container output sd_mod sg sr_mod cdrom ahci ata_piix ata_generic libata scsi_mod dock thermal processor fan
[   47.646461] Pid: 0, comm: swapper Not tainted 2.6.27-rc1-4aug2008-test #1
[   47.646532] RIP: f3c0:[<ffff88007f0e6108>]  [<ffff88007f0e6108>] 0xffff88007f0e6108
[   47.646667] RSP: ffffffff8022cb16:ffff88007f17fb00  EFLAGS: ffff88007f181998
[   47.646739] RAX: ffff88007f17fab0 RBX: 0000000000003022 RCX: ffffffff8022a65f
[   47.646811] RDX: ffff88007f0e6108 RSI: ffff88000101f3c0 RDI: ffff880001022a00
[   47.646885] RBP: ffff88007f044f18 R08: ffff88007f17faf0 R09: ffffffff80295671
[   47.646957] R10: ffff88007f17fa90 R11: ffff88007f044f18 R12: 0000000000000000
[   47.647028] R13: ffff88007f241a90 R14: 0000000000000000 R15: 000000007f7e7de0
[   47.647100] FS:  0000000000000000(0000) GS:ffff88007f03fe88(0000) knlGS:0000000000000000
[   47.647184] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   47.647254] CR2: 0000000000000046 CR3: 000000007a81c000 CR4: 00000000000006e0
[   47.647325] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   47.647397] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   47.647469] Process swapper (pid: 0, threadinfo ffff88007f0ba000, task ffff88007f0ac6b0)
[   47.647552] Stack:  ffff88007f17fb40 ffffffff8022cff8 ffff880001022a00 ffff880001022a00
[   47.647886]  00000000ffff0a4b ffff88007950a230 0000000000000001 ffffc2000002405b
[   47.648172]  ffff88007f17fc00 0000000000000046 000000000000028d ffffffff804a24d0
[   47.648395] Call Trace:
[   47.648519]
[   47.648582]
[   47.648645] Code: 88 ff ff 02 00 00 00 40 80 20 80 00 00 00 00 ff ff ff ff 73 00 00 00 73 00 00 00 73 00 00 00 00 00 00 00 20 2b 48 80 ff ff ff ff <31> 0c 00 00 00 00 00 00 97 ff 14 00 00 00 00 00 01 00 00 00 00
[   47.655499] RIP  [<ffff88007f0e6108>] 0xffff88007f0e6108
[   47.655613]  RSP <ffff88007f17fb00>
[   47.655673] CR2: 0000000000000046
[   47.656081] ---[ end trace 5faf4dab7e32f729 ]---
[   47.656216] Kernel panic - not syncing: Attempted to kill the idle task!

(I'm not a kernel developer, but here's what I managed to understand from
this): There is some kind of stack corruption, and upon function return
RIP got some nonsensical address, probably pointing to the data (?).  So
the "Code" is not of any help here (and it disassembles to nonsense).

Address 0xffffffff8022cff8 (found on stack) is in pick_next_task_fair(),
kernel/sched_fair.c, just in the place where hrtick_start_fair() should
return.  This address appears in the same place on stack in every Type A
oops.

0xffffffff8022cfe8 <pick_next_task_fair+200>:	sub    $0x38,%rbx
0xffffffff8022cfec <pick_next_task_fair+204>:	mov    -0x30(%rbp),%rdi
0xffffffff8022cff0 <pick_next_task_fair+208>:	mov    %rbx,%rsi
0xffffffff8022cff3 <pick_next_task_fair+211>:	callq  0xffffffff8022cd80 <hrtick_start_fair>
0xffffffff8022cff8 <pick_next_task_fair+216>:	add    $0x8,%rsp <== here
0xffffffff8022cffc <pick_next_task_fair+220>:	mov    %rbx,%rax
0xffffffff8022cfff <pick_next_task_fair+223>:	pop    %rbx
0xffffffff8022d000 <pick_next_task_fair+224>:	pop    %r12
0xffffffff8022d002 <pick_next_task_fair+226>:	pop    %r13
0xffffffff8022d004 <pick_next_task_fair+228>:	pop    %r14
0xffffffff8022d006 <pick_next_task_fair+230>:	pop    %r15
0xffffffff8022d008 <pick_next_task_fair+232>:	leaveq 
0xffffffff8022d009 <pick_next_task_fair+233>:	retq   

Address 0xffffffff804a24d0 (found on stack) is symbol _acpi_module_name
and contains ASCIZ string "dsutils" (but this address does not appear in
every Type A oops).

And 0xffffffff8022cb16 (is it ss segment???) is __dequeue_entity+54.  It
appears in all oopses (type A and B).

(gdb) disassemble 0xffffffff8022cb16
Dump of assembler code for function __dequeue_entity:
0xffffffff8022cae0 <__dequeue_entity+0>:	push   %rbp
0xffffffff8022cae1 <__dequeue_entity+1>:	mov    %rsp,%rbp
0xffffffff8022cae4 <__dequeue_entity+4>:	sub    $0x20,%rsp
0xffffffff8022cae8 <__dequeue_entity+8>:	mov    %rbx,-0x18(%rbp)
0xffffffff8022caec <__dequeue_entity+12>:	mov    %r12,-0x10(%rbp)
0xffffffff8022caf0 <__dequeue_entity+16>:	mov    %r13,-0x8(%rbp)
0xffffffff8022caf4 <__dequeue_entity+20>:	lea    0x10(%rsi),%r12
0xffffffff8022caf8 <__dequeue_entity+24>:	mov    %rdi,%rbx
0xffffffff8022cafb <__dequeue_entity+27>:	mov    %rsi,%r13
0xffffffff8022cafe <__dequeue_entity+30>:	cmp    %r12,0x38(%rdi)
0xffffffff8022cb02 <__dequeue_entity+34>:	je     0xffffffff8022cb38 <__dequeue_entity+88>
0xffffffff8022cb04 <__dequeue_entity+36>:	cmp    %r13,0x60(%rbx)
0xffffffff8022cb08 <__dequeue_entity+40>:	je     0xffffffff8022cb28 <__dequeue_entity+72>
0xffffffff8022cb0a <__dequeue_entity+42>:	lea    0x30(%rbx),%rsi
0xffffffff8022cb0e <__dequeue_entity+46>:	mov    %r12,%rdi
0xffffffff8022cb11 <__dequeue_entity+49>:	callq  0xffffffff80351040 <rb_erase>
0xffffffff8022cb16 <__dequeue_entity+54>:	mov    -0x18(%rbp),%rbx <== here
0xffffffff8022cb1a <__dequeue_entity+58>:	mov    -0x10(%rbp),%r12
0xffffffff8022cb1e <__dequeue_entity+62>:	mov    -0x8(%rbp),%r13
0xffffffff8022cb22 <__dequeue_entity+66>:	leaveq 
0xffffffff8022cb23 <__dequeue_entity+67>:	retq   
0xffffffff8022cb24 <__dequeue_entity+68>:	nopl   0x0(%rax)
0xffffffff8022cb28 <__dequeue_entity+72>:	movq   $0x0,0x60(%rbx)
0xffffffff8022cb30 <__dequeue_entity+80>:	jmp    0xffffffff8022cb0a <__dequeue_entity+42>
0xffffffff8022cb32 <__dequeue_entity+82>:	nopw   0x0(%rax,%rax,1)
0xffffffff8022cb38 <__dequeue_entity+88>:	mov    %r12,%rdi
0xffffffff8022cb3b <__dequeue_entity+91>:	callq  0xffffffff803513f0 <rb_next>
0xffffffff8022cb40 <__dequeue_entity+96>:	mov    %rax,0x38(%rbx)
0xffffffff8022cb44 <__dequeue_entity+100>:	test   %rax,%rax
0xffffffff8022cb47 <__dequeue_entity+103>:	je     0xffffffff8022cb04 <__dequeue_entity+36>
0xffffffff8022cb49 <__dequeue_entity+105>:	mov    0x40(%rax),%rax
0xffffffff8022cb4d <__dequeue_entity+109>:	mov    0x20(%rbx),%rcx
0xffffffff8022cb51 <__dequeue_entity+113>:	mov    %rax,%rdx
0xffffffff8022cb54 <__dequeue_entity+116>:	sub    %rcx,%rdx
0xffffffff8022cb57 <__dequeue_entity+119>:	test   %rdx,%rdx
0xffffffff8022cb5a <__dequeue_entity+122>:	cmovle %rcx,%rax
0xffffffff8022cb5e <__dequeue_entity+126>:	mov    %rax,0x20(%rbx)
0xffffffff8022cb62 <__dequeue_entity+130>:	jmp    0xffffffff8022cb04 <__dequeue_entity+36>
End of assembler dump.

"Type B" oops: happens more rarely than Type A and contains little useful infomation
[   51.215963] BUG: unable to handle kernel NULL pointer dereference at 0000000000000046
[   51.216159] IP: [<ffff88007f1eed38>] 0xffff88007f1eed38
[   51.216285] PGD 0
[   51.216413] Oops: 0000 [1] SMP
[   51.216587] CPU 1
[   51.216700] Modules linked in: loop iTCO_wdt wmi battery container intel_agp video button ac output sg sr_mod cdrom sd_mod ata_piix ata_generic ahci libata scsi_mod dock thermal processor fan
[   51.218004] Pid: 0, comm: swapper Not tainted 2.6.27-rc1-4aug2008-test #1
[   51.218074] RIP: 0000:[<000000000002405b>]  [<000000000002405b>] 0x2405b
[   51.218198] RSP: ffffffffffffffff:0000000000000000  EFLAGS: 00000000
[   51.218268] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000800
[   51.218340] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   51.218411] RBP: ffff88000101f480 R08: 000000000000029f R09: 0000000000000000
[   51.218483] R10: ffff88000101f4f0 R11: ffff88000101f4f0 R12: 0000000100000000
[   51.218554] R13: ffff88007f17fbb8 R14: 0000000200000000 R15: ffff88007f17fbcc
[   51.218626] FS:  0000000000000000(0000) GS:ffff88007f03fe88(0000) knlGS:0000000000000000
[   51.218709] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   51.218778] CR2: 0000000000000046 CR3: 0000000000201000 CR4: 00000000000006e0
[   51.218850] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   51.218921] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   51.218993] Process swapper (pid: 0, threadinfo ffff88007f0ba000, task ffff88007f0ac6b0)
[   51.219075] Stack:  ffff88007f17f818 0000000000000000 ffff88007f17fa38 0000000000000000
[   51.219411]  0000000000000040 000000000000002b ffff88007f17f888 ffffffff8020e2c1
[   51.219691]  ffff88007f17f888 0000000000000000 ffffffff804ece49 ffff88007f17fa38
[   51.219912] Call Trace:
[   51.220035]
[   51.220097]
[   51.220160] Code:  Bad RIP value.
[   51.220328] RIP  [<000000000002405b>] 0x2405b
[   51.220445]  RSP <0000000000000000>
[   51.220512] CR2: 0000000000000046
[   51.224358] ---[ end trace 2fd9488f8ce78a4d ]---
[   51.224468] Kernel panic - not syncing: Attempted to kill the idle task!

0xffffffff8020e2c1 is in show_registers(), in a place where
show_stack_log_lvl() should return.

0xffffffff804ece49 is kallsyms_token_index+26257.

This oops is 100% reproducible, I can trigger it easily and can do additional
testing/checks as needed.

.config:

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_USER_SCHED=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLOCK_COMPAT=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_CLASSIC_RCU=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
CONFIG_MCORE2=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_GET_USER_PAGES_FAST=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_RESOURCES_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HZ_250=y
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_PM=y
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_WMI=m
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_FIB_HASH=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_CONNECTOR=m
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_RAM=y
CONFIG_HAVE_IDE=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_SRP=m
CONFIG_ATA=m
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ARTOP=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_SIS=m
CONFIG_PATA_SCH=m
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_NETDEVICES=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NETDEV_1000=y
CONFIG_E1000E=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_DIGIEPCA=m
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=m
CONFIG_SX=m
CONFIG_RIO=m
CONFIG_RIO_OLDPCI=y
CONFIG_STALDRV=y
CONFIG_NOZOMI=m
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_NVRAM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_MWAVE=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_W1=m
CONFIG_W1_CON=y
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=y
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_IT8712F_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=m
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y
CONFIG_SSB_POSSIBLE=y
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_VESA=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_V3020=m
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_FS_POSIX_ACL=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_GENERIC_ACL=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_CONFIGFS_FS=y
CONFIG_CRAMFS=y
CONFIG_ROMFS_FS=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_FRAME_POINTER=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_IO_DELAY_0X80=y
CONFIG_KEYS=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_HAVE_KVM=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y

# lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile GME965/GLE960 Memory Controller Hub (rev 0c)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile GME965/GLE960 Integrated Graphics Controller (rev 0c)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at e0300000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 2000 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+

00:02.1 Display controller: Intel Corporation Mobile GME965/GLE960 Integrated Graphics Controller (rev 0c)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at e0400000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+

00:19.0 Ethernet controller: Intel Corporation 82562GT 10/100 Network Connection (rev 03)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 222
	Region 0: Memory at e0500000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e0520000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 2020 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 4161
	Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 4: I/O ports at 2040 [size=32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at e0521000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at e0524000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4151
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30d8
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 4: I/O ports at 2060 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 10
	Region 4: I/O ports at 2080 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 4: I/O ports at 20a0 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at e0528000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 30d8

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 20c0 [size=16]
	Kernel driver in use: ata_piix
	Kernel modules: ata_generic, ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01)
	Subsystem: Hewlett-Packard Company Device 30d8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 221
	Region 0: I/O ports at 13f0 [size=8]
	Region 1: I/O ports at 15f4 [size=4]
	Region 2: I/O ports at 1370 [size=8]
	Region 3: I/O ports at 1574 [size=4]
	Region 4: I/O ports at 2100 [size=32]
	Region 5: Memory at e0529000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
		Address: fee0300c  Data: 4171
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

# dmidecode
# dmidecode 2.9
SMBIOS 2.4 present.
25 structures occupying 1236 bytes.
Table at 0x000F25F6.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Hewlett-Packard
	Version: 68MDU Ver. F.0B
	Release Date: 06/20/2008
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		3.5"/720 KB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		Smart battery is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 15.11
	Firmware Revision: 131.14

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Hewlett-Packard
	Product Name: HP Compaq 6720s
	Version: F.0B
	Serial Number: CNU8201T4G
	UUID: B6D2FF9A-C915-E011-3A80-6D9910224129
	Wake-up Type: Power Switch
	SKU Number: KU325ES#ACB
	Family: 103C_5336AN

Handle 0x0040, DMI type 126, 48 bytes
Inactive

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: Hewlett-Packard
	Product Name: 30D8
	Version: KBC Version 83.0E
	Serial Number: Not Specified

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: Hewlett-Packard
	Type: Notebook
	Lock: Not Present
	Version: Not Specified
	Serial Number: CNU8201T4G
	Asset Tag: CNU8201T4G
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: External Interface Enabled

Handle 0x0041, DMI type 126, 32 bytes
Inactive

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U10
	Type: Central Processor
	Family: Pentium M
	Manufacturer: Intel(R)
	ID: FD 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 13
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz
	Voltage: 1.1 V
	External Clock: 200 MHz
	Max Speed: 1800 MHz
	Current Speed: 1800 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: External
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0007, DMI type 9, 13 bytes
System Slot Information
	Designation: PC CARD-Slot 0
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Short
	ID: Adapter 0, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		PME signal is supported

Handle 0x0008, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description: 8

Handle 0x0009, DMI type 11, 5 bytes
OEM Strings
	String 1: www.hp.com
	String 2: ABS 70/71 79 7A 7B 7C

Handle 0x000A, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: No Error
	Number Of Devices: 2

Handle 0x000B, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: SODIMM
	Set: None
	Locator: DIMM #1
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer:                          
	Serial Number:         
	Asset Tag: Not Specified
	Part Number:                   

Handle 0x000C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM #2
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Samsung                  
	Serial Number: 7645FCCC
	Asset Tag: Not Specified
	Part Number: M4 70T5663QZ3-CE6 

Handle 0x000D, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x000A
	Partition Width: 0

Handle 0x000E, DMI type 126, 19 bytes
Inactive

Handle 0x000F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x000C
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: 1

Handle 0x0010, DMI type 22, 26 bytes
Portable Battery
	Location: Primary
	Manufacturer: Hewlett-Packard
	Manufacture Date: 05/08/2008
	Serial Number: 53524       
	Name: HP                
	Chemistry: Lithium Ion
	Design Capacity: 44000 mWh
	Design Voltage: 10800 mV
	SBDS Version: Not Specified
	Maximum Error: Unknown
	OEM-specific Information: 0x00000000

Handle 0x0011, DMI type 126, 26 bytes
Inactive

Handle 0x0012, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0085, DMI type 133, 34 bytes
OEM-specific Type
	Header and Data:
		85 22 85 00 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00
		00 00
	Strings:
		                
		No battery        

Handle 0x0086, DMI type 134, 34 bytes
OEM-specific Type
	Header and Data:
		86 22 86 00 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00
		00 00
	Strings:
		                
		                  

Handle 0x0013, DMI type 144, 26 bytes
OEM-specific Type
	Header and Data:
		90 1A 13 00 FF FF FF FF FF FF FF FF FF FF FF FF
		FF FF FF FF FF FF FF FF 00 00

Handle 0x0014, DMI type 127, 4 bytes
End Of Table

Regards,
Dmitri

-- 
main(i,j){for(i=2;;i++){for(j=2;j<i;j++){if(!(i%j)){j=0;break;}}if
(j){printf("%d\n",i);}}} /*Dmitri Gribenko <gribozavr@gmail.com>*/


