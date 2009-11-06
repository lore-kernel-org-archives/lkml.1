Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbZKFWqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbZKFWqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbZKFWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:28 -0500
Received: from kroah.org ([198.145.64.141]:56651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760087AbZKFWWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:40 2009
Message-Id: <20091106221539.906129663@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [09/99] futex: Handle spurious wake up
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=futex-handle-spurious-wake-up.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit d58e6576b0deec6f0b9ff8450fe282da18c50883 upstream.

The futex code does not handle spurious wake up in futex_wait and
futex_wait_requeue_pi.

The code assumes that any wake up which was not caused by futex_wake /
requeue or by a timeout was caused by a signal wake up and returns one
of the syscall restart error codes.

In case of a spurious wake up the signal delivery code which deals
with the restart error codes is not invoked and we return that error
code to user space. That causes applications which actually check the
return codes to fail. Blaise reported that on preempt-rt a python test
program run into a exception trap. -rt exposed that due to a built in
spurious wake up accelerator :)

Solve this by checking signal_pending(current) in the wake up path and
handle the spurious wake up case w/o returning to user space.

Reported-by: Blaise Gassend <blaise@willowgarage.com>
Debugged-by: Darren Hart <dvhltc@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1767,6 +1767,7 @@ static int futex_wait(u32 __user *uaddr,
 					     current->timer_slack_ns);
 	}
 
+retry:
 	/* Prepare to wait on uaddr. */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
@@ -1784,9 +1785,14 @@ static int futex_wait(u32 __user *uaddr,
 		goto out_put_key;
 
 	/*
-	 * We expect signal_pending(current), but another thread may
-	 * have handled it for us already.
+	 * We expect signal_pending(current), but we might be the
+	 * victim of a spurious wakeup as well.
 	 */
+	if (!signal_pending(current)) {
+		put_futex_key(fshared, &q.key);
+		goto retry;
+	}
+
 	ret = -ERESTARTSYS;
 	if (!abs_time)
 		goto out_put_key;
@@ -2094,9 +2100,11 @@ int handle_early_requeue_pi_wakeup(struc
 		 */
 		plist_del(&q->list, &q->list.plist);
 
+		/* Handle spurious wakeups gracefully */
+		ret = -EAGAIN;
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
-		else
+		else if (signal_pending(current))
 			ret = -ERESTARTNOINTR;
 	}
 	return ret;
@@ -2174,6 +2182,7 @@ static int futex_wait_requeue_pi(u32 __u
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
+retry:
 	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
@@ -2271,6 +2280,9 @@ out_put_keys:
 out_key2:
 	put_futex_key(fshared, &key2);
 
+	/* Spurious wakeup ? */
+	if (ret == -EAGAIN)
+		goto retry;
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);


