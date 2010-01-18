Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992Ab0ARRpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0ARRpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929Ab0ARRpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:45:15 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42399 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0ARRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:45:13 -0500
Date: Mon, 18 Jan 2010 23:15:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Joshua Pincus <joshua.pincus@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100118174505.GB23680@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 05:45:55PM -0800, Joshua Pincus wrote:
<snipped>
> 1) When executed, a user-land application must be able to program 4
> pinned hardware
> breakpoint registers.  I need 1 byte granularity (address length
> specificity) and the ability
> to set RWX event triggers.
> 

attr.pinned = 1;
attr.bp_len = HW_BREAKPOINT_LEN_1;
attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;

(HW_BREAKPOINT_X is allowed only for user-space requests in x86, at the
moment).

> 2) All calls to clone() or fork() will propagate the
> debug register settings from parent to child(ren).
> 

attr.inherit = 1;

When used with the proposed new interface:
register_user_hbp_by_pid(struct perf_event_attr * attr,
perf_overflow_handler_t triggered, pid_t pid)
(LKML reference:20091217172010.GB5457@in.ibm.com)

the said request is propagated to all new threads of the process and
any child processes (and its threads).

> 3) When a breakpoint is triggered, the application
> thread currently running which triggered the breakpoint
> immediately stops execution and is sent a SIGTRAP.
> 

Signal generation happens by default for all user-space breakpoint
requests (and not just for ptrace requests).

> 4) The thread transitions from the PC that triggered the breakpoint to
> the signal handler for SIGTRAP.
> 
> 5) The signal handler does some work.  (This "work" is outside the
> scope of my request, but you may have some insights.  I need to be
> able to change the PC and nPC for the thread that triggered a
> breakpoint such that when it
> returns from the signal handler it doesn't return to the instruction
> that triggered the breakpoint but to the one after it.  If I were
> using ptrace(8), I would just have the parent
> process use the ptrace(8) syscall to modify the PC and
> nPC of the child.  I'm not using ptrace(8).)
> 

I don't see a need to do this explicitly (atleast on x86 and hopefully
for PPC64 too). Breakpoint exceptions due to data accesses are mostly
triggered after the memory access is performed. In other words, the
instruction causing the memory access is completed following which the
breakpoint exception is raised (atleast on x86). In turn, this implies
that the signal is delivered/handled after "PC" and when the execution
returns to the original thread, it resumes from the new PC (I'm not
sure nPC referred to here actually means).

> 6) The signal handler returns and the thread returns to normal
> execution at the new
> PC and nPC.
> 

It is possible to achieve all the above requirements (using the
above-suggested methods) in a slightly convoluted way i.e. by using
a kernel module that makes user-space breakpoint requests by directly
invoking the hw-breakpoint API (and not through ptrace or perf syscalls).
Such a kernel module can receive parameters namely PID, user-space address
(and breakpoint attributes such as length, etc) through various ways - 
as kernel module parameters or through proc, sys, debugfs interfaces.

Thanks,
K.Prasad

