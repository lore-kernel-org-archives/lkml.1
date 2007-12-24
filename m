Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXLXBZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXLXBZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 20:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbXLXBZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 20:25:43 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1171 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbXLXBZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 20:25:43 -0500
Date: Mon, 24 Dec 2007 09:25:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trem <tremyfr@yahoo.fr>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071224012524.GA21843@gondor.apana.org.au>
References: <9DtBq-2jD-3@gated-at.bofh.it> <476EAF98.6040004@yahoo.fr> <20071223121410.0d572e03.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223121410.0d572e03.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 12:14:10PM -0800, Andrew Morton wrote:
>
> No, the problem is that include/crypto/scatterwalk.h doesn't include enough
> header files to support its inlining fetish.  It needs sched.h.

I'll get it fixed in cryptodev.

> Ingo, it's not good that we have cond_resched() definitions conditionally
> duplicated in kernel.h - that's increasing the risk of bugs like this one.

Actually, why do we even have cond_resched when real preemption
is on? It seems to be a waste of space and time.

Any objections to something like this to remove cond_resched with
CONFIG_PREEMPT on (apart from the potential to uncover more bugs
like this one)?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..a7283c9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -105,8 +105,8 @@ struct user;
  * supposed to.
  */
 #ifdef CONFIG_PREEMPT_VOLUNTARY
-extern int cond_resched(void);
-# define might_resched() cond_resched()
+extern int _cond_resched(void);
+# define might_resched() _cond_resched()
 #else
 # define might_resched() do { } while (0)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac3d496..ae8e9bd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1863,7 +1863,18 @@ static inline int need_resched(void)
  * cond_resched_lock() will drop the spinlock before scheduling,
  * cond_resched_softirq() will enable bhs before scheduling.
  */
-extern int cond_resched(void);
+#ifdef CONFIG_PREEMPT
+static inline int cond_resched(void)
+{
+	return 0;
+}
+#else
+extern int _cond_resched(void);
+static inline int cond_resched(void)
+{
+	return _cond_resched();
+}
+#endif
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 3df84ea..2dc2bbf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4683,7 +4683,8 @@ static void __cond_resched(void)
 	} while (need_resched());
 }
 
-int __sched cond_resched(void)
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_VOLUNTARY)
+int __sched _cond_resched(void)
 {
 	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
 					system_state == SYSTEM_RUNNING) {
@@ -4692,7 +4693,8 @@ int __sched cond_resched(void)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(cond_resched);
+EXPORT_SYMBOL(_cond_resched);
+#endif
 
 /*
  * cond_resched_lock() - if a reschedule is pending, drop the given lock,
