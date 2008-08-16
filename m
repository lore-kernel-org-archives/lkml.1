Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYHPKUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYHPKUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHPKTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:19:54 -0400
Received: from server03.ke-net.com ([84.19.168.8]:39091 "EHLO
	server03.ke-net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYHPKTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:19:52 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Aug 2008 06:19:51 EDT
Subject: SCHED_FIFO and SCHED_RR broken by cfs
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain
Date: Sat, 16 Aug 2008 11:55:52 +0200
Message-Id: <1218880552.11912.9.camel@matrix>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel hackers,

it seems that the new completely fair scheduler breaks the SCHED_RR and
SCHED_FIFO realtime scheduler.

In my opinion a high priority real time user process with SCHED_FIFO
should be only interrupted by the kernel or a process with an higher
priority. So a user process running under SCHED_FIFO and priority 99
should never be interrupted by any other process.  This was true under
kernel 2.6.20. 

On my pentium/celeron III/400 MHz system with kernel 2.6.20 a busy loop
using the "time stamp counter" of the x86 cpu for delaying, this was
very accurate. The max. jitter of the delaying was about 5 microseconds.

With the new kernel 2.6.26 the jitter is about 51177 microseconds or in
other words 51 milliseconds or more the 10000 times greater than kernel
2.6.20. This huge latency is far away from realtime.

Below are the results of the attached test program. Maybe somebody else
can confirm this results. All measurements was done with no other
process running, only the busybox 1.11.1 shell and the init process was
there.

kernel 2.6.20
-------------

reported cpufreq: 398816000 Hz

time chrt -f 99 /tmp/a.out      time chrt -o 0 /tmp/a.out
 average: 0                      average: 0
 min. jitter: 0 usec             min. jitter: 0 usec
 max. jitter: 5 usec             max. jitter: 113 usec
real    0m 5.02s                real    0m 5.02s
user    0m 5.00s                user    0m 5.01s
sys     0m 0.01s                sys     0m 0.01s

kernel 2.6.26
-------------

reported cpufreq: 400000000 Hz

time chrt -f 99 /tmp/a.out      time chrt -o 0 /tmp/a.out
 average: 189                    average: 1
 min. jitter: 0 use              min. jitter: 0 usec
 max. jitter: 51177 us           max. jitter: 368 usec
real    0m 5.21s                real    0m 5.03s
user    0m 4.99s                user    0m 5.00s
sys     0m 0.01s                sys     0m 0.02s

I tried the test also on a pentium-m 2,267 GHz notebook with the kernel
2.6.26 and 2.6.27-rc3-git2 and the behavior is the same. The process
started the SCHED_OTHER has less max. jitter than the process started
with SCHED_FIFO.

Below the attached test program and an extract of my kernel 2.6.26
configuration.

<---test program starts here

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

#define	USECS	1000000ULL

typedef unsigned long long	u64;

static u64	cpufreq;

static inline void getCPUfreq(void)
{
	FILE *	file;
	char	buffer[32];

	file=popen("cat /proc/cpuinfo|grep 'cpu MHz'|cut -f2 -d':'","r");

	if (file==NULL) {
		fprintf(stderr,"get cpuinfo failed\n");
		abort();
	}
	if (fgets(buffer,sizeof(buffer),file)==NULL) {
		fprintf(stderr,"read cpuinfo data failed\n");
		abort();
	}
	fclose(file);

	cpufreq=atof(buffer)*USECS;

	printf("cpufreq: %llu Hz\n",cpufreq);
}

static inline u64 readtsc(void)
{
	u64 val;
	
	__asm__ __volatile__ ("rdtsc" : "=&A" (val));
	
	return val;
}

static inline int usleep(long usec)
{
	u64	start;
	u64	end;

	start=readtsc();

	for(end=(cpufreq*usec)/USECS;(readtsc()-start)<=end;);

	return 0;
}

static inline struct timeval subtimeval(const struct timeval *t1,const
struct timeval *t2)
{
	struct timeval	t;

	if (t1->tv_usec<t2->tv_usec) {
		t.tv_sec =t1->tv_sec -t2->tv_sec-1;
		t.tv_usec=t1->tv_usec-t2->tv_usec+USECS;
	}
	else {
		t.tv_sec =t1->tv_sec -t2->tv_sec;
		t.tv_usec=t1->tv_usec-t2->tv_usec;
	}
	return t;
}

int main(void)
{
	long		elapsed,usec,jitter;
	long		min_jitter=LONG_MAX,max_jitter=0;
	struct timeval	overhead,tv1,tv2,delta;
	unsigned long	cnt=0,sum=0;

	getCPUfreq();

	/* calculate gettimeofday overhead */
	gettimeofday(&tv1,NULL);
	for(cnt=0;cnt<9998;cnt++)
		gettimeofday(&overhead,NULL);
	gettimeofday(&tv2,NULL);

	overhead=subtimeval(&tv2,&tv1);
	overhead.tv_usec/=cnt/2+1;
	overhead.tv_sec=0;
	printf("gettimeofday() call overhead:%ld\n",overhead.tv_usec);

	/* measure busywait usleep() function */
	for(cnt=1;cnt<=1000;cnt++) {
		usec=cnt*10;

		gettimeofday(&tv1,NULL);
		usleep(usec);
		gettimeofday(&tv2,NULL);

		delta=subtimeval(&tv2,&tv1);
		delta=subtimeval(&delta,&overhead);	/* subtract gettimeofday call
overhead */

		elapsed=delta.tv_sec*USECS+delta.tv_usec;

		if (elapsed<usec) {
			/* usleep early returned? */
			if (elapsed+overhead.tv_usec<usec) {
				fprintf(stderr,"invalid timing - usec: %ld elapsed: %ld
\n",usec,elapsed);
				abort();
			}
			/* fix if overhead measurement was not accurate enough */ 
			elapsed=usec;
		}
		jitter=elapsed-usec;

		if (jitter>max_jitter)
			max_jitter=jitter;
		if (jitter<min_jitter)
			min_jitter=jitter;

		sum+=jitter;
	}
	printf("result:\n average:%lu usec\n min. jitter:%ld usec\n max.
jitter:%ld usec\n",sum/cnt,min_jitter,max_jitter);
	return 0;
}

sample source ends here--->

<---extract of my kernel 2.6.26 config
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26
# Fri Jul 25 11:22:39 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_KALLSYMS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
# CONFIG_BUG is not set
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_RT_MUTEXES=y
CONFIG_TINY_SHMEM=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
# CONFIG_X86_PM_TIMER is not set
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LEGACY=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
end of extract of my kernel config--->


