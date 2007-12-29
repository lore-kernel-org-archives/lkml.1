Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbXL2CMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbXL2CMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXL2CMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:12:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:56028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbXL2CMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:12:00 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Russell Leidich" <rml@google.com>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Date: Sat, 29 Dec 2007 03:11:51 +0100
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
References: <20071217185453.C4597CC562@localhost> <20071227233419.d1adf3f3.akpm@linux-foundation.org> <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com>
In-Reply-To: <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712290311.51176.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007 21:40:28 Russell Leidich wrote:
> OK, given our discussion, perhaps the attached revised patch will be
> more to your liking.
> 
> If so, let me know and I'll give it one last paranoid test, then mail
> you a Signed-off-by patch.
> 

In general you seem to have a lot (too many?) of low level comments,
but no high level "strategy" comment anywhere what this code actually
tries to do. I find the high level comments usually more useful.

amd_cpu_callback:

-	if (cpu >= NR_CPUS)
-		goto out;
-

that change seems to be unrelated cleanup. Such patches should be always separate.
Same with the rename.

I find it is quite common to do smp_call_function_single in CPU up/down callbacks.
It would be better to fix that generically in the high level code (provide
a new callback that is guaranteed to run on the target CPU) than to always reimplement 
it.

thermal_apic_init:


+		printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
+			"functional.\n", cpu);

Why is that KERN_CRIT? Does not seem that critical to me.

smp_thermal_interrupt_init:

The erratum number/part number should be documented and the kernel ought to print
why it didn't initialize thermal on that hardware.

I'm not sure which erratum that is, but since that PCI-ID is used by all K8s
you excluded all of them, don't you? Is that whole code only for Fam10h? 
That seems a little drastic. Perhaps it should just check steppings etc.
And needs more comments.

You're technically racy against parallel cpu hotplug happening from initrd
(which already runs during initcall -- yes that is a deathtrap) 
although that is typically hard to fix.

thermal_apic_init_allowed seems like a hack. A separate notifier would
be cleaner.

+/*
+ * smp_thermal_interrupt_init cannot execute until PCI has been fully
+ * initialized, hence late_initcall().
+ */
+late_initcall(smp_thermal_interrupt_init);

PCI is already initialized before normal initcall, otherwise pretty much 
all drivers would break.


mce_thermal.c seems to be just unnecessary to me. It would be cleaner
to just keep the separate own handlers, especially since they do quite
different things anyways. Don't mesh together what is quite different.

Also "cpu_specific_smp_thermal_interrupt_callback_t" is definitely too long.

-Andi
