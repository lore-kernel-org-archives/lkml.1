Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZCIPuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZCIPuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZCIPum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:50:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47135 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZCIPul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:50:41 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com
Cc: bcrl@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch] aio: remove aio-max-nr and instead use the memlock rlimit to limit the number of pages pinned for the aio completion ring
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 09 Mar 2009 11:49:57 -0400
Message-ID: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Believe it or not, I get numerous questions from customers about the
suggested tuning value of aio-max-nr.  aio-max-nr limits the total
number of io events that can be reserved, system wide, for aio
completions.  Each time io_setup is called, a ring buffer is allocated
that can hold nr_events I/O completions.  That ring buffer is then
mapped into the process' address space, and the pages are pinned in
memory.  So, the reason for this upper limit (I believe) is to keep a
malicious user from pinning all of kernel memory.  Now, this sounds like
a much better job for the memlock rlimit to me, hence the following
patch.

It's worth noting that, by default, aio-max-nr was set to 65536
requests.  By default, the memlock rlimit is set to 64kb per process.
With this patch in place, a single process can specify 2045 for the
nr_events parameter of io_setup.  Or, for the worst case scenario, a
process can only create 16 io contexts, each with a single event (since
the minimum ring size is a page).

I created a simple program that sets the process' memlock rlimit and
then drops the CAP_IPC_LOCK capability (the memlock rlimit is a command
line parameter, so you can see how the nr_events allowable changes with
different limits in place).  Then, it calls io_setup/io_destroy in a
loop, increasing nr_events until it fails.  Finally, it calls io_setup
in a loop with a single event to see how many iterations it can perform
before receiving -EAGAIN.  I ran the test on a patched kernel and the
results are in line with expectations.

I also ran the aio-dio-regress regression tests, and all passed but
one.  The one that failed only failed due to an expected return code of
-ENOMEM, and instead got -EAGAIN.  Part of the patch below returns a
proper error code from aio_setup_ring.  So, I'm calling this a test
issue, but we can debate this nuance if it is deemed important.

Further, as a result of this exercise, I noticed that there are numerous
places in the kernel that test to see if locking memory will exceed the
maximum amount of allowed locked memory.  I've factored out that bit of
code in a follow-on patch that I will post.

Finally, I updated the aio man pages to reflect this change (and fix
references to aio_context_t that should be io_context_t).

You can find a copy of the test program I used at:
  http://people.redhat.com/jmoyer/aio/ioctx_alloc.c
I'll apologize in advance for the crudity of the test code.

For those reviewing the below patch, it may be worth looking at:

commit d55b5fdaf40846221d543937b786956e27837fda
Author: Zach Brown <zach.brown@oracle.com>
Date:   Mon Nov 7 00:59:31 2005 -0800

    [PATCH] aio: remove aio_max_nr accounting race

The below patch basically reverts the above commit.  There is no
accounting race now, because we are charging per-process rlimits instead
of a system-wide maximum number of aio requests.  This has the added
benefit of reducing some code complexity.

Comments and suggestions are encouraged.  I'll follow up with the other
two patches I mentioned shortly.

Thanks!
Jeff

diff --git a/fs/aio.c b/fs/aio.c
index 8fa77e2..3bbda9d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -43,9 +43,8 @@
 #endif
 
 /*------ sysctl variables----*/
-static DEFINE_SPINLOCK(aio_nr_lock);
-unsigned long aio_nr;		/* current system wide number of aio requests */
-unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
+/* current system wide number of aio requests */
+atomic_t aio_nr = ATOMIC_INIT(0);
 /*----end sysctl variables---*/
 
 static struct kmem_cache	*kiocb_cachep;
@@ -90,6 +89,7 @@ static void aio_free_ring(struct kioctx *ctx)
 	if (info->mmap_size) {
 		down_write(&ctx->mm->mmap_sem);
 		do_munmap(ctx->mm, info->mmap_base, info->mmap_size);
+		ctx->mm->locked_vm -= info->nr_pages;
 		up_write(&ctx->mm->mmap_sem);
 	}
 
@@ -106,6 +106,8 @@ static int aio_setup_ring(struct kioctx *ctx)
 	unsigned nr_events = ctx->max_reqs;
 	unsigned long size;
 	int nr_pages;
+	unsigned long locked;
+	unsigned long lock_limit;
 
 	/* Compensate for the ring buffer's head/tail overlap entry */
 	nr_events += 2;	/* 1 is required, 2 for good luck */
@@ -130,6 +132,20 @@ static int aio_setup_ring(struct kioctx *ctx)
 	info->mmap_size = nr_pages * PAGE_SIZE;
 	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
 	down_write(&ctx->mm->mmap_sem);
