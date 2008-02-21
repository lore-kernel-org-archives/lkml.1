Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbYBUUx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbYBUUx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYBUUxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:53:47 -0500
Received: from www.tglx.de ([62.245.132.106]:43571 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbYBUUxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:53:46 -0500
Date: Thu, 21 Feb 2008 21:47:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Andi Kleen <ak@muc.de>,
       Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
In-Reply-To: <1203624160.6150.5.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0802212129510.7583@apollo.tec.linutronix.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>  <20080221155852.GA42442@muc.de>  <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de> <1203624160.6150.5.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, john stultz wrote:
> > > Yes they are.  But a system call sequence at a known fixed address
> > > is potentially useful to exploits. That is why it is nop'ed out when
> > > it is not needed.
> > 
> > That's a nice intent, but the reality is that this code is broken as
> > hell:
> > 
> > 1) the patching code runs without synchronizing other CPUs
> > 
> > 2) it inserts NOPs even if there is no clock source which provides
> > vread
> > 
> > 3) when the clock source changes to one without vread we run in
> > exactly the same problem as in #2
> 
> I've not looked deeply here, but it seems to resolve #2 and #3, we need
> some way for glibc to know if it should jump to the vsyscall or make the
> syscall itself.

Does glibc have an existing fallback, when we return -ENOSYS (or
whatever) from the vsyscall path ? If not, we can not do this.

> If it always jumps to the vsyscall address, it seems we have to have
> some way of falling back to syscall inside the vsyscall.
> 
> That or we need to do the NOP/un-NOP part in the update_vsyscall code
> dependent on if the current clocksource supports vread, instead of on
> the /proc entry access.

That won't fly. We need to sychronize the CPUs when we patch the code,
which is not possible from update_wall_time with interrupts disabled.

I fear we have to kill the broken code for .25 and implement vdso
randomizing to fix that. Another short term solution to prevent
attacks via the syscall instruction would be to sanity check syscalls
when the call originates from the vsyscall address range, but that
might be frowned upon as it adds two assembler instructions into the
syscall hotpath :)

Thanks,

	tglx
