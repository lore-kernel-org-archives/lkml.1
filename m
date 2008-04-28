Return-Path: <linux-kernel-owner+w=401wt.eu-S1765722AbYD1JSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765722AbYD1JSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933035AbYD1JRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:17:53 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:56693 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbYD1JRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:17:52 -0400
Date: Mon, 28 Apr 2008 11:17:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428091745.GB27056@osiris.boeblingen.de.ibm.com>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com> <20080427183926.acb66fff.akpm@linux-foundation.org> <20080428070946.GA4507@osiris.boeblingen.de.ibm.com> <20080428002853.1693e7fd.akpm@linux-foundation.org> <20080428075253.GB4507@osiris.boeblingen.de.ibm.com> <20080428081129.GC4507@osiris.boeblingen.de.ibm.com> <20080428083222.GA16963@elte.hu> <20080428084904.GA27056@osiris.boeblingen.de.ibm.com> <20080428015723.e1632c45.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428015723.e1632c45.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 01:57:23AM -0700, Andrew Morton wrote:
> On Mon, 28 Apr 2008 10:49:04 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> >  /* doms_cur_mutex serializes access to doms_cur[] array */
> > -static DEFINE_MUTEX(doms_cur_mutex);
> > +static DEFINE_MUTEX(sched_domains_mutex);
> 
> The comment refers to a no-longer-existing lock, and no longer correctly
> describes the lock's usage.

version 42. Please feel free to change the comment if you think it could
be better :)

Subject: [PATCH] sched: fix locking in arch_reinit_sched_domains

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Concurrent calls to detach_destroy_domains and arch_init_sched_domains
were prevented by the old scheduler subsystem cpu hotplug mutex. When
this got converted to get_online_cpus() the locking got broken.
Unlike before now several processes can concurrently enter the critical
sections that were protected by the old lock.

So use the already present doms_cur_mutex to protect these sections again.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/sched.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -308,8 +308,10 @@ static DEFINE_PER_CPU(struct rt_rq, init
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
-/* doms_cur_mutex serializes access to doms_cur[] array */
-static DEFINE_MUTEX(doms_cur_mutex);
+/* sched_domains_mutex serializes calls to arch_init_sched_domains,
+ * detach_destroy_domains and partition_sched_domains.
+ */
+static DEFINE_MUTEX(sched_domains_mutex);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
@@ -358,21 +360,9 @@ static inline void set_task_rq(struct ta
 #endif
 }
 
-static inline void lock_doms_cur(void)
-{
-	mutex_lock(&doms_cur_mutex);
-}
-
-static inline void unlock_doms_cur(void)
-{
-	mutex_unlock(&doms_cur_mutex);
-}
-
 #else
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline void lock_doms_cur(void) { }
-static inline void unlock_doms_cur(void) { }
 
 #endif	/* CONFIG_GROUP_SCHED */
 
@@ -7755,7 +7745,7 @@ void partition_sched_domains(int ndoms_n
 {
 	int i, j;
 
-	lock_doms_cur();
+	mutex_lock(&sched_domains_mutex);
 
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
@@ -7804,7 +7794,7 @@ match2:
 
 	register_sched_domain_sysctl();
 
-	unlock_doms_cur();
+	mutex_unlock(&sched_domains_mutex);
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -7813,8 +7803,10 @@ int arch_reinit_sched_domains(void)
 	int err;
 
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
 	return err;
