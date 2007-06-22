Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbXFVCkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbXFVCkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 22:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXFVCkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 22:40:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXFVCko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 22:40:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
X-Fcc: ~/Mail/utrace
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: utrace comments
In-Reply-To: Russell King's message of  Monday, 30 April 2007 10:33:31 +0100 <20070430093331.GB11345@flint.arm.linux.org.uk>
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070622024010.57368D0002@magilla.localdomain>
Date: Thu, 21 Jun 2007 19:40:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell.  Your last comments in this thread gave the impression you
thought that ARM's existing PTRACE_SINGLESTEP support would be lost by
converting to the utrace-based ptrace implementation.  Christoph Hellwig
posted a reply giving the (correct) details of how this is not the case.
But I gather there is still some misunderstanding circulating on this point.

Here is the section from utrace-arch-porting-howto.txt about this:

    7. Software single-step.

       A few machines do not have any hardware single-step support, but provide
       PTRACE_SINGLESTEP by doing memory breakpoint insertion.  If your machine
       does this, do not define tracehook_enable_single_step et al.  The
       tracehook single-step/block-step functions are intended for true
       hardware support, or forms of software support that truly work as well
       as hardware support does.  Simply changing memory has a lot of problems,
       notably its incompatibility with multi-threaded debugging.

       For ptrace compatibility, just handle PTRACE_SINGLESTEP in your
       arch_ptrace function using your existing code.  If arch_ptrace needs
       to do something that should be undone when ptrace cleans up,
       asm/ptrace.h can #define HAVE_ARCH_PTRACE_DETACH and it will
       call void arch_ptrace_detach(struct task_struct *) before detaching.

       In future, the utrace world will have facilities to do things like
       per-thread breakpoints while mitigating the bad side effects of
       breakpoint insertion.  Then single-stepping will be emulated using
       those.  Until we have that, your old PTRACE_SINGLESTEP support code is
       fine for ptrace, but new utrace-based users will expect not to see side
       effects like memory-writing breakpoint insertion and are better off not
       falsely thinking there is proper single-step support.

I think that is pretty unambiguous, but please advise me how to make it
more clear.  In short, any existing arch with PTRACE_SINGLESTEP support
will keep it.  What differs between an arch with hardware support and an
arch doing a breakpoint-insertion hack is just where the old code is moved
to in the newly reorganized code.  Hardware support (or anything
indistinguishable from it) goes in tracehook_enable_single_step et al.
Old-style memory-modifying breakpoint-insertion goes into arch_ptrace.

> I have no real problem with a decision being made to drop kernel-based
> single stepping _provided_ we have some replacement strategy in place
> and readily available.  At the moment I've not seen such a strategy.

I never intended to suggest in any way that any regression in the behavior
of the ptrace call on any machine would be acceptable.  Maintaining the
status quo for ptrace is straightforward.

The challenge for machines without hardware single-step support is for the
future, more-interesting things built on utrace, unrelated to ptrace, to
support instruction-step features in nice ways.  I have not gotten into
details of the strategies for that because it is still vaporware barely
tried yet even in contorted prototype forms, and is not directly apropos to
the more immediate goal of integrating the utrace core into the kernel
without regressions in ptrace behavior.

> I'm not sure if Roland's expecting architecture maintainers to
> create such a strategy themselves - which would probably turn out to
> being far worse since you could end up with different implementations
> for each architecture.

Indeed I do not expect any arch to start from scratch, just to do the
narrowly arch-specific parts.  There isn't even a prototype of something to
try doing new ports of, so I have not mentioned details of what arch
support entails.  Making kprobes work robustly for your arch is useful
related work that you can do now (and someone has done some for ARM), not
that it addresses the userland single-step issue per se, but the arch
implementation details for kprobes inform arch details of some strategies
available.  We can talk about it if you like, but that is future work for
new features beyond the status quo.  I wouldn't like to conflate it with
discussions about the utrace work that exists now, or let that slow down
review or arch ports for the basic infrastructure.


I hope you will consider taking another crack at the utrace port for your
arch.  It really is not so much work.  If your arch is supported well by
qemu, and you can point me to either a qemu disk image or an easily
installed distro version that works well for kernel hacking on your arch, I
would be happy to give it a whirl to help write and debug the port.



Thanks,
Roland
