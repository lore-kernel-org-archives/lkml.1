Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbYHKXyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbYHKXyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbYHKXxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:53:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56970 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684AbYHKXxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:53:38 -0400
Message-Id: <20080811235323.872291138@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 16:53:23 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 0/5] Container Freezer v6: Reuse Suspend Freezer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces a cgroup subsystem that utilizes the swsusp
freezer to freeze a group of tasks. It's immediately useful for batch job
management scripts. It should also be useful in the future for implementing
container checkpoint/restart.

The freezer subsystem in the container filesystem defines a cgroup file named
freezer.state. Reading freezer.state will return the current state of the
cgroup.  Writing "FROZEN" to the state file will freeze all tasks in the
cgroup. Subsequently writing "RUNNING" will unfreeze the tasks in the cgroup. 

* Examples of usage :

   # mkdir /containers/freezer
   # mount -t cgroup -ofreezer freezer  /containers
   # mkdir /containers/0
   # echo $some_pid > /containers/0/tasks

to get status of the freezer subsystem :

   # cat /containers/0/freezer.state
   RUNNING

to freeze all tasks in the container :

   # echo FROZEN > /containers/0/freezer.state
   # cat /containers/0/freezer.state
   FREEZING
   # cat /containers/0/freezer.state
   FROZEN

to unfreeze all tasks in the container :

   # echo RUNNING > /containers/0/freezer.state
   # cat /containers/0/freezer.state
   RUNNING

Andrew, please consider these patches for -mm.

Cheers,
	-Matt Helsley

Changes since v5:
v6:
	Merged the patch using the cgroups write_string() method since Linus
		has merged the patch supporting it.
	Moved header file modifications to in patch 1 to
		arch/$ARCH/include/asm/thread_info.h where appropriate.
	Moved cgroup_freezer.h contents into cgroups_freezer.c and freezer.h
	Added CONFIG_FREEZER to help conditionally build the freezer code.
		This required some simplifications of the second patch.
	Fix a lock ordering problem with the freezer->lock reacquire code
		Required order: freezer->lock, css_set_lock, task->alloc_lock
		Reacquiring: css_set_lock, task->alloc_lock, freezer->lock
		Solution: change freezer_fork() to not require any ordering
			between task->alloc_lock and freezer->lock
v5:
	Split out write_string as a separate patch for easier merging
		with trees lacking certain cgroup patches at the time.
	Checked use of task alloc lock for races with swsusp freeze/thaw --
		looks safe because there are explicit barriers to handle
		freeze/thaw races for individual tasks, we explicitly
		handle partial group freezing, and partial group thawing
		should be resolved without changing swsusp's loop.
	Updated the patches to Linus' git tree as of approximately
		7/31/2008.
	Added Pavel and Serge's Acked-by lines to Acked patches

v4 (Almost all of these changes are confined to patch 3):
	Reworked the series to use task_lock() instead of RCU.
	Reworked the series to use write_string() and read_seq_string()
		cgroup methods.
	Fixed the race Paul Menage identified.
	Fixed up check_if_frozen() to do more than just test the FROZEN
		flag. In some cases tasks could be stopped (T) and marked
		FREEZING. When that happens we can safely assume that it
		will be frozen immediately upon waking up in the kernel.
		Waiting for it to get marked with PF_FROZEN in order to
		transition to the FROZEN state would block unnecessarily.
	Removed freezer_ prefix from static functions in cgroup_freezer.c.
	Simplified STATE_ switch.
	Updated the locking comments.

v3:
	Ported to 2.6.26-rc5-mm2 with Rafael's freezer patches
	Tested on 24 combinations of 3 architectures (x86, x86_64, ppc64)
		with 8 different kernel configs varying power management
		and cgroup config variables. Each patch builds and boots
		in these 24 combinations.
	Passes functional testing.

v2 (roughly patches 3 and 5):
	Moved the "kill" file into a separate cgroup subsystem (signal) and
		it's own patch.
	Changed the name of the file from freezer.freeze to freezer.state.
	Switched from taking 1 and 0 as input to the strings "FROZEN" and 
		"RUNNING", respectively. This helps keep the interface
		human-usable if/when we need to more states.
	Checked that stopped or interrupted is "frozen enough"
		Since try_to_freeze() is called upon wakeup of these tasks
		this should be fine. This idea comes from recent changes to
		the freezer.
	Checked that if (task == current) whilst freezing cgroup we're ok
	Fixed bug where -EBUSY would always be returned when freezing
	Added code to handle userspace retries for any remaining -EBUSY

-- 
