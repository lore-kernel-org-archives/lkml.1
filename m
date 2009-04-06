Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZDFQTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZDFQTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZDFQTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:19:30 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:46891 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZDFQT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:19:29 -0400
Date: Mon, 6 Apr 2009 21:48:48 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v5 PATCH 3/4] timers: /proc/sys sysctl hook to enable timer
	migration
Message-ID: <20090406161848.GD15269@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090406161357.GB15269@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090406161357.GB15269@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-06 21:43:57]:

This patch creates the /proc/sys sysctl interface at
/proc/sys/kernel/timer_migration

Timer migration is enabled by default.

To disable timer migration, when CONFIG_SCHED_DEBUG = y,

echo 0 > /proc/sys/kernel/timer_migration

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    1 +
 kernel/sysctl.c       |    8 ++++++++
 3 files changed, 10 insertions(+)

Index: linux.trees.git/include/linux/sched.h
===================================================================
--- linux.trees.git.orig/include/linux/sched.h
+++ linux.trees.git/include/linux/sched.h
@@ -1763,6 +1763,7 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_timer_migration;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: linux.trees.git/kernel/sysctl.c
===================================================================
--- linux.trees.git.orig/kernel/sysctl.c
+++ linux.trees.git/kernel/sysctl.c
@@ -328,6 +328,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "timer_migration",
+		.data		= &sysctl_timer_migration,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c
+++ linux.trees.git/kernel/sched.c
@@ -7445,6 +7445,7 @@ static void sched_domain_node_span(int n
 #endif /* CONFIG_NUMA */
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+const_debug unsigned int sysctl_timer_migration = 1;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
