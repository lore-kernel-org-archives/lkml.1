Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbXJEJYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbXJEJYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbXJEJYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:24:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45796 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095AbXJEJYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:24:34 -0400
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Cliff Wickman <cpw@sgi.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Fri, 05 Oct 2007 02:24:32 -0700
Message-Id: <20071005092432.32047.60952.sendpatchset@jackhammer.engr.sgi.com>
Subject: [DEBUG PATCH] demonstration of hang in sched domain partitioning code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

I'm running into a problem trying to use your suggested
partition_sched_domains(cpumask_t *partition) routine the way
I thought I was supposed to be able to use it.

If I ask to set up the same partition twice in a row having
just one CPU in it (a singleton) the kernel hangs.

I don't know enough about kernel/sched.c to be able to debug
this very efficiently.  Any chance you could take a look?

The following patch can be used to reproduce the problem
I'm seeing.  I'm on an 8 CPU Altix using sn2_defconfig.

This patch applies to 2.6.23-rc8-mm2 immediately -after- the
existing patch:

  cpuset-remove-sched-domain-hooks-from-cpusets.patch

To see the problem, do:
 1) apply the patch, build and boot it
 2) mount -t cpuset cpuset /dev/cpuset
 3) cd /dev/cpuset
 4) echo 1 > memory_pressure_enabled
 5) echo 1 > memory_pressure_enabled
 6) system hung ... big red switch time ...

Well, not entirely hung - but that task, and sooner
or later other tasks, hang enough so that you can't
login anymore or complete a natural reboot.

P.S. - the second writing, step (6) above, apparently
is not needed.  I just had another boot freeze a couple
seconds after the first write.

The patch 'borrows' the infrequently used top cpuset file
file memory_pressure_enabled to let you directly invoke
partition_sched_domains() with a singleton containing
just whatever CPU number you write to it.

Here's the syslog output generated from the above
(I wrote "2", not "1" as above, when I generated the
following):

================================================================
Oct  5 01:38:27 margin kernel: Invoking partition_sched_domains for singleton on CPU 2
Oct  5 01:38:27 margin kernel: CPU2 attaching NULL sched-domain.
Oct  5 01:38:27 margin kernel: CPU2 attaching sched-domain:
Oct  5 01:38:27 margin kernel:  domain 0: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000004
Oct  5 01:38:27 margin kernel:   groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000004
Oct  5 01:38:27 margin kernel: Returned from partition_sched_domains.
Oct  5 01:38:30 margin kernel: Invoking partition_sched_domains for singleton on CPU 2
Oct  5 01:38:30 margin kernel: CPU2 attaching NULL sched-domain.
================================================================

---

 include/linux/sched.h |    2 ++
 kernel/cpuset.c       |   12 ++++++++++++
 kernel/sched.c        |   14 +++++++++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

--- 2.6.23-rc8-mm2.orig/include/linux/sched.h	2007-10-05 00:39:27.256416155 -0700
+++ 2.6.23-rc8-mm2/include/linux/sched.h	2007-10-05 00:41:21.918141772 -0700
@@ -718,6 +718,8 @@ struct sched_domain {
 #endif
 };
 
+extern int partition_sched_domains(cpumask_t *partition);
+
 #endif	/* CONFIG_SMP */
 
 /*
--- 2.6.23-rc8-mm2.orig/kernel/cpuset.c	2007-10-05 00:38:13.195313659 -0700
+++ 2.6.23-rc8-mm2/kernel/cpuset.c	2007-10-05 00:50:28.258426364 -0700
@@ -1005,10 +1005,22 @@ done:
 
 static int update_memory_pressure_enabled(struct cpuset *cs, char *buf)
 {
+#ifdef THE_USUAL_CODE
 	if (simple_strtoul(buf, NULL, 10) != 0)
 		cpuset_memory_pressure_enabled = 1;
 	else
 		cpuset_memory_pressure_enabled = 0;
+#else /* partition_sched_domains debug hook */
+	int i;
+	cpumask_t singleton;
+
+	i = simple_strtoul(buf, NULL, 10);
+	cpus_clear(singleton);
+	cpu_set(i, singleton);
+	printk("Invoking partition_sched_domains for singleton on CPU %d\n", i);
+	partition_sched_domains(&singleton);
+	printk("Returned from partition_sched_domains.\n");
+#endif
 	return 0;
 }
 
--- 2.6.23-rc8-mm2.orig/kernel/sched.c	2007-10-05 00:39:11.884187317 -0700
+++ 2.6.23-rc8-mm2/kernel/sched.c	2007-10-05 01:21:49.359083211 -0700
@@ -5493,7 +5493,7 @@ int __init migration_init(void)
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
-#undef SCHED_DOMAIN_DEBUG
+#define SCHED_DOMAIN_DEBUG
 #ifdef SCHED_DOMAIN_DEBUG
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
@@ -6327,6 +6327,18 @@ static void detach_destroy_domains(const
 	arch_destroy_sched_domains(cpu_map);
 }
 
+int partition_sched_domains(cpumask_t *partition)
+{
+	cpumask_t m;
+
+	cpus_and(m, *partition, cpu_online_map);
+	cpus_andnot(m, m, cpu_isolated_map);
+
+	/* Detach sched domains from all of the affected cpus */
+	detach_destroy_domains(&m);
+	return build_sched_domains(&m);
+}
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 static int arch_reinit_sched_domains(void)
 {

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
