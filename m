Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYFVJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYFVJLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYFVJLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:11:07 -0400
Received: from lec.cs.unibo.it ([130.136.1.103]:34372 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbYFVJLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:11:05 -0400
Date: Sun, 22 Jun 2008 11:11:02 +0200
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/1] ptrace_vm: let us simplify the code for ptrace and add useful features for VM
Message-ID: <20080622091102.GA29401@cs.unibo.it>
References: <20080616075804.GA6950@cs.unibo.it> <20080617162511.GA7223@c2.user-mode-linux.org> <20080617190831.GC32418@cs.unibo.it> <20080618164942.GC8225@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618164942.GC8225@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 12:49:42PM -0400, Jeff Dike wrote:
> Looking at things this way, it seems like you might want three flags,
> since the asymmetry is caused by two things being bundled into
> SKIPCALL.
> If you have
> 	PTRACE_VM_SKIPEXIT - skip the return notification
> 	PTRACE_VM_SKIPCALL - skip the syscall
> 	PTRACE_VM_SKIPSTART - skip the call notification
> this makes the meaning make more sense to me.

Jeff,

There are three events for a syscall:
START - call notification
CALL - run the SYSCALL
EXIT - return notification.

I think that it is a non sense to write code for useless cases.
Let us see all the combinations of doing/skipping each one of the three
phases:

0- DOSTART - DOCALL - DOEXIT - Standard PTRACE_SYSCALL (new option 0)
1- DOSTART - DOCALL - SKIPEXIT - PTRACE_VM_SKIPEXIT of my proposal
2- DOSTART - SKIPCALL - DOEXIT - useless, nothing has changed between
                              the two notifications
3- DOSTART - SKIPCALL - SKIPEXIT - PTRACE_VM_SKIPCALL in my proposal
4- SKIPSTART - DOCALL - DOEXIT - is this useful? (Case 4,see below)
5- SKIPSTART - DOCALL - SKIPEXIT - simply don't use PTRACE_SYSCALL
6- SKIPSTART - SKIPCALL - DOEXIT - this is the old PTRACE_SYSEMU (case 6)
7- SKIPSTART - SKIPCALL - SKIPEXIT - nullify completely the syscalls
                                (case 7).
                                
case 4: a vm or debugging monitor receives just the return value of a
syscall. In many architectures it not even possible to read the parameters
of the call (e.g. powerpc where the first argument and the return value
use the same register). This choice must be done a-priori, so without
actually know which will be the next system call.

case 6: this makes sense just for applications which virtualize *all* the
system call, current PTRACE_SYSEMU works exactly in this way.
My patch shows that for these applications it does not matter whether the
virtualization takes place before skipping the call or after having just
skipped the call. So PTRACE_VM_SKIPCALL can be used instead.

case 7: skip the next syscall and give no information about, there is no way
to virtualize or trace what is going on.
Who could be ever interested in an option like this?

It seems that the combinations that really make sense are those skipping
a trailing part of the sequence.

DOSTART - DOCALL - DOEXIT         my option 0
DOSTART - DOCALL - SKIPEXIT       my option PTRACE_VM_SKIPEXIT
DOSTART - SKIPCALL - SKIPEXIT     my option PTRACE_VM_SKIPCALL

If you think that it is not clear from the tag name that PTRACE_VM_SKIPCALL
implies PTRACE_VM_SKIPEXIT let us change the name in:
PTRACE_VM_SKIPCALL_SKIPEXIT
Maybe the name is quite long, but in this way it is clear what it does.

Here are some problems I have in implementing all the combinations of
do/skip.
Case 2 should be implemented by faking the second notification just after
the first (just for the sake of completeness, it is useless!).
For Case 4 to 7, we'd need to keep a global process state bit because
a previous PTRACE_SYSCALL parameter affects the execution of the next
syscall.

Provided that an application has the need to trace the syscalls executed
by a target process why somebody would ever want to skip or do something
for the next syscall without even know which system call it is?  If
somebody wants to trace system calls it is reasonable that he/she wants
to be notified about each syscall first and then decide how to manage
the actual call.

Shortly, if we can envision applications that can reasonably use other
combinations of DO-SKIP flags, I'll be glad to rewrite a more general
patch, otherwise these options just add some complexity to the code
(against the premises), slow down (a bit) the execution speed and waste
kernel programmers' time.

  renzo