+	/*
+	 * Check that the memory reserved for the completion ring does
+	 * not exceed the memlock memory limit.
+	 */
+	locked = nr_pages + ctx->mm->locked_vm;
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit >>= PAGE_SHIFT;
+	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		up_write(&ctx->mm->mmap_sem);
+		info->mmap_size = 0;
+		aio_free_ring(ctx);
+		return -EAGAIN;
+	}
+
 	info->mmap_base = do_mmap(NULL, 0, info->mmap_size, 
 				  PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
 				  0);
@@ -144,6 +160,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	info->nr_pages = get_user_pages(current, ctx->mm,
 					info->mmap_base, nr_pages, 
 					1, 0, info->ring_pages, NULL);
+	ctx->mm->locked_vm += info->nr_pages;
 	up_write(&ctx->mm->mmap_sem);
 
 	if (unlikely(info->nr_pages != nr_pages)) {
@@ -194,16 +211,8 @@ static int aio_setup_ring(struct kioctx *ctx)
 static void ctx_rcu_free(struct rcu_head *head)
 {
 	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
-	unsigned nr_events = ctx->max_reqs;
 
 	kmem_cache_free(kioctx_cachep, ctx);
-
-	if (nr_events) {
-		spin_lock(&aio_nr_lock);
-		BUG_ON(aio_nr - nr_events > aio_nr);
-		aio_nr -= nr_events;
-		spin_unlock(&aio_nr_lock);
-	}
 }
 
 /* __put_ioctx
@@ -217,6 +226,7 @@ static void __put_ioctx(struct kioctx *ctx)
 	cancel_delayed_work(&ctx->wq);
 	cancel_work_sync(&ctx->wq.work);
 	aio_free_ring(ctx);
+	atomic_sub(ctx->max_reqs, &aio_nr);
 	mmdrop(ctx->mm);
 	ctx->mm = NULL;
 	pr_debug("__put_ioctx: freeing %p\n", ctx);
@@ -240,7 +250,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 {
 	struct mm_struct *mm;
 	struct kioctx *ctx;
-	int did_sync = 0;
+	int ret;
 
 	/* Prevent overflows */
 	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
@@ -249,9 +259,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 		return ERR_PTR(-EINVAL);
 	}
 
-	if ((unsigned long)nr_events > aio_max_nr)
-		return ERR_PTR(-EAGAIN);
-
 	ctx = kmem_cache_zalloc(kioctx_cachep, GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
@@ -269,26 +276,11 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	INIT_LIST_HEAD(&ctx->run_list);
 	INIT_DELAYED_WORK(&ctx->wq, aio_kick_handler);
 
-	if (aio_setup_ring(ctx) < 0)
+	if ((ret = aio_setup_ring(ctx)) < 0)
 		goto out_freectx;
 
-	/* limit the number of system wide aios */
-	do {
-		spin_lock_bh(&aio_nr_lock);
-		if (aio_nr + nr_events > aio_max_nr ||
-		    aio_nr + nr_events < aio_nr)
-			ctx->max_reqs = 0;
-		else
-			aio_nr += ctx->max_reqs;
-		spin_unlock_bh(&aio_nr_lock);
-		if (ctx->max_reqs || did_sync)
-			break;
-
-		/* wait for rcu callbacks to have completed before giving up */
-		synchronize_rcu();
-		did_sync = 1;
-		ctx->max_reqs = nr_events;
-	} while (1);
+	/* update the number of system wide aios */
+	atomic_add(ctx->max_reqs, &aio_nr);  /* undone by __put_ioctx */
 
 	if (ctx->max_reqs == 0)
 		goto out_cleanup;
@@ -309,7 +301,7 @@ out_cleanup:
 out_freectx:
 	mmdrop(mm);
 	kmem_cache_free(kioctx_cachep, ctx);
-	ctx = ERR_PTR(-ENOMEM);
+	ctx = ERR_PTR(ret);
 
 	dprintk("aio: error allocating ioctx %p\n", ctx);
 	return ctx;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index b16a957..09ec393 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -233,7 +233,6 @@ static inline struct kiocb *list_kiocb(struct list_head *h)
 }
 
 /* for sysctl: */
-extern unsigned long aio_nr;
-extern unsigned long aio_max_nr;
+extern atomic_t aio_nr;
 
 #endif /* __LINUX__AIO_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..32ced38 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1385,14 +1385,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &aio_nr,
 		.maxlen		= sizeof(aio_nr),
 		.mode		= 0444,
-		.proc_handler	= &proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "aio-max-nr",
-		.data		= &aio_max_nr,
-		.maxlen		= sizeof(aio_max_nr),
-		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dointvec,
 	},
 #endif /* CONFIG_AIO */
 #ifdef CONFIG_INOTIFY_USER
