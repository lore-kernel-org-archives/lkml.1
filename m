Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXLPVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXLPVag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbXLPVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:30:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758755AbXLPVaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:30:25 -0500
Date: Sun, 16 Dec 2007 19:29:44 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] Reduce overhead of CONFIG_TIMER_STATS
Message-ID: <20071216212944.GA5128@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
	While looking at the pahole output for struct timer_list on
recent kernels I noticed that there is a 4 bytes padding on struct
timer_list that gets propagated to many structs on 64 bits
architectures:

[acme@doppio linux-2.6]$ pahole -C timer_list /tmp/tcp.o.before
struct timer_list {
        struct list_head      entry;          /*     0    16 */
        long unsigned int     expires;        /*    16     8 */
        void                  (*function)(long unsigned int); /* 24     8 */
        long unsigned int     data;           /*    32     8 */
        struct tvec_t_base_s *base;           /*    40     8 */
        void *                start_site;     /*    48     8 */
        char                  start_comm[16]; /*    56    16 */
        /* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
        int                   start_pid;      /*    72     4 */

        /* size: 80, cachelines: 2 */
        /* padding: 4 */
        /* last cacheline: 16 bytes */
};
[acme@doppio linux-2.6]$

	So the attached patch reduces the 4 bytes hole overhead of
CONFIG_TIMER_STATS on 64bit architectures by shrinking the field for
the process name by 4 bytes.

	Statistically this doesn't affects that many process names as
most are less than 12 bytes. As CONFIG_TIMER_STATS is enabled at least
on fedora kernels I think that we can, with this patch, still reap the
benefits of powertopping.

	Results, with codiff supressing per object files per struct
reports already showed in previous object file reports:

[acme@doppio linux-2.6]$ codiff --structs /tmp/vmlinux.before ../build/linux-2.6/doppio/vmlinux
/home/acme/git/linux-2.6/arch/x86/kernel/head64.c:
  struct timer_list    |   -8
  struct delayed_work  |   -8
  struct kioctx        |   -8
  struct hrtimer       |   -8
  struct signal_struct |   -8
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/init_task.c:
 5 structs changed

/home/acme/git/linux-2.6/init/main.c:
  struct tty_struct    |   -8
  struct tty_bufhead   |   -8
 7 structs changed

/home/acme/git/linux-2.6/init/version.c:
 5 structs changed

/home/acme/git/linux-2.6/init/do_mounts.c:
 7 structs changed

/home/acme/git/linux-2.6/init/do_mounts_initrd.c:
 5 structs changed

/home/acme/git/linux-2.6/init/do_mounts_md.c:
  struct request_queue |   -8
 6 structs changed

/home/acme/git/linux-2.6/init/initramfs.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/process_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/signal_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/traps_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/irq_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/ptrace_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/time_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/ioport_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/ldt_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/setup_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/i8259_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/sys_x86_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/i387_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/setup64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/bootflag.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/e820_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/reboot_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/quirks.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/pci-dma_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/pci-nommu_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/alternative.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/hpet.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/tsc_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/bugs_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/i8253.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/mtrr/main.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/mtrr/if.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/mtrr/state.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpu/perfctr-watchdog.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/acpi/boot.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/acpi/sleep_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/acpi/cstate.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/msr.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/cpuid.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/smp_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/smpboot_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/tsc_sync.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/apic_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/nmi_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/io_apic_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/mpparse_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/machine_kexec_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/crash.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/crash_dump_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/suspend_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/pci-gart_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/aperture_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/pci-calgary_64.c:
  struct iommu_table   |   -8
 6 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/tce_64.c:
 6 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/pci-swiotlb_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/kprobes_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/k8.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/audit_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/kernel/early-quirks.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/init_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/fault_64.c:
 7 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/ioremap_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/pageattr_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/mmap_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/hugetlbpage.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/numa_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/mm/srat_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/vdso/vma.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/sys_ia32.c:
  struct sock          |   -8
  struct net_device    |   +0
  struct neighbour     |   -8
  struct neigh_table   |  -16
 9 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/ia32_signal.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/tls32.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/ia32_binfmt.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/fpu32.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/ptrace32.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/syscall32.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/mmap32.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/ia32/ipc32.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/sched.c:
 6 structs changed

