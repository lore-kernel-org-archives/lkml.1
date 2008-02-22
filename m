Return-Path: <linux-kernel-owner+w=401wt.eu-S933613AbYBVMzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbYBVMzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYBVMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:55:04 -0500
Received: from colin.muc.de ([193.149.48.1]:4001 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYBVMzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:55:03 -0500
Date: 22 Feb 2008 13:55:01 +0100
Date: Fri, 22 Feb 2008 13:55:00 +0100
From: Andi Kleen <ak@muc.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
       Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
Message-ID: <20080222125500.GB81921@muc.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no> <20080221155852.GA42442@muc.de> <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de> <1203624160.6150.5.camel@localhost.localdomain> <alpine.LFD.1.00.0802212129510.7583@apollo.tec.linutronix.de> <alpine.LFD.1.00.0802212154550.7583@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802212154550.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 09:59:24PM +0100, Thomas Gleixner wrote:
> On Thu, 21 Feb 2008, Thomas Gleixner wrote:
> > > That or we need to do the NOP/un-NOP part in the update_vsyscall code
> > > dependent on if the current clocksource supports vread, instead of on
> > > the /proc entry access.
> > 
> > That won't fly. We need to sychronize the CPUs when we patch the code,
> > which is not possible from update_wall_time with interrupts disabled.
> 
> Also this is utterly stupid as we keep the syscall in cases where we
> do not have vread anyway, so we keep the attack point open for a lot
> of existing machines due to TSC wreckage and HPET unavailability.

Yes that is true, but I didn't find a cheap way around it without
breaking binary compatibility.

I found an expensive way (essentially just putting
a trampoline to a variable mapped vsyscall page on the old static
address), but since it would have added quite a lot of complexity
(vsyscall is inside the kernel mapping and would need to be rewritten
at context switch) and memory overhead in page tables and one more
page per process I didn't do that.

I also considered doing boot time randomization only (which
would avoid a lot of these problems), but it didn't seem worth it.

Also one must say I don't consider it a big security improvement on most
systems.  That is because most programs are not PIC, but linked at a fixed
address and usually if you grep the larger binary for the few bytes
needed for a system call you'll find it at some known offset as 
part of another instruction sequence.

-Andi
