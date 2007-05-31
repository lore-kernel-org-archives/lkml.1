Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbXEaCxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbXEaCxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 22:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXEaCxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 22:53:33 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:57384 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbXEaCxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 22:53:33 -0400
Subject: [PATCH RT] fix faulting bomb in futex_unlock_pi64
From: Steven Rostedt <rostedt@goodmis.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <1180572567.6126.44.camel@localhost.localdomain>
References: <1180572567.6126.44.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 30 May 2007 22:52:33 -0400
Message-Id: <1180579953.21781.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing Uli because John forgot to with the original patch]

As John found with futex_unlock_pi (which that patch should apply nicely
to the -rt tree), the code can get screwed up with faulting in at the
cmpxchg in futex_unlock_pi code.

>From John's original email:

----
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
                uval = futex_atomic_cmpxchg_inatomic(uaddr,
current->pid, 0);
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
----


We see that uval is -EFAULT when jumping to pi_faulted. But when it goes
back to retry_locked, the uval is still -EFAULT. Which just happens to
have the FUTEX_OWNER_DIED bit set.  So we don't do the
futex_atomic_cmpxchg_inatomic call, and go to the next conditional which
just so happens to be a check of uval for -EFAULT. And guess what? it
still is!!

Way to go John in finding this!!

But, the -rt kernel has pretty much the same code for the
futex_unlock_pi64, and it has the same bug. Hence this email.

This patch is the same fix that John posted, but simply for the
futex_unlock_pi64 that exists in the RT kernel and not the mainline.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-rt-work/kernel/futex.c
===================================================================
--- linux-2.6-rt-work.orig/kernel/futex.c	2007-05-30 22:29:04.000000000 -0400
+++ linux-2.6-rt-work/kernel/futex.c	2007-05-30 22:32:01.000000000 -0400
@@ -3503,6 +3503,7 @@ pi_faulted:
 			ret = -EFAULT;
 			goto out_unlock;
 		}
+		uval = 0;
 		goto retry_locked;
 	}
 