/home/acme/git/linux-2.6/kernel/fork.c:
 7 structs changed

/home/acme/git/linux-2.6/kernel/exec_domain.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/panic.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/printk.c:
 7 structs changed

/home/acme/git/linux-2.6/kernel/profile.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/exit.c:
 8 structs changed

/home/acme/git/linux-2.6/kernel/itimer.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/softirq.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/sysctl.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/capability.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/ptrace.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/timer.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/user.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/user_namespace.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/signal.c:
 7 structs changed

/home/acme/git/linux-2.6/kernel/sys.c:
 7 structs changed

/home/acme/git/linux-2.6/kernel/kmod.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/workqueue.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/pid.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/rcupdate.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/posix-timers.c:
  struct k_itimer      |   -8
 6 structs changed

/home/acme/git/linux-2.6/kernel/kthread.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/wait.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/posix-cpu-timers.c:
 6 structs changed

/home/acme/git/linux-2.6/kernel/mutex.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/hrtimer.c:
  struct hrtimer_sleeper               |   -8
 6 structs changed

/home/acme/git/linux-2.6/kernel/nsproxy.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/srcu.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/utsname.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/notifier.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time/timekeeping.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time/ntp.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time/clocksource.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time/timer_list.c:
  struct tick_sched    |   -8
 6 structs changed

/home/acme/git/linux-2.6/kernel/time/tick-common.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time/tick-broadcast.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time/tick-oneshot.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/time/tick-sched.c:
 6 structs changed

/home/acme/git/linux-2.6/kernel/time/timer_stats.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/futex.c:
 6 structs changed

/home/acme/git/linux-2.6/kernel/futex_compat.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/rtmutex.c:
 6 structs changed

/home/acme/git/linux-2.6/kernel/cpu.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/spinlock.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/uid16.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/module.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/kallsyms.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/power/main.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/power/pm.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/power/process.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/power/console.c:
 7 structs changed

/home/acme/git/linux-2.6/kernel/power/swsusp.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/power/disk.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/power/snapshot.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/power/swap.c:
 6 structs changed

/home/acme/git/linux-2.6/kernel/power/user.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/acct.c:
  struct acct_glbs     |   -8
 9 structs changed

/home/acme/git/linux-2.6/kernel/kexec.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/compat.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/stop_machine.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/audit.c:
 11 structs changed

/home/acme/git/linux-2.6/kernel/auditfilter.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/auditsc.c:
 7 structs changed

/home/acme/git/linux-2.6/kernel/audit_tree.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/kprobes.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/ksysfs.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/softlockup.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/handle.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/manage.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/spurious.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/resend.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/chip.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/devres.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/autoprobe.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/irq/proc.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/seccomp.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/relay.c:
  struct rchan_buf     |   +0
 6 structs changed

/home/acme/git/linux-2.6/kernel/utsname_sysctl.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/delayacct.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/taskstats.c:
 5 structs changed

/home/acme/git/linux-2.6/kernel/tsacct.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/bootmem.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/filemap.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/mempool.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/oom_kill.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/fadvise.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/page_alloc.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/page-writeback.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/pdflush.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/readahead.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/swap.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/truncate.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/vmscan.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/prio_tree.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/vmstat.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/backing-dev.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/page_isolation.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/fremap.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/highmem.c:
 7 structs changed

/home/acme/git/linux-2.6/mm/madvise.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/memory.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/mincore.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/mlock.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/mmap.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/mprotect.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/mremap.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/msync.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/rmap.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/vmalloc.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/bounce.c:
 7 structs changed

/home/acme/git/linux-2.6/mm/page_io.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/swap_state.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/swapfile.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/thrash.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/hugetlb.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/mempolicy.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/sparse.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/sparse-vmemmap.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/shmem.c:
 6 structs changed

/home/acme/git/linux-2.6/mm/shmem_acl.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/slub.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/filemap_xip.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/migrate.c:
 5 structs changed

/home/acme/git/linux-2.6/mm/allocpercpu.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/open.c:
 7 structs changed

