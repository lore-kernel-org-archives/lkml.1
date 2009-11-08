Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZKHM0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZKHM0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZKHM0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:26:40 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49541 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZKHMWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:33 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 11/23] sysctl kernel: Remove binary sysctl logic
Date: Sun,  8 Nov 2009 04:21:58 -0800
Message-Id: <1257682930-31401-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sched.c          |    5 ++---
 kernel/slow-work.c      |    5 +----
 kernel/utsname_sysctl.c |   31 -------------------------------
 3 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a455dca..dbb99d7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7373,17 +7373,16 @@ static struct ctl_table sd_ctl_dir[] = {
 		.procname	= "sched_domain",
 		.mode		= 0555,
 	},
-	{0, },
+	{}
 };
 
 static struct ctl_table sd_ctl_root[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.mode		= 0555,
 		.child		= sd_ctl_dir,
 	},
-	{0, },
+	{}
 };
 
 static struct ctl_table *sd_alloc_ctl_entry(int n)
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 0d31135..0134b15 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -52,7 +52,6 @@ static const int slow_work_max_vslow = 99;
 
 ctl_table slow_work_sysctls[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "min-threads",
 		.data		= &slow_work_min_threads,
 		.maxlen		= sizeof(unsigned),
@@ -62,7 +61,6 @@ ctl_table slow_work_sysctls[] = {
 		.extra2		= &slow_work_max_threads,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "max-threads",
 		.data		= &slow_work_max_threads,
 		.maxlen		= sizeof(unsigned),
@@ -72,7 +70,6 @@ ctl_table slow_work_sysctls[] = {
 		.extra2		= (void *) &slow_work_max_max_threads,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "vslow-percentage",
 		.data		= &vslow_work_proportion,
 		.maxlen		= sizeof(unsigned),
@@ -81,7 +78,7 @@ ctl_table slow_work_sysctls[] = {
 		.extra1		= (void *) &slow_work_min_vslow,
 		.extra2		= (void *) &slow_work_max_vslow,
 	},
-	{ .ctl_name = 0 }
+	{}
 };
 #endif
 
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 69eae35..a2cd77e 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -57,78 +57,47 @@ static int proc_do_uts_string(ctl_table *table, int write,
 #define proc_do_uts_string NULL
 #endif
 
-
-#ifdef CONFIG_SYSCTL_SYSCALL
-/* The generic string strategy routine: */
-static int sysctl_uts_string(ctl_table *table,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	struct ctl_table uts_table;
-	int r, write;
-	write = newval && newlen;
-	memcpy(&uts_table, table, sizeof(uts_table));
-	uts_table.data = get_uts(table, write);
-	r = sysctl_string(&uts_table, oldval, oldlenp, newval, newlen);
-	put_uts(table, write, uts_table.data);
-	return r;
-}
-#else
-#define sysctl_uts_string NULL
-#endif
-
 static struct ctl_table uts_kern_table[] = {
 	{
-		.ctl_name	= KERN_OSTYPE,
 		.procname	= "ostype",
 		.data		= init_uts_ns.name.sysname,
 		.maxlen		= sizeof(init_uts_ns.name.sysname),
 		.mode		= 0444,
 		.proc_handler	= proc_do_uts_string,
-		.strategy	= sysctl_uts_string,
 	},
 	{
-		.ctl_name	= KERN_OSRELEASE,
 		.procname	= "osrelease",
 		.data		= init_uts_ns.name.release,
 		.maxlen		= sizeof(init_uts_ns.name.release),
 		.mode		= 0444,
 		.proc_handler	= proc_do_uts_string,
-		.strategy	= sysctl_uts_string,
 	},
 	{
-		.ctl_name	= KERN_VERSION,
 		.procname	= "version",
 		.data		= init_uts_ns.name.version,
 		.maxlen		= sizeof(init_uts_ns.name.version),
 		.mode		= 0444,
 		.proc_handler	= proc_do_uts_string,
-		.strategy	= sysctl_uts_string,
 	},
 	{
-		.ctl_name	= KERN_NODENAME,
 		.procname	= "hostname",
 		.data		= init_uts_ns.name.nodename,
 		.maxlen		= sizeof(init_uts_ns.name.nodename),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
-		.strategy	= sysctl_uts_string,
 	},
 	{
-		.ctl_name	= KERN_DOMAINNAME,
 		.procname	= "domainname",
 		.data		= init_uts_ns.name.domainname,
 		.maxlen		= sizeof(init_uts_ns.name.domainname),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
-		.strategy	= sysctl_uts_string,
 	},
 	{}
 };
 
 static struct ctl_table uts_root_table[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.mode		= 0555,
 		.child		= uts_kern_table,
-- 
1.6.5.2.143.g8cc62

