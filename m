Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYABT6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYABT6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYABT6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:58:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49842 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYABT6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:58:46 -0500
Date: Wed, 2 Jan 2008 21:00:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Russell Leidich <rml@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       valdis.kletnieks@vt.edu
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-ID: <20080102200039.GA13784@one.firstfloor.org>
References: <20071217185453.C4597CC562@localhost> <20071225140413.e8b4f2cd.akpm@linux-foundation.org> <3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com> <20071227233419.d1adf3f3.akpm@linux-foundation.org> <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com> <p731w9410yc.fsf@bingen.suse.de> <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 11:43:08AM -0800, Russell Leidich wrote:
> > > +      */
> > > +     for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
> > > +             if ((k8_northbridges[nb_num]->device) == 0x1103)
> > > +                     goto out;
> > > +     }
> >
> > AFAIK that's all K8s so the code will never work on them.
> 
> Well, yes, this is Barcelona-only at the moment (and in all

Ok, but that was totally unclear to me which suggests it should
be somewhere in the description/changelog and possibly in the comments.

> likelihood, will extend to some future CPUs).  Indeed, as far as my
> testing has determined, there is no stepping of K8s which properly
> implements thermal throttling.  Even Rev F has a crippling erratum.

How about RevG?
> 
> > Same with the rename.
> 
> I disagree here.  The original code was exclusively focussed on
> setting some MCE-related "threshold".  With my changes, it's more
> generic.  "amd_" might not be the most appropriate prefix, but
> "threshold_" certainly is not.

But such changes should be separate.

> 
> > +             printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
> > +                     "functional.\n", cpu);
> >
> > Why is that KERN_CRIT? Does not seem that critical to me.
> 
> So what this message really says is:  "The OS cannot hook the thermal
> interrupt because it has been hijacked or misconfigured by the BIOS.
> Therefore, the throttling MCEs which you might naturally expect to see
> on other Barcelona systems will not occur on this one.  Therefore, if
> your cooling policy relies on these MCEs (bad idea, but legal), it

I don't think any Linux relies on that MCE for cooling so that seems like
a highly hypothetical situation. You would need a kernel driver for it
because there is no way to get it in user space even using a mce trigger.

If anything that should be handled through ACPI thermal trip anyways.

I think my point stands that this is not critical.

> I agree, but it sounds like that should be the subject of another
> patch which touches lots of other components.

Sure.

> 
> > The erratum number/part number should be documented and the kernel ought to print
> > why it didn't initialize thermal on that hardware.
> 
> I don't think there's a need for this, because 0x1103 came before
> Barcelona; therefore, we can just consider this as a
> Barcelona-and-later feature.

Ok, but that needs to be documented somewhere. Otherwise people will
eventually find out and then require lots of research to find this out.

e.g. if you had a high level comment that says

/* AMD Fam10h supports thermal throttling. When such a event happens we do 
 * .... because of X Y Z. Implement this in the following code.
 * We don't do it on K8 due to crippling errata.
 */

it would have been all clear.

> 
> > You're technically racy against parallel cpu hotplug happening from initrd
> > (which already runs during initcall -- yes that is a deathtrap)
> > although that is typically hard to fix.
> 
> Can you elaborate?  I'm assuming that I still need to fix this in
> order to get the patch accepted, no?

initrd user space can run in parallel with __initcall and in theory
it could trigger CPU hotplug events (and do lots of other things too) 

It's quite unexpected and regularly causes bugs.

A lot of subsystems are racy this way.  Also it's not easily fixable because 
of locking problems in the cpu hotplug subsystem.

I just mentioned it for completeness; fixing it is probably beyond
scope of your patch and not a merging requirement.

> 
> > thermal_apic_init_allowed seems like a hack. A separate notifier would
> > be cleaner.
> 
> A variable is always lighter than a notifier.  I'm just trying to make

Lighter but still a hack.  I don't insist on it, it just makes
your code uglier than it could be.

> sure that if a CPU comes online before I'm ready to hook the thermal
> interrupt, that it does not attempt to do so prematurely.  I'm not
> sure what a notifier would do, other than set
> thermal_apic_init_allowed anyway.
> 
> > PCI is already initialized before normal initcall, otherwise pretty much
> > all drivers would break.
> 
> I'll change the comment.  I still want the convenience of a process
> context, so I plan to keep the late_initcall().

All __initcalls are in process context. late etc. just changes the
ordering inside them.

> 
> > mce_thermal.c seems to be just unnecessary to me. It would be cleaner
> > to just keep the separate own handlers, especially since they do quite
> > different things anyways. Don't mesh together what is quite different.
> 
> As I mentioned to Andrew Morton, this is not easily avoidable without
> some gross runtime CPUID hack.  Specifically, how do you handle a
> kernel build which supports both AMD and Intel thermal throttling,
> wherein you don't know which CPU -- if either -- is present until
> runtime?  The root of the problem is that both architectures share the
> same APIC vector, but implement throttling in incompatible ways.

You set different handlers depending on the CPU type.

> 
> > Also "cpu_specific_smp_thermal_interrupt_callback_t" is definitely too long.
> 
> I'll delete some characters to make it more obscure and Linux-like.

If you just set different handlers you don't need it at all.

-Andi
