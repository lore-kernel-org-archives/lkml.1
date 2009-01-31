Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZAaPFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZAaPFD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 10:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAaPEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 10:04:53 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53273 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbZAaPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 10:04:52 -0500
Subject: Re: [PATCH] voyager: fix cpu bootmaps
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200901312327.50684.rusty@rustcorp.com.au>
References: <1233340317.3248.39.camel@localhost.localdomain>
	 <200901312327.50684.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 09:04:53 -0600
Message-Id: <1233414293.3541.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 23:27 +1030, Rusty Russell wrote:
> On Saturday 31 January 2009 05:01:57 James Bottomley wrote:
> > commit 98a79d6a50181ca1ecf7400eda01d5dc1bc0dbf0
> > Author: Rusty Russell <rusty@rustcorp.com.au>
> > Date:   Sat Dec 13 21:19:41 2008 +1030
> > 
> >     cpumask: centralize cpu_online_map and cpu_possible_map
> > 
> > Broke voyager largely because it currently initialises the
> > possible_map by copying, which isn't possible in the new scheme.  Fix
> > this by using init_cpu_possible() instead and tidy up other of the
> > cpumask declarations which now have global variables.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  arch/x86/mach-voyager/voyager_smp.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
> > index 9840b7e..dcc07d5 100644
> > --- a/arch/x86/mach-voyager/voyager_smp.c
> > +++ b/arch/x86/mach-voyager/voyager_smp.c
> > @@ -378,7 +378,7 @@ void __init find_smp_config(void)
> >  	cpus_addr(phys_cpu_present_map)[0] |=
> >  	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
> >  				       3) << 24;
> > -	cpu_possible_map = phys_cpu_present_map;
> > +	init_cpu_possible(&phys_cpu_present_map);
> >  	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
> >  	       cpus_addr(phys_cpu_present_map)[0]);
> >  	/* Here we set up the VIC to enable SMP */
> 
> Strange, the assignment should still work, even though this new method is
> preferred.

I know, it's weird ... it's like the compiler is copying to the lvalue
but then discarding the result somehow ... with the direct assignment,
we end up with nothing in cpu_possible_bits, then the smp alternatives
switch to UP and all hell breaks loose when multiple CPUs are brought
up.

I think the problem is that cpu_possible_mask isn't an alias for
cpu_possible_bits, so when I update the former directly it breaks the
correspondence set up in kernel/cpu.c ... your declaration of it as
*const looks to be causing the compiler to do this.

Thus, I think direct assignment to cpu_possible_map (and hence
cpu_possible_mask) should be forbidden.

> How do your patches normally get upstream?  I'd normally just fwd this to
> Ingo...
> 
> Sorry I broke your platform...

That's OK ... Voyager is one of those platforms that tends to come off
worst on updates, so I'm used to sweeping up around it.

James


