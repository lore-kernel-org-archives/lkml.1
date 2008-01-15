Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYAORvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYAORvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYAORvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:51:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32945 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYAORvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:51:09 -0500
Date: Tue, 15 Jan 2008 17:49:48 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Bryan Wu <bryan.wu@analog.com>
Cc: Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20080115174948.GB19306@flint.arm.linux.org.uk>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk> <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 08:24:34AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 15 Jan 2008, Russell King wrote:
> > 
> > I don't particularly like stuffing the options into some random place
> > in the architectures Kconfig file when they should stay along side the
> > instrumentation configuration entries.
> 
> Well, I have to say that I don't particularly like obviously 
> architecture-specific stuff in an obviously non-architecture file..
> 
> I'd almost prefer to revert the thing that caused the problem, because 
> with Adrian's patch, I think the end result may *work*, but it's uglier 
> than what we started out with.
> 
> However, I think the *cleanest* solution right now may be something like 
> the appended. Totally untested, of course. It basically just copies the 
> generic kernel/Kconfig.instrumentation file into the arm directory, makes 
> arm use its own instead of the generic one, and removes the dependencies 
> on ARM in there (including all of the KPROBES entry that apparently isn't 
> an issue on ARM anyway). It then adds back the ARM-specific ones.
> 
> This follows the sacred rules of good code:
> 
>  - generic code is either generic or not. If it's not generic, don't claim 
>    it is.
> 
>  - don't *force* people to use generic code if it doesn't suit them. Make 
>    it available for the cases it makes sense for, but don't shoe-horn it 
>    into cases where it doesn't work well.
> 
> So it allows the sharing of the common case and *many* architectures end 
> up using the generic Kconfig file, but hey, if it doesn't make sense for 
> ARM, it doesn't make sense for ARM. It's that simple.
> 
> But as mentioned, it's totally untested and I don't have (or really want 
> to have) a cross-compiling environment. And I don't care *that* much. I 
> just want something we can all live with.
> 
> So does something like this work for people?

BTW, your patch may fix ARM, but the original commit broke blackfin as
well - it removed the Kconfig entry for HARDWARE_PM, which is still used:

$ grep HARDWARE_PM arch/blackfin/ -r
arch/blackfin/mach-common/interrupt.S:#ifdef CONFIG_HARDWARE_PM
arch/blackfin/mach-common/interrupt.S:#ifdef CONFIG_HARDWARE_PM
arch/blackfin/mach-common/irqpanic.c:#ifdef CONFIG_HARDWARE_PM
arch/blackfin/oprofile/Makefile:oprofile-$(CONFIG_HARDWARE_PM) += op_model_bf533.o
arch/blackfin/oprofile/common.c:#ifdef CONFIG_HARDWARE_PM

So blackfin also needs fixing.  I don't know if blackfin people are
aware of this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
