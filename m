Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZCQFnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZCQFnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 01:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZCQFm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 01:42:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43965 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZCQFm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 01:42:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18879.14425.221429.861838@drongo.ozlabs.ibm.com>
Date: Tue, 17 Mar 2009 16:42:49 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH/RFC 1/2] perfcounters: provide a way to read the current value of interrupting counters
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new feature

At present, if the user specifies hw_event->record_type ==
PERF_RECORD_IRQ or PERF_RECORD_GROUP when creating a counter, reads from
the counter will return records from the interrupt event queue for the
counter.  This means that there is no way to find out the current value
of the counter.  Also, using the record_type is slightly problematic in
that what actually determines whether the counter generates interrupts
is whether hw_event->irq_period is non-zero or not.

This provides a way for users to get a second fd for an interrupting
counter, which has a different set of file operations, set up so that
reads on the second (or "clone") fd return the counter value rather than
reading the interrupt event queue.  The way to get the clone fd is like
this:

	clone_fd = sys_perf_counter_open(NULL, 0, 0, counter_fd, 0);

That is, the hw_event parameter is NULL and the original counter fd is
supplied in the group_fd parameter.

This also simplifies the counter read path a bit by setting up two
file_operations structs, one for interrupting counters and one for
simple (non-interrupting) counters, and uses irq_period rather than
record_type to determine which type of counter is being requested.
This will enable us to use a wider range of values in record_type in
future, allowing the user to specify what information they want recorded
on an interrupt.

Internally, we now potentially have multiple struct files pointing to
the one struct counter, which could lead to lifetime issues.  We avoid
any such issues by having the clone files keep a reference to the
original file.  The reference is dropped when the clone file is closed.
Thus the original file can never be released while there is any clone
file still open.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This and the following patch are in the rfc branch of my
perfcounters.git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc

(Note that the rfc branch includes the master branch, which has the
"perfcounters: abstract wakeup flag setting in core to fix powerpc
build" commit in it.)

 kernel/perf_counter.c |  114 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 87 insertions(+), 27 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b39456a..7c62b93 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1172,11 +1172,24 @@ static int perf_release(struct inode *inode, struct file *file)
 }
 
 /*
+ * Called when the last reference to a clone file is gone.
+ */
+static int perf_clone_release(struct inode *inode, struct file *file)
+{
+	struct perf_counter *counter = file->private_data;
+
+	file->private_data = NULL;
+	fput(counter->filp);
+	return 0;
+}
+
+/*
  * Read the performance counter - simple non blocking version for now
  */
 static ssize_t
-perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
+perf_read_value(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
+	struct perf_counter *counter = file->private_data;
 	u64 cntval;
 
 	if (count != sizeof(cntval))
@@ -1218,11 +1231,12 @@ perf_copy_usrdata(struct perf_data *usrdata, char __user *buf, size_t count)
 }
 
 static ssize_t
-perf_read_irq_data(struct perf_counter	*counter,
-		   char __user		*buf,
-		   size_t		count,
-		   int			nonblocking)
+perf_read_irq_data(struct file	*file,
+		   char __user	*buf,
+		   size_t	count,
+		   loff_t	*ppos)
 {
+	struct perf_counter *counter = file->private_data;
 	struct perf_data *irqdata, *usrdata;
 	DECLARE_WAITQUEUE(wait, current);
 	ssize_t res, res2;
@@ -1233,7 +1247,7 @@ perf_read_irq_data(struct perf_counter	*counter,
 	if (usrdata->len + irqdata->len >= count)
 		goto read_pending;
 
-	if (nonblocking)
+	if (file->f_flags & O_NONBLOCK)
 		return -EAGAIN;
 
 	spin_lock_irq(&counter->waitq.lock);
@@ -1283,23 +1297,6 @@ out:
 	return res;
 }
 
-static ssize_t
-perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
-{
-	struct perf_counter *counter = file->private_data;
-
-	switch (counter->hw_event.record_type) {
-	case PERF_RECORD_SIMPLE:
-		return perf_read_hw(counter, buf, count);
-
-	case PERF_RECORD_IRQ:
-	case PERF_RECORD_GROUP:
-		return perf_read_irq_data(counter, buf, count,
-					  file->f_flags & O_NONBLOCK);
-	}
-	return -EINVAL;
-}
-
 static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_counter *counter = file->private_data;
@@ -1334,9 +1331,25 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return err;
 }
 
