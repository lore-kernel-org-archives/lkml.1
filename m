Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZGCKSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZGCKSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZGCKSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:18:43 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45155 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbZGCKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:18:42 -0400
Subject: Re: Exiting with locks still held (was Re: [PATCH] kmemleak: Fix 
	scheduling-while-atomic bug)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0907021031260.4830@localhost.localdomain>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
	 <20090701110438.GA15958@elte.hu>
	 <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
	 <84144f020907020554n1b098e28o8b4a4a58a08728e3@mail.gmail.com>
	 <1246544024.13320.95.camel@pc1117.cambridge.arm.com>
	 <alpine.LFD.2.01.0907021031260.4830@localhost.localdomain>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 03 Jul 2009 11:18:19 +0100
Message-Id: <1246616299.24965.13.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2009 10:18:20.0104 (UTC) FILETIME=[96A21C80:01C9FBC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 10:39 -0700, Linus Torvalds wrote:
> On Thu, 2 Jul 2009, Catalin Marinas wrote:
> > 
> > Initially, the scan_mutex was acquired in kmemleak_open() and released
> > in kmemleak_release() (corresponding to /sys/kernel/debug/kmemleak
> > operations). This was causing some lockdep reports when the file was
> > closed from a different task than the one opening it. This patch moves
> > the scan_mutex acquiring in kmemleak_write() or kmemleak_seq_show().
> 
> This is better, but not really how you are supposed to do it.
> 
> The whole seq-file thing is very much _designed_ for taking a lock at the 
> beginning of the operation, and releasing it at the end. It's a very 
> common pattern.

Thanks for this. Here's the updated patch (the difference from misc.c is
that it uses mutex_lock_interruptible):


kmemleak: Do not acquire scan_mutex in kmemleak_open()

From: Catalin Marinas <catalin.marinas@arm.com>

Initially, the scan_mutex was acquired in kmemleak_open() and released
in kmemleak_release() (corresponding to /sys/kernel/debug/kmemleak
operations). This was causing some lockdep reports when the file was
closed from a different task than the one opening it. This patch moves
the scan_mutex acquiring in kmemleak_write() or kmemleak_seq_start()
with releasing in kmemleak_seq_stop().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   63 +++++++++++++++++++++++++++------------------------------
 1 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 23bf5f0..c6e0aae 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1103,6 +1103,11 @@ static void *kmemleak_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct kmemleak_object *object;
 	loff_t n = *pos;
+	int err;
+
+	err = mutex_lock_interruptible(&scan_mutex);
+	if (err < 0)
+		return ERR_PTR(err);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
@@ -1146,8 +1151,15 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
  */
 static void kmemleak_seq_stop(struct seq_file *seq, void *v)
 {
-	if (v)
-		put_object(v);
+	if (!IS_ERR(v)) {
+		/*
+		 * kmemleak_seq_start may return ERR_PTR if the scan_mutex
+		 * waiting was interrupted, so only release it if !IS_ERR.
+		 */
+		mutex_unlock(&scan_mutex);
+		if (v)
+			put_object(v);
+	}
 }
 
 /*
@@ -1174,36 +1186,15 @@ static const struct seq_operations kmemleak_seq_ops = {
 
 static int kmemleak_open(struct inode *inode, struct file *file)
 {
-	int ret = 0;
-
 	if (!atomic_read(&kmemleak_enabled))
 		return -EBUSY;
 
-	ret = mutex_lock_interruptible(&scan_mutex);
-	if (ret < 0)
-		goto out;
-	if (file->f_mode & FMODE_READ) {
-		ret = seq_open(file, &kmemleak_seq_ops);
-		if (ret < 0)
-			goto scan_unlock;
-	}
-	return ret;
-
-scan_unlock:
-	mutex_unlock(&scan_mutex);
-out:
-	return ret;
+	return seq_open(file, &kmemleak_seq_ops);
 }
 
 static int kmemleak_release(struct inode *inode, struct file *file)
 {
-	int ret = 0;
-
-	if (file->f_mode & FMODE_READ)
-		seq_release(inode, file);
-	mutex_unlock(&scan_mutex);
-
-	return ret;
+	return seq_release(inode, file);
 }
 
 /*
@@ -1223,15 +1214,17 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 {
 	char buf[64];
 	int buf_size;
-
-	if (!atomic_read(&kmemleak_enabled))
-		return -EBUSY;
+	int ret;
 
 	buf_size = min(size, (sizeof(buf) - 1));
 	if (strncpy_from_user(buf, user_buf, buf_size) < 0)
 		return -EFAULT;
 	buf[buf_size] = 0;
 
+	ret = mutex_lock_interruptible(&scan_mutex);
+	if (ret < 0)
+		return ret;
+
 	if (strncmp(buf, "off", 3) == 0)
 		kmemleak_disable();
 	else if (strncmp(buf, "stack=on", 8) == 0)
@@ -1244,11 +1237,10 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 		stop_scan_thread();
 	else if (strncmp(buf, "scan=", 5) == 0) {
 		unsigned long secs;
-		int err;
 
-		err = strict_strtoul(buf + 5, 0, &secs);
-		if (err < 0)
-			return err;
+		ret = strict_strtoul(buf + 5, 0, &secs);
+		if (ret < 0)
+			goto out;
 		stop_scan_thread();
 		if (secs) {
 			jiffies_scan_wait = msecs_to_jiffies(secs * 1000);
@@ -1257,7 +1249,12 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 	} else if (strncmp(buf, "scan", 4) == 0)
 		kmemleak_scan();
 	else
-		return -EINVAL;
+		ret = -EINVAL;
+
+out:
+	mutex_unlock(&scan_mutex);
+	if (ret < 0)
+		return ret;
 
 	/* ignore the rest of the buffer, only one command at a time */
 	*ppos += size;


-- 
Catalin

