Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXEaAty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXEaAty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXEaAtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:49:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59771 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXEaAtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:49:46 -0400
Subject: [BUG] futex_unlock_pi() hurts my brain and may cause application
	deadlock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Sripathi Kodi <sripathik@in.ibm.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 17:49:27 -0700
Message-Id: <1180572567.6126.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,
	So we've been seeing PI mutex deadlocks with a few of our applications
using the -rt kernel. After narrowing things down, we were finding that
the applications were indirectly calling futex_unlock_pi(), which on
occasion would return -EFAULT, which is promptly ignored by glibc. This
would cause the application to continue on as if it has unlocked the
mutex, until it tried to reacquire it and deadlock.

In looking into why the kernel was returning -EFAULT, I found the
following:

...
retry_locked:
	/*
	 * To avoid races, try to do the TID -> 0 atomic transition
	 * again. If it succeeds then we can return without waking
	 * anyone else up:
	 */
	if (!(uval & FUTEX_OWNER_DIED)) {
		pagefault_disable();
		uval = futex_atomic_cmpxchg_inatomic(uaddr, current->pid, 0);
		pagefault_enable();
	}

	if (unlikely(uval == -EFAULT))
		goto pi_faulted;
...[snip]...
pi_faulted:
	/*
	 * We have to r/w  *(int __user *)uaddr, but we can't modify it
	 * non-atomically.  Therefore, if get_user below is not
	 * enough, we need to handle the fault ourselves, while
	 * still holding the mmap_sem.
	 */
	if (attempt++) {
		ret = futex_handle_fault((unsigned long)uaddr, fshared,
					 attempt);
		if (ret)
			goto out_unlock;
		goto retry_locked;
	}


Should we fault through normal causes, on the second round we call
futex_handle_fault, which faults in the address, and we then jump back
to retry_locked. However, since uval is -EFAULT from the last cmpxchg,
it &s w/ FUTEX_OWNER_DIED so we don't enter the first conditional to try
to cmpxchg again. So since uval is still -EFAULT, we loop back to
pi_faulted! This will loop until futex_handle_fault() bombs out because
attempt is too big and we return -EFAULT.

I *think* this is a possible quick fix here, but I'm no futex guru, so I
wanted to run it by folks for review.

Big thanks to Sripathi and Angela Lin for helping debug this, and Steven
for suggesting a cleaner fix then what I first tried.

thanks
-john

Avoid futex_unlock_pi returning -EFAULT (which results in deadlock), by
clearing uval before jumping to retry_locked.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
diff --git a/kernel/futex.c b/kernel/futex.c
index b7ce15c..9969b36 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2011,6 +2011,7 @@ pi_faulted:
 					 attempt);
 		if (ret)
 			goto out_unlock;
+		uval = 0;
 		goto retry_locked;
 	}
 


