Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZLVLZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZLVLZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZLVLZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:25:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40806 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZLVLZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:25:31 -0500
Date: Tue, 22 Dec 2009 11:25:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Kevin Constantine <kevin.constantine@gmail.com>, netdev@vger.kernel.org,
       linux kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Kernel Panics in the network stack
Message-ID: <20091222112505.GA11410@n2100.arm.linux.org.uk>
References: <4B309AED.7080601@gmail.com> <1261480105.29570.15.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261480105.29570.15.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 11:08:25AM +0000, Catalin Marinas wrote:
> On Tue, 2009-12-22 at 10:09 +0000, Eric Dumazet wrote:
> > I found an old commit mentioning a problem with LDM instruction that
> > could be interrupted/ restarted with a base register already changed
> > -> we load registers with garbage.
> [...]
> > If the low interrupt latency mode is enabled for the CPU (from ARMv6
> > onwards), the ldm/stm instructions are no longer atomic. An ldm instruction
> > restoring the sp and pc registers can be interrupted immediately after sp
> > was updated but before the pc. If this happens, the CPU restores the base
> > register to the value before the ldm instruction but if the base register
> > is not sp, the interrupt routine will corrupt the stack and the restarted
> > ldm instruction will load garbage.
> [...]
> > I found one instance of LDM instruction in 2.6.30 that could have same problem :
> > 
> > __switch_to:
> > 
> > ...
> >         ldm r4, {r4, r5, r6, r7, r8, r9, sl, fp, sp, pc}
> 
> It looks to me like it is possible to get an interrupt after SP was
> loaded but before PC, the stack could be corrupted and PC would be
> loaded with garbage. One instance of your oops messages looks like PC
> corruption but the other may be caused by something else. What ARM CPU
> are you using?
> 
> I'm cc'ing Russell as well, it's strange that we haven't got any issue
> with this so far.

We don't see the issue because we explicitly disable low latency
interrupt mode.

> You could try #undef'ing __ARCH_WANT_INTERRUPTS_ON_CTXSW in
> arch/arm/include/asm/system.h as a sanity check for your aborts.

Unfortunately, we can't do that for older ARM architectures without
severely impacting the interrupt latency there.  Not only that, but
the interrupt latency will be increased during any context switch.

I really question the value of this "low latency interrupt" setting.
If you're worried about interrupts being disabled for a very small
number of bus cycles for a LDM, then you're going to be screaming
merry hell about the places in the kernel where interrupts are masked.
The two just do not go together.

The only case for enabling the low latency interrupt mode would be if
you have tightly controlled software which never disables interrupts.
Linux does not fall into that category, so enabling it is pointless
and causes unnecessary problems.

Given that, the simple and obvious solution is: do not modify the kernel
to enable low interrupt latency mode.
