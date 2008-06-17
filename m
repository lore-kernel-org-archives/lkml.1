Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYFQQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYFQQ0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYFQQ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:26:38 -0400
Received: from [198.99.130.12] ([198.99.130.12]:35179 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYFQQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:26:37 -0400
Date: Tue, 17 Jun 2008 12:25:11 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/1] ptrace_vm: let us simplify the code for ptrace and
	add useful features for VM
Message-ID: <20080617162511.GA7223@c2.user-mode-linux.org>
References: <20080616075804.GA6950@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616075804.GA6950@cs.unibo.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 09:58:04AM +0200, Renzo Davoli wrote:
> Summary of the solution:
> Use tags in the "addr" parameter of existing
> PTRACE_SYSCALL/PTRACE_SINGLESTEP/PTRACE_CONT/PTRACE_BLOCKSTEP calls
> to skip the current call (PTRACE_VM_SKIPCALL) or skip the second upcall to 
> the VM/debugger after the syscall execution (PTRACE_VM_SKIPEXIT).

On the whole, I'm in favor of generalizing ptrace, especially if it
also simplifies the interface and code.  Some notes below...

> I already proposed some time ago a different tag: PTRACE_SYSVM 
> (and I maintain a patch for it) where:
> ptrace(PTRACE_SYSVM, pid, XXX, 0)
> 1* is the same as PTRACE_SYSCALL when XXX==0,
> 2* skips the call (and stops before entering the next syscall) when
>   PTRACE_VM_SKIPCALL | PTRACE_VM_SKIPEXIT

There's a symmetry implied in the PTRACE_VM_SKIPCALL and
PTRACE_VM_SKIPEXIT names which doesn't exist in reality.  SKIPEXIT (as
you note later) merely omits the notification on system call return.
SKIPCALL keeps the notification, but omits the system call execution,
so the effects are very different from each other.

I think this is just a naming issue - we don't want the names to fake
people into assuming things which aren't true.

> SYSVM can be used also for partial virtual machines (some syscall gets
> virtualized and some others do not), like our umview.

BTW, if performance is the issue here (and I don't see any other
compelling reasons for it), there are other possibilities which
provide much better performance.  Any PTRACE_* variant will have at
least one notification.  While there is a noticable gain over two
notifications, that's marginal compared to no notifications at all.
If you know ahead of time what system calls you want to trace, a
system call tracing mask lets you avoid those notifications totally.

I wrote up a patch a couple of years ago -
	http://marc.info/?l=user-mode-linux-devel&m=114495242202954&w=2
but the interface implemented there isn't very good.

    		  	      Jeff

-- 
Work email - jdike at linux dot intel dot com
