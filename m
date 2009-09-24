Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZIXQ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZIXQ4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZIXQ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:56:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48723 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbZIXQ42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:56:28 -0400
Date: Thu, 24 Sep 2009 09:55:48 -0700
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
Subject: [RFC][v7][PATCH 0/9] Implement clone2() system call
Message-ID: <20090924165548.GA16586@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


=== NEW CLONE() SYSTEM CALL:

To support application checkpoint/restart, a task must have the same pid it
had when it was checkpointed.  When containers are nested, the tasks within
the containers exist in multiple pid namespaces and hence have multiple pids
to specify during restart.

This patchset implements a new system call, clone2() that lets a process
specify the pids of the child process.

Patches 1 through 6 are helper patches, needed for choosing a pid for the
child process.

Patch 8 defines a prototype of the new system call. Patch 9 adds some
documentation on the new system call, some/all of which will eventually
go into a man page.

Changelog[v7]:
	- [Peter Zijlstra, Arnd Bergmann]
	  Rename clone_with_pids() to clone2(). Also group the arguments to
	  clone2() into a 'struct clone_struct' to workaround the issue of
	  exceeding 6 arguments to the system call. Also define clone-flags
	  as u64 to allow additional clone-flags.

Changelog[v6]:
	- [Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torvalds]
	  Change 'pid_set.pids' to 'pid_t pids[]' so sizeof(struct pid_set) is
	  constant across architectures (Patches 7, 8).
	- (Nathan Lynch) Change pid_set.num_pids to unsigned and remove
	  'unum_pids < 0' check (Patches 7,8)
	- (Pavel Machek) New patch (Patch 9) to add some documentation.

Changelog[v5]:
	- Make 'pid_max' a property of pid_ns (Integrated Serge Hallyn's patch
	  into this set)
	- (Eric Biederman): Avoid the new function, set_pidmap() - added
	  couple of checks on 'target_pid' in alloc_pidmap() itself.

=== IMPORTANT TODO:

clone() system call has another limitation - all available bits in clone-flags
are in use and any new clone-flag will need a variant of the clone() system
call. 

It appears to make sense to try and extend this new system call to address
this limitation as well. The requirements of a new clone system call could
then be summarized as:

	- do everything clone() does today, and
	- give application an ability to choose pids for the child process
	  in all ancestor pid namespaces, and
	- allow more clone_flags

Contstraints:

	- system-calls are restricted to 6 parameters and clone() already
	  takes 5 parameters, any extension to clone() interface would require
	  one or more copy_from_user().  (Not sure if copy_from_user() of ~40
	  bytes would have a significant impact on performance of clone() on
	  any architecture).

Based on these requirements and constraints, we explored a couple of system
call interfaces (in earlier versions of this patchset) and currently define
the system call as:

	struct clone_struct {
		u64 flags;
		u64 child_stack;
		u32 nr_pids;
		u32 parent_tid;
		u32 child_tid;
		u32 reserved1;
		u64 reserved2;
	};

	sys_clone2(struct clone_struct __user *cs, pid_t __user *pids)

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
