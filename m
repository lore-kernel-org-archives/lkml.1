Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYFQTIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYFQTIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbYFQTIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:08:43 -0400
Received: from lec.cs.unibo.it ([130.136.1.103]:54299 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbYFQTIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:08:42 -0400
Date: Tue, 17 Jun 2008 21:08:31 +0200
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/1] ptrace_vm: let us simplify the code for ptrace and add useful features for VM
Message-ID: <20080617190831.GC32418@cs.unibo.it>
References: <20080616075804.GA6950@cs.unibo.it> <20080617162511.GA7223@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617162511.GA7223@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 12:25:11PM -0400, Jeff Dike wrote:
> On the whole, I'm in favor of generalizing ptrace, especially if it
> also simplifies the interface and code.  Some notes below...
So, we agree on this.
> 
> > I already proposed some time ago a different tag: PTRACE_SYSVM 
> > (and I maintain a patch for it) where:
> > ptrace(PTRACE_SYSVM, pid, XXX, 0)
> > 1* is the same as PTRACE_SYSCALL when XXX==0,
> > 2* skips the call (and stops before entering the next syscall) when
> >   PTRACE_VM_SKIPCALL | PTRACE_VM_SKIPEXIT
> There's a symmetry implied in the PTRACE_VM_SKIPCALL and
> PTRACE_VM_SKIPEXIT names which doesn't exist in reality.  SKIPEXIT (as
> you note later) merely omits the notification on system call return.
> SKIPCALL keeps the notification, but omits the system call execution,
> so the effects are very different from each other.
Maybe we can find out better tag names.
In the patch I submitted PTRACE_VM_SKIPCALL implies PTRACE_VM_SKIPEXIT
as it is useless to have a notification after nothing has been done.
So, there are three behaviors after the first notification:
0 -> do the syscall and notify after it
PTRACE_VM_SKIPEXIT -> do the syscall and do not notify after it
PTRACE_VM_SKIPCALL -> skip everything.
> 
> I think this is just a naming issue - we don't want the names to fake
> people into assuming things which aren't true.
Please help me to find better tag names.
> 
> > SYSVM can be used also for partial virtual machines (some syscall gets
> > virtualized and some others do not), like our umview.
> BTW, if performance is the issue here (and I don't see any other
> compelling reasons for it), there are other possibilities which
> provide much better performance.  Any PTRACE_* variant will have at
> least one notification.  While there is a noticable gain over two
> notifications, that's marginal compared to no notifications at all.
> If you know ahead of time what system calls you want to trace, a
> system call tracing mask lets you avoid those notifications totally.
There is a misunderstanding about what I meant with "some syscall gets
virtualized and some others do not". Obviously it if a fault of mine, it
was poorly explained. Let me briefly describe our partial virtual
machines to explain one possible application for these tags.
(the complete documentation of the project can be found here:
wiki.virtualsquare.org).

umview (and now kmview using a kernel module based on utrace) decides if
a syscall must be virtualized or not depending on the value of its
arguments, not on the syscall number. With "system call" I mean "call of
a system call", a "system call call";-)

For example, *mview {umview,kmview} can virtualize just a subtree of the
file system, thus a "open" system call gets virtualized only if the path
refers to a file in the subtree. Consequently a system call like "read"
becomes virtual if the file descriptor was created by a virtualized
open, otherwise the process executes the standard read provided by the
kernel.

In this way users can (virtually) mount file system images just for the
processes running inside a *mview instance, or run user-level network
stacks, virtual devices, define their own perspective on everything
(uid, gid, system name). We have virtualized even the pace of the time
flowing.

We do not "boot" a different kernel, there are just modules that users
can combine to virtualize different entities:
- umfuse for the file system
- umnet for networking
- umdev for devices
- umtime, umbinfmt, umtime, umname... 

We need all the different behaviors listed above.
PTRACE_VM_SKIPCALL -> for the system calls we virtualize.
PTRACE_VM_SKIPEXIT -> for the non virtualized system call.
0 -> sometimes we need the kernel to execute a different system call
or just we need to provide the process with a different output.
In the "open" situation above, we need the kernel to run something to
acquire a real file descriptor, as the process sees a mix of real and
virtual open files.

I think that other projects can benefit from this generalization, while
UML can use PTRACE_VM_SKIPCALL as it is currently using PTRACE_SYSEMU,
maybe extending this optimization to other architectures.

	renzo
