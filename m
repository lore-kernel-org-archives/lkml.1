Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbYAYJlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbYAYJlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYAYJlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:41:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:50364 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754828AbYAYJlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:41:01 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/4Fm1ZpwT4alhc1+RNTvVQvwkKAgk2vDsXR1L9JN
	f3nydFf23Z91Wm
Date: Fri, 25 Jan 2008 10:40:46 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [Patch] Removal of FUTEX_FD
Message-ID: <20080125094046.GA4494@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.24-rc8 (x86_64)
X-Uptime: 10:36:07 up  3:50,  7 users,  load average: 0.16, 0.28, 0.52
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

since FUTEX_FD was scheduled for removal in June 2007 lets remove it.
Google Code search found no users for it and NGPT was abandoned in 2003
according to IBM. futex.h is left untouched to make sure the id does
not get reassigned. Since queue_me() has no users left it is commented
out to avoid a warning, i didnt remove it completely since it is part
of the internal api (matching unqueue_me())

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux/kernel/futex.c.orig	2008-01-25 09:53:28.000000000 +0100
+++ linux/kernel/futex.c	2008-01-25 10:01:53.000000000 +0100
@@ -1026,6 +1026,7 @@ queue_unlock(struct futex_q *q, struct f
  * exactly once.  They are called with the hashed spinlock held.
  */
 
+#if 0
 /* The key must be already stored in q->key. */
 static void queue_me(struct futex_q *q, int fd, struct file *filp)
 {
@@ -1034,6 +1035,7 @@ static void queue_me(struct futex_q *q, 
 	hb = queue_lock(q, fd, filp);
 	__queue_me(q, hb);
 }
+#endif
 
 /* Return 1 if we were still queued (ie. 0 means we were woken) */
 static int unqueue_me(struct futex_q *q)
@@ -1750,87 +1752,6 @@ static const struct file_operations fute
 };
 
 /*
- * Signal allows caller to avoid the race which would occur if they
- * set the sigio stuff up afterwards.
- */
-static int futex_fd(u32 __user *uaddr, int signal)
-{
-	struct futex_q *q;
-	struct file *filp;
-	int ret, err;
-	struct rw_semaphore *fshared;
-	static unsigned long printk_interval;
-
-	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
-		printk(KERN_WARNING "Process `%s' used FUTEX_FD, which "
-		       "will be removed from the kernel in June 2007\n",
-		       current->comm);
-	}
-
-	ret = -EINVAL;
-	if (!valid_signal(signal))
-		goto out;
-
-	ret = get_unused_fd();
-	if (ret < 0)
-		goto out;
-	filp = get_empty_filp();
-	if (!filp) {
-		put_unused_fd(ret);
-		ret = -ENFILE;
-		goto out;
-	}
-	filp->f_op = &futex_fops;
-	filp->f_path.mnt = mntget(futex_mnt);
-	filp->f_path.dentry = dget(futex_mnt->mnt_root);
-	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
-
-	if (signal) {
-		err = __f_setown(filp, task_pid(current), PIDTYPE_PID, 1);
-		if (err < 0) {
-			goto error;
-		}
-		filp->f_owner.signum = signal;
-	}
-
-	q = kmalloc(sizeof(*q), GFP_KERNEL);
-	if (!q) {
-		err = -ENOMEM;
-		goto error;
-	}
-	q->pi_state = NULL;
-
-	fshared = &current->mm->mmap_sem;
-	down_read(fshared);
-	err = get_futex_key(uaddr, fshared, &q->key);
-
-	if (unlikely(err != 0)) {
-		up_read(fshared);
-		kfree(q);
-		goto error;
-	}
-
-	/*
-	 * queue_me() must be called before releasing mmap_sem, because
-	 * key->shared.inode needs to be referenced while holding it.
-	 */
-	filp->private_data = q;
-
-	queue_me(q, ret, filp);
-	up_read(fshared);
-
-	/* Now we map fd to filp, so userspace can access it */
-	fd_install(ret, filp);
-out:
-	return ret;
-error:
-	put_unused_fd(ret);
-	put_filp(filp);
-	ret = err;
-	goto out;
-}
-
-/*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.
  *
@@ -2048,10 +1969,6 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_WAKE:
 		ret = futex_wake(uaddr, fshared, val);
 		break;
-	case FUTEX_FD:
-		/* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
-		ret = futex_fd(uaddr, val);
-		break;
 	case FUTEX_REQUEUE:
 		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
 		break;
