Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZIGVKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZIGVKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZIGVKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:10:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51275 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIGVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:10:18 -0400
Date: Mon, 7 Sep 2009 14:14:45 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: [RFC][v5][PATCH 3/8] Make pid_max a pid_ns property
Message-ID: <20090907211445.GC6685@us.ibm.com>
References: <20090907211302.GA5892@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907211302.GA5892@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Serge Hallyn <serue@us.ibm.com>
Subject: [RFC][v5][PATCH 3/8] Make pid_max a pid_ns property

Remove the pid_max global, and make it a property of the
pid_namespace.  When a pid_ns is created, it inherits
the parent's pid_ns.

Fixing up sysctl (trivial akin to ipc version, but
potentially tedious to get right for all CONFIG*
combinations) is left for later.

Changelog[v2]:
	- Port to newer kernel
	- Make pid_max a local variable in alloc_pidmap() to simplify code/patch

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 include/linux/pid_namespace.h |    1 +
 kernel/pid.c                  |   14 +++++++-------
 kernel/pid_namespace.c        |    6 ++++--
 kernel/sysctl.c               |    4 ++--
 4 files changed, 14 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/pid_namespace.h
===================================================================
--- linux-2.6.orig/include/linux/pid_namespace.h	2009-08-05 13:00:21.000000000 -0700
+++ linux-2.6/include/linux/pid_namespace.h	2009-09-07 13:12:04.000000000 -0700
@@ -30,6 +30,7 @@
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	int pid_max;
 };
 
 extern struct pid_namespace init_pid_ns;
Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-09-07 13:11:39.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-09-07 13:12:04.000000000 -0700
@@ -43,8 +43,6 @@
 static int pidhash_shift;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
-int pid_max = PID_MAX_DEFAULT;
-
 #define RESERVED_PIDS		300
 
 int pid_max_min = RESERVED_PIDS + 1;
@@ -78,6 +76,7 @@
 	.last_pid = 0,
 	.level = 0,
 	.child_reaper = &init_task,
+	.pid_max = PID_MAX_DEFAULT,
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
@@ -151,6 +150,7 @@
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
 	int rc = -EAGAIN;
+	int pid_max = pid_ns->pid_max;
 	struct pidmap *map;
 
 	pid = last + 1;
Index: linux-2.6/kernel/pid_namespace.c
===================================================================
--- linux-2.6.orig/kernel/pid_namespace.c	2009-08-05 13:00:23.000000000 -0700
+++ linux-2.6/kernel/pid_namespace.c	2009-09-07 13:12:04.000000000 -0700
@@ -87,6 +87,7 @@
 
 	kref_init(&ns->kref);
 	ns->level = level;
+	ns->pid_max = parent_pid_ns->pid_max;
 	ns->parent = get_pid_ns(parent_pid_ns);
 
 	set_bit(0, ns->pidmap[0].page);
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2009-09-07 13:10:39.000000000 -0700
+++ linux-2.6/kernel/sysctl.c	2009-09-07 13:13:23.000000000 -0700
@@ -55,6 +55,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <linux/pid_namespace.h>
 
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
@@ -78,7 +79,6 @@
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
-extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
@@ -670,7 +670,7 @@
 	{
 		.ctl_name	= KERN_PIDMAX,
 		.procname	= "pid_max",
-		.data		= &pid_max,
+		.data		= &init_pid_ns.pid_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
