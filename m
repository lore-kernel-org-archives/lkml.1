Return-Path: <linux-kernel-owner+w=401wt.eu-S1765709AbZCaXnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765709AbZCaXnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765606AbZCaXmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:42:24 -0400
Received: from ozlabs.org ([203.10.76.45]:48433 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765617AbZCaXmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:42:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.29 boot hang
Date: Wed, 1 Apr 2009 10:12:11 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       andreas.herrmann3@amd.com
References: <49D280EF.1080507@oracle.com>
In-Reply-To: <49D280EF.1080507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904011012.11527.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009 07:15:35 Randy Dunlap wrote:
> On a 4-proc x86_64 (HP BladeCenter, AMD CPUs) system, booting 2.6.29
> (or earlier, back to 2.6.28-6921-g873392c) hangs during boot.
> 
> git bisect says:
> 873392ca514f87eae39f53b6944caf85b1a047cb is first bad commit
> commit 873392ca514f87eae39f53b6944caf85b1a047cb
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed Dec 31 23:54:56 2008 +1030
> 
>     PCI: work_on_cpu: use in drivers/pci/pci-driver.c

...

> If I change CONFIG_MICROCODE_AMD=y to CONFIG_MICROCODE_AMD=n & rebuild,
> the kernel boots successfully.

How very very odd.  My first thought was a deadlock with keventd used
by work_on_cpu (changed in latest Linus tree), but the microcode code at
that version doesn't use work_on_cpu.

So I don't think that's it, but this patch should canonically eliminate it:

Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
From: Andrew Morton <akpm@linux-foundation.org>

The various implemetnations and proposed implemetnations of work_on_cpu()
are vulnerable to various deadlocks because they all used queues of some
form.

Unrelated pieces of kernel code thus gained dependencies wherein if one
work_on_cpu() caller holds a lock which some other work_on_cpu() callback
also takes, the kernel could rarely deadlock.

Fix this by creating a short-lived kernel thread for each work_on_cpu()
invokation.

This is not terribly fast, but the only current caller of work_on_cpu() is
pci_call_probe().

It would be nice to find some other way of doing the node-local
allocations in the PCI probe code so that we can zap work_on_cpu()
altogether.  The code there is rather nasty.  I can't think of anything
simple at this time...

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/workqueue.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand kernel/workqueue.c
--- a/kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand
+++ a/kernel/workqueue.c
@@ -985,20 +985,20 @@ undo:
 }
 
 #ifdef CONFIG_SMP
-static struct workqueue_struct *work_on_cpu_wq __read_mostly;
 
 struct work_for_cpu {
-	struct work_struct work;
+	struct completion completion;
 	long (*fn)(void *);
 	void *arg;
 	long ret;
 };
 
-static void do_work_for_cpu(struct work_struct *w)
+static int do_work_for_cpu(void *_wfc)
 {
-	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
-
+	struct work_for_cpu *wfc = _wfc;
 	wfc->ret = wfc->fn(wfc->arg);
+	complete(&wfc->completion);
+	return 0;
 }
 
 /**
@@ -1009,17 +1009,23 @@ static void do_work_for_cpu(struct work_
  *
  * This will return the value @fn returns.
  * It is up to the caller to ensure that the cpu doesn't go offline.
+ * The caller must not hold any locks which would prevent @fn from completing.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct work_for_cpu wfc;
-
-	INIT_WORK(&wfc.work, do_work_for_cpu);
-	wfc.fn = fn;
-	wfc.arg = arg;
-	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
-	flush_work(&wfc.work);
-
+	struct task_struct *sub_thread;
+	struct work_for_cpu wfc = {
+		.completion = COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
+		.fn = fn,
+		.arg = arg,
+	};
+
+	sub_thread = kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
+	if (IS_ERR(sub_thread))
+		return PTR_ERR(sub_thread);
+	kthread_bind(sub_thread, cpu);
+	wake_up_process(sub_thread);
+	wait_for_completion(&wfc.completion);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
@@ -1035,8 +1041,4 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-#ifdef CONFIG_SMP
-	work_on_cpu_wq = create_workqueue("work_on_cpu");
-	BUG_ON(!work_on_cpu_wq);
-#endif
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-unify-some-pmd_-functions-fix-s390.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
