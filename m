Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbYABVNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbYABVNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbYABVNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:13:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30814 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbYABVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:13:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=FBomAwDa3YENzisdSdyra60/k9hdskNi6gHHx9ERbj7DamRtCvHTc0/N2zjZfTwR/
	vYHRC4aZFSPGtwCgqX3Aw==
Message-ID: <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com>
Date: Wed, 2 Jan 2008 13:12:58 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       valdis.kletnieks@vt.edu
In-Reply-To: <20080102200039.GA13784@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071217185453.C4597CC562@localhost>
	 <20071225140413.e8b4f2cd.akpm@linux-foundation.org>
	 <3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com>
	 <20071227233419.d1adf3f3.akpm@linux-foundation.org>
	 <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com>
	 <p731w9410yc.fsf@bingen.suse.de>
	 <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com>
	 <20080102200039.GA13784@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2008 12:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Jan 02, 2008 at 11:43:08AM -0800, Russell Leidich wrote:
> > > > +      */
> > > > +     for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
> > > > +             if ((k8_northbridges[nb_num]->device) == 0x1103)
> > > > +                     goto out;
> > > > +     }
> > >
> > > AFAIK that's all K8s so the code will never work on them.
> >
> > Well, yes, this is Barcelona-only at the moment (and in all
>
> Ok, but that was totally unclear to me which suggests it should
> be somewhere in the description/changelog and possibly in the comments.

Deal.

>
> > likelihood, will extend to some future CPUs).  Indeed, as far as my
> > testing has determined, there is no stepping of K8s which properly
> > implements thermal throttling.  Even Rev F has a crippling erratum.
>
> How about RevG?

I don't know of any RevG.  Please explain.

> >
> > > Same with the rename.
> >
> > I disagree here.  The original code was exclusively focussed on
> > setting some MCE-related "threshold".  With my changes, it's more
> > generic.  "amd_" might not be the most appropriate prefix, but
> > "threshold_" certainly is not.
>
> But such changes should be separate.

OK, I'll back it out.

>
> >
> > > +             printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
> > > +                     "functional.\n", cpu);
> > >
> > > Why is that KERN_CRIT? Does not seem that critical to me.
> >
> > So what this message really says is:  "The OS cannot hook the thermal
> > interrupt because it has been hijacked or misconfigured by the BIOS.
> > Therefore, the throttling MCEs which you might naturally expect to see
> > on other Barcelona systems will not occur on this one.  Therefore, if
> > your cooling policy relies on these MCEs (bad idea, but legal), it
>
> I don't think any Linux relies on that MCE for cooling so that seems like
> a highly hypothetical situation. You would need a kernel driver for it
> because there is no way to get it in user space even using a mce trigger.
>
> If anything that should be handled through ACPI thermal trip anyways.
>
> I think my point stands that this is not critical.

OK, KERN_WARN then.

>
> > I agree, but it sounds like that should be the subject of another
> > patch which touches lots of other components.
>
> Sure.
>
> >
> > > The erratum number/part number should be documented and the kernel ought to print
> > > why it didn't initialize thermal on that hardware.
> >
> > I don't think there's a need for this, because 0x1103 came before
> > Barcelona; therefore, we can just consider this as a
> > Barcelona-and-later feature.
>
> Ok, but that needs to be documented somewhere. Otherwise people will
> eventually find out and then require lots of research to find this out.
>
> e.g. if you had a high level comment that says
>
> /* AMD Fam10h supports thermal throttling. When such a event happens we do
>  * .... because of X Y Z. Implement this in the following code.
>  * We don't do it on K8 due to crippling errata.
>  */
>
> it would have been all clear.

Will do.

>
> >
> > > You're technically racy against parallel cpu hotplug happening from initrd
> > > (which already runs during initcall -- yes that is a deathtrap)
> > > although that is typically hard to fix.
> >
> > Can you elaborate?  I'm assuming that I still need to fix this in
> > order to get the patch accepted, no?
>
> initrd user space can run in parallel with __initcall and in theory
> it could trigger CPU hotplug events (and do lots of other things too)
>
> It's quite unexpected and regularly causes bugs.
>
> A lot of subsystems are racy this way.  Also it's not easily fixable because
> of locking problems in the cpu hotplug subsystem.
>
> I just mentioned it for completeness; fixing it is probably beyond
> scope of your patch and not a merging requirement.

OK, well it's good to have your comment in the mail archives for when
someone tries to fix this globally.

>
> >
> > > thermal_apic_init_allowed seems like a hack. A separate notifier would
> > > be cleaner.
> >
> > A variable is always lighter than a notifier.  I'm just trying to make
>
> Lighter but still a hack.  I don't insist on it, it just makes
> your code uglier than it could be.

I'm going to be ugly, but if someone to beautify it later, I won't oppose.

>
> > sure that if a CPU comes online before I'm ready to hook the thermal
> > interrupt, that it does not attempt to do so prematurely.  I'm not
> > sure what a notifier would do, other than set
> > thermal_apic_init_allowed anyway.
> >
> > > PCI is already initialized before normal initcall, otherwise pretty much
> > > all drivers would break.
> >
> > I'll change the comment.  I still want the convenience of a process
> > context, so I plan to keep the late_initcall().
>
> All __initcalls are in process context. late etc. just changes the
> ordering inside them.
>
> >
> > > mce_thermal.c seems to be just unnecessary to me. It would be cleaner
> > > to just keep the separate own handlers, especially since they do quite
> > > different things anyways. Don't mesh together what is quite different.
> >
> > As I mentioned to Andrew Morton, this is not easily avoidable without
> > some gross runtime CPUID hack.  Specifically, how do you handle a
> > kernel build which supports both AMD and Intel thermal throttling,
> > wherein you don't know which CPU -- if either -- is present until
> > runtime?  The root of the problem is that both architectures share the
> > same APIC vector, but implement throttling in incompatible ways.
>
> You set different handlers depending on the CPU type.

Right.  But that's exactly what I'm doing.  If I understand correctly,
your complaint is just that I'm doing the CPU-independent stuff in one
place (before branching to the CPU-specific code), and it would be
better to create duplicate code?  If I do it your way, I'll need to do
something gross in entry_64.S.  Specifically, thermal_interrupt() will
need to change from:
--------------------------
ENTRY(thermal_interrupt)
	apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt
END(thermal_interrupt)
--------------------------
to:
--------------------------
ENTRY(thermal_interrupt)
        push %rax
        mov ($some_memory_location), %rax
	apicinterrupt THERMAL_APIC_VECTOR,%rax
        pop %rax
END(thermal_interrupt)
--------------------------
which might not work, depending on how apicinterrupt is defined, and
how easily I can get $some_memory_location loaded with the right
value.

Is this the fix you have in mind?

>
> >
> > > Also "cpu_specific_smp_thermal_interrupt_callback_t" is definitely too long.
> >
> > I'll delete some characters to make it more obscure and Linux-like.
>
> If you just set different handlers you don't need it at all.

True.

>
> -Andi
>



-- 
Russell Leidich