/home/acme/git/linux-2.6/fs/read_write.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/file_table.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/super.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/char_dev.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/stat.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/exec.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/pipe.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/namei.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/fcntl.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/ioctl.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/readdir.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/select.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/fifo.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/locks.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/dcache.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/attr.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/bad_inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/file.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/namespace.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/aio.c:
  struct aio_timeout   |   -8
 6 structs changed

/home/acme/git/linux-2.6/fs/xattr.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/libfs.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/fs-writeback.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/pnode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/drop_caches.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/splice.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/sync.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/utimes.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/buffer.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/bio.c:
 7 structs changed

/home/acme/git/linux-2.6/fs/block_dev.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/direct-io.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/mpage.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/ioprio.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/inotify.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/inotify_user.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/eventpoll.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/anon_inodes.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/signalfd.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/eventfd.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/compat.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/compat_ioctl.c:
 12 structs changed

/home/acme/git/linux-2.6/fs/nfsctl.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/binfmt_misc.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/binfmt_elf.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/posix_acl.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/generic_acl.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/dquot.c:
 7 structs changed

/home/acme/git/linux-2.6/fs/quota.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/dnotify.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/mmu.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/task_mmu.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/root.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/base.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/generic.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/array.c:
 7 structs changed

/home/acme/git/linux-2.6/fs/proc/proc_tty.c:
 4 structs changed

/home/acme/git/linux-2.6/fs/proc/proc_misc.c:
 8 structs changed

/home/acme/git/linux-2.6/fs/proc/proc_sysctl.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/proc_net.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/kcore.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/vmcore.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/proc/kmsg.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/partitions/check.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/amiga.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/mac.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/msdos.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/osf.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/sgi.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/sun.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/efi.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/partitions/karma.c:
 6 structs changed

/home/acme/git/linux-2.6/fs/sysfs/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/sysfs/file.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/sysfs/mount.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/devpts/inode.c:
 7 structs changed

/home/acme/git/linux-2.6/fs/dcookies.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/ramfs/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/ramfs/file-mmu.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/hugetlbfs/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/namei.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/dir.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/util.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/rock.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/export.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/joliet.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/isofs/compress.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/debugfs/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/fs/debugfs/file.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/compat.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/util.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/msgutil.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/msg.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/sem.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/shm.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/ipc_sysctl.c:
 5 structs changed

/home/acme/git/linux-2.6/ipc/mqueue.c:
 9 structs changed

/home/acme/git/linux-2.6/ipc/compat_mq.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/key.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/keyring.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/keyctl.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/permission.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/process_keys.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/request_key.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/request_key_auth.c:
 5 structs changed

/home/acme/git/linux-2.6/security/keys/proc.c:
 5 structs changed

/home/acme/git/linux-2.6/security/security.c:
 5 structs changed

/home/acme/git/linux-2.6/security/dummy.c:
 9 structs changed

/home/acme/git/linux-2.6/security/inode.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/avc.c:
  struct unix_sock     |   -8
  struct inet_sock     |   -8
 11 structs changed

/home/acme/git/linux-2.6/security/selinux/hooks.c:
 11 structs changed

/home/acme/git/linux-2.6/security/selinux/selinuxfs.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/netlink.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/nlmsgtab.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/netif.c:
 6 structs changed

/home/acme/git/linux-2.6/security/selinux/exports.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/xfrm.c:
  struct xfrm_policy   |   -8
  struct xfrm_state    |  -16
  struct inet6_ifaddr  |   -8
  struct inet6_dev     |  -24
  struct ifmcaddr6     |   -8
 14 structs changed

/home/acme/git/linux-2.6/security/selinux/netlabel.c:
 9 structs changed

/home/acme/git/linux-2.6/security/selinux/ss/ebitmap.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/ss/sidtab.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/ss/avtab.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/ss/policydb.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/ss/services.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/ss/conditional.c:
 5 structs changed

/home/acme/git/linux-2.6/security/selinux/ss/mls.c:
 5 structs changed

/home/acme/git/linux-2.6/security/commoncap.c:
 5 structs changed

