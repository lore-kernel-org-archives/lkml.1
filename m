Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYGUKyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYGUKyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYGUKyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:54:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044AbYGUKyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:54:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Miller <davem@davemloft.net>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
In-Reply-To: David Miller's message of  Friday, 18 July 2008 02:20:35 -0700 <20080718.022035.208722773.davem@davemloft.net>
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080718.022035.208722773.davem@davemloft.net>
X-Shopping-List: (1) Joyous climate gloves
   (2) Avaricious congestion
   (3) Repellent annoyers
Message-Id: <20080721105431.3BD2015421D@magilla.localdomain>
Date: Mon, 21 Jul 2008 03:54:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I took a quick look at the sparc64 tracehook support and only spotted
> one issue.

Thanks for the feedback.  The sparc64 (and ia64) code I have is meant
only as a starting point, and there are some unfinished holes.  I'd
intended to point you (arch maintainers) at what I whipped up but
leave it to you to decide on the correct arch bits and merge them
eventually.  (The x86 and powerpc patches are the only ones I've
really used myself and would submit as claimed to be ready.)

> You'll need special handling for 32-bit compat tasks when copying the
> arguments in.  You can't just use the full 64-bit values because they
> get 32-bit zero extended by the 32-bit syscall entry code, and this
> doesn't propagate into the pt_regs copies.

This is true of powerpc too.  I guess I'd figured that uses of the
calls would know when it's 32-bit and truncate what they saw.  Isn't
that what happens now when a 64-bit ptrace caller uses the 64-bit
getregs flavor on a target task that is actually 32-bit?  

But I don't disagree it might well be better for syscall_get_arguments
to truncate values to 32 bits.  I don't think there's a need for it to
reflect sign-extended 64-bit values when it's a 32-bit task.  Probably
better not to, i.e. see "123 0xffffffff ..." in /proc/pid/syscall on a
64-bit kernel for a 32-bit task as on 32-bit, instead of 32-bit apps
that don't normally notice whether the kernel is 64 or 32 sometimes
seeing "123 0xffffffffffffffff ...".

> Actually, it's more complicated than that.  We have to sign extend
> arguments in some cases, and this is performed by a class of stubs
> in arch/sparc64/kernel/sys32.S which then revector to the real
> system call handler.

It's odd that you need sign-extended arguments for all those calls
when other machines don't.

> I don't know how you want to handle those cases.  Should the tracehook
> user know that it's a 32-bit task, what system call it is, and therefore
> do the appropriate sign extensions?  That doesn't sound right.

Which call are you talking about?  For syscall_get_arguments, I think
it's fine to get all values zero-extended from 32 bits (maybe even
fine to get random high bits).  The consumer of those values in the
kernel code ought well enough to know whether it's a 32-bit or 64-bit
task's system call--that changes what the call number and arguments
mean, anyway.

For syscall_set_arguments, it's a different question.  In that case,
we should expect that whatever original source of the value being
poked in was, it just knows it's poking a 32-bit task and doesn't even
consider that the kernel might be 64 bits.  It should poke a 32-bit
value and have the effect that poking that 32-bit value has on a
32-bit kernel.

Anyway, I don't see how this side of it is really an issue at all.
syscall_set_arguments is only valid to use at the syscall entry
tracing point.  This is before the dispatch to those stubs doing the
sign extension.  (Or it could be used at a point entirely outside of
syscall entry, like on the state just after -ERESTARTSYS handling
to change the args before the user re-executes the syscall.)

> The other arch's with compat support will have this same exact issue.

They don't seem to.


Thanks,
Roland
