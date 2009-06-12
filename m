Return-Path: <linux-kernel-owner+w=401wt.eu-S1763218AbZFLIkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763218AbZFLIkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZFLIkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:40:04 -0400
Received: from www.tglx.de ([62.245.132.106]:37107 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbZFLIkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:40:00 -0400
Date: Fri, 12 Jun 2009 10:39:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
In-Reply-To: <alpine.LFD.2.00.0906121010210.3369@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906121036220.3369@localhost.localdomain>
References: <1244689688.2560.268.camel@ymzhang>  <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>  <1244709196.2560.287.camel@ymzhang>  <1244720183.6691.214.camel@laptop> <1244768378.2560.297.camel@ymzhang>
 <alpine.LFD.2.00.0906121010210.3369@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Thomas Gleixner wrote:
> On Fri, 12 Jun 2009, Zhang, Yanmin wrote:
> > On Thu, 2009-06-11 at 13:36 +0200, Peter Zijlstra wrote:
> > > FWIW, using a private futex on a shm section is wrong in and of itself.
> >
> > What I mean is it could be used as a DOS attack.
> 
> Right. Fix is on the way.
>  
> > Did you try my test case? Could you kill it when it runs?
> 
> No, you can not kill it. That's why it needs a proper fix. Will send
> out today.

Can you please verify the patch below ? It's against 2.6.30.

Thanks,

	tglx

-------------->
futex: Fix the write access fault problem for real
    
commit 64d1304a64 (futex: setup writeable mapping for futex ops which
modify user space data) did address only half of the problem of write
access faults.
    
The patch was made on two wrong assumptions:
    
1) access_ok(VERIFY_WRITE,...) would actually check write access.
  
   On x86 it does _NOT_. It's a pure address range check.
    
2) a RW mapped region can not go away under us.
    
   That's wrong as well. Nobody can prevent another thread to call
   mprotect(PROT_READ) on that region where the futex resides. If that
   call hits between the get_user_pages_fast() verification and the
   actual write access in the atomic region we are toast again.
    
   The solution is to not rely on access_ok and get_user() for any write
   access related fault on private and shared futexes. Instead we need to
   go through get_user_pages_fast() in the fault path to avoid any of the
   above pitfalls. If get_user_pages_fast() returns -EFAULT we know that
   we can not fix it anymore and need to bail out to user space.
    
   Remove a bunch of confusing comments on this issue as well.
    
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

Index: linux-2.6-tip/kernel/futex.c
===================================================================
--- linux-2.6-tip.orig/kernel/futex.c
+++ linux-2.6-tip/kernel/futex.c
@@ -278,6 +278,31 @@ void put_futex_key(int fshared, union fu
 	drop_futex_key_refs(key);
 }
 
+/*
+ * get_user_writeable - get user page and verify RW access
+ * @uaddr:	pointer to faulting user space address
+ *
+ * We cannot write to the user space address and get_user just faults
+ * the page in, but does not tell us whether the mapping is writeable.
+ *
+ * We can not rely on access_ok() for private futexes as it is just a
+ * range check and we can neither rely on get_user_pages() as there
+ * might be a mprotect(PROT_READ) for that mapping after
+ * get_user_pages() and before the fault in the atomic write access.
+ */
+static int get_user_writeable(u32 __user *uaddr)
+{
+	unsigned long addr = (unsigned long)uaddr;
+	struct page *page;
+	int ret;
+
+	ret = get_user_pages_fast(addr, 1, 1, &page);
+	if (!ret)
+		put_page(page);
+
+	return ret;
+}
+
 static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
 {
 	u32 curval;
@@ -739,7 +764,6 @@ retry:
 retry_private:
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
-		u32 dummy;
 
 		double_unlock_hb(hb1, hb2);
 
@@ -757,7 +781,7 @@ retry_private:
 			goto out_put_keys;
 		}
 
-		ret = get_user(dummy, uaddr2);
+		ret = get_user_writeable(uaddr2);
 		if (ret)
 			goto out_put_keys;
 
@@ -1097,7 +1121,7 @@ retry:
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = get_user(uval, uaddr);
+	ret = get_user_writeable(uaddr);
 
 	spin_lock(q->lock_ptr);
 
@@ -1552,16 +1576,9 @@ out:
 	return ret;
 
 uaddr_faulted:
-	/*
-	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
-	 * atomically.  Therefore, if we continue to fault after get_user()
-	 * below, we need to handle the fault ourselves, while still holding
-	 * the mmap_sem.  This can occur if the uaddr is under contention as
-	 * we have to drop the mmap_sem in order to call get_user().
-	 */
 	queue_unlock(&q, hb);
 
-	ret = get_user(uval, uaddr);
+	ret = get_user_writeable(uaddr);
 	if (ret)
 		goto out_put_key;
 
@@ -1657,17 +1674,10 @@ out:
 	return ret;
 
 pi_faulted:
-	/*
-	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
-	 * atomically.  Therefore, if we continue to fault after get_user()
-	 * below, we need to handle the fault ourselves, while still holding
-	 * the mmap_sem.  This can occur if the uaddr is under contention as
-	 * we have to drop the mmap_sem in order to call get_user().
-	 */
 	spin_unlock(&hb->lock);
 	put_futex_key(fshared, &key);
 
-	ret = get_user(uval, uaddr);
+	ret = get_user_writeable(uaddr);
 	if (!ret)
 		goto retry;
 
