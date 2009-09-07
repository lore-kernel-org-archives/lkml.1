Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZIGVIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZIGVIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZIGVIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:08:36 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60772 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZIGVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:08:36 -0400
Date: Mon, 7 Sep 2009 14:13:02 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: [RFC][v5] clone_with_pids() system call
Message-ID: <20090907211302.GA5892@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To support application checkpoint/restart, a task must have the same pid it
had when it was checkpointed.  When containers are nested, the tasks within
the containers exist in multiple pid namespaces and hence have multiple pids
to specify during restart.

This patchset implements a new system call, clone_with_pids() that lets a
process specify the pids of the child process.

Patches 1 through 6 are helpers and we believe they are needed for application
restart, regardless of the kernel implementation of application restart.

Patch 8/8 defines a prototype of the new system call.

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
this limitation as well. The basic requirements of a new clone system call
could then be summarized as:

	- do everything clone() does today, and
	- give application an ability to choose pids for the child process
	  in all ancestor pid namespaces, and
	- allow more clone_flags

Contstraints:

	- system-calls are restricted to 6 parameters and clone() already
	  takes 5 parameters, any extension to clone() interface would require
	  one or more copy_from_user().

	- does copy_from_user() of a few words have a significant impact on
	  the total cost of clone() ?

Based on these requirements and constraints, we have been exploring a couple
of system call interfaces and appreciate any iput.  

1. =====

	#if 64bit
	#define CLONE_FLAGS_WORDS	1
	#else
	#define CLONE_FLAGS_WORDS	2
	#endif

        struct pid_set {
                int num_pids;
                pid_t *pids;
        };

	typedef struct {
		unsigned long flags[CLONE_FLAGS_WORDS];
	} clone_flags_t;

	int clone_extended(clone_flags_t *flags, void *child_stack, int *unused,
		int *parent_tid, int *child_tid, struct pid_set *pid_set);

	Pros:
		- extendible clone_flags (like sigset_t)

	Cons:
		- copy_from_user() needed on all architectures (we maybe able
		  to play some tricks with 'clone_flags_t' to avoid the copy
		  on 64-bit archtitectures till N_CLONE_FLAGS exceeds 64).

		- Both applications and kernel must use interfaces equivalent
		  to sigsetops(3) to test/set/clear clone flags.
2. ======

	struct clone_info {
		int num_clone_high_words;
		int *flags_high;
		struct pid_set pid_set;
	}

        int clone_extended(int flags_low, void *child_stack, void *unused,
		int *parent_tid, int *child_tid, struct clone_info *clone_info);

	Pros:
		- copy_from_user() needed only for new flags and pid_set

	Cons:
		- splitting the high and low clone-flags is awkward ?


Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
