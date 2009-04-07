Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZDGJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZDGJIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZDGJIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:08:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:46971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbZDGJH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:07:59 -0400
Date: Tue, 7 Apr 2009 09:07:13 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094517.579788800@chello.nl>
References: <20090406094517.579788800@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: SIGIO support
Message-ID: <tip-3c446b3d3b38f991f97e9d2df0ad26a60a94dcff@git.kernel.org>
Git-Commit-ID: 3c446b3d3b38f991f97e9d2df0ad26a60a94dcff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:07:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c446b3d3b38f991f97e9d2df0ad26a60a94dcff
Gitweb:     http://git.kernel.org/tip/3c446b3d3b38f991f97e9d2df0ad26a60a94dcff
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:55 +0200

perf_counter: SIGIO support

Provide support for fcntl() I/O availability signals.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094517.579788800@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index f9d5cf0..8d5d11b 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -238,6 +238,7 @@ enum perf_event_type {
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/hrtimer.h>
+#include <linux/fs.h>
 #include <asm/atomic.h>
 
 struct task_struct;
@@ -398,6 +399,7 @@ struct perf_counter {
 
 	/* poll related */
 	wait_queue_head_t		waitq;
+	struct fasync_struct		*fasync;
 	/* optional: for NMIs */
 	struct perf_wakeup_entry	wakeup;
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 727624d..c58cc64 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
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
@@ -1533,6 +1549,7 @@ static const struct file_operations perf_fops = {
 	.unlocked_ioctl		= perf_ioctl,
 	.compat_ioctl		= perf_ioctl,
 	.mmap			= perf_mmap,
+	.fasync			= perf_fasync,
 };
 
 /*
@@ -1549,7 +1566,7 @@ void perf_counter_wakeup(struct perf_counter *counter)
 	rcu_read_lock();
 	data = rcu_dereference(counter->data);
 	if (data) {
-		(void)atomic_xchg(&data->wakeup, POLL_IN);
+		atomic_set(&data->wakeup, POLL_IN);
 		/*
 		 * Ensure all data writes are issued before updating the
 		 * user-space data head information. The matching rmb()
@@ -1561,6 +1578,7 @@ void perf_counter_wakeup(struct perf_counter *counter)
 	rcu_read_unlock();
 
 	wake_up_all(&counter->waitq);
+	kill_fasync(&counter->fasync, SIGIO, POLL_IN);
 }
 
 /*
