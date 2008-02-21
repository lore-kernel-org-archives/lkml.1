Return-Path: <linux-kernel-owner+w=401wt.eu-S1765463AbYBUTrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765463AbYBUTrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbYBUTrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:47:22 -0500
Received: from www.tglx.de ([62.245.132.106]:57064 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042AbYBUTrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:47:20 -0500
Date: Thu, 21 Feb 2008 20:45:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@muc.de>
cc: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
In-Reply-To: <20080221155852.GA42442@muc.de>
Message-ID: <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no> <20080221155852.GA42442@muc.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Andi Kleen wrote:

> On Wed, Feb 20, 2008 at 02:57:34PM +0100, Arne Georg Gleditsch wrote:
> > Hi,
> > 
> > I'm looking at 2.6.25-rc2.  vsyscall_sysctl_change contains code to NOP
> > out the actual system call instructions of the vsyscall page when
> > vsyscall64 is enabled.  This seems to interact badly with the fallback
> > code in do_vgettimeofday which tries to call gettimeofday if the
> > configured clock source does not support vread.  (In effect,
> > gettimeofday() becomes a nop and time() always returns 0.  Not very
> > useful.)
> > 
> > Is there a good reason to keep this?  Aren't the instructions in
> > question avoided (or invoked) according to the vsyscall64 flag by the
> > surrounding logic anyway?
> 
> Yes they are.  But a system call sequence at a known fixed address
> is potentially useful to exploits. That is why it is nop'ed out when
> it is not needed.

That's a nice intent, but the reality is that this code is broken as
hell:

1) the patching code runs without synchronizing other CPUs

2) it inserts NOPs even if there is no clock source which provides
vread

3) when the clock source changes to one without vread we run in
exactly the same problem as in #2

4) if nobody toggles the proc entry from 1 to 0 and to 1 again, then
the syscall is not patched out contrary to your claim.

Thanks,

	tglx
