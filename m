Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZIXRDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZIXRDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZIXRDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:03:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33796 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZIXRDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:03:43 -0400
Date: Thu, 24 Sep 2009 10:02:43 -0700
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
Subject: [RFC][v7][PATCH 7/9]: Define do_fork_with_pids()
Message-ID: <20090924170243.GG16989@us.ibm.com>
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



Subject: [RFC][v7][PATCH 7/9]: Define do_fork_with_pids()

do_fork_with_pids() is same as do_fork(), except that it takes an
additional, 'pid_set', parameter. This parameter, currently unused,
specifies the set of target pids of the process in each of its pid
namespaces.

Changelog[v7]:
	- Drop 'struct pid_set' object and pass in 'pid_t *target_pids'
	  instead of 'struct pid_set *'.

Changelog[v6]:
	- (Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torvalds)
	  Change 'pid_set.pids' to a 'pid_t pids[]' so size of 'struct pid_set'
	  is constant across architectures.
	- (Nathan Lynch) Change 'pid_set.num_pids' to 'unsigned int'.

Changelog[v4]:
	- Rename 'struct target_pid_set' to 'struct pid_set' since it may
	  be useful in other contexts.

Changelog[v3]:
	- Fix "long-line" warning from checkpatch.pl

Changelog[v2]:
	- To facilitate moving architecture-inpdendent code to kernel/fork.c
	  pass in 'struct target_pid_set __user *' to do_fork_with_pids()
	  rather than 'pid_t *' (next patch moves the arch-independent
	  code to kernel/fork.c)

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 include/linux/sched.h |    3 +++
 kernel/fork.c         |   17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2009-09-11 18:44:04.000000000 -0700
+++ linux-2.6/include/linux/sched.h	2009-09-12 09:43:20.000000000 -0700
@@ -2054,6 +2054,9 @@ extern int disallow_signal(int);
 
 extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
+extern long do_fork_with_pids(unsigned long, unsigned long, struct pt_regs *,
+				unsigned long, int __user *, int __user *,
+				unsigned int, pid_t __user *);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2009-09-11 20:09:15.000000000 -0700
+++ linux-2.6/kernel/fork.c	2009-09-12 11:17:21.000000000 -0700
@@ -1332,12 +1332,14 @@ struct task_struct * __cpuinit fork_idle
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
  */
-long do_fork(unsigned long clone_flags,
+long do_fork_with_pids(unsigned long clone_flags,
 	      unsigned long stack_start,
 	      struct pt_regs *regs,
 	      unsigned long stack_size,
 	      int __user *parent_tidptr,
-	      int __user *child_tidptr)
+	      int __user *child_tidptr,
+	      unsigned int num_pids,
+	      pid_t __user *upids)
 {
 	struct task_struct *p;
 	int trace = 0;
@@ -1440,6 +1442,17 @@ long do_fork(unsigned long clone_flags,
 	return nr;
 }
 
+long do_fork(unsigned long clone_flags,
+	      unsigned long stack_start,
+	      struct pt_regs *regs,
+	      unsigned long stack_size,
+	      int __user *parent_tidptr,
+	      int __user *child_tidptr)
+{
+	return do_fork_with_pids(clone_flags, stack_start, regs, stack_size,
+			parent_tidptr, child_tidptr, 0, NULL);
+}
+
 #ifndef ARCH_MIN_MMSTRUCT_ALIGN
 #define ARCH_MIN_MMSTRUCT_ALIGN 0
 #endif
