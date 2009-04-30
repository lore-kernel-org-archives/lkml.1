Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZD3SQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZD3SQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbZD3SPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:15:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33875 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZD3SPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:15:51 -0400
Date: Thu, 30 Apr 2009 11:15:46 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered
	active device IRQ interrruption
Message-ID: <20090430181546.GA7257@us.ibm.com>
References: <20090408230820.GA14412@us.ibm.com> <86802c440904102346lfbc85f2w4508bded0572ec58@mail.gmail.com> <20090413193717.GB8393@us.ibm.com> <m1bpr0e2au.fsf@fess.ebiederm.org> <20090428000536.GA7347@us.ibm.com> <m1bpqhjco7.fsf@fess.ebiederm.org> <20090429004451.GA7329@us.ibm.com> <m1eivc9qsn.fsf@fess.ebiederm.org> <20090429171719.GA7385@us.ibm.com> <m13abr2w0a.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13abr2w0a.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:46:29AM -0700, Eric W. Biederman wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
> 
> >> > This didn't help.  Using 2.6.30-rc3 plus your patch both bugs
> >> > are unfortunately still present.
> >> 
> >> You could offline the cpus?  I know when I tested it on my
> >> laptop I could not offline the cpus.
> >
> > Eric, I'm sorry!  This was due to my stupid mistake.  When I
> > went to apply your patch I included --dry-run to test it but
> > apparently got distracted and never actually ran patch(1)
> > without --dry-run. <SIGH>
> >
> > So, I just rebuilt after _really_ applying the patch and got
> > the following result which probably to be what you intended.
> 
> Ok.  Good to see.
> 
> >> >> I propose detecting thpe cases that we know are safe to migrate in
> >> >> process context, aka logical deliver with less than 8 cpus aka "flat"
> >> >> routing mode and modifying the code so that those work in process
> >> >> context and simply deny cpu hotplug in all of the rest of the cases.
> >> >
> >> > Humm, are you suggesting that CPU offlining/onlining would not
> >> > be possible at all on systems with >8 logical CPUs (i.e. most
> >> > of our systems) or would this just force users to separately
> >> > migrate IRQ affinities away from a CPU (e.g. by shutting down
> >> > the irqbalance daemon and writing to /proc/irq/<irq>/smp_affinity)
> >> > before attempting to offline it?
> >> 
> >> A separate migration, for those hard to handle irqs.
> >> 
> >> The newest systems have iommus that irqs go through or are using MSIs
> >> for the important irqs, and as such can be migrated in process
> >> context.  So this is not a restriction for future systems.
> >
> > I understand your concerns but we need a solution for the
> > earlier systems that does NOT remove or cripple the existing
> > CPU hotplug functionality.  If you can come up with a way to
> > retain CPU hotplug function while doing all IRQ migration in
> > interrupt context I would certainly be willing to try to find
> > some time to help test and debug your changes on our systems.
> 
> Well that is ultimately what I am looking towards.
> 
> How do we move to a system that works by design, instead of
> one with design goals that are completely conflicting.
> 
> Thinking about it, we should be able to preemptively migrate
> irqs in the hook I am using that denies cpu hotplug.
> 
> If they don't migrate after a short while I expect we should
> still fail but that would relieve some of the pain, and certainly
> prevent a non-working system.
> 
> There are little bits we can tweak like special casing irqs that
> no-one is using.
> 
> My preference here is that I would rather deny cpu hotplug unplug than
> have the non-working system problems that you have seen.
> 
> All of that said I have some questions about your hardware.
> - How many sockets and how many cores do you have?

The largest is the x3950 M2 with up to 16 sockets and
96 cores in currently supported configurations and I
expect that there could be at least double those numbers
in the future.
http://www-03.ibm.com/systems/x/hardware/enterprise/x3950m2/index.html

> - How many irqs do you have?

On the single node x3950 M2 that I have been using with 
all of it's 7 PCIe slots vacant I see:
  [root@elm3c160 ~]# cat /proc/interrupts | wc -l
  21
Up to 4 nodes are currently supported and I expect
that there could be at least double that number in
the future.

> - Do you have an iommu that irqs can go through?

Only a subset of our systems (e.g. x460, x3850, x3950 
w/Calgary iommu) have this.

> 
> If you have <= 8 cores this problem is totally solvable.

Dreamer :-)

> 
> Other cases may be but I don't know what the tradeoffs are.
> For very large systems we don't have enough irqs without
> limiting running in physical flat mode which makes things
> even more of a challenge.
> 
> It may also be that your ioapics don't have the bugs that
> intel and amd ioapics have and we could have a way to recognize
> high quality ioapics.

I believe all our System x boxes have Intel and AMD ioapics.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

