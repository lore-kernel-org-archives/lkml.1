Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbYBUUDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbYBUUDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYBUUDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:03:37 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53208 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbYBUUDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:03:36 -0500
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>,
       Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>
	 <20080221155852.GA42442@muc.de>
	 <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 12:02:40 -0800
Message-Id: <1203624160.6150.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 20:45 +0100, Thomas Gleixner wrote:
> On Thu, 21 Feb 2008, Andi Kleen wrote:
> 
> > On Wed, Feb 20, 2008 at 02:57:34PM +0100, Arne Georg Gleditsch wrote:
> > > Hi,
> > > 
> > > I'm looking at 2.6.25-rc2.  vsyscall_sysctl_change contains code to NOP
> > > out the actual system call instructions of the vsyscall page when
> > > vsyscall64 is enabled.  This seems to interact badly with the fallback
> > > code in do_vgettimeofday which tries to call gettimeofday if the
> > > configured clock source does not support vread.  (In effect,
> > > gettimeofday() becomes a nop and time() always returns 0.  Not very
> > > useful.)
> > > 
> > > Is there a good reason to keep this?  Aren't the instructions in
> > > question avoided (or invoked) according to the vsyscall64 flag by the
> > > surrounding logic anyway?
> > 
> > Yes they are.  But a system call sequence at a known fixed address
> > is potentially useful to exploits. That is why it is nop'ed out when
> > it is not needed.
> 
> That's a nice intent, but the reality is that this code is broken as
> hell:
> 
> 1) the patching code runs without synchronizing other CPUs
> 
> 2) it inserts NOPs even if there is no clock source which provides
> vread
> 
> 3) when the clock source changes to one without vread we run in
> exactly the same problem as in #2

I've not looked deeply here, but it seems to resolve #2 and #3, we need
some way for glibc to know if it should jump to the vsyscall or make the
syscall itself.

If it always jumps to the vsyscall address, it seems we have to have
some way of falling back to syscall inside the vsyscall.

That or we need to do the NOP/un-NOP part in the update_vsyscall code
dependent on if the current clocksource supports vread, instead of on
the /proc entry access.

-john



