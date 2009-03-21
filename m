Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZCUExQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZCUExQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 00:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbZCUEw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 00:52:59 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:54994 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZCUEw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 00:52:58 -0400
Date: Fri, 20 Mar 2009 21:52:51 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, shai@scalex86.org
Subject: [rfc] [patch 2/2 ] Sysctl to turn on/off private futex hash tables
	for private futexes
Message-ID: <20090321045251.GB7278@localdomain>
References: <20090321044637.GA7278@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321044637.GA7278@localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch introduces a sysctl to control whether process private
hashtable will be used for process private futexes.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>

Index: linux-2.6.28.6/include/linux/futex.h
===================================================================
--- linux-2.6.28.6.orig/include/linux/futex.h	2009-03-18 16:59:27.000000000 -0800
+++ linux-2.6.28.6/include/linux/futex.h	2009-03-18 17:49:02.000000000 -0800
@@ -179,6 +179,7 @@ static inline void exit_pi_state_list(st
 
 #ifdef CONFIG_PROCESS_PRIVATE_FUTEX
 extern void free_futex_htb(struct mm_struct *mm);
+extern int sysctl_private_hash;
 #else
 static inline void free_futex_htb(struct mm_struct *mm)
 {
Index: linux-2.6.28.6/kernel/futex.c
===================================================================
--- linux-2.6.28.6.orig/kernel/futex.c	2009-03-18 17:36:04.000000000 -0800
+++ linux-2.6.28.6/kernel/futex.c	2009-03-18 17:57:13.000000000 -0800
@@ -154,14 +154,16 @@ void free_futex_htb(struct mm_struct *mm
 
 static void alloc_htb(struct mm_struct *mm)
 {
-	struct futex_hash_bucket *htb;
 	int i;
+	struct futex_hash_bucket *htb = NULL;
 	/*
 	 * Allocate and install a private hash table of the
 	 * same size as the global hash table.  We fall
-	 * back onto the global hash on allocation failure
+	 * back onto the global hash on allocation failure, or
+	 * if private futexes are disabled.
 	 */
-	htb = kmalloc(sizeof(futex_queues), GFP_KERNEL);
+	if (sysctl_private_hash)
+		htb = kmalloc(sizeof(futex_queues), GFP_KERNEL);
 	if (!htb)
 		htb = futex_queues;
 	else {
@@ -183,6 +185,8 @@ static void alloc_htb(struct mm_struct *
 
 }
 
+int sysctl_private_hash;
+
 static struct futex_hash_bucket *get_futex_hashtable(union futex_key *key)
 {
 	struct mm_struct *mm;
Index: linux-2.6.28.6/kernel/sysctl.c
===================================================================
--- linux-2.6.28.6.orig/kernel/sysctl.c	2009-03-18 16:59:27.000000000 -0800
+++ linux-2.6.28.6/kernel/sysctl.c	2009-03-18 17:49:02.000000000 -0800
@@ -48,6 +48,7 @@
 #include <linux/acpi.h>
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
+#include <linux/futex.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -799,6 +800,19 @@ static struct ctl_table kern_table[] = {
 		.strategy	= &sysctl_intvec,
 	},
 #endif
+#ifdef CONFIG_PROCESS_PRIVATE_FUTEX
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "private_futex_hashtable",
+		.data		= &sysctl_private_hash,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_COMPAT
 	{
 		.ctl_name	= KERN_COMPAT_LOG,
Index: linux-2.6.28.6/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.28.6.orig/Documentation/sysctl/kernel.txt	2009-02-17 09:29:27.000000000 -0800
+++ linux-2.6.28.6/Documentation/sysctl/kernel.txt	2009-03-20 12:14:15.000000000 -0800
@@ -281,6 +281,25 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+private_futex_hashtable:
+
+This sysctl can be used to enable processes to use a per-process
+private hash table for private futexes.  Private futexes
+are typically used in threaded workloads.  When this option is
+off, which is the default, threads waiting on futexes get
+hashed onto a global hash table.  On large core count machines
+this turns out to be bad for performance if the workload
+consist of multiple unrelated threaded processes.  Turning
+this option on will enable processes to use a private hash
+for private futexes, improving performance.
+
+Valid options are 0 and 1. A value of 0 turns off process private
+futex hash tables and a value of 1 enables private futex hash
+tables.  This option will only affect processes that get created
+after the option gets changed.
+
+==============================================================
+
 randomize-va-space:
 
 This option can be used to select the type of process address