/home/acme/git/linux-2.6/security/capability.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/api.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/cipher.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/digest.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/compress.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/algapi.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/scatterwalk.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/proc.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/hash.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/cryptomgr.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/hmac.c:
 5 structs changed

/home/acme/git/linux-2.6/crypto/sha1_generic.c:
 5 structs changed

/home/acme/git/linux-2.6/block/elevator.c:
 7 structs changed

/home/acme/git/linux-2.6/block/ll_rw_blk.c:
 7 structs changed

/home/acme/git/linux-2.6/block/ioctl.c:
 7 structs changed

/home/acme/git/linux-2.6/block/genhd.c:
 6 structs changed

/home/acme/git/linux-2.6/block/scsi_ioctl.c:
 6 structs changed

/home/acme/git/linux-2.6/block/bsg.c:
 6 structs changed

/home/acme/git/linux-2.6/block/noop-iosched.c:
 6 structs changed

/home/acme/git/linux-2.6/block/as-iosched.c:
  struct as_data       |   -8
 7 structs changed

/home/acme/git/linux-2.6/block/deadline-iosched.c:
 6 structs changed

/home/acme/git/linux-2.6/block/cfq-iosched.c:
  struct cfq_data      |  -16
 7 structs changed

/home/acme/git/linux-2.6/block/blktrace.c:
 7 structs changed

/home/acme/git/linux-2.6/block/compat_ioctl.c:
 7 structs changed

/home/acme/git/linux-2.6/lib/bug.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/ioremap.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/kobject_uevent.c:
 9 structs changed

/home/acme/git/linux-2.6/lib/prio_tree.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/rwsem-spinlock.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/lib/delay_64.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/bust_spinlocks.c:
 7 structs changed

/home/acme/git/linux-2.6/lib/iomap.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/devres.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/kernel_lock.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/swiotlb.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/access.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/bus.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/probe.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/remove.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pci.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/quirks.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pci-driver.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/search.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pci-sysfs.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/rom.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/setup-res.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/proc.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pcie/portdrv_core.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pcie/portdrv_pci.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pcie/portdrv_bus.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pcie/aer/aerdrv_errprint.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pcie/aer/aerdrv_core.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pcie/aer/aerdrv.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pcie/aer/aerdrv_acpi.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/hotplug.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/hotplug/pci_hotplug_core.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/hotplug/acpi_pcihp.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/msi.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/htirq.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/setup-bus.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pci/pci-acpi.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/video/fb_notify.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/video/fbmem.c:
  struct fb_info       |   -8
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/fbmon.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/fbcmap.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/fbsysfs.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/modedb.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/fbcvt.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/video/console/dummycon.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/video/console/vgacon.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/video/console/fbcon.c:
  struct fbcon_ops     |   -8
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/console/bitblit.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/console/softcursor.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/console/tileblit.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/console/fbcon_rotate.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/console/fbcon_cw.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/console/fbcon_ud.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/console/fbcon_ccw.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/video/backlight/backlight.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/cfbfillrect.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/cfbcopyarea.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/cfbimgblt.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/fb_defio.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/video/vesafb.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/acpi/osl.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/namespace/nsinit.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/sleep/main.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/sleep/proc.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/bus.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/ec.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/pci_root.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/pci_link.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/pci_irq.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/pci_bind.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/processor_core.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/processor_throttling.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/processor_idle.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/acpi/thermal.c:
  struct acpi_thermal |   -8
 2 structs changed

/home/acme/git/linux-2.6/drivers/acpi/event.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pnp/core.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pnp/resource.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pnp/pnpacpi/rsparser.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/mem.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/random.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/tty_io.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/n_tty.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/tty_ioctl.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/pty.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/vt_ioctl.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/vc_screen.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/consolemap.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/selection.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/keyboard.c:
  struct input_dev     |   -8
 8 structs changed

/home/acme/git/linux-2.6/drivers/char/vt.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/tty_audit.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/sysrq.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/char/rtc.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/hpet.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/nvram.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/hw_random/core.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/backend.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/frontend.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/generic.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/isoch.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/compat_ioctl.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/amd64-agp.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/intel-agp.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/sis-agp.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/char/agp/via-agp.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/connector/cn_queue.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/connector/connector.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/connector/cn_proc.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/serial/serial_core.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/serial/8250.c:
  struct uart_8250_port |   -8
 8 structs changed

