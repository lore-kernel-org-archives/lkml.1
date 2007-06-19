Return-Path: <linux-kernel-owner+w=401wt.eu-S1763038AbXFSUCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038AbXFSUCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbXFSUBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:01:52 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:60570 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXFSUBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:01:49 -0400
Date: Tue, 19 Jun 2007 16:01:36 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       mingo@redhat.com
Cc: mbligh@google.com
Subject: Re: Problem with global_flush_tlb() on i386 (x86_64? too) in 2.6.22-rc4-mm2
Message-ID: <20070619200136.GA4943@Krystal>
References: <20070619170914.GA30623@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070619170914.GA30623@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:46:40 up 22 days,  4:25,  2 users,  load average: 0.45, 0.74, 1.05
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looking more closely into the code to find the cause of the
change_page_addr()/global_flush_tlb() inconsistency, I see where the
problem could be:

In arch/i386/mm/pageattr.c:
__change_page_attr adds the page to the df_list for deferred removal
when it is replaced by a large page (going back to the normal flags).
This list is walked by global_flush_tlb(); it calls flush_map() and
__free_page for each of these pages.

flush_map() is the only call that ends up doing a clflush/wbinvd and
__flush_tlb_all() on every cpu. However, this is only done when there
are pages recombined in a large page. It never happens when we set the
page flags to something unusual in __change_page_attr().

The x86_64 implementation seems to work around this issue by doing a
flush_map() independently of the deferred_pages list. It will therefore
call __flush_tlb_all(), which should flush the TLB, but even there, I
wonder if it should call clflush on the pages that had their flags
modified by __change_page_attr() ?

Some input about the best way to fix this (adding the modified pages to
the deferred list in __change_page_attr() or flushing all the TLBs, and
all caches, independently of the deferred pages list in
global_flush_tlb()) would be appreciated. If we add the pages that
simply had their flags modified to the df_list, would it be ok to issue
a __free_page on them ?

