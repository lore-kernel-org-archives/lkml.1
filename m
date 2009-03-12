Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZCLNoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZCLNoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZCLNoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:44:10 -0400
Received: from www.tglx.de ([62.245.132.106]:46538 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbZCLNoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:44:09 -0400
Date: Thu, 12 Mar 2009 14:42:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/6] Additional (get|put)_futex_key() fixes
In-Reply-To: <20090312101636.GB7157@elte.hu>
Message-ID: <alpine.LFD.2.00.0903121207520.29264@localhost.localdomain>
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075545.9856.75152.stgit@Aeon> <20090312101636.GB7157@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Ingo Molnar wrote:
> 
> * Darren Hart <dvhltc@us.ibm.com> wrote:
> 
> > futex_requeue and futex_lock_pi still had some bad 
> > (get|put)_futex_key() usage. This patch adds the missing 
> > put_futex_keys() and corrects a goto in futex_lock_pi() to 
> > avoid a double get.
> > 
> > Build and boot tested on a 4 way Intel x86_64 workstation.  
> > Passes basic pthread_mutex and PI tests out of 
> > ltp/testcases/realtime.
> 
> hm, how bad is the impact - do we need this in v2.6.29?

I think so. We leak key references in some of the error/retry code
pathes.  Darrens patch does not apply to mainline. Backport below.

Thanks,

	tglx
---
Subject: futex: fix key reference leaks
From: Darren Hart <dvhltc@us.ibm.com>
Date: Thu, 12 Mar 2009 12:10:01 +0100

Impact: bugfix

futex_wake_op, futex_requeue, futex_lock_pi and futex_unlock_pi still
had some bad (get|put)_futex_key() usage. This patch adds the missing
put_futex_keys() and corrects a goto in futex_lock_pi() to avoid a
double get.

[ tglx: backport to mainline ]

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---

 kernel/futex.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -803,6 +803,9 @@ retry:
 			goto retry;
 		}
 
+		put_futex_key(fshared, &key2);
+		put_futex_key(fshared, &key1);
+
 		ret = get_user(dummy, uaddr2);
 		if (ret)
 			return ret;
@@ -881,12 +884,15 @@ retry:
 			if (hb1 != hb2)
 				spin_unlock(&hb2->lock);
 
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
+
 			ret = get_user(curval, uaddr1);
 
 			if (!ret)
 				goto retry;
 
-			goto out_put_keys;
+			return ret;
 		}
 		if (curval != *cmpval) {
 			ret = -EAGAIN;
@@ -1459,7 +1465,7 @@ retry_locked:
 			 */
 			queue_unlock(&q, hb);
 			cond_resched();
-			goto retry;
+			goto retry_unlocked;
 
 		case -ESRCH:
 			/*
@@ -1598,6 +1604,7 @@ uaddr_faulted:
 		goto retry_unlocked;
 	}
 
+	put_futex_key(fshared, &q.key);
 	ret = get_user(uval, uaddr);
 	if (!ret)
 		goto retry;
@@ -1709,6 +1716,8 @@ pi_faulted:
 		goto retry_unlocked;
 	}
 
+	put_futex_key(fshared, &key);
+
 	ret = get_user(uval, uaddr);
 	if (!ret)
 		goto retry;
