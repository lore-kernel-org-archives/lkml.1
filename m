Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYABTn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYABTn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYABTnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:43:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:13793 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYABTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:43:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vb2LL8r4n7qrloLw9BqWt6coQGpRiwzpxp2nLkICngAYqvjFEhoRElbaqTVQc0EPB
	Ey6tvv9jGfvMrvoQlpyDQ==
Message-ID: <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com>
Date: Wed, 2 Jan 2008 11:43:08 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       valdis.kletnieks@vt.edu
In-Reply-To: <p731w9410yc.fsf@bingen.suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 10:39 AM, Andi Kleen <andi@firstfloor.org> wrote:
> "Russell Leidich" <rml@google.com> writes:
>
> Not sure you have addressed any of my feedback; don't see many changes.

I emailed you on 12/7/2007 and never heard back, so I assumed that you
had no further issues.  Anyway, thanks for getting back to me.

>
> When you repost stuff can you please add a changelog or if you decide
> to not address some review comment say why at least.
>
> Also the patch changelog description is missing anyways?

Sorry.  I'll add a robust description with the next revision of the patch.

> In general you seem to have a lot (too many?) of low level comments,
> but no high level "strategy" comment anywhere what this code actually
> tries to do. I find the high level comments usually more useful.
>

I tried to add high-level comments at the top of each function.  But I
can add more.

>
> Biggest issue I raised is still not addressed:
>
> > +     /*
> > +      * If any of the northbridges has PCI ID 0x1103, then its thermal
> > +      * hardware suffers from an erratum which prevents this code from
> > +      * working, so abort.
> > +      */
> > +     for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
> > +             if ((k8_northbridges[nb_num]->device) == 0x1103)
> > +                     goto out;
> > +     }
>
> AFAIK that's all K8s so the code will never work on them.

Well, yes, this is Barcelona-only at the moment (and in all
likelihood, will extend to some future CPUs).  Indeed, as far as my
testing has determined, there is no stepping of K8s which properly
implements thermal throttling.  Even Rev F has a crippling erratum.

>
> amd_cpu_callback:
>
> -       if (cpu >= NR_CPUS)
> -               goto out;
> -
>
> that change seems to be unrelated cleanup. Such patches should be always separate.

My buddy at Google suggested that I might as well fix this while I'm
tearing up the code.  But OK, I'll remove it.  I may or may not submit
a further patch.

> Same with the rename.

I disagree here.  The original code was exclusively focussed on
setting some MCE-related "threshold".  With my changes, it's more
generic.  "amd_" might not be the most appropriate prefix, but
"threshold_" certainly is not.

> +             printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
> +                     "functional.\n", cpu);
>
> Why is that KERN_CRIT? Does not seem that critical to me.

So what this message really says is:  "The OS cannot hook the thermal
interrupt because it has been hijacked or misconfigured by the BIOS.
Therefore, the throttling MCEs which you might naturally expect to see
on other Barcelona systems will not occur on this one.  Therefore, if
your cooling policy relies on these MCEs (bad idea, but legal), it
will fail, potentially resulting in fire or the loss of user data."
For example, if you're expecting to be warned at 50C that your CPU has
tripped the throttling threshold, you may never receive this warning,
and therefore may never turn on the fan.  Just because the CPU itself
may automatically shut down at 100C does not mean that the system
itself can withstand CPU temperatures this high, so fire is a remote
possibility.  If that's not CRIT, then tell me what level is
appropriate, and I'll change it.  To Valdis' point: the code is only
checking here for whether or not the BIOS has preempted the OS'
ability to hook the interrupt; there is no way for the code to
determine whether or not the sensor is actually functional, however
any client code which relies on its production of MCEs would fail, as
I just explained.

> I find it is quite common to do smp_call_function_single in CPU up/down callbacks.
> It would be better to fix that generically in the high level code (provide
> a new callback that is guaranteed to run on the target CPU) than to always reimplement
> it.

I agree, but it sounds like that should be the subject of another
patch which touches lots of other components.

> The erratum number/part number should be documented and the kernel ought to print
> why it didn't initialize thermal on that hardware.

I don't think there's a need for this, because 0x1103 came before
Barcelona; therefore, we can just consider this as a
Barcelona-and-later feature.

> You're technically racy against parallel cpu hotplug happening from initrd
> (which already runs during initcall -- yes that is a deathtrap)
> although that is typically hard to fix.

Can you elaborate?  I'm assuming that I still need to fix this in
order to get the patch accepted, no?

> thermal_apic_init_allowed seems like a hack. A separate notifier would
> be cleaner.

A variable is always lighter than a notifier.  I'm just trying to make
sure that if a CPU comes online before I'm ready to hook the thermal
interrupt, that it does not attempt to do so prematurely.  I'm not
sure what a notifier would do, other than set
thermal_apic_init_allowed anyway.

> PCI is already initialized before normal initcall, otherwise pretty much
> all drivers would break.

I'll change the comment.  I still want the convenience of a process
context, so I plan to keep the late_initcall().

> mce_thermal.c seems to be just unnecessary to me. It would be cleaner
> to just keep the separate own handlers, especially since they do quite
> different things anyways. Don't mesh together what is quite different.

As I mentioned to Andrew Morton, this is not easily avoidable without
some gross runtime CPUID hack.  Specifically, how do you handle a
kernel build which supports both AMD and Intel thermal throttling,
wherein you don't know which CPU -- if either -- is present until
runtime?  The root of the problem is that both architectures share the
same APIC vector, but implement throttling in incompatible ways.

> Also "cpu_specific_smp_thermal_interrupt_callback_t" is definitely too long.

I'll delete some characters to make it more obscure and Linux-like.

-- 
Russell Leidich
