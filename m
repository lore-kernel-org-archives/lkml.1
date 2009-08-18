Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZHRD3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZHRD3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZHRD3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:29:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58667 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZHRD3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:29:44 -0400
Date: Mon, 17 Aug 2009 20:31:23 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][v4][PATCH 0/7] clone_with_pids() system call
Message-ID: <20090818033123.GC4713@us.ibm.com>
References: <20090807061103.GA19343@us.ibm.com> <m1vdks5qc8.fsf@fess.ebiederm.org> <20090813080049.GA16639@us.ibm.com> <m1vdks2iea.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdks2iea.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:

| > But last_pid is from the pid_ns. Do you mean to have alloc_pidmap()
| > take a pid_min and pid_max and when choosing a specific pid, have
| > pid_min == pid_max == target_pid ?
| 
| Yes. It already takes a pid_min and a pid_max from the environment.
| I guess the pid_min is RESERVED_PIDS by default.

Well, defining alloc_pidmap() as:

	int alloc_pidmap(pid_ns, int min, int max)

seems to unnecessarily complicate alloc_pidmap() - what if 'min' is 0
but 'max' is not or vice-versa. Generalizing alloc_pidmap() to handle
all combinations seems like an overkill and/or expose RESERVED_PIDS and
pid_max caller.

Maybe we can drop the set_pidmap() call by sticking to 

	int alloc_pidmap(pid_ns, target_pid)

and setting 'max_scan' to 1 when target_pid is set (see quick patch below).

| 
| > | No changes to copy_process are needed it already takes a struct pid
| > | argument.
| >
| >
| > I see your point about passing in both 'struct pid*' and target_pids[].
| > But in the common case the struct pid passed into copy_process() is
| > NULL - allocating pid in do_fork() would significantly alter the
| > existing control flow - no ? alloc_pid() assumes any new pid namespace
| > has been created - in copy_namespaces(). Moving the alloc_pid() to
| > do_fork() would require parsing clone_flags in do_fork() and pulling
| > pid namespace code out of copy_namespaces().
| 
| Why change do_fork?

Sorry, maybe I am missing something. If we don't pass target_pids as a
parameter to copy_process(), how do we specify the target pids ?
Fill in a dummy struct pid with the target-pids and pass it into
copy_process() ?

| 
| > | I haven't been following closely what is gained by having a clone_with_pids
| > | syscall?  
| >
| > When restarting an application from a checkpoint, the application must get
| > the same pid it had at the time of checkpoint. clone_with_pids() would be
| > used during restart so the child can be created with a specific set of pids.
| 
| That part I understand.  What I don't understand is why have that one part be
| special and have user space do the work?

By 'work' do you mean the rest of the process-restart logic ?

The user-level restart program creates the necessary process using
clone_with_pids() and each child process calls another system call,
sys_restart() which restores the process state.

Sukadev

---

Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-08-17 18:43:15.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-08-17 19:41:57.000000000 -0700
@@ -122,18 +122,29 @@
 	atomic_inc(&map->nr_free);
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int alloc_pidmap(struct pid_namespace *pid_ns, int target_pid)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
 	struct pidmap *map;
 	int rc;
 
-	pid = last + 1;
-	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+	if (target_pid) {
+		if (target_pid < 0 || target_pid >= pid_max)
+			return -EINVAL;
+		pid = target_pid;
+		max_scan = 1;
+	} else {
+		pid = last + 1;
+		if (pid >= pid_max)
+			pid = RESERVED_PIDS;
+	}
+
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
+
 	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	if (target_pid)
+		max_scan = 1;
 
 	rc = -EAGAIN;
 	for (i = 0; i <= max_scan; ++i) {
@@ -258,7 +269,7 @@
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = alloc_pidmap(tmp, 0);
 		if (nr < 0)
 			goto out_free;
 
