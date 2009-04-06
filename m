Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZDFJqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZDFJqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZDFJok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbZDFJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:36 -0400
Message-Id: <20090406094517.579788800@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/15] perf_counter: SIGIO support
Content-Disposition: inline; filename=perf_counter-sigio.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

provide support for fcntl() I/O availability signals.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -238,6 +238,7 @@ enum perf_event_type {
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/hrtimer.h>
+#include <linux/fs.h>
 #include <asm/atomic.h>
 
 struct task_struct;
@@ -397,6 +398,7 @@ struct perf_counter {
 
 	/* poll related */
 	wait_queue_head_t		waitq;
+	struct fasync_struct		*fasync;
 	/* optional: for NMIs */
 	struct perf_wakeup_entry	wakeup;
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1526,6 +1526,22 @@ out:
 	return ret;
 }
 
+static int perf_fasync(int fd, struct file *filp, int on)
+{
+	struct perf_counter *counter = filp->private_data;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int retval;
+
+	mutex_lock(&inode->i_mutex);
+	retval = fasync_helper(fd, filp, on, &counter->fasync);
+	mutex_unlock(&inode->i_mutex);
+
+	if (retval < 0)
+		return retval;
+
+	return 0;
+}
+
 static const struct file_operations perf_fops = {
 	.release		= perf_release,
 	.read			= perf_read,
@@ -1533,6 +1549,7 @@ static const struct file_operations perf
 	.unlocked_ioctl		= perf_ioctl,
 	.compat_ioctl		= perf_ioctl,
 	.mmap			= perf_mmap,
+	.fasync			= perf_fasync,
 };
 
 /*
@@ -1549,7 +1566,7 @@ void perf_counter_wakeup(struct perf_cou
 	rcu_read_lock();
 	data = rcu_dereference(counter->data);
 	if (data) {
-		(void)atomic_xchg(&data->wakeup, POLL_IN);
+		atomic_set(&data->wakeup, POLL_IN);
 		/*
 		 * Ensure all data writes are issued before updating the
 		 * user-space data head information. The matching rmb()
@@ -1561,6 +1578,7 @@ void perf_counter_wakeup(struct perf_cou
 	rcu_read_unlock();
 
 	wake_up_all(&counter->waitq);
+	kill_fasync(&counter->fasync, SIGIO, POLL_IN);
 }
 
 /*

-- 

