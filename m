Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYLPPe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYLPPe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbYLPPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:34:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55304 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbYLPPes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:34:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: acpi_os_allocate(GFP_KERNEL) (was Re: acpi_evaluate_integer broken by design)
Date: Tue, 16 Dec 2008 16:34:25 +0100
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>, pavel@suse.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <20081125110508.GA1943@elf.ucw.cz> <alpine.LFD.2.00.0812152240500.30475@localhost.localdomain> <20081215214140.9031d4c8.akpm@linux-foundation.org>
In-Reply-To: <20081215214140.9031d4c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161634.25838.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16 of December 2008, Andrew Morton wrote:
> On Tue, 16 Dec 2008 00:24:43 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
> 
> > > Obviously, it is even better to do neither.  It is a basic and
> > > oft-reoccurring design mistake for a low-level piece of code to
> > > hardwire its GFP_foo decision.  The gfp_t should be passed in from the
> > > callers, all the way down the chain from the top-level code which
> > > actually knows what state this thread of control is in.
> > 
> > Here the caller does not know.
> 
> I bet it does it's just that the caller is thirty five levels of
> function call higher up...
> 
> > The crux of the problem it that the AML interpreter
> > may need to allocate memory and thus may sleep.
> > Under nominal conditions the interpreter only runs in 
> > user-context and allocatges with GFP_KERNEL
> > so sleeping is just dandy.
> > 
> > But AML also needs to run at boot time and at resume time
> > to do things like configure interrupts before interrupts are
> > enabled...
> > 
> > boot-time is handled by _cond_resched()
> > not calling __cond_resched unless
> > system_state == SYSTEM_RUNNING
> > 
> > I suppose I could do something like this,
> > though I'm not sure of the prettiest place
> > to check system_resume_irqsoff == true,
> > so that is left out for now...
> > 
> >
> > ...
> > 
> > diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
> > index e52ad91..def91fa 100644
> > --- a/drivers/acpi/pci_link.c
> > +++ b/drivers/acpi/pci_link.c
> > @@ -320,7 +320,7 @@ static int acpi_pci_link_set(struct acpi_pci_link *link, int irq)
> >  	if (!link || !irq)
> >  		return -EINVAL;
> >  
> > -	resource = kzalloc(sizeof(*resource) + 1, irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
> > +	resource = kzalloc(sizeof(*resource) + 1, GFP_KERNEL);
> >  	if (!resource)
> >  		return -ENOMEM;
> >  
> > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > index bb7d50d..27243f9 100644
> > --- a/drivers/acpi/power.c
> > +++ b/drivers/acpi/power.c
> > @@ -218,8 +218,7 @@ static int acpi_power_on(acpi_handle handle, struct acpi_device *dev)
> >  	}
> >  
> >  	if (!found) {
> > -		ref = kmalloc(sizeof (struct acpi_power_reference),
> > -		    irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
> > +		ref = kmalloc(sizeof (struct acpi_power_reference), GFP_KERNEL);
> >  		if (!ref) {
> >  			ACPI_DEBUG_PRINT((ACPI_DB_INFO, "kmalloc() failed\n"));
> >  			mutex_unlock(&resource->resource_lock);
> > diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> > index 029c8c0..9fbf73f 100644
> > --- a/include/acpi/platform/aclinux.h
> > +++ b/include/acpi/platform/aclinux.h
> > @@ -121,17 +121,16 @@ static inline acpi_thread_id acpi_os_get_thread_id(void)
> >  #include <acpi/actypes.h>
> >  static inline void *acpi_os_allocate(acpi_size size)
> >  {
> > -	return kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> > +	return kmalloc(size, GFP_KERNEL);
> >  }
> >  static inline void *acpi_os_allocate_zeroed(acpi_size size)
> >  {
> > -	return kzalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> > +	return kzalloc(size, GFP_KERNEL);
> >  }
> >  
> >  static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
> >  {
> > -	return kmem_cache_zalloc(cache,
> > -				 irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> > +	return kmem_cache_zalloc(cache, GFP_KERNEL);
> >  }
> >  
> >  #define ACPI_ALLOCATE(a)	acpi_os_allocate(a)
> > diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> > index 2ce8207..a716de8 100644
> > --- a/include/linux/suspend.h
> > +++ b/include/linux/suspend.h
> > @@ -128,9 +128,16 @@ extern void arch_suspend_disable_irqs(void);
> >   */
> >  extern void arch_suspend_enable_irqs(void);
> >  
> > +/**
> > + * suspend_irqs_off
> > + *
> > + * flag to indicate that IRQs are off for the benefit of suspend
> > + */
> > +extern bool system_suspend_irqs_off;
> >  extern int pm_suspend(suspend_state_t state);
> >  #else /* !CONFIG_SUSPEND */
> >  #define suspend_valid_only_mem	NULL
> > +#define system_suspend_irqs_off false
> >  
> >  static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
> >  static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
> > diff --git a/kernel/power/main.c b/kernel/power/main.c
> > index b8f7ce9..2eadae7 100644
> > --- a/kernel/power/main.c
> > +++ b/kernel/power/main.c
> > @@ -268,16 +268,20 @@ static int suspend_prepare(void)
> >  	return error;
> >  }
> >  
> > +bool system_resume_irqsoff;	/* IRQs are off for resume */
> 
> I guess that was supposed to be "system_suspend_irqs_off"?
> 
> >  /* default implementation */
> >  void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
> >  {
> >  	local_irq_disable();
> > +	system_resume_irqsoff = true;
> >  }
> >  
> >  /* default implementation */
> >  void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
> >  {
> >  	local_irq_enable();
> > +	system_resume_irqsoff = false;
> >  }
> 
> (please use __weak)
> 
> Whether it's "system_resume_irqsoff" or "system_suspend_irqs_off",
> neither of them actually got used ;)
> 
> If the code is really this simple and localised then perhaps:
> 
> gfp_t acpi_aml_gfp_flags = GFP_ATOMIC;
> 
> void __weak arch_suspend_disable_irqs(void)
> {
> 	local_irq_disable();
> 	acpi_aml_gfp_flags = GFP_ATOMIC;
> }
> 
> /* default implementation */
> void __weak arch_suspend_enable_irqs(void)
> {
> 	local_irq_enable();
> 	acpi_aml_gfp_flags = GFP_KERNEL;
> }
> 
> would suffice.  Dunno.

arch_suspend_disable_irqs() and arch_suspend_enable_irqs() are only used during
suspend to RAM, but we have the 'suspend atomic context' during hibernation as
well.

> Why are we providing for an arch override of this?

Because of powerpc that does additional stuff here, AFAICS.

Anyway, analogous situation can happen on shutdown when the nonboot CPUs
are disabled and interrupts are off on the BSP.

I think what we need is something like 'if the nonboot CPUs are disabled and
interrupts are off (on the BSP, which is the only CPU active), use GFP_ATOMIC'.

I'll prepare a patch for that, unless someone is faster.

Thanks,
Rafael
