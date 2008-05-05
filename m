Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYEEIAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYEEIAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYEEH7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:59:55 -0400
Received: from ozlabs.org ([203.10.76.45]:38463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYEEH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:59:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Removal of FUTEX_FD
Date: Mon, 5 May 2008 17:59:30 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eric Sesterhenn <snakebyte@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051759.31052.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sesterhenn <snakebyte@gmx.de>
Date: Fri, 25 Jan 2008 10:40:46 +0100

[This has been in -mm for a while, I don't care if it goes in now or
 next merge]

hi,

since FUTEX_FD was scheduled for removal in June 2007 lets remove it.
Google Code search found no users for it and NGPT was abandoned in 2003
according to IBM. futex.h is left untouched to make sure the id does
not get reassigned. Since queue_me() has no users left it is commented
out to avoid a warning, i didnt remove it completely since it is part
of the internal api (matching unqueue_me())

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (removed rest)
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |  176 +--------------------------------------------------------
 1 file changed, 6 insertions(+), 170 deletions(-)

diff -r a1496ab2d0e2 kernel/futex.c
--- a/kernel/futex.c	Mon Apr 07 15:13:56 2008 +1000
+++ b/kernel/futex.c	Mon Apr 07 15:27:30 2008 +1000
@@ -104,10 +104,6 @@ struct futex_q {
 	/* Key which the futex is hashed on: */
 	union futex_key key;
 
-	/* For fd, sigio sent using these: */
-	int fd;
-	struct file *filp;
-
 	/* Optional priority inheritance state: */
 	struct futex_pi_state *pi_state;
 	struct task_struct *task;
@@ -125,9 +121,6 @@ struct futex_hash_bucket {
 };
 
 static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
-
-/* Futex-fs vfsmount entry: */
-static struct vfsmount *futex_mnt;
 
 /*
  * Take mm->mmap_sem, when futex is shared
@@ -610,8 +603,6 @@ static void wake_futex(struct futex_q *q
 static void wake_futex(struct futex_q *q)
 {
 	plist_del(&q->list, &q->list.plist);
-	if (q->filp)
-		send_sigio(&q->filp->f_owner, q->fd, POLL_IN);
 	/*
 	 * The lock in wake_up_all() is a crucial memory barrier after the
 	 * plist_del() and also before assigning to q->lock_ptr.
@@ -988,13 +979,9 @@ out:
 }
 
 /* The key must be already stored in q->key. */
-static inline struct futex_hash_bucket *
-queue_lock(struct futex_q *q, int fd, struct file *filp)
+static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
-
-	q->fd = fd;
-	q->filp = filp;
 
 	init_waitqueue_head(&q->waiters);
 
@@ -1006,7 +993,7 @@ queue_lock(struct futex_q *q, int fd, st
 	return hb;
 }
 
-static inline void __queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
+static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	int prio;
 
@@ -1040,15 +1027,6 @@ queue_unlock(struct futex_q *q, struct f
  * queue_me and unqueue_me must be called as a pair, each
  * exactly once.  They are called with the hashed spinlock held.
  */
-
-/* The key must be already stored in q->key. */
-static void queue_me(struct futex_q *q, int fd, struct file *filp)
-{
-	struct futex_hash_bucket *hb;
-
-	hb = queue_lock(q, fd, filp);
-	__queue_me(q, hb);
-}
 
 /* Return 1 if we were still queued (ie. 0 means we were woken) */
 static int unqueue_me(struct futex_q *q)
@@ -1194,7 +1172,7 @@ static int futex_wait(u32 __user *uaddr,
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
-	hb = queue_lock(&q, -1, NULL);
+	hb = queue_lock(&q);
 
 	/*
 	 * Access the page AFTER the futex is queued.
@@ -1238,7 +1216,7 @@ static int futex_wait(u32 __user *uaddr,
 		goto out_unlock_release_sem;
 
 	/* Only actually queue if *uaddr contained val.  */
-	__queue_me(&q, hb);
+	queue_me(&q, hb);
 
 	/*
 	 * Now the futex is queued and we have checked the data, we
@@ -1381,7 +1359,7 @@ static int futex_lock_pi(u32 __user *uad
 		goto out_release_sem;
 
  retry_unlocked:
-	hb = queue_lock(&q, -1, NULL);
+	hb = queue_lock(&q);
 
  retry_locked:
 	ret = lock_taken = 0;
@@ -1494,7 +1472,7 @@ static int futex_lock_pi(u32 __user *uad
 	/*
 	 * Only actually queue now that the atomic ops are done:
 	 */
-	__queue_me(&q, hb);
+	queue_me(&q, hb);
 
 	/*
 	 * Now the futex is queued and we have checked the data, we
@@ -1733,121 +1711,6 @@ pi_faulted:
 		goto retry;
 
 	return ret;
-}
-
-static int futex_close(struct inode *inode, struct file *filp)
-{
-	struct futex_q *q = filp->private_data;
-
-	unqueue_me(q);
-	kfree(q);
-
-	return 0;
-}
-
-/* This is one-shot: once it's gone off you need a new fd */
-static unsigned int futex_poll(struct file *filp,
-			       struct poll_table_struct *wait)
-{
-	struct futex_q *q = filp->private_data;
-	int ret = 0;
-
-	poll_wait(filp, &q->waiters, wait);
-
-	/*
-	 * plist_node_empty() is safe here without any lock.
-	 * q->lock_ptr != 0 is not safe, because of ordering against wakeup.
-	 */
-	if (plist_node_empty(&q->list))
-		ret = POLLIN | POLLRDNORM;
-
-	return ret;
-}
-
-static const struct file_operations futex_fops = {
-	.release	= futex_close,
-	.poll		= futex_poll,
-};
-
-/*
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
 }
 
 /*
@@ -2081,10 +1944,6 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_WAKE_BITSET:
 		ret = futex_wake(uaddr, fshared, val, val3);
 		break;
-	case FUTEX_FD:
-		/* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
-		ret = futex_fd(uaddr, val);
-		break;
 	case FUTEX_REQUEUE:
 		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
 		break;
@@ -2145,19 +2004,6 @@ asmlinkage long sys_futex(u32 __user *ua
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
 
-static int futexfs_get_sb(struct file_system_type *fs_type,
-			  int flags, const char *dev_name, void *data,
-			  struct vfsmount *mnt)
-{
-	return get_sb_pseudo(fs_type, "futex", NULL, FUTEXFS_SUPER_MAGIC, mnt);
-}
-
-static struct file_system_type futex_fs_type = {
-	.name		= "futexfs",
-	.get_sb		= futexfs_get_sb,
-	.kill_sb	= kill_anon_super,
-};
-
 static int __init futex_init(void)
 {
 	u32 curval;
@@ -2182,16 +2028,6 @@ static int __init futex_init(void)
 		spin_lock_init(&futex_queues[i].lock);
 	}
 
-	i = register_filesystem(&futex_fs_type);
-	if (i)
-		return i;
-
-	futex_mnt = kern_mount(&futex_fs_type);
-	if (IS_ERR(futex_mnt)) {
-		unregister_filesystem(&futex_fs_type);
-		return PTR_ERR(futex_mnt);
-	}
-
 	return 0;
 }
 __initcall(futex_init);
