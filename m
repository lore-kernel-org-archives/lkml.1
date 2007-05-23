Return-Path: <linux-kernel-owner+w=401wt.eu-S1764219AbXEWLwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764219AbXEWLwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759763AbXEWLw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:52:29 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:58376 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759006AbXEWLw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:52:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=E4tpbOaO7bhMpZUYJjCOGiAqIygL+O/S8KKEe90jpqIZZZ5rhWtYjOhXIIPfr3ykCZYj/Ldk2G5fkuxlgx4d0dB2ZSoFh3doU4k4NXi8MlSryaOhAOaD3BENZaw0FGJ7iEVTOEFVPc84X8Y1znCgJ+LCw0WfBPw9oyecT2bJGH0=;
Date: Wed, 23 May 2007 15:51:59 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
Message-ID: <20070523115159.GA30251@ms2.inr.ac.ru>
References: <20070507144351.GA12302@ms2.inr.ac.ru> <20070523072609.GC6859@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523072609.GC6859@elte.hu>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> #2 crash be explained via any of the bugs you fixed? (i.e. memory
> corruption?)

Yes, I found the reason, it is really fixed by taking tasklist_lock.
This happens after task struct with not cleared pi_state_list is freed
and the list of futex_pi_state's is corrupted.


Meanwhile... two more bugs were found.

The first chunk: results in self-inflicted deadlock inside glibc.
Sometimes futex_lock_pi returns -ESRCH, when it is not expected
and glibc enters to for(;;) sleep() to simulate deadlock. This problem
is quite obvious and I think the patch is right. Though it looks like
each "if" in futex_lock_pi() got some stupid special case "else if". :-)


The second chunk: sometimes futex_lock_pi() returns -EDEADLK,
when nobody has the lock. The reason is also obvious (see comment
in the patch), but correct fix is far beyond my comprehension.
I guess someone already saw this, the chunk:

                        if (rt_mutex_trylock(&q.pi_state->pi_mutex))
                                ret = 0;

is obviously from the same opera. But it does not work, because the
rtmutex is really taken at this point: wake_futex_pi() of previous
owner reassigned it to us. My fix works. But it looks very stupid.
I would think about removal of shift of ownership in wake_futex_pi()
and making all the work in context of process taking lock.

Both bugs show up when running glibc's tst-robustpi8 long enough.

Yes, all this about pre May 8 futexes. Seems, updates did not change
anything in logic, but I am not sure.


--- kernel/futex.c.intermediate	2007-05-23 14:48:27.000000000 +0400
+++ kernel/futex.c	2007-05-23 14:58:06.000000000 +0400
@@ -1244,8 +1244,21 @@ static int futex_lock_pi(u32 __user *uad
 			if (unlikely(curval != uval))
 				goto retry_locked;
 			ret = 0;
-		}
-		goto out_unlock_release_sem;
+		} else if (ret == -ESRCH) {
+			/* Process could exit right now, so that robust list
+			 * was processed after we got uval. Retry. */
+			pagefault_disable();
+			curval = futex_atomic_cmpxchg_inatomic(uaddr,
+							       uval, uval);
+			pagefault_enable();
+			if (unlikely(curval == -EFAULT))
+				goto uaddr_faulted;
+			if (unlikely(curval != uval)) {
+				printk("RETRY %x %x %x\n", current->pid, uval, curval);
+				goto retry_locked;
+			}
+ 		}
+ 		goto out_unlock_release_sem;
 	}
 
 	/*
@@ -1361,6 +1374,22 @@ static int futex_lock_pi(u32 __user *uad
 		if (ret && q.pi_state->owner == curr) {
 			if (rt_mutex_trylock(&q.pi_state->pi_mutex))
 				ret = 0;
+			/* Holy crap... Now futex lock returns -EDEADLK
+			 * sometimes, because ownership was passed to us while
+			 * unlock of previous owner. Who wrote this?
+			 * Please, fix this correctly. For now:
+			 */
+			if (ret == -EDEADLK) {
+				pagefault_disable();
+				uval = futex_atomic_cmpxchg_inatomic(uaddr,
+								     0, 0);
+				pagefault_enable();
+				if (uval != -EFAULT &&
+				    (uval&FUTEX_TID_MASK) == current->pid) {
+					printk("ALERT1 %x\n", uval);
+					ret = 0;
+				}
+			}
 		}
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q, hb);
