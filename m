Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbZJMEwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbZJMEwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZJMEwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:52:02 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38509 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZJMEwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:52:01 -0400
Date: Mon, 12 Oct 2009 21:52:34 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: [RFC][v8][PATCH 7/10]: Check invalid clone flags
Message-ID: <20091013045234.GG28435@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013044925.GA28181@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v8][PATCH 7/10]: Check invalid clone flags

As pointed out by Oren Laadan, we want to ensure that unused bits in the
clone-flags remain unused and available for future. To ensure this, define
a mask of clone-flags and check the flags in the clone() system calls.

Changelog[v8]:
	- New patch in set

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

---
 include/linux/sched.h |   10 ++++++++++
 kernel/fork.c         |    3 +++
 2 files changed, 13 insertions(+)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2009-10-02 18:53:55.000000000 -0700
+++ linux-2.6/include/linux/sched.h	2009-10-02 19:58:21.000000000 -0700
@@ -29,6 +29,16 @@
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
 #define CLONE_IO		0x80000000	/* Clone io context */
 
+#define VALID_CLONE_FLAGS	(CSIGNAL | CLONE_VM | CLONE_FS | CLONE_FILES |\
+				 CLONE_SIGHAND | CLONE_PTRACE | CLONE_VFORK  |\
+				 CLONE_PARENT | CLONE_THREAD | CLONE_NEWNS   |\
+				 CLONE_SYSVSEM | CLONE_SETTLS                |\
+				 CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID  |\
+				 CLONE_DETACHED | CLONE_UNTRACED             |\
+				 CLONE_CHILD_SETTID | CLONE_STOPPED          |\
+				 CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER |\
+				 CLONE_NEWPID | CLONE_NEWNET| CLONE_IO)
+
 /*
  * Scheduling policies
  */
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2009-10-02 19:00:08.000000000 -0700
+++ linux-2.6/kernel/fork.c	2009-10-02 19:57:36.000000000 -0700
@@ -942,6 +942,9 @@ static struct task_struct *copy_process(
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
 
+	if (clone_flags & ~VALID_CLONE_FLAGS)
+		return ERR_PTR(-EINVAL);
+
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
