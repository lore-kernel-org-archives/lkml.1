Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZDPGpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZDPGpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZDPGpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:45:43 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:35662 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZDPGpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:45:42 -0400
Date: Thu, 16 Apr 2009 12:15:34 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
       Chris Zankel <chris@zankel.net>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Tony Luck <tony.luck@intel.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v6 PATCH 3/4] timers: /proc/sys sysctl hook to enable timer
	migration
Message-ID: <20090416064534.GD7510@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090416064136.GA7510@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090416064136.GA7510@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-16 12:11:36]:

This patch creates the /proc/sys sysctl interface at
/proc/sys/kernel/timer_migration

Timer migration is enabled by default.

To disable timer migration, when CONFIG_SCHED_DEBUG = y,

echo 0 > /proc/sys/kernel/timer_migration

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 ++
 kernel/sysctl.c       |    8 ++++++++
 3 files changed, 11 insertions(+)

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
@@ -8426,6 +8426,8 @@ void __init sched_init_smp(void)
 }
 #endif /* CONFIG_SMP */
 
+const_debug unsigned int sysctl_timer_migration = 1;
+
 int in_sched_functions(unsigned long addr)
 {
 	return in_lock_functions(addr) ||
