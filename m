Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZCTPTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZCTPTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZCTPSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:18:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:52494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbZCTPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:18:37 -0400
Message-Id: <20090320151734.839895260@chello.nl>
References: <20090320151547.937040269@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Mar 2009 16:15:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/3] perf_counter: add an mmap method to allow userspace to read hardware counters
Content-Disposition: inline; filename=paulus-perfcounters-add_an_mmap_method_to_allow_userspace_to_read_hardware_counters.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

Impact: new feature giving performance improvement

This adds the ability for userspace to do an mmap on a hardware counter
fd and get access to a read-only page that contains the information
needed to translate a hardware counter value to the full 64-bit
counter value that would be returned by a read on the fd.  This is
useful on architectures that allow user programs to read the hardware
counters, such as PowerPC.

The mmap will only succeed if the counter is a hardware counter
monitoring the current process.

On my quad 2.5GHz PowerPC 970MP machine, userspace can read a counter
and translate it to the full 64-bit value in about 30ns using the
mmapped page, compared to about 830ns for the read syscall on the
counter, so this does give a significant performance improvement.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_counter.c |    6 ++
 include/linux/perf_counter.h       |   15 +++++++
 kernel/perf_counter.c              |   76 +++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -417,6 +417,8 @@ void hw_perf_restore(u64 disable)
 		atomic64_set(&counter->hw.prev_count, val);
 		counter->hw.idx = hwc_index[i] + 1;
 		write_pmc(counter->hw.idx, val);
+		if (counter->user_page)
+			perf_counter_update_userpage(counter);
 	}
 	mb();
 	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
@@ -572,6 +574,8 @@ static void power_perf_disable(struct pe
 			ppmu->disable_pmc(counter->hw.idx - 1, cpuhw->mmcr);
 			write_pmc(counter->hw.idx, 0);
 			counter->hw.idx = 0;
+			if (counter->user_page)
+				perf_counter_update_userpage(counter);
 			break;
 		}
 	}
@@ -697,6 +701,8 @@ static void record_and_restart(struct pe
 	write_pmc(counter->hw.idx, val);
 	atomic64_set(&counter->hw.prev_count, val);
 	atomic64_set(&counter->hw.period_left, left);
+	if (counter->user_page)
+		perf_counter_update_userpage(counter);
 
 	/*
 	 * Finally record data if requested.
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -126,6 +126,17 @@ struct perf_counter_hw_event {
 #define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
 #define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
 
+/*
+ * Structure of the page that can be mapped via mmap
+ */
+struct perf_counter_mmap_page {
+	__u32	version;		/* version number of this structure */
+	__u32	compat_version;		/* lowest version this is compat with */
+	__u32	lock;			/* seqlock for synchronization */
+	__u32	index;			/* hardware counter identifier */
+	__s64	offset;			/* add to hardware counter value */
+};
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -240,6 +251,9 @@ struct perf_counter {
 	int				oncpu;
 	int				cpu;
 
+	/* pointer to page shared with userspace via mmap */
+	unsigned long			user_page;
+
 	/* read() / irq related data */
 	wait_queue_head_t		waitq;
 	/* optional: for NMIs */
@@ -316,6 +330,7 @@ extern int perf_counter_task_enable(void
 extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx, int cpu);
+extern void perf_counter_update_userpage(struct perf_counter *counter);
 
 extern void perf_counter_output(struct perf_counter *counter,
 				int nmi, struct pt_regs *regs);
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1176,6 +1176,7 @@ static int perf_release(struct inode *in
 	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
+	free_page(counter->user_page);
 	free_counter(counter);
 	put_context(ctx);
 
@@ -1345,12 +1346,87 @@ static long perf_ioctl(struct file *file
 	return err;
 }
 
+void perf_counter_update_userpage(struct perf_counter *counter)
+{
+	struct perf_counter_mmap_page *userpg;
+
+	if (!counter->user_page)
+		return;
+	userpg = (struct perf_counter_mmap_page *) counter->user_page;
+
+	++userpg->lock;
+	smp_wmb();
+	userpg->index = counter->hw.idx;
+	userpg->offset = atomic64_read(&counter->count);
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
+		userpg->offset -= atomic64_read(&counter->hw.prev_count);
+	smp_wmb();
+	++userpg->lock;
+}
+
+static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct perf_counter *counter = vma->vm_file->private_data;
+
+	if (!counter->user_page)
+		return VM_FAULT_SIGBUS;
+
+	vmf->page = virt_to_page(counter->user_page);
+	get_page(vmf->page);
+	return 0;
+}
+
+static struct vm_operations_struct perf_mmap_vmops = {
+	.fault = perf_mmap_fault,
+};
+
+static int perf_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct perf_counter *counter = file->private_data;
+	unsigned long userpg;
+
+	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * For now, restrict to the case of a hardware counter
+	 * on the current task.
+	 */
+	if (is_software_counter(counter) || counter->task != current)
+		return -EINVAL;
+
+	userpg = counter->user_page;
+	if (!userpg) {
+		userpg = get_zeroed_page(GFP_KERNEL);
+		mutex_lock(&counter->mutex);
+		if (counter->user_page) {
+			free_page(userpg);
+			userpg = counter->user_page;
+		} else {
+			counter->user_page = userpg;
+		}
+		mutex_unlock(&counter->mutex);
+		if (!userpg)
+			return -ENOMEM;
+	}
+
+	perf_counter_update_userpage(counter);
+
+	vma->vm_flags &= ~VM_MAYWRITE;
+	vma->vm_flags |= VM_RESERVED;
+	vma->vm_ops = &perf_mmap_vmops;
+	return 0;
+}
+
 static const struct file_operations perf_fops = {
 	.release		= perf_release,
 	.read			= perf_read,
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
 	.compat_ioctl		= perf_ioctl,
+	.mmap			= perf_mmap,
 };
 
 /*

-- 

