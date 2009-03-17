Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZCQFnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZCQFnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 01:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZCQFnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 01:43:32 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43977 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZCQFnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 01:43:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18879.14431.733358.248755@drongo.ozlabs.ibm.com>
Date: Tue, 17 Mar 2009 16:42:55 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH/RFC 2/2] perfcounters: add an mmap method to allow userspace to read hardware counters
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/powerpc/kernel/perf_counter.c |    6 +++
 include/linux/perf_counter.h       |   15 +++++++
 kernel/perf_counter.c              |   78 ++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 5008762..44271b6 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -417,6 +417,8 @@ void hw_perf_restore(u64 disable)
 		atomic64_set(&counter->hw.prev_count, val);
 		counter->hw.idx = hwc_index[i] + 1;
 		write_pmc(counter->hw.idx, val);
+		if (counter->user_page)
+			perf_counter_update_userpage(counter);
 	}
 	mb();
 	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
@@ -572,6 +574,8 @@ static void power_perf_disable(struct perf_counter *counter)
 			ppmu->disable_pmc(counter->hw.idx - 1, cpuhw->mmcr);
 			write_pmc(counter->hw.idx, 0);
 			counter->hw.idx = 0;
+			if (counter->user_page)
+				perf_counter_update_userpage(counter);
 			break;
 		}
 	}
@@ -732,6 +736,8 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	write_pmc(counter->hw.idx, val);
 	atomic64_set(&counter->hw.prev_count, val);
 	atomic64_set(&counter->hw.period_left, left);
+	if (counter->user_page)
+		perf_counter_update_userpage(counter);
 
 	/*
 	 * Finally record data if requested.
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 08c11a6..3f9309f 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -100,6 +100,17 @@ struct perf_counter_hw_event {
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
@@ -214,6 +225,9 @@ struct perf_counter {
 	int				oncpu;
 	int				cpu;
 
+	/* pointer to page shared with userspace via mmap */
+	unsigned long			user_page;
+
 	/* read() / irq related data */
 	wait_queue_head_t		waitq;
 	/* optional: for NMIs */
@@ -289,6 +303,7 @@ extern int perf_counter_task_enable(void);
 extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx, int cpu);
+extern void perf_counter_update_userpage(struct perf_counter *counter);
 
 /*
  * Return 1 for a software counter, 0 for a hardware counter
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7c62b93..a440b9e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1165,6 +1165,7 @@ static int perf_release(struct inode *inode, struct file *file)
 	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
+	free_page(counter->user_page);
 	call_rcu(&counter->rcu_head, free_counter_rcu);
 	put_context(ctx);
 
@@ -1331,12 +1332,87 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
 static const struct file_operations perf_intr_fops = {
 	.release		= perf_release,
 	.read			= perf_read_irq_data,
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
 	.compat_ioctl		= perf_ioctl,
+	.mmap			= perf_mmap,
 };
 
 static const struct file_operations perf_value_fops = {
@@ -1345,6 +1421,7 @@ static const struct file_operations perf_value_fops = {
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
 	.compat_ioctl		= perf_ioctl,
+	.mmap			= perf_mmap,
 };
 
 static const struct file_operations perf_clone_fops = {
@@ -1353,6 +1430,7 @@ static const struct file_operations perf_clone_fops = {
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
 	.compat_ioctl		= perf_ioctl,
+	.mmap			= perf_mmap,
 };
 
 /*
-- 
1.5.5.rc3.7.gba13