/home/acme/git/linux-2.6/drivers/serial/8250_pnp.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/serial/8250_pci.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/serial/8250_early.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/base/dd.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/base/platform.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/base/cpu.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/base/power/trace.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/base/dma-mapping.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/base/dmapool.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/base/firmware_class.c:
  struct firmware_priv |   -8
 6 structs changed

/home/acme/git/linux-2.6/drivers/base/node.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/base/topology.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/block/rd.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/net/Space.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/net/loopback.c:
 9 structs changed

/home/acme/git/linux-2.6/drivers/macintosh/mac_hid.c:
 8 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/cs.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/cistpl.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/rsrc_mgr.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/socket_sysfs.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/cardbus.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/ds.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/pcmcia_resource.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/rsrc_nonstatic.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/pcmcia/yenta_socket.c:
  struct yenta_socket  |   -8
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/usb.c:
  struct usb_device    |   -8
  struct usb_hcd       |   -8
 7 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/hub.c:
  struct usb_hub       |   -8
 8 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/hcd.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/urb.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/message.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/driver.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/config.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/file.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/buffer.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/sysfs.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/endpoint.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/devio.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/notify.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/generic.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/quirks.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/hcd-pci.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/inode.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/core/devices.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/mon/mon_main.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/mon/mon_stat.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/mon/mon_text.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/mon/mon_bin.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/usb/mon/mon_dma.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/usb/host/pci-quirks.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/input/serio/serio.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/input/serio/i8042.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/input/serio/serport.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/input/serio/libps2.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/input/input.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/ff-core.c:
 2 structs changed

/home/acme/git/linux-2.6/drivers/input/ff-memless.c:
  struct ml_device  |   -8
 3 structs changed

/home/acme/git/linux-2.6/drivers/input/mousedev.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/evdev.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/keyboard/atkbd.c:
  struct atkbd         |   -8
 7 structs changed

/home/acme/git/linux-2.6/drivers/input/mouse/psmouse-base.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/mouse/synaptics.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/mouse/alps.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/mouse/logips2pp.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/mouse/lifebook.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/input/mouse/trackpoint.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/i2c/i2c-boardinfo.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/md/md.c:
  struct mddev_s       |   -8
 7 structs changed

/home/acme/git/linux-2.6/drivers/md/bitmap.c:
 7 structs changed

/home/acme/git/linux-2.6/drivers/cpufreq/cpufreq.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/cpufreq/cpufreq_userspace.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/cpuidle/cpuidle.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/firmware/dmi_scan.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/clocksource/acpi_pm.c:
 5 structs changed

/home/acme/git/linux-2.6/drivers/hid/hid-core.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/hid/hid-input.c:
 2 structs changed

/home/acme/git/linux-2.6/drivers/hid/hid-debug.c:
 2 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hid-core.c:
  struct usbhid_device |   -8
 8 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hiddev.c:
 8 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hid-pidff.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hid-lgff.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hid-plff.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hid-tmff.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hid-zpff.c:
 6 structs changed

/home/acme/git/linux-2.6/drivers/hid/usbhid/hid-ff.c:
 6 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/i386.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/direct.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/fixup.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/init.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/acpi.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/legacy.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/irq.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/common.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/early.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/mmconfig_64.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/mmconfig-shared.c:
 5 structs changed

/home/acme/git/linux-2.6/arch/x86/pci/k8-bus_64.c:
 5 structs changed

/home/acme/git/linux-2.6/net/socket.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/sock.c:
 14 structs changed

/home/acme/git/linux-2.6/net/core/request_sock.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/skbuff.c:
 14 structs changed

/home/acme/git/linux-2.6/net/core/iovec.c:
 5 structs changed

/home/acme/git/linux-2.6/net/core/datagram.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/stream.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/scm.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/gen_stats.c:
 5 structs changed

/home/acme/git/linux-2.6/net/core/gen_estimator.c:
  struct gen_estimator_head |   -8
 6 structs changed

/home/acme/git/linux-2.6/net/core/net_namespace.c:
 5 structs changed

