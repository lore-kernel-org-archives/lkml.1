Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYC1FWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYC1FWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 01:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYC1FW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 01:22:27 -0400
Received: from rtr.ca ([76.10.145.34]:4089 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbYC1FW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 01:22:26 -0400
Message-ID: <47EC8090.6070304@rtr.ca>
Date: Fri, 28 Mar 2008 01:22:24 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <200803272300.24462.rjw@sisk.pl>
In-Reply-To: <200803272300.24462.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 27 of March 2008, Mark Lord wrote:
>> It is with great reluctance when I attempt moving my main "desktop"
>> over to a new kernel version -- because the USB subsystem seems to
>> break every single time.
>>
>> So today I tried 2.6.25-rc7 on it for the first time.
>> Not good.
>>
>> It boots, but just a simple suspend/resume (RAM) was enough to kill it.
>> It comes back on resume, with an X desktop again,
>> but with no USB functionality -- no mouse.
> 
> Mark, could you try to boot with "acpi_new_pts_ordering" and retest?
> 
> Perhaps the problem is caused by the suspend ordering being wrong.
..

Thanks for the suggestion.  It made no difference.

I do have this in the syslog from either boot method:

proc_dir_entry 'rtc' already registered
Pid: 1, comm: swapper Not tainted 2.6.25-rc7 #2
 [proc_register+185/295] proc_register+0xb9/0x127
 [create_proc_entry+109/128] create_proc_entry+0x6d/0x80
 [rtc_proc_add_device+26/53] rtc_proc_add_device+0x1a/0x35
 [rtc_device_register+328/443] rtc_device_register+0x148/0x1bb
 [cmos_do_probe+197/661] cmos_do_probe+0xc5/0x295
 [pnp_device_probe+99/129] pnp_device_probe+0x63/0x81
 [driver_probe_device+182/296] driver_probe_device+0xb6/0x128
 [__driver_attach+0/121] __driver_attach+0x0/0x79
 [__driver_attach+70/121] __driver_attach+0x46/0x79
 [bus_for_each_dev+55/89] bus_for_each_dev+0x37/0x59
 [driver_attach+17/19] driver_attach+0x11/0x13
 [__driver_attach+0/121] __driver_attach+0x0/0x79
 [bus_add_driver+138/424] bus_add_driver+0x8a/0x1a8
 [driver_register+69/153] driver_register+0x45/0x99
 [kernel_init+307/621] kernel_init+0x133/0x26d
 [schedule_tail+23/68] schedule_tail+0x17/0x44
 [ret_from_fork+6/28] ret_from_fork+0x6/0x1c
 [kernel_init+0/621] kernel_init+0x0/0x26d
 [kernel_init+0/621] kernel_init+0x0/0x26d
 [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
 =======================
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k

Some kind of .config conflict, I suppose -- though how it has survived
this far into 2.6.25-rc* makes one wonder.

Meanwhile, I've been trying to rebuild a kernel with debug options
enabled, but so far none of them will come back from suspend,
just a black screen, no alt-sysrq, 5-seconds on the power button
required to escape.

The last attempt had only these differences from the original problem
kernel.  The original at least resumes, this one doesn't.
I'm rebuilding now without the PM debug flags set.

--- dot_config.nousb	2008-03-27 22:43:50.000000000 -0400
+++ dot_config.nothing	2008-03-27 22:47:32.000000000 -0400
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.25-rc7
-# Thu Mar 27 10:54:45 2008
+# Thu Mar 27 22:47:32 2008
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -70,7 +70,7 @@
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
-CONFIG_LOG_BUF_SHIFT=16
+CONFIG_LOG_BUF_SHIFT=17
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
@@ -84,7 +84,7 @@
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
-# CONFIG_KALLSYMS_ALL is not set
+CONFIG_KALLSYMS_ALL=y
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
 CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
@@ -277,7 +277,10 @@
 #
 CONFIG_PM=y
 CONFIG_PM_LEGACY=y
-# CONFIG_PM_DEBUG is not set
+CONFIG_PM_DEBUG=y
+CONFIG_PM_VERBOSE=y
+CONFIG_CAN_PM_TRACE=y
+# CONFIG_PM_TRACE_RTC is not set
 CONFIG_PM_SLEEP_SMP=y
 CONFIG_PM_SLEEP=y
 CONFIG_SUSPEND=y
@@ -1767,30 +1770,35 @@
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
+CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHED_DEBUG is not set
 # CONFIG_SCHEDSTATS is not set
 CONFIG_TIMER_STATS=y
-# CONFIG_DEBUG_SLAB is not set
+CONFIG_DEBUG_SLAB=y
+CONFIG_DEBUG_SLAB_LEAK=y
 # CONFIG_DEBUG_PREEMPT is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
 # CONFIG_RT_MUTEX_TESTER is not set
-# CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_DEBUG_LOCK_ALLOC is not set
-# CONFIG_PROVE_LOCKING is not set
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_LOCKDEP=y
 # CONFIG_LOCK_STAT is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
-# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
-# CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_HIGHMEM is not set
+CONFIG_DEBUG_LOCKDEP=y
+CONFIG_TRACE_IRQFLAGS=y
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
+CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
+CONFIG_STACKTRACE=y
+CONFIG_DEBUG_KOBJECT=y
+CONFIG_DEBUG_HIGHMEM=y
 CONFIG_DEBUG_BUGVERBOSE=y
-# CONFIG_DEBUG_INFO is not set
-# CONFIG_DEBUG_VM is not set
-# CONFIG_DEBUG_LIST is not set
-# CONFIG_DEBUG_SG is not set
-# CONFIG_FRAME_POINTER is not set
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_LIST=y
+CONFIG_DEBUG_SG=y
+CONFIG_FRAME_POINTER=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
@@ -1799,10 +1807,11 @@
 # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
 # CONFIG_SAMPLES is not set
 # CONFIG_EARLY_PRINTK is not set
-# CONFIG_DEBUG_STACKOVERFLOW is not set
-# CONFIG_DEBUG_STACK_USAGE is not set
-# CONFIG_DEBUG_PAGEALLOC is not set
-# CONFIG_DEBUG_RODATA is not set
+CONFIG_DEBUG_STACKOVERFLOW=y
+CONFIG_DEBUG_STACK_USAGE=y
+CONFIG_DEBUG_PAGEALLOC=y
+CONFIG_DEBUG_RODATA=y
+# CONFIG_DEBUG_RODATA_TEST is not set
 # CONFIG_DEBUG_NX_TEST is not set
 CONFIG_4KSTACKS=y
 CONFIG_X86_FIND_SMP_CONFIG=y
