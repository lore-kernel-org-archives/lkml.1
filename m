Return-Path: <linux-kernel-owner+w=401wt.eu-S1423111AbXBHQQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423111AbXBHQQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423121AbXBHQQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:16:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423111AbXBHQQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:16:20 -0500
Message-ID: <45CB4C55.4070902@redhat.com>
Date: Thu, 08 Feb 2007 11:14:13 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Size of 2.6.20 task_struct on x86_64 machines
Content-Type: multipart/mixed;
 boundary="------------050801010509050305040603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050801010509050305040603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This past week I was playing around with that pahole tool
(http://oops.ghostprotocols.net:81/acme/dwarves/) and looking at the
size of various struct in the kernel. I was surprised by the size of
the task_struct on x86_64, approaching 4K.  I looked through the
fields in task_struct and found that a number of them were declared as
"unsigned long" rather than "unsigned int" despite them appearing okay
as 32-bit sized fields. On x86_64 "unsigned long" ends up being 8
bytes in size and forces 8 byte alignment. Is there a reason there
a reason they are "unsigned long"?

The patch below drops the size of the struct from 3808 bytes (60
64-byte cachelines) to 3760 bytes (59 64-byte cachelines). A couple
other fields in the task struct take a signficant amount of space:

struct thread_struct       thread;               688
struct held_lock           held_locks[30];       1680

CONFIG_LOCKDEP is turned on in the .config

-Will

--------------050801010509050305040603
Content-Type: text/x-patch;
 name="task_struct_compress.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="task_struct_compress.diff"

--- include/linux/sched.h.compress	2007-02-06 16:16:14.000000000 -0500
+++ include/linux/sched.h	2007-02-07 18:09:34.000000000 -0500
@@ -802,8 +802,8 @@
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	struct thread_info *thread_info;
 	atomic_t usage;
-	unsigned long flags;	/* per process flags, defined below */
-	unsigned long ptrace;
+	unsigned int flags;	/* per process flags, defined below */
+	unsigned int ptrace;
 
 	int lock_depth;		/* BKL lock depth */
 
@@ -826,7 +826,7 @@
 	unsigned long long sched_time; /* sched_clock time spent running */
 	enum sleep_type sleep_type;
 
-	unsigned long policy;
+	unsigned int policy;
 	cpumask_t cpus_allowed;
 	unsigned int time_slice, first_time_slice;
 
@@ -846,11 +846,11 @@
 
 /* task state */
 	struct linux_binfmt *binfmt;
-	long exit_state;
+	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	/* ??? */
-	unsigned long personality;
+	unsigned int personality;
 	unsigned did_exec:1;
 	pid_t pid;
 	pid_t tgid;
@@ -882,7 +882,7 @@
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
-	unsigned long rt_priority;
+	unsigned int rt_priority;
 	cputime_t utime, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time;

--------------050801010509050305040603--