/home/acme/git/linux-2.6/net/core/sysctl_net_core.c:
 14 structs changed

/home/acme/git/linux-2.6/net/core/dev.c:
  struct netpoll_info  |   -8
 10 structs changed

/home/acme/git/linux-2.6/net/core/ethtool.c:
 6 structs changed

/home/acme/git/linux-2.6/net/core/dev_mcast.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/dst.c:
 8 structs changed

/home/acme/git/linux-2.6/net/core/netevent.c:
 5 structs changed

/home/acme/git/linux-2.6/net/core/neighbour.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/rtnetlink.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/utils.c:
 5 structs changed

/home/acme/git/linux-2.6/net/core/link_watch.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/filter.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/flow.c:
 5 structs changed

/home/acme/git/linux-2.6/net/core/net-sysfs.c:
 9 structs changed

/home/acme/git/linux-2.6/net/core/netpoll.c:
  struct in_device     |  -16
 11 structs changed

/home/acme/git/linux-2.6/net/core/fib_rules.c:
 9 structs changed

/home/acme/git/linux-2.6/net/compat.c:
 9 structs changed

/home/acme/git/linux-2.6/net/llc/llc_core.c:
 6 structs changed

/home/acme/git/linux-2.6/net/llc/llc_input.c:
 6 structs changed

/home/acme/git/linux-2.6/net/llc/llc_output.c:
 6 structs changed

/home/acme/git/linux-2.6/net/ethernet/eth.c:
 9 structs changed

/home/acme/git/linux-2.6/net/ethernet/pe2.c:
 6 structs changed

/home/acme/git/linux-2.6/net/802/sysctl_net_802.c:
 5 structs changed

/home/acme/git/linux-2.6/net/802/p8022.c:
 6 structs changed

/home/acme/git/linux-2.6/net/802/psnap.c:
 6 structs changed

/home/acme/git/linux-2.6/net/802/tr.c:
 8 structs changed

/home/acme/git/linux-2.6/net/802/fc.c:
 8 structs changed

/home/acme/git/linux-2.6/net/802/fddi.c:
 9 structs changed

/home/acme/git/linux-2.6/net/sched/sch_generic.c:
 6 structs changed

/home/acme/git/linux-2.6/net/sched/sch_api.c:
  struct qdisc_watchdog |   -8
 7 structs changed

/home/acme/git/linux-2.6/net/sched/sch_blackhole.c:
 6 structs changed

/home/acme/git/linux-2.6/net/sched/cls_api.c:
 6 structs changed

/home/acme/git/linux-2.6/net/sched/act_api.c:
 6 structs changed

/home/acme/git/linux-2.6/net/sched/act_police.c:
 6 structs changed

/home/acme/git/linux-2.6/net/sched/sch_fifo.c:
 6 structs changed

/home/acme/git/linux-2.6/net/sched/ematch.c:
 6 structs changed

/home/acme/git/linux-2.6/net/netlink/af_netlink.c:
  struct netlink_sock  |   -8
 10 structs changed

/home/acme/git/linux-2.6/net/netlink/attr.c:
 6 structs changed

/home/acme/git/linux-2.6/net/netlink/genetlink.c:
 9 structs changed

/home/acme/git/linux-2.6/net/netfilter/core.c:
 10 structs changed

/home/acme/git/linux-2.6/net/netfilter/nf_log.c:
 9 structs changed

/home/acme/git/linux-2.6/net/netfilter/nf_queue.c:
 9 structs changed

/home/acme/git/linux-2.6/net/netfilter/nf_sockopt.c:
 9 structs changed

/home/acme/git/linux-2.6/net/ipv4/route.c:
  struct ip_mc_list    |   -8
 16 structs changed

/home/acme/git/linux-2.6/net/ipv4/inetpeer.c:
 5 structs changed

/home/acme/git/linux-2.6/net/ipv4/protocol.c:
 9 structs changed

/home/acme/git/linux-2.6/net/ipv4/ip_input.c:
 16 structs changed

/home/acme/git/linux-2.6/net/ipv4/ip_fragment.c:
  struct inet_frag_queue |   -8
  struct inet_frags      |   -8
  struct ipq             |   -8
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/ip_forward.c:
 14 structs changed

