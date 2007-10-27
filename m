Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbXJ0OSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbXJ0OSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXJ0OSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:18:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56334 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751543AbXJ0OST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:18:19 -0400
Date: Sat, 27 Oct 2007 16:18:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: rusty@rustcorp.com.au
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] lguest_user.c: fix memory leak
Message-ID: <20071027141840.GU30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/lguest/lguest_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6/drivers/lguest/lguest_user.c.old	2007-10-27 04:48:14.000000000 +0200
+++ linux-2.6/drivers/lguest/lguest_user.c	2007-10-27 04:48:49.000000000 +0200
@@ -127,121 +127,121 @@ static int initialize(struct file *file,
 	lg = kzalloc(sizeof(*lg), GFP_KERNEL);
 	if (!lg) {
 		err = -ENOMEM;
 		goto unlock;
 	}
 
 	/* Populate the easy fields of our "struct lguest" */
 	lg->mem_base = (void __user *)(long)args[0];
 	lg->pfn_limit = args[1];
 
 	/* We need a complete page for the Guest registers: they are accessible
 	 * to the Guest and we can only grant it access to whole pages. */
 	lg->regs_page = get_zeroed_page(GFP_KERNEL);
 	if (!lg->regs_page) {
 		err = -ENOMEM;
 		goto release_guest;
 	}
 	/* We actually put the registers at the bottom of the page. */
 	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
 
 	/* Initialize the Guest's shadow page tables, using the toplevel
 	 * address the Launcher gave us.  This allocates memory, so can
 	 * fail. */
 	err = init_guest_pagetable(lg, args[2]);
 	if (err)
 		goto free_regs;
 
 	/* Now we initialize the Guest's registers, handing it the start
 	 * address. */
 	lguest_arch_setup_regs(lg, args[3]);
 
 	/* The timer for lguest's clock needs initialization. */
 	init_clockdev(lg);
 
 	/* We keep a pointer to the Launcher task (ie. current task) for when
 	 * other Guests want to wake this one (inter-Guest I/O). */
 	lg->tsk = current;
 	/* We need to keep a pointer to the Launcher's memory map, because if
 	 * the Launcher dies we need to clean it up.  If we don't keep a
 	 * reference, it is destroyed before close() is called. */
 	lg->mm = get_task_mm(lg->tsk);
 
 	/* Initialize the queue for the waker to wait on */
 	init_waitqueue_head(&lg->break_wq);
 
 	/* We remember which CPU's pages this Guest used last, for optimization
 	 * when the same Guest runs on the same CPU twice. */
 	lg->last_pages = NULL;
 
 	/* We keep our "struct lguest" in the file's private_data. */
 	file->private_data = lg;
 
 	mutex_unlock(&lguest_lock);
 
 	/* And because this is a write() call, we return the length used. */
 	return sizeof(args);
 
 free_regs:
 	free_page(lg->regs_page);
 release_guest:
-	memset(lg, 0, sizeof(*lg));
+	kfree(lg);
 unlock:
 	mutex_unlock(&lguest_lock);
 	return err;
 }
 
 /*L:010 The first operation the Launcher does must be a write.  All writes
  * start with an unsigned long number: for the first write this must be
  * LHREQ_INITIALIZE to set up the Guest.  After that the Launcher can use
  * writes of other values to send interrupts. */
 static ssize_t write(struct file *file, const char __user *in,
 		     size_t size, loff_t *off)
 {
 	/* Once the guest is initialized, we hold the "struct lguest" in the
 	 * file private data. */
 	struct lguest *lg = file->private_data;
 	const unsigned long __user *input = (const unsigned long __user *)in;
 	unsigned long req;
 
 	if (get_user(req, input) != 0)
 		return -EFAULT;
 	input++;
 
 	/* If you haven't initialized, you must do that first. */
 	if (req != LHREQ_INITIALIZE && !lg)
 		return -EINVAL;
 
 	/* Once the Guest is dead, all you can do is read() why it died. */
 	if (lg && lg->dead)
 		return -ENOENT;
 
 	/* If you're not the task which owns the Guest, you can only break */
 	if (lg && current != lg->tsk && req != LHREQ_BREAK)
 		return -EPERM;
 
 	switch (req) {
 	case LHREQ_INITIALIZE:
 		return initialize(file, input);
 	case LHREQ_IRQ:
 		return user_send_irq(lg, input);
 	case LHREQ_BREAK:
 		return break_guest_out(lg, input);
 	default:
 		return -EINVAL;
 	}
 }
 
 /*L:060 The final piece of interface code is the close() routine.  It reverses
  * everything done in initialize().  This is usually called because the
  * Launcher exited.
  *
  * Note that the close routine returns 0 or a negative error number: it can't
  * really fail, but it can whine.  I blame Sun for this wart, and K&R C for
  * letting them do it. :*/
 static int close(struct inode *inode, struct file *file)
 {
 	struct lguest *lg = file->private_data;
 
 	/* If we never successfully initialized, there's nothing to clean up */
 	if (!lg)
 		return 0;

