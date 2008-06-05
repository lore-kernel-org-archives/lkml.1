Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbYFEShd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbYFEShd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYFESh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:37:26 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53386 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbYFEShZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:37:25 -0400
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
In-Reply-To: <20080604061637.6bab3f67@infradead.org>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080603182014.79a38d03@infradead.org>
	 <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com>
	 <20080604061637.6bab3f67@infradead.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 05 Jun 2008 11:37:22 -0700
Message-Id: <1212691042.3946.20.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 06:16 -0700, Arjan van de Ven wrote:
> On Tue, 3 Jun 2008 21:01:54 -0700
> "Alok kataria" <alokkataria1@gmail.com> wrote:
> 
> > On Tue, Jun 3, 2008 at 6:20 PM, Arjan van de Ven
> > <arjan@infradead.org> wrote:
> > > On Tue, 03 Jun 2008 17:41:09 -0700
> > > Alok Kataria <akataria@vmware.com> wrote:
> > >
> > >> On X86 platform we can use the value of cpu_khz computed during tsc
> > >> calibration to calculate the loops_per_jiffy value. Its very
> > >> important to keep the error in lpj values to minimum as any error
> > >> in that may result in kernel panic in check_timer.
> > >> In virtualization environment on a highly overloaded host, the
> > >> guest delay calibration may sometimes result in errors beyond the
> > >> ~50% that timer_irq_works can handle, resulting in the guest
> > >> panicking.
> > > \
> > >
> > > can you guarantee that the rate tsc ticks at is the same as the
> > > current CPU frequency? Answer: You can't....
> > >
> >
> > I think at the boot time atleast we can assume that, no ?
> 
> Nope, absolutely not.
> 1) The rate TSC ticks may or may not be the maximum frequency (usually
> is, but no guarantee)
> 2) The BIOS might not boot your system at the maximum frequency (think
> "laptop on battery")... that's really up to the BIOS.
> 

So then, how about using the tsc_khz (tsc frequency) for this
calculation. Atleast for the boot processor the lpj value can be derived
from the tsc frequency.
So insted of using lpj_tsc for all cpu's we can use it just for the boot
processor.

> >
> > > sadly we do need to calibrate this...
> > >
> > > In addition, clearly you can have different cpus in a system run at
> > > a different rate (both in terms of cpu_khz and, independently, in
> > > terms of tsc rate)
> > >
> >
> > Again yes at run time frequency's may change but they shouldn't at
> > boottime. AFAIK, i don't think there are X86 MP systems with
> > asymmetric cpus i.e. systems with different
> > base frequencies. If thats not true then there sure is a problem.
> 
> there's nothing that guarantees this. (Well maybe Dell's website does
> because they want to sell you 2 expensive cpus rather than 1 cheap 1
> expensive one ;-)

Agreed so we might not be able to use it for other cpus's. 
Is there a way to get the cpu frequency of the processor that we are
bringing up, i see that there is cpufreq_quick_get but this would be
initialized very late in the boot process.  

If there is a way we can check if the cpu being brought up is same as
the last one and then we can skip the delay calibration, something like
what ia64 does.

Thanks,
Alok