/home/acme/git/linux-2.6/net/ipv4/ip_options.c:
 9 structs changed

/home/acme/git/linux-2.6/net/ipv4/ip_output.c:
 15 structs changed

/home/acme/git/linux-2.6/net/ipv4/ip_sockglue.c:
  struct inet_connection_sock |  -24
 18 structs changed

/home/acme/git/linux-2.6/net/ipv4/inet_hashtables.c:
  struct inet_timewait_death_row |  -16
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/inet_timewait_sock.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/inet_connection_sock.c:
 16 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp.c:
  struct tcp_sock                |  -24
 18 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp_input.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp_output.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp_timer.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp_ipv4.c:
 18 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp_minisocks.c:
 18 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp_cong.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/datagram.c:
 10 structs changed

/home/acme/git/linux-2.6/net/ipv4/raw.c:
  struct raw_sock      |   -8
 16 structs changed

/home/acme/git/linux-2.6/net/ipv4/udp.c:
  struct udp_sock      |   -8
 16 structs changed

/home/acme/git/linux-2.6/net/ipv4/udplite.c:
 11 structs changed

/home/acme/git/linux-2.6/net/ipv4/arp.c:
 10 structs changed

/home/acme/git/linux-2.6/net/ipv4/icmp.c:
 11 structs changed

/home/acme/git/linux-2.6/net/ipv4/devinet.c:
 11 structs changed

/home/acme/git/linux-2.6/net/ipv4/af_inet.c:
 17 structs changed

/home/acme/git/linux-2.6/net/ipv4/igmp.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/sysctl_net_ipv4.c:
 6 structs changed

/home/acme/git/linux-2.6/net/ipv4/fib_frontend.c:
 10 structs changed

/home/acme/git/linux-2.6/net/ipv4/fib_semantics.c:
 10 structs changed

/home/acme/git/linux-2.6/net/ipv4/inet_fragment.c:
 7 structs changed

/home/acme/git/linux-2.6/net/ipv4/fib_hash.c:
 10 structs changed

/home/acme/git/linux-2.6/net/ipv4/proc.c:
 11 structs changed

/home/acme/git/linux-2.6/net/ipv4/fib_rules.c:
 10 structs changed

/home/acme/git/linux-2.6/net/ipv4/ipmr.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/syncookies.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/netfilter.c:
 14 structs changed

/home/acme/git/linux-2.6/net/ipv4/tcp_cubic.c:
 12 structs changed

/home/acme/git/linux-2.6/net/ipv4/cipso_ipv4.c:
 11 structs changed

/home/acme/git/linux-2.6/net/ipv4/xfrm4_policy.c:
 15 structs changed

/home/acme/git/linux-2.6/net/ipv4/xfrm4_state.c:
 14 structs changed

/home/acme/git/linux-2.6/net/ipv4/xfrm4_input.c:
 16 structs changed

/home/acme/git/linux-2.6/net/ipv4/xfrm4_output.c:
 14 structs changed

/home/acme/git/linux-2.6/net/xfrm/xfrm_policy.c:
 14 structs changed

/home/acme/git/linux-2.6/net/xfrm/xfrm_state.c:
 14 structs changed

/home/acme/git/linux-2.6/net/xfrm/xfrm_hash.c:
 5 structs changed

/home/acme/git/linux-2.6/net/xfrm/xfrm_input.c:
 14 structs changed

/home/acme/git/linux-2.6/net/xfrm/xfrm_output.c:
 14 structs changed

/home/acme/git/linux-2.6/net/xfrm/xfrm_algo.c:
 14 structs changed

/home/acme/git/linux-2.6/net/xfrm/xfrm_user.c:
 14 structs changed

/home/acme/git/linux-2.6/net/unix/af_unix.c:
 10 structs changed

/home/acme/git/linux-2.6/net/unix/garbage.c:
 10 structs changed

/home/acme/git/linux-2.6/net/unix/sysctl_net_unix.c:
 5 structs changed

/home/acme/git/linux-2.6/net/ipv6/addrconf_core.c:
 9 structs changed

