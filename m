Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZGBOOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZGBOOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZGBOOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:14:16 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53032 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbZGBOOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:14:14 -0400
Subject: Re: Exiting with locks still held (was Re: [PATCH] kmemleak: Fix 
	scheduling-while-atomic bug)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <84144f020907020554n1b098e28o8b4a4a58a08728e3@mail.gmail.com>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
	 <20090701110438.GA15958@elte.hu>
	 <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
	 <84144f020907020554n1b098e28o8b4a4a58a08728e3@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 02 Jul 2009 15:13:44 +0100
Message-Id: <1246544024.13320.95.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 14:13:45.0146 (UTC) FILETIME=[4F66B9A0:01C9FB1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 15:54 +0300, Pekka Enberg wrote:
> On Thu, Jul 2, 2009 at 3:48 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> > For example, the badly written code below opens kmemleak and acquires
> > the scan_mutex in the parent task but releases it in the child (it needs
> > a few tries to trigger it). With waitpid() in parent everything is fine.
[...]
> Well, you are not supposed to hold on to locks when returning from a
> system call ("sys_open") anyway.

There's a fix to this. I'll test it a bit more before pushing upstream:


kmemleak: Do not acquire scan_mutex in kmemleak_open()

From: Catalin Marinas <catalin.marinas@arm.com>

Initially, the scan_mutex was acquired in kmemleak_open() and released
in kmemleak_release() (corresponding to /sys/kernel/debug/kmemleak
operations). This was causing some lockdep reports when the file was
closed from a different task than the one opening it. This patch moves
the scan_mutex acquiring in kmemleak_write() or kmemleak_seq_show().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   58 +++++++++++++++++++++++++++------------------------------
 1 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 958b462..678baad 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1157,11 +1157,22 @@ static int kmemleak_seq_show(struct seq_file *seq, void *v)
 {
 	struct kmemleak_object *object = v;
 	unsigned long flags;
+	int ret;
+
+	/*
+	 * scan_mutex needs to be acquired here since unreferenced_object() is
+	 * not reliable during memory scanning.
+	 */
+	ret = mutex_lock_interruptible(&scan_mutex);
+	if (ret < 0)
+		return ret;
 
 	spin_lock_irqsave(&object->lock, flags);
 	if ((object->flags & OBJECT_REPORTED) && unreferenced_object(object))
 		print_unreferenced(seq, object);
 	spin_unlock_irqrestore(&object->lock, flags);
+
+	mutex_unlock(&scan_mutex);
 	return 0;
 }
 
@@ -1174,36 +1185,15 @@ static const struct seq_operations kmemleak_seq_ops = {
 
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
@@ -1223,15 +1213,17 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
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
@@ -1244,11 +1236,10 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
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
@@ -1257,7 +1248,12 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
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

