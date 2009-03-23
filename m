Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZCWU5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZCWU5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZCWU5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:57:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:49064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbZCWU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:57:04 -0400
Date: Mon, 23 Mar 2009 20:56:40 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090323172417.297057964@chello.nl>
References: <20090323172417.297057964@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add an mmap method to allow userspace to read hardware counters
Message-ID: <tip-36e6cd42be5579128495e7d9e678638f4945de6e@git.kernel.org>
Git-Commit-ID: 36e6cd42be5579128495e7d9e678638f4945de6e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 20:56:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36e6cd42be5579128495e7d9e678638f4945de6e
Gitweb:     http://git.kernel.org/tip/36e6cd42be5579128495e7d9e678638f4945de6e
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 23 Mar 2009 18:22:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 21:45:09 +0100

perf_counter: add an mmap method to allow userspace to read hardware counters

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
LKML-Reference: <20090323172417.297057964@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    6 +++
 include/linux/perf_counter.h       |   15 +++++++
 kernel/perf_counter.c              |   76 ++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index d056515..e434928 100644
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
@@ -698,6 +702,8 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	write_pmc(counter->hw.idx, val);
 	atomic64_set(&counter->hw.prev_count, val);
 	atomic64_set(&counter->hw.period_left, left);
+	if (counter->user_page)
+		perf_counter_update_userpage(counter);
 
 	/*
 	 * Finally record data if requested.
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 18dc17d..40b324e 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -143,6 +143,17 @@ struct perf_counter_hw_event {
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
@@ -278,6 +289,9 @@ struct perf_counter {
 	int				oncpu;
 	int				cpu;
 
+	/* pointer to page shared with userspace via mmap */
+	unsigned long			user_page;
+
 	/* read() / irq related data */
 	wait_queue_head_t		waitq;
 	/* optional: for NMIs */
@@ -361,6 +375,7 @@ extern int perf_counter_task_enable(void);
 extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx, int cpu);
+extern void perf_counter_update_userpage(struct perf_counter *counter);
 
 extern void perf_counter_output(struct perf_counter *counter,
 				int nmi, struct pt_regs *regs);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ce34bff..d9cfd90 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1177,6 +1177,7 @@ static int perf_release(struct inode *inode, struct file *file)
 	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
+	free_page(counter->user_page);
 	free_counter(counter);
 	put_context(ctx);
 
@@ -1346,12 +1347,87 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
