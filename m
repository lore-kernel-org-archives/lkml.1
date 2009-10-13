Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZJMEzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZJMEzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZJMEze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:55:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58438 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZJMEzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:55:33 -0400
Date: Mon, 12 Oct 2009 21:55:56 -0700
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
Subject: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Message-ID: <20091013045556.GJ28435@us.ibm.com>
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



Subject: [RFC][v8][PATCH 10/10]: Document clone3() syscall

This gives a brief overview of the clone3() system call.  We should
eventually describe more details in existing clone(2) man page or in
a new man page.

Changelog[v8]:
	- clone2() is already in use in IA64. Rename syscall to clone3()
	- Add notes to say that we return -EINVAL if invalid clone flags
	  are specified or if the reserved fields are not 0.
Changelog[v7]:
	- Rename clone_with_pids() to clone2()
	- Changes to reflect new prototype of clone2() (using clone_struct).

Signed-off-by: Sukadev Bhattiprolu <sukadev@vnet.linux.ibm.com>
---
 Documentation/clone2 |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

Index: linux-2.6/Documentation/clone2
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/clone2	2009-10-12 19:54:38.000000000 -0700
@@ -0,0 +1,89 @@
+
+struct clone_struct {
+	u64 flags;
+	u64 child_stack;
+	u32 nr_pids;
+	u32 reserved1;
+	u64 parent_tid;
+	u64 child_tid;
+	u64 reserved2;
+};
+
+clone3(struct clone_struct * __user clone_args, pid_t * __user pids)
+
+	In addition to doing everything that clone() system call does,
+	the clone3() system call:
+
+		- allows additional clone flags (all 32 bits in the flags
+		  parameter to clone() are in use)
+
+		- allows user to specify a pid for the child process in its
+		  active and ancestor pid name spaces.
+
+	This system call is meant to be used when restarting an application
+	from a checkpoint.  Such restart requires that the processes in the
+	application have the same pids they had when the application was
+	checkpointed. When containers are nested, the processes within the
+	containers exist in multiple pid namespaces and hence have multiple
+	pids to specify during restart.
+
+	The @pids defines the set of pids that should be assigned to the child
+	process in its active and ancestor pid name spaces. The descendant pid
+	namespaces do not matter since a process does not have a pid in
+	descendant namespaces, unless the process is in a new pid namespace
+	in which case the process is a container-init (and must have the pid 1
+	in that namespace).
+
+	See CLONE_NEWPID section of clone(2) man page for details about pid
+	namespaces.
+
+	The order pids in @pids corresponds to the nesting order of pid-
+	namespaces, with @pids[0] corresponding to the init_pid_ns.
+
+	If a pid in the @pids list is 0, the kernel will assign the next
+	available pid in the pid namespace, for the process.
+
+	If a pid in the @pids list is non-zero, the kernel tries to assign
+	the specified pid in that namespace.  If that pid is already in use
+	by another process, the system call fails with -EBUSY.
+
+	On success, the system call returns the pid of the child process in
+	the parent's active pid namespace.
+
+	On failure, clone3() returns -1 and sets 'errno' to one of following
+	values (the child process is not created).
+
+	EPERM	Caller does not have the SYS_ADMIN privilege needed to excute
+		this call.
+
+	EINVAL	The number of pids specified in 'clone_struct.nr_pids' exceeds
+		the current nesting level of parent process
+
+	EINVAL	Not all specified clone-flags are valid.
+
+	EINVAL	The reserved fields in the clone_struct argument are not 0.
+
+	EBUSY	A requested pid is in use by another process in that name space.
+
+Example:
+
+	pid_t pids[] = { 77, 99 };
+	struct clone_struct cs;
+
+	cs.flags = (u64) SIGCHLD;
+	cs.child_stack = (u64) setup_child_stack();
+	cs.nr_pids = 2;
+	cs.parent_tid = 0LL;
+	cs.child_tid = 0LL;
+
+	rc = syscall(__NR_clone3, &cs, pids);
+
+	if (rc < 0) {
+		perror("clone3()");
+		exit(1);
+	} else if (rc) {
+		/* Parent */
+	} else {
+		/* Child */
+	}
+
