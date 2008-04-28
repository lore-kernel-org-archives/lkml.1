Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbYD1ILo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbYD1ILo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765673AbYD1ILd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:11:33 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:24719 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765216AbYD1ILc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:11:32 -0400
Date: Mon, 28 Apr 2008 10:11:29 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428081129.GC4507@osiris.boeblingen.de.ibm.com>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com> <20080427183926.acb66fff.akpm@linux-foundation.org> <20080428070946.GA4507@osiris.boeblingen.de.ibm.com> <20080428002853.1693e7fd.akpm@linux-foundation.org> <20080428075253.GB4507@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428075253.GB4507@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 kernel/sched.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -311,6 +311,16 @@ static DEFINE_SPINLOCK(task_group_lock);
 /* doms_cur_mutex serializes access to doms_cur[] array */
 static DEFINE_MUTEX(doms_cur_mutex);
 
+static inline void lock_doms_cur(void)
+{
+	mutex_lock(&doms_cur_mutex);
+}
+
+static inline void unlock_doms_cur(void)
+{
+	mutex_unlock(&doms_cur_mutex);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
@@ -358,21 +368,9 @@ static inline void set_task_rq(struct ta
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
 
@@ -7813,8 +7811,10 @@ int arch_reinit_sched_domains(void)
 	int err;
 
 	get_online_cpus();
+	lock_doms_cur();
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
+	unlock_doms_cur();
 	put_online_cpus();
 
 	return err;
