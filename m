Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZHMH7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZHMH7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZHMH7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:59:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33676 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbZHMH7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:59:43 -0400
Date: Thu, 13 Aug 2009 01:00:49 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][v4][PATCH 0/7] clone_with_pids() system call
Message-ID: <20090813080049.GA16639@us.ibm.com>
References: <20090807061103.GA19343@us.ibm.com> <m1vdks5qc8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdks5qc8.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
| 
| > === NEW CLONE() SYSTEM CALL:
| >
| > To support application checkpoint/restart, a task must have the same pid it
| > had when it was checkpointed.  When containers are nested, the tasks within
| > the containers exist in multiple pid namespaces and hence have multiple pids
| > to specify during restart.
| >
| > This patchset implements a new system call, clone_with_pids() that lets a
| > process specify the pids of the child process.
| >
| > Patches 1 through 5 are helpers and we believe they are needed for application
| > restart, regardless of the kernel implementation of application restart.
| 
| I'm not very impressed.
| 
| - static int alloc_pidmap(struct pid_namespace *pid_ns)
| + static int alloc_pidmap(struct pid_namespace *pid_ns, int pid_max, int last_pid)
| 
| Do that.
| 
| That is pass in pid_max and last_pid, and you don't have to do weird
| things in alloc_pidmap, and no set_pidmap is needed.

But last_pid is from the pid_ns. Do you mean to have alloc_pidmap()
take a pid_min and pid_max and when choosing a specific pid, have
pid_min == pid_max == target_pid ?

| 
| No changes to copy_process are needed it already takes a struct pid
| argument.


I see your point about passing in both 'struct pid*' and target_pids[].
But in the common case the struct pid passed into copy_process() is
NULL - allocating pid in do_fork() would significantly alter the
existing control flow - no ? alloc_pid() assumes any new pid namespace
has been created - in copy_namespaces(). Moving the alloc_pid() to
do_fork() would require parsing clone_flags in do_fork() and pulling
pid namespace code out of copy_namespaces().

| 
| I haven't been following closely what is gained by having a clone_with_pids
| syscall?  

When restarting an application from a checkpoint, the application must get
the same pid it had at the time of checkpoint. clone_with_pids() would be
used during restart so the child can be created with a specific set of pids.

| 
| As for new namespaces that don't need to happen at process creation time
| (which is just about anything that is left) we can create a new syscall that
| unshares just that one.
| 

Ok. If all new namespaces can be handled with a variant of unshare(), we can
decouple clone_with_pids() from the clone-flags issue.

| 
| Eric