-static const struct file_operations perf_fops = {
+static const struct file_operations perf_intr_fops = {
 	.release		= perf_release,
-	.read			= perf_read,
+	.read			= perf_read_irq_data,
+	.poll			= perf_poll,
+	.unlocked_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_ioctl,
+};
+
+static const struct file_operations perf_value_fops = {
+	.release		= perf_release,
+	.read			= perf_read_value,
+	.poll			= perf_poll,
+	.unlocked_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_ioctl,
+};
+
+static const struct file_operations perf_clone_fops = {
+	.release		= perf_clone_release,
+	.read			= perf_read_value,
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
 	.compat_ioctl		= perf_ioctl,
@@ -1888,6 +1901,38 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	return counter;
 }
 
+static long perf_counter_clone(int orig_fd)
+{
+	struct perf_counter *counter;
+	struct file *counter_file;
+	int ret;
+
+	/*
+	 * The cloned file holds a reference to the original
+	 * file; the corresponding fput to this fget is in
+	 * perf_clone_release().
+	 */
+	counter_file = fget(orig_fd);
+	if (!counter_file)
+		return -EBADF;
+
+	ret = -EINVAL;
+	if (counter_file->f_op != &perf_intr_fops &&
+	    counter_file->f_op != &perf_value_fops)
+		goto out_fput;
+
+	counter = counter_file->private_data;
+
+	ret = anon_inode_getfd("[perf_counter]", &perf_clone_fops, counter, 0);
+	if (ret < 0)
+		goto out_fput;
+	return ret;
+
+ out_fput:
+	fput(counter_file);
+	return ret;
+}
+
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -1905,6 +1950,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	struct perf_counter_context *ctx;
 	struct file *counter_file = NULL;
 	struct file *group_file = NULL;
+	const struct file_operations *fops;
 	int fput_needed = 0;
 	int fput_needed2 = 0;
 	int ret;
@@ -1913,6 +1959,15 @@ SYSCALL_DEFINE5(perf_counter_open,
 	if (flags)
 		return -EINVAL;
 
+	/*
+	 * See if the user wants to clone an existing counter,
+	 * to get another fd referring to the same counter but with
+	 * file operations set to read the counter value rather than
+	 * irq events.
+	 */
+	if (hw_event_uptr == NULL)
+		return perf_counter_clone(group_fd);
+
 	if (copy_from_user(&hw_event, hw_event_uptr, sizeof(hw_event)) != 0)
 		return -EFAULT;
 
@@ -1932,7 +1987,8 @@ SYSCALL_DEFINE5(perf_counter_open,
 		group_file = fget_light(group_fd, &fput_needed);
 		if (!group_file)
 			goto err_put_context;
-		if (group_file->f_op != &perf_fops)
+		if (group_file->f_op != &perf_intr_fops &&
+		    group_file->f_op != &perf_value_fops)
 			goto err_put_context;
 
 		group_leader = group_file->private_data;
@@ -1961,7 +2017,11 @@ SYSCALL_DEFINE5(perf_counter_open,
 	if (!counter)
 		goto err_put_context;
 
-	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (counter->hw_event.irq_period)
+		fops = &perf_intr_fops;
+	else
+		fops = &perf_value_fops;
+	ret = anon_inode_getfd("[perf_counter]", fops, counter, 0);
 	if (ret < 0)
 		goto err_free_put_context;
 
-- 
1.5.5.rc3.7.gba13

