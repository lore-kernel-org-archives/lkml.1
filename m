Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbZLOKU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbZLOKU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759662AbZLOKUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:20:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759661AbZLOKUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:20:47 -0500
Date: Tue, 15 Dec 2009 11:19:59 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 3/4 -mmotm] copy_signal() cleanup: clean
	thread_group_cputime_init()
Message-ID: <20091215101959.GD9134@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142814.GH10052@darkmag.usersys.redhat.com> <20091207123615.fc841a83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207123615.fc841a83.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded initializations in thread_group_cputime_init() and
in posix_cpu_timers_init_group(). They are useless after 
kmem_cache_zalloc() was used in copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 23b26c7..c26bdb8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2434,9 +2434,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	sig->cputimer.cputime = INIT_CPUTIME;
 	spin_lock_init(&sig->cputimer.lock);
-	sig->cputimer.running = 0;
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
diff --git a/kernel/fork.c b/kernel/fork.c
index 404e6ca..a9252bf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -829,17 +829,6 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
-	/* Expiration times and increments. */
-	sig->it[CPUCLOCK_PROF].expires = cputime_zero;
-	sig->it[CPUCLOCK_PROF].incr = cputime_zero;
-	sig->it[CPUCLOCK_VIRT].expires = cputime_zero;
-	sig->it[CPUCLOCK_VIRT].incr = cputime_zero;
-
-	/* Cached expiration times. */
-	sig->cputime_expires.prof_exp = cputime_zero;
-	sig->cputime_expires.virt_exp = cputime_zero;
-	sig->cputime_expires.sched_exp = 0;
-
 	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 	if (cpu_limit != RLIM_INFINITY) {
 		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
