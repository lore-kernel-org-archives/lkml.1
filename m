Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZJACgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZJACgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 22:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZJACgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 22:36:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38322 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbZJACgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 22:36:37 -0400
Date: Wed, 30 Sep 2009 19:36:18 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
Message-ID: <20091001023618.GA31344@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com> <4ABBAFE5.2000704@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABBAFE5.2000704@librato.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan [orenl@librato.com] wrote:
| 
| 
| Sukadev Bhattiprolu wrote:
| > === NEW CLONE() SYSTEM CALL:
| > 
| > To support application checkpoint/restart, a task must have the same pid it
| > had when it was checkpointed.  When containers are nested, the tasks within
| > the containers exist in multiple pid namespaces and hence have multiple pids
| > to specify during restart.
| > 
| > This patchset implements a new system call, clone2() that lets a process
| > specify the pids of the child process.
| > 
| > Patches 1 through 6 are helper patches, needed for choosing a pid for the
| > child process.
| > 
| > Patch 8 defines a prototype of the new system call. Patch 9 adds some
| > documentation on the new system call, some/all of which will eventually
| > go into a man page.
| > 
| 
| [...]
| 
| > 
| > Based on these requirements and constraints, we explored a couple of system
| > call interfaces (in earlier versions of this patchset) and currently define
| > the system call as:
| > 
| > 	struct clone_struct {
| > 		u64 flags;
| > 		u64 child_stack;
| > 		u32 nr_pids;
| > 		u32 parent_tid;
| > 		u32 child_tid;
| 
| So @parent_tid and @child_tid are pointers to userspace memory and
| require 'u64' (and it won't hurt to make @reserved1 a 'u64' as well).

Well, if we make parent_tid and child_tid u64, we could move reserved1
after ->nr_pids and leave it as a 32-bit value.

| 
| > 		u32 reserved1;
| > 		u64 reserved2;
| > 	};
| > 
| 
| Also, for forward/backward compatibility, explicitly state in the
| documentation, and enforce in the kernel, that flags which are not
| defined must not be set, and that reserved{1,2} must remain 0.

Agree with checking for reserved1 and reserved2.

We currently don't check for invalid clone_flags - we just ignore them.
Adding checks like

	if (fls(kcs.flags) > fls(CLONE_LAST_FLAG))

would assume we always use bits in order (while it seems to make sense, to
use them in order, we don't seem to have done so in the past).

Alternatively we could define a CLONE_FLAG_MASK of valid flags and update
the mask when each new clone flag is added. 

But do we really need to check for invalid flags ?

Sukadev
