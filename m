Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZIXRDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZIXRDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZIXRDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:03:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51173 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbZIXRDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:03:11 -0400
Date: Thu, 24 Sep 2009 10:02:15 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: [RFC][v7][PATCH 6/9]: Add target_pids parameter to copy_process()
Message-ID: <20090924170215.GF16989@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924165548.GA16586@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v7][PATCH 6/9]: Add target_pids parameter to copy_process()

Add a 'target_pids' parameter to copy_process().  The new parameter will be
used in a follow-on patch when clone_with_pids() is implemented.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/fork.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2009-09-10 10:29:10.000000000 -0700
+++ linux-2.6/kernel/fork.c	2009-09-10 10:29:13.000000000 -0700
@@ -935,12 +935,12 @@ static struct task_struct *copy_process(
 					unsigned long stack_size,
 					int __user *child_tidptr,
 					struct pid *pid,
+					pid_t *target_pids,
 					int trace)
 {
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
-	pid_t *target_pids = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1319,7 +1319,7 @@ struct task_struct * __cpuinit fork_idle
 	struct pt_regs regs;
 
 	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
-			    &init_struct_pid, 0);
+			    &init_struct_pid, NULL, 0);
 	if (!IS_ERR(task))
 		init_idle(task, cpu);
 
@@ -1342,6 +1342,7 @@ long do_fork(unsigned long clone_flags,
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
+	pid_t *target_pids = NULL;
 
 	/*
 	 * Do some preliminary argument and permissions checking before we
@@ -1382,7 +1383,7 @@ long do_fork(unsigned long clone_flags,
 		trace = tracehook_prepare_clone(clone_flags);
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
-			 child_tidptr, NULL, trace);
+			 child_tidptr, NULL, target_pids, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
