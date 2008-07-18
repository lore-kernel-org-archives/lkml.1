Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbYGRXIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbYGRXIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYGRXIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:08:39 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:45339 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYGRXIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:08:38 -0400
Date: Fri, 18 Jul 2008 17:08:37 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/14] Introduce cpu_enabled_map and friends
Message-ID: <20080718230837.GC20344@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <20080715023344.2528.1836.stgit@blender.achiang> <20080715023349.2528.9423.stgit@blender.achiang> <20080715031512.GF14894@parisc-linux.org> <87wsjnxy4w.fsf@basil.nowhere.org> <20080715102130.GA22866@flint.arm.linux.org.uk> <20080715175740.GB10919@ldl.fc.hp.com> <20080715181632.GG14894@parisc-linux.org> <20080715184822.GB29991@flint.arm.linux.org.uk> <20080715191515.GE10919@ldl.fc.hp.com> <20080718214454.GD25816@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718214454.GD25816@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King <rmk+lkml@arm.linux.org.uk>:
> On Tue, Jul 15, 2008 at 01:15:15PM -0600, Alex Chiang wrote:
> > * Russell King <rmk+lkml@arm.linux.org.uk>:
> > > 
> > > How about having smp_init() call into arch code to query whether
> > > it should bring up a not-already-online CPU?  Architectures that
> > > want to do something special can then make the decision there and
> > > everyone else can define the test completely away.
> > 
> > So this is exactly what I'm doing. The ia64 patch has this hunk:
> > 
> > @@ -820,6 +824,9 @@ __cpu_up (unsigned int cpu)
> >         if (cpu_isset(cpu, cpu_callin_map))
> >                 return -EINVAL;
> > 
> > +       if (!cpu_isset(cpu, cpu_enabled_map))
> > +               return -EINVAL;
> > +
> >         per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
> >         /* Processor goes to start_secondary(), sets online flag */
> >         ret = do_boot_cpu(sapicid, cpu);
> > 
> > That was the easiest, most-straightforward solution I could think
> > of. If you have an idea for a version with lower taxes (doesn't
> > touch all the archs or can be #define'd out), I'm happy to hear
> > it.
> 
> I think I did make a suggestion in the bit you quote from me above.
> 
> Let me be more explicit:

Thanks, sorry for being dense.

> static void __init smp_init(void)
> {
>         unsigned int cpu;
> 
>         /* FIXME: This should be done in userspace --RR */
>         for_each_present_cpu(cpu) {
>                 if (num_online_cpus() >= setup_max_cpus)
>                         break;
> -		if (!cpu_online(cpu))
> +		if (smp_cpu_enabled(cpu) && !cpu_online(cpu))
>                         cpu_up(cpu);
>         }
> 
>         /* Any cleanup work */
>         printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
>         smp_cpus_done(setup_max_cpus);
> }
> 
> and have architectures provide 'smp_cpu_enabled(cpu)' which can either
> be a function, inline function or a macro (and therefore possible to be
> completely eliminated.)

Yup, this is nicer. I'll try this.

/ac