/home/acme/git/linux-2.6/net/ipv6/exthdrs_core.c:
 9 structs changed

/home/acme/git/linux-2.6/net/ipv6/inet6_hashtables.c:
 12 structs changed

/home/acme/git/linux-2.6/net/packet/af_packet.c:
  struct packet_sock   |   -8
 10 structs changed

/home/acme/git/linux-2.6/net/wireless/wext.c:
 6 structs changed

/home/acme/git/linux-2.6/net/netlabel/netlabel_user.c:
 11 structs changed

/home/acme/git/linux-2.6/net/netlabel/netlabel_kapi.c:
 9 structs changed

/home/acme/git/linux-2.6/net/netlabel/netlabel_domainhash.c:
 5 structs changed

/home/acme/git/linux-2.6/net/netlabel/netlabel_mgmt.c:
 9 structs changed

/home/acme/git/linux-2.6/net/netlabel/netlabel_unlabeled.c:
 9 structs changed

/home/acme/git/linux-2.6/net/netlabel/netlabel_cipso_v4.c:
 9 structs changed

/home/acme/git/linux-2.6/net/sysctl_net.c:
 5 structs changed

/home/acme/git/linux-2.6/lib/semaphore-sleepers.c:
 5 structs changed

--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="TIMER_STATS_footprint_reduced.patch"

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 7a9398e..7b29bc6 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -121,7 +121,7 @@ struct hrtimer {
 #endif
 #ifdef CONFIG_TIMER_STATS
 	void				*start_site;
-	char				start_comm[16];
+	char				start_comm[12];
 	int				start_pid;
 #endif
 };
diff --git a/include/linux/timer.h b/include/linux/timer.h
index 78cf899..2556358 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -17,7 +17,7 @@ struct timer_list {
 	struct tvec_t_base_s *base;
 #ifdef CONFIG_TIMER_STATS
 	void *start_site;
-	char start_comm[16];
+	char start_comm[12];
 	int start_pid;
 #endif
 };
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e65dd0b..2349c2b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -632,7 +632,7 @@ void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
 		return;
 
 	timer->start_site = addr;
-	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	memcpy(timer->start_comm, current->comm, sizeof(timer->start_comm));
 	timer->start_pid = current->pid;
 }
 #endif
@@ -1006,7 +1006,7 @@ void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
-	memset(timer->start_comm, 0, TASK_COMM_LEN);
+	memset(timer->start_comm, 0, sizeof(timer->start_comm));
 #endif
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 12c5f4c..2259b55 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -50,7 +50,7 @@ static void
 print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
 {
 #ifdef CONFIG_TIMER_STATS
-	char tmp[TASK_COMM_LEN + 1];
+	char tmp[sizeof(timer->start_comm) + 1];
 #endif
 	SEQ_printf(m, " #%d: ", idx);
 	print_name_offset(m, timer);
@@ -60,8 +60,8 @@ print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
 #ifdef CONFIG_TIMER_STATS
 	SEQ_printf(m, ", ");
 	print_name_offset(m, timer->start_site);
-	memcpy(tmp, timer->start_comm, TASK_COMM_LEN);
-	tmp[TASK_COMM_LEN] = 0;
+	memcpy(tmp, timer->start_comm, sizeof(timer->start_comm));
+	tmp[sizeof(timer->start_comm)] = 0;
 	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
 #endif
 	SEQ_printf(m, "\n");
diff --git a/kernel/timer.c b/kernel/timer.c
index a05817c..c7705dd 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -303,7 +303,7 @@ void __timer_stats_timer_set_start_info(struct timer_list *timer, void *addr)
 		return;
 
 	timer->start_site = addr;
-	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	memcpy(timer->start_comm, current->comm, sizeof(timer->start_comm));
 	timer->start_pid = current->pid;
 }
 
@@ -336,7 +336,7 @@ void fastcall init_timer(struct timer_list *timer)
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
-	memset(timer->start_comm, 0, TASK_COMM_LEN);
+	memset(timer->start_comm, 0, sizeof(timer->start_comm));
 #endif
 }
 EXPORT_SYMBOL(init_timer);

--rS8CxjVDS/+yyDmU--