Thanks,

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> Trying to test my "Text Edit Lock" patches, I ran into a problem related
> to global_flush_tlb() not doing its job at updating the page flags when,
> it seems, the page has been recently accessed. Therefore, it can only be
> reproduced by doing a couple of iterations.
> 
> I run on a Pentium 4 with the following characteristics:
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 4
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 1
> cpu MHz         : 3000.201
> cache size      : 1024 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl cid xtpr
> bogomips        : 6007.49
> clflush size    : 64
> 
> config :
> CONFIG_X86_INVLPG=y (complete .config at the end)
> CONFIG_PARAVIRT=y/n
> 
> 
> (notice that pge and clflush features are present)
> 
> The kernel is configured in UP (I first saw the problem in SMT, but
> switched to UP and it is still there).
> 
> I provide a really crude hackish test module that shows the problematic
> behavior below.
> 
> Whenever I run the module using global_flush_tlb(), I get the following
> OOPS:
> 
> 
> [ 1112.512389] Init Attr RX
> [ 1112.521691] Init Attr RX end
> [ 1113.702965] Loop 0
> [ 1113.709171] Attr RWX 621545
> [ 1113.717662] Attr RX 621545
> [ 1113.725869] Attr RWX 432917
> [ 1113.734295] Attr RX 432917
> [ 1113.742460] Attr RWX 973425
> [ 1113.750885] Attr RX 973425
> [ 1113.759048] Attr RWX 453890
> [ 1113.767490] Attr RX 453890
> [ 1113.775653] Attr RWX 1035918
> [ 1113.784341] Attr RX 1035918
> [ 1113.792764] Attr RWX 1038276
> [ 1113.801449] Attr RX 1038276
> [ 1113.809902] Attr RWX 71394
> [ 1113.818067] Attr RX 71394
> [ 1113.825970] Attr RWX 88253
> [ 1113.834134] Attr RX 88253
> [ 1113.842039] Attr RWX 108029
> [ 1113.850505] Attr RX 108029
> [ 1113.858670] Attr RWX 767772
> [ 1113.867095] Attr RX 767772
> [ 1113.875259] Attr RWX 251394
> [ 1113.883694] Attr RX 251394
> [ 1113.891859] Attr RWX 817582
> [ 1113.900376] Attr RX 817582
> [ 1113.908540] Attr RWX 577819
> [ 1113.916965] Attr RX 577819
> [ 1113.925127] Attr RWX 56979
> [ 1113.933293] Attr RX 56979
> [ 1113.941195] Attr RWX 72953
> [ 1113.949361] Attr RX 72953
> [ 1113.957265] Attr RWX 94222
> [ 1113.965445] BUG: unable to handle kernel paging request at virtual address c3a1700e
> [ 1113.988291]  printing eip:
> [ 1113.996340] f885e0a6
> [ 1114.002835] *pde = 038c6163
> [ 1114.011145] *pte = 03a17163
> [ 1114.019455] Oops: 0003 [#1]
> [ 1114.027766] PREEMPT 
> [ 1114.034268] LTT NESTING LEVEL : 0 
> [ 1114.044402] Modules linked in: test_rodata ltt_statedump ltt_control sky2 skge rtc snd_hda_intel
> [ 1114.070679] CPU:    0
> [ 1114.070680] EIP:    0060:[<f885e0a6>]    Not tainted VLI
> [ 1114.070681] EFLAGS: 00010282   (2.6.22-rc4-mm2-testssmp #129)
> [ 1114.110395] EIP is at my_open+0xa6/0x124 [test_rodata]
> [ 1114.125711] eax: c3a00000   ebx: 0001700e   ecx: c39e4000   edx: 00000000
> [ 1114.145953] esi: 36f1700e   edi: f885e000   ebp: c39e5ebc   esp: c39e5ea0
> [ 1114.166195] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> [ 1114.183583] Process cat (pid: 4112, ti=c39e4000 task=c38ac1b0 task.ti=c39e4000)
> [ 1114.204862] Stack: f885e223 0001700e 00000000 0000f000 c31d3480 00000000 f885e000 c39e5ed8 
> [ 1114.229843]        c01a3c2a c39d2540 c368d4a8 c39d2540 00000000 c368d4a8 c39e5ef8 c016f5d9 
> [ 1114.254830]        c1c0eec0 c378ccfc c39e5eec c39d2540 00008000 c39e5f1c c39e5f0c c016f76b 
> [ 1114.279814] Call Trace:
> [ 1114.287620]  [<c01a3c2a>] proc_reg_open+0x42/0x68
> [ 1114.301655]  [<c016f5d9>] __dentry_open+0xe6/0x1e2
> [ 1114.315944]  [<c016f76b>] nameidata_to_filp+0x35/0x3f
> [ 1114.331008]  [<c016f7b0>] do_filp_open+0x3b/0x43
> [ 1114.344777]  [<c016f7fb>] do_sys_open+0x43/0x116
> [ 1114.358545]  [<c016f906>] sys_open+0x1c/0x1e
> [ 1114.371274]  [<c0104128>] syscall_call+0x7/0xb
> [ 1114.384524]  [<ffffe410>] 0xffffe410
> [ 1114.395178]  =======================
> [ 1114.405823] INFO: lockdep is turned off.
> [ 1114.417504] Code: 60 df 7c c0 b9 63 01 00 00 ba 01 00 00 00 e8 3f 7d 8b c7 0f ae f0 89 f6 e8 5c 80 8b c7 0f ae f0 89 f6 a1 88 eb 85 f8 0f b6 55 f0 <88> 14 03 0f ae f0 89 f6 89 d8 03 05 88 eb 85 f8 05 00 00 00 40 
> [ 1114.474329] EIP: [<f885e0a6>] my_open+0xa6/0x124 [test_rodata] SS:ESP 0068:c39e5ea0
> [ 1114.497187] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> [ 1114.520025] in_atomic():0, irqs_disabled():1
> [ 1114.532744] INFO: lockdep is turned off.
> [ 1114.544427] irq event stamp: 1894
> [ 1114.554293] hardirqs last  enabled at (1893): [<c03c892b>] _spin_unlock_irq+0x22/0x4e
> [ 1114.577666] hardirqs last disabled at (1894): [<c03c8584>] _spin_lock_irqsave+0x25/0x61
> [ 1114.601556] softirqs last  enabled at (1886): [<c0122988>] __do_softirq+0xe1/0x184
> [ 1114.624149] softirqs last disabled at (1875): [<c0122a9d>] do_softirq+0x72/0x77
> [ 1114.645969]  [<c01051bc>] dump_trace+0x1d5/0x204
> [ 1114.659737]  [<c0105205>] show_trace_log_lvl+0x1a/0x30
> [ 1114.675060]  [<c0105fc2>] show_trace+0x12/0x14
> [ 1114.688308]  [<c0105fd9>] dump_stack+0x15/0x17
> [ 1114.701557]  [<c0118dbf>] __might_sleep+0xcf/0xe1
> [ 1114.715584]  [<c013273c>] down_read+0x18/0x4b
> [ 1114.728574]  [<c011f4a0>] exit_mm+0x27/0xd1
> [ 1114.741045]  [<c0120bc1>] do_exit+0x10f/0x88f
> [ 1114.754035]  [<c01058ef>] do_trap+0x0/0x152
> [ 1114.766503]  [<c0115553>] do_page_fault+0x310/0x7ed
> [ 1114.781050]  [<c03c8bda>] error_code+0x6a/0x70
> [ 1114.794303]  [<f885e0a6>] my_open+0xa6/0x124 [test_rodata]
> [ 1114.810665]  [<c01a3c2a>] proc_reg_open+0x42/0x68
> [ 1114.824692]  [<c016f5d9>] __dentry_open+0xe6/0x1e2
> [ 1114.838979]  [<c016f76b>] nameidata_to_filp+0x35/0x3f
> [ 1114.854044]  [<c016f7b0>] do_filp_open+0x3b/0x43
> [ 1114.867811]  [<c016f7fb>] do_sys_open+0x43/0x116
> [ 1114.881579]  [<c016f906>] sys_open+0x1c/0x1e
> [ 1114.894308]  [<c0104128>] syscall_call+0x7/0xb
> [ 1114.907557]  [<ffffe410>] 0xffffe410
> [ 1114.918212]  =======================
> 
> This is clearly the memory write I am trying to do in the page of
> which I just changed the attributes to RWX.
> 
> If I remove the variable read before I change the flags, it starts
> working correctly (as far as I have tested...).
> 
> If I use my own my_local_tlb_flush() function (not SMP aware) instead of
> global_flush_tlb(), it works correctly.
> 
> I also tried just calling clflush on the modified page just after the
> global_flush_tlb(), and the problem was still there.
> 
> I therefore suspect that
> 
> include/asm-i386/tlbflush.h:
> #define __native_flush_tlb_global()                                     \
>         do {                                                            \
>                 unsigned int tmpreg, cr4, cr4_orig;                     \
>                                                                         \
>                 __asm__ __volatile__(                                   \
>                         "movl %%cr4, %2;  # turn off PGE     \n"        \
>                         "movl %2, %1;                        \n"        \
>                         "andl %3, %1;                        \n"        \
>                         "movl %1, %%cr4;                     \n"        \
>                         "movl %%cr3, %0;                     \n"        \
>                         "movl %0, %%cr3;  # flush TLB        \n"        \
>                         "movl %2, %%cr4;  # turn PGE back on \n"        \
>                         : "=&r" (tmpreg), "=&r" (cr4), "=&r" (cr4_orig) \
>                         : "i" (~X86_CR4_PGE)                            \
>                         : "memory");                                    \
>         } while (0)
> 
> is not doing its job correctly. The problem does not seem to be caused
> by PARAVIRT, because it is still buggy even if I disable the PARAVIRT
> config option.
> 
> This is as far as I went digging into this. Is "movl %0, %%cr3;  # flush
> TLB" really flushing the local TLB ? Should invlpg be used instead ?
> 
> If you have some advice, it would be welcome,
> 
> Thanks,
> 
> Mathieu
> 
> ---- BEGIN ---
> /*
>  * test-rodata.c
>  *
>  */
> 
> #include <linux/marker.h>
> #include <linux/module.h>
> #include <linux/proc_fs.h>
> #include <linux/sched.h>
> #include <linux/slab.h>
> #include <asm/timex.h>
> #include <asm/ptrace.h>
> #include <asm/cacheflush.h>
> #include <asm/tlbflush.h>
> 
> #define NR_LOOPS 5
> #define ASIZE (1024*1024)
> 
> volatile char value;
> char *array;
> 
> struct proc_dir_entry *pentry = NULL;
> 
> /*
>  * Flush local TLB with invlpg and cache for one address on P4 */
> static void my_local_tlb_flush(void *address)
> {
> 	mb();
> 	__native_flush_tlb_single(address);
> 	mb();
> 	asm volatile("clflush (%0)" :: "r" (address));
> 	mb();
> }
> 
> static int my_open(struct inode *inode, struct file *file)
> {
> 	unsigned int i,j;
> 
> 	for(i=0; i<NR_LOOPS; i++) {
> 		printk("Loop %u\n", i);
> 		for(j=0; j<ASIZE; j+=4096) {
> 			/* "random" offset */
> 			unsigned int offset = get_cycles() % ASIZE;
> 			/* preload in cache by reading */
> 			value = array[offset];
> 			/* Setting page for writing */
> 			printk("Attr RWX %u\n", offset);
> 			mb();
> 			change_page_attr(virt_to_page(&array[offset]), 1,
> 			__pgprot((_PAGE_KERNEL_EXEC | _PAGE_GLOBAL) | _PAGE_RW));
> 			mb();
> 			global_flush_tlb();
> 			mb();
> 			//FIX the issue my_local_tlb_flush(&array[offset]);
> 
> 			/* memory write */
> 			array[offset] = (char)j;
> 
> 			/* Setting the page read-only */
> 			mb();
> 			change_page_attr(virt_to_page(&array[offset]), 1,
> 			__pgprot((_PAGE_KERNEL_EXEC & ~_PAGE_RW) | _PAGE_GLOBAL));
> 			//FIX the issue my_local_tlb_flush(&array[offset]);
> 			mb();
> 			global_flush_tlb();
> 			mb();
> 			printk("Attr RX %u\n", offset);
> 		}
> 	}
> 
> 	return -EPERM;
> }
> 
> 
> static struct file_operations my_operations = {
> 	.open = my_open,
> };
> 
> int init_module(void)
> {
> 	pentry = create_proc_entry("testrodata", 0444, NULL);
> 	if (pentry)
> 		pentry->proc_fops = &my_operations;
> 	array = kzalloc(ASIZE, GFP_KERNEL);
> 	printk("Init Attr RX\n");
> 	change_page_attr(virt_to_page(array), ASIZE/4096,
> 	__pgprot((_PAGE_KERNEL_EXEC & ~_PAGE_RW) | _PAGE_GLOBAL));
> 	global_flush_tlb();
> 	printk("Init Attr RX end\n");
> 
> 
> 	return 0;
> }
> 
> void cleanup_module(void)
> {
> 	printk("Exit Attr RWX\n");
> 	change_page_attr(virt_to_page(array), ASIZE/4096,
> 	__pgprot((_PAGE_KERNEL) | _PAGE_GLOBAL));
> 	global_flush_tlb();
> 	printk("Exit Attr RWX end\n");
> 
> 	kfree(array);
> 	remove_proc_entry("testrodata", NULL);
> }
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Mathieu Desnoyers");
> MODULE_DESCRIPTION("rodata test");
> --- END ---
> 
> Complete .config :
> 
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.22-rc4-mm2
> # Tue Jun 19 09:50:24 2007
> #
> CONFIG_X86_32=y
> CONFIG_GENERIC_TIME=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_SEMAPHORE_SLEEPERS=y
> CONFIG_X86=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_QUICKLIST=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_DMI=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> 
> #
> # Code maturity level options
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> 
> #
> # General setup
> #
> CONFIG_LOCALVERSION="-testssmp"
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_SWAP=y
> CONFIG_SWAP_PREFETCH=y
> CONFIG_SYSVIPC=y
> # CONFIG_IPC_NS is not set
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_UTS_NS is not set
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=17
> # CONFIG_CONTAINER_DEBUG is not set
> CONFIG_SYSFS_DEPRECATED=y
> # CONFIG_CONTAINER_CPUACCT is not set
> CONFIG_RELAY=y
> # CONFIG_BLK_DEV_INITRD is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_EMBEDDED=y
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_PROC_SMAPS=y
> CONFIG_PROC_CLEAR_REFS=y
> CONFIG_PROC_PAGEMAP=y
> CONFIG_PROC_KPAGEMAP=y
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_KMOD=y
> CONFIG_BLOCK=y
> CONFIG_LBD=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_LSF=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_AS=y
> # CONFIG_DEFAULT_DEADLINE is not set
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="anticipatory"
> 
> #
> # Processor type and features
> #
> # CONFIG_TICK_ONESHOT is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> # CONFIG_SMP is not set
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_X86_SUMMIT is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_VISWS is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_ES7000 is not set
> CONFIG_PARAVIRT=y
> # CONFIG_XEN is not set
> # CONFIG_VMI is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MCORE2 is not set
> CONFIG_MPENTIUM4=y
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_XADD=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_MODEL=4
> # CONFIG_HPET_TIMER is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_BKL=y
> # CONFIG_X86_UP_APIC is not set
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_NONFATAL=y
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> # CONFIG_X86_REBOOTFIXUPS is not set
> # CONFIG_MICROCODE is not set
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_DELL_RBU is not set
> CONFIG_DCDBAS=m
> CONFIG_DMIID=y
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_VMSPLIT_3G=y
> # CONFIG_VMSPLIT_3G_OPT is not set
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_2G_OPT is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_RESOURCES_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_NR_QUICK=1
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_HIGHPTE is not set
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x100000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x100000
> CONFIG_COMPAT_VDSO=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management options (ACPI, APM)
> #
> CONFIG_PM=y
> # CONFIG_PM_LEGACY is not set
> # CONFIG_PM_DEBUG is not set
> # CONFIG_PM_SYSFS_DEPRECATED is not set
> # CONFIG_SOFTWARE_SUSPEND is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> CONFIG_ACPI_SLEEP_PROC_FS=y
> # CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_APM is not set
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> 
> #
> # CPU idle PM support
> #
> # CONFIG_CPU_IDLE is not set
> 
> #
> # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> # CONFIG_EISA is not set
> # CONFIG_MCA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
> 
> #
> # Executable file formats
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_BINFMT_MISC=y
> 
> #
> # Networking
> #
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> # CONFIG_PACKET_MMAP is not set
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> # CONFIG_XFRM_USER is not set
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_FIB_HASH=y
> # CONFIG_IP_PNP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE is not set
> # CONFIG_IP_MROUTE is not set
> # CONFIG_ARPD is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> # CONFIG_INET_TUNNEL is not set
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> # CONFIG_IP_VS is not set
> # CONFIG_IPV6 is not set
> # CONFIG_INET6_XFRM_TUNNEL is not set
> # CONFIG_INET6_TUNNEL is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> # CONFIG_NF_CONNTRACK_ENABLED is not set
> # CONFIG_NF_CONNTRACK is not set
> # CONFIG_NETFILTER_XTABLES is not set
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_IP_NF_QUEUE=y
> # CONFIG_IP_NF_IPTABLES is not set
> # CONFIG_IP_NF_ARPTABLES is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> 
> #
> # QoS and/or fair queueing
> #
> # CONFIG_NET_SCHED is not set
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> 
> #
> # Wireless
> #
> # CONFIG_CFG80211 is not set
> # CONFIG_WIRELESS_EXT is not set
> # CONFIG_MAC80211 is not set
> CONFIG_IEEE80211=m
> CONFIG_IEEE80211_DEBUG=y
> CONFIG_IEEE80211_CRYPT_WEP=m
> CONFIG_IEEE80211_CRYPT_CCMP=m
> # CONFIG_IEEE80211_CRYPT_TKIP is not set
> # CONFIG_IEEE80211_SOFTMAC is not set
> # CONFIG_RFKILL is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=m
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> # CONFIG_MTD is not set
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_SERIAL is not set
> # CONFIG_PARPORT_PC_FIFO is not set
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
> 
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_DEV_XD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_BLINK is not set
> # CONFIG_EEPROM_93CX6 is not set
> CONFIG_IDE=y
> CONFIG_IDE_MAX_HWIFS=4
> CONFIG_BLK_DEV_IDE=y
> 
> #
> # Please see Documentation/ide.txt for help/info on IDE drives
> #
> # CONFIG_BLK_DEV_IDE_SATA is not set
> # CONFIG_BLK_DEV_HD_IDE is not set
> CONFIG_BLK_DEV_IDEDISK=y
> CONFIG_IDEDISK_MULTI_MODE=y
> CONFIG_BLK_DEV_IDECD=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEFLOPPY is not set
> # CONFIG_BLK_DEV_IDESCSI is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> CONFIG_BLK_DEV_CMD640=y
> # CONFIG_BLK_DEV_CMD640_ENHANCED is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_SHARE_IRQ=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> CONFIG_BLK_DEV_GENERIC=y
> # CONFIG_BLK_DEV_OPTI621 is not set
> CONFIG_BLK_DEV_RZ1000=y
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> # CONFIG_BLK_DEV_IDEDMA_FORCED is not set
> # CONFIG_IDEDMA_ONLYDISK is not set
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CY82C693 is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_CS5535 is not set
> # CONFIG_BLK_DEV_HPT34X is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> CONFIG_BLK_DEV_PIIX=y
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
> # CONFIG_IDE_ARM is not set
> # CONFIG_IDE_CHIPSETS is not set
> CONFIG_BLK_DEV_IDEDMA=y
> # CONFIG_IDEDMA_IVB is not set
> # CONFIG_BLK_DEV_HD is not set
> 
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
> 
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> CONFIG_SCSI_LOWLEVEL=y
> # CONFIG_ISCSI_TCP is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_7000FASST is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AHA152X is not set
> # CONFIG_SCSI_AHA1542 is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> CONFIG_SCSI_DPT_I2O=m
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_IN2000 is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_DTC3280 is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> # CONFIG_SCSI_GENERIC_NCR5380 is not set
> # CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_PPA is not set
> # CONFIG_SCSI_IMM is not set
> # CONFIG_SCSI_NCR53C406A is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> # CONFIG_SCSI_PAS16 is not set
> # CONFIG_SCSI_PSI240I is not set
> # CONFIG_SCSI_QLOGIC_FAS is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_SEAGATE is not set
> # CONFIG_SCSI_SYM53C416 is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_T128 is not set
> # CONFIG_SCSI_U14_34F is not set
> # CONFIG_SCSI_ULTRASTOR is not set
> # CONFIG_SCSI_NSP32 is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_SRP is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_SVW is not set
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SX4 is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIL24 is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_LEGACY is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_QDI is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> # CONFIG_PATA_WINBOND_VLB is not set
> # CONFIG_PATA_PLATFORM is not set
> # CONFIG_CD_NO_IDESCSI is not set
> # CONFIG_MD is not set
> 
> #
> # Fusion MPT device support
> #
> # CONFIG_FUSION is not set
> # CONFIG_FUSION_SPI is not set
> # CONFIG_FUSION_FC is not set
> # CONFIG_FUSION_SAS is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> CONFIG_IEEE1394=y
> 
> #
> # Subsystem Options
> #
> # CONFIG_IEEE1394_VERBOSEDEBUG is not set
> 
> #
> # Controllers
> #
> 
> #
> # Texas Instruments PCILynx requires I2C
> #
> CONFIG_IEEE1394_OHCI1394=y
> 
> #
> # Protocols
> #
> # CONFIG_IEEE1394_VIDEO1394 is not set
> # CONFIG_IEEE1394_SBP2 is not set
> # CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
> # CONFIG_IEEE1394_ETH1394 is not set
> # CONFIG_IEEE1394_DV1394 is not set
> CONFIG_IEEE1394_RAWIO=y
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_MAC_EMUMOUSEBTN is not set
> CONFIG_NETDEVICES=y
> CONFIG_DUMMY=m
> # CONFIG_BONDING is not set
> # CONFIG_EQUALIZER is not set
> CONFIG_TUN=m
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_PHYLIB is not set
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_LANCE is not set
> # CONFIG_NET_VENDOR_SMC is not set
> # CONFIG_NET_VENDOR_RACAL is not set
> # CONFIG_NET_TULIP is not set
> # CONFIG_AT1700 is not set
> # CONFIG_DEPCA is not set
> # CONFIG_HP100 is not set
> # CONFIG_NET_ISA is not set
> CONFIG_NET_PCI=y
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_AC3200 is not set
> # CONFIG_APRICOT is not set
> # CONFIG_B44 is not set
> # CONFIG_FORCEDETH is not set
> # CONFIG_CS89x0 is not set
> # CONFIG_DGRS is not set
> # CONFIG_EEPRO100 is not set
> # CONFIG_E100 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_8139CP is not set
> CONFIG_8139TOO=y
> CONFIG_8139TOO_PIO=y
> # CONFIG_8139TOO_TUNE_TWISTER is not set
> # CONFIG_8139TOO_8129 is not set
> # CONFIG_8139_OLD_RX_RESET is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_TLAN is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> # CONFIG_NET_POCKET is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> CONFIG_SKGE=m
> CONFIG_SKY2=m
> # CONFIG_SK98LIN is not set
> # CONFIG_VIA_VELOCITY is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_QLA3XXX is not set
> # CONFIG_ATL1 is not set
> CONFIG_NETDEV_10000=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T3 is not set
> # CONFIG_IXGB is not set
> CONFIG_S2IO=m
> # CONFIG_S2IO_NAPI is not set
> # CONFIG_MYRI10GE is not set
> # CONFIG_NETXEN_NIC is not set
> # CONFIG_MLX4_CORE is not set
> # CONFIG_TR is not set
> 
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> # CONFIG_WLAN_80211 is not set
> # CONFIG_RTL818X is not set
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET_MII is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PLIP is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NET_FC is not set
> # CONFIG_SHAPER is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_TSDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_INPORT is not set
> # CONFIG_MOUSE_LOGIBM is not set
> # CONFIG_MOUSE_PC110PAD is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PARKBD is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> CONFIG_PRINTER=y
> # CONFIG_LP_CONSOLE is not set
> # CONFIG_PPDEV is not set
> # CONFIG_TIPAR is not set
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_WATCHDOG is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> CONFIG_RTC=m
> # CONFIG_GEN_RTC is not set
> # CONFIG_DTLK is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_DRM=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_I830 is not set
> # CONFIG_DRM_I915 is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_CS5535_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> # CONFIG_I2C is not set
> 
> #
> # SPI support
> #
> # CONFIG_SPI is not set
> # CONFIG_SPI_MASTER is not set
> # CONFIG_W1 is not set
> # CONFIG_POWER_SUPPLY is not set
> CONFIG_HWMON=y
> # CONFIG_HWMON_VID is not set
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_CORETEMP is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_SENSORS_APPLESMC is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> 
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_SM501 is not set
> 
> #
> # Multimedia devices
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> CONFIG_DAB=y
> # CONFIG_USB_DABUSB is not set
> 
> #
> # Graphics support
> #
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> 
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> # CONFIG_FB is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> # CONFIG_VIDEO_SELECT is not set
> # CONFIG_MDA_CONSOLE is not set
> CONFIG_DUMMY_CONSOLE=y
> 
> #
> # Sound
> #
> CONFIG_SOUND=y
> 
> #
> # Advanced Linux Sound Architecture
> #
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_SEQUENCER=y
> # CONFIG_SND_SEQ_DUMMY is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=y
> CONFIG_SND_PCM_OSS=y
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_SEQUENCER_OSS=y
> # CONFIG_SND_RTCTIMER is not set
> # CONFIG_SND_DYNAMIC_MINORS is not set
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> 
> #
> # Generic devices
> #
> CONFIG_SND_AC97_CODEC=y
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_VIRMIDI is not set
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_MTS64 is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
> # CONFIG_SND_PORTMAN2X4 is not set
> 
> #
> # ISA devices
> #
> # CONFIG_SND_ADLIB is not set
> # CONFIG_SND_AD1816A is not set
> # CONFIG_SND_AD1848 is not set
> # CONFIG_SND_ALS100 is not set
> # CONFIG_SND_AZT2320 is not set
> # CONFIG_SND_CMI8330 is not set
> # CONFIG_SND_CS4231 is not set
> # CONFIG_SND_CS4232 is not set
> # CONFIG_SND_CS4236 is not set
> # CONFIG_SND_DT019X is not set
> # CONFIG_SND_ES968 is not set
> # CONFIG_SND_ES1688 is not set
> # CONFIG_SND_ES18XX is not set
> # CONFIG_SND_GUSCLASSIC is not set
> # CONFIG_SND_GUSEXTREME is not set
> # CONFIG_SND_GUSMAX is not set
> # CONFIG_SND_INTERWAVE is not set
> # CONFIG_SND_INTERWAVE_STB is not set
> # CONFIG_SND_OPL3SA2 is not set
> # CONFIG_SND_OPTI92X_AD1848 is not set
> # CONFIG_SND_OPTI92X_CS4231 is not set
> # CONFIG_SND_OPTI93X is not set
> # CONFIG_SND_MIRO is not set
> # CONFIG_SND_SB8 is not set
> # CONFIG_SND_SB16 is not set
> # CONFIG_SND_SBAWE is not set
> # CONFIG_SND_SGALAXY is not set
> # CONFIG_SND_SSCAPE is not set
> # CONFIG_SND_WAVEFRONT is not set
> 
> #
> # PCI devices
> #
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> CONFIG_SND_INTEL8X0=y
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> # CONFIG_SND_AC97_POWER_SAVE is not set
> 
> #
> # USB devices
> #
> # CONFIG_SND_USB_AUDIO is not set
> # CONFIG_SND_USB_USX2Y is not set
> # CONFIG_SND_USB_CAIAQ is not set
> 
> #
> # System on Chip audio support
> #
> # CONFIG_SND_SOC is not set
> 
> #
> # SoC Audio support for SuperH
> #
> 
> #
> # Open Sound System
> #
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=y
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HID_DEBUG is not set
> # CONFIG_HIDRAW is not set
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=y
> # CONFIG_USB_HIDINPUT_POWERBOOK is not set
> # CONFIG_HID_FF is not set
> # CONFIG_USB_HIDDEV is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_SUSPEND is not set
> # CONFIG_USB_PERSIST is not set
> # CONFIG_USB_OTG is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_SPLIT_ISO is not set
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> # CONFIG_USB_EHCI_FSL is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> CONFIG_USB_UHCI_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> CONFIG_USB_PRINTER=y
> 
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
> 
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_DPCM is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> CONFIG_USB_MON=y
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_USS720 is not set
> 
> #
> # USB Serial Converter support
> #
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_AUERSWALD is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> CONFIG_USB_CYTHERM=m
> # CONFIG_USB_PHIDGET is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_GOTEMP is not set
> 
> #
> # USB DSL modem support
> #
> 
> #
> # USB Gadget Support
> #
> # CONFIG_USB_GADGET is not set
> # CONFIG_MMC is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> 
> #
> # Real Time Clock
> #
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> 
> #
> # on-CPU RTC drivers
> #
> 
> #
> # DMA Engine support
> #
> # CONFIG_DMA_ENGINE is not set
> 
> #
> # DMA Clients
> #
> 
> #
> # DMA Devices
> #
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=m
> CONFIG_KVM_INTEL=m
> CONFIG_KVM_AMD=m
> 
> #
> # Userspace I/O
> #
> # CONFIG_UIO is not set
> # CONFIG_LGUEST is not set
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_FS_XATTR=y
> # CONFIG_EXT3_FS_POSIX_ACL is not set
> # CONFIG_EXT3_FS_SECURITY is not set
> # CONFIG_EXT4DEV_FS is not set
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISER4_FS is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_FS_POSIX_ACL is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_ROMFS_FS is not set
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> CONFIG_DNOTIFY=y
> # CONFIG_AUTOFS_FS is not set
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_RAMFS=y
> # CONFIG_CONFIGFS_FS is not set
> 
> #
> # Layered filesystems
> #
> # CONFIG_UNION_FS is not set
> 
> #
> # Miscellaneous filesystems
> #
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> 
> #
> # Network File Systems
> #
> CONFIG_NFS_FS=y
> # CONFIG_NFS_V3 is not set
> # CONFIG_NFS_V4 is not set
> # CONFIG_NFS_DIRECTIO is not set
> CONFIG_NFSD=y
> # CONFIG_NFSD_V3 is not set
> CONFIG_NFSD_TCP=y
> CONFIG_LOCKD=y
> CONFIG_EXPORTFS=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> # CONFIG_SUNRPC_BIND34 is not set
> # CONFIG_RPCSEC_GSS_KRB5 is not set
> # CONFIG_RPCSEC_GSS_SPKM3 is not set
> # CONFIG_SMB_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> # CONFIG_9P_FS is not set
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> 
> #
> # Native Language Support
> #
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_UTF8 is not set
> 
> #
> # Distributed Lock Manager
> #
> # CONFIG_DLM is not set
> CONFIG_INSTRUMENTATION=y
> # CONFIG_PROFILING is not set
> # CONFIG_KPROBES is not set
> CONFIG_IMMEDIATE=y
> CONFIG_MARKERS=y
> CONFIG_LTT=y
> CONFIG_LTT_TRACER=y
> CONFIG_LTT_RELAY=y
> CONFIG_LTT_SERIALIZE=y
> CONFIG_LTT_ALIGNMENT=y
> # CONFIG_LTT_HEARTBEAT is not set
> CONFIG_LTT_TEST_TSC=y
> CONFIG_LTT_USERSPACE_GENERIC=y
> CONFIG_LTT_NETLINK_CONTROL=m
> CONFIG_LTT_STATEDUMP=m
> 
> #
> # Probes
> #
> CONFIG_LTT_PROBE_CORE=m
> CONFIG_LTT_PROBE_FS=m
> CONFIG_LTT_PROBE_KERNEL=m
> CONFIG_LTT_PROBE_ARCH=m
> CONFIG_LTT_PROBE_MM=m
> CONFIG_LTT_PROBE_NET=m
> CONFIG_LTT_PROBE_LIST=m
> CONFIG_LTT_PROBE_LOCKING=m
> # CONFIG_LTT_PROBE_STACK is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_UNUSED_SYMBOLS=y
> # CONFIG_PAGE_OWNER is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> CONFIG_DETECT_SOFTLOCKUP=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_SLAB is not set
> CONFIG_DEBUG_PREEMPT=y
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_LIST=y
> CONFIG_FRAME_POINTER=y
> CONFIG_UNWIND_INFO=y
> CONFIG_STACK_UNWIND=y
> # CONFIG_PROFILE_LIKELY is not set
> CONFIG_FORCED_INLINING=y
> # CONFIG_DEBUG_SYNCHRO_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_4KSTACKS is not set
> CONFIG_DOUBLEFAULT=y
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_ALGAPI=m
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_MANAGER=m
> # CONFIG_CRYPTO_HMAC is not set
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_MD4 is not set
> # CONFIG_CRYPTO_MD5 is not set
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_WP512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_GF128MUL is not set
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_CBC=m
> CONFIG_CRYPTO_PCBC=m
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> # CONFIG_CRYPTO_DES is not set
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_586 is not set
> # CONFIG_CRYPTO_SERPENT is not set
> CONFIG_CRYPTO_AES=m
> # CONFIG_CRYPTO_AES_586 is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> # CONFIG_CRYPTO_TEA is not set
> CONFIG_CRYPTO_ARC4=m
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> # CONFIG_CRYPTO_DEFLATE is not set
> CONFIG_CRYPTO_MICHAEL_MIC=m
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_TEST is not set
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_PADLOCK is not set
> CONFIG_CRYPTO_DEV_GEODE=m
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> # CONFIG_CRC_CCITT is not set
> # CONFIG_CRC16 is not set
> # CONFIG_CRC_ITU_T is not set
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=m
> CONFIG_AUDIT_GENERIC=y
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_KTIME_SCALAR=y
> 
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
