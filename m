Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbYD0VMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbYD0VMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYD0VM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 17:12:27 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:58438 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYD0VM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 17:12:27 -0400
Date: Sun, 27 Apr 2008 23:12:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Concurrent calls to detach_destroy_domains and arch_init_sched_domains
were prevented by the old scheduler subsystem cpu hotplug mutex. When
this got converted to get_online_cpus() the locking got broken.
Unlike before now several processes can concurrently enter the critical
sections that were protected by the old lock.

So add a new sched_domains_mutex which protects these sections again.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/sched.h |    2 ++
 kernel/cpuset.c       |    2 ++
 kernel/sched.c        |   11 +++++++++++
 3 files changed, 15 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7807,14 +7807,23 @@ match2:
 	unlock_doms_cur();
 }
 
+/*
+ * Protects against concurrent calls to detach_destroy_domains
+ * and arch_init_sched_domains.
+ */
+DEFINE_MUTEX(sched_domains_mutex);
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 int arch_reinit_sched_domains(void)
 {
+	static DEFINE_MUTEX(arch_reinit_sched_domains_mutex);
 	int err;
 
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
 	return err;
@@ -7932,10 +7941,12 @@ void __init sched_init_smp(void)
 	BUG_ON(sched_group_nodes_bycpu == NULL);
 #endif
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	arch_init_sched_domains(&cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -809,6 +809,8 @@ struct sched_domain {
 #endif
 };
 
+extern struct mutex sched_domains_mutex;
+
 extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -684,7 +684,9 @@ restart:
 rebuild:
 	/* Have scheduler rebuild sched domains */
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	partition_sched_domains(ndoms, doms, dattr);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
 done:
