Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYLPFY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYLPFY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 00:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYLPFYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 00:24:49 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:41955 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYLPFYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 00:24:48 -0500
Date: Tue, 16 Dec 2008 00:24:43 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: acpi_os_allocate(GFP_KERNEL) (was Re: acpi_evaluate_integer broken by
 design)
In-reply-to: <20081126150224.947c18d4.akpm@linux-foundation.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pavel@suse.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812152240500.30475@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081125110508.GA1943@elf.ucw.cz>
 <20081126132050.cecb170b.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811261729550.3895@localhost.localdomain>
 <20081126150224.947c18d4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > The reason that the ACPI code is littered with bogus
> > irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL)
> > is because, like boot, resume starts life with interrupts off.
> 
> yes, suspend's disabling of interrupts causes problems all over the place.
> 
> If we really do need to inspect global state to handle this, it would
> be much better to create a new
> 
> bool resume_is_running_so_you_cant_sleep;
>
> and to test that.  Something which is clear, highly specific and which
> cannot be accidentally triggered via other means.

can do.

> > I would prefer that resume and boot handle this the same way,
> > with system_state.  However, a few years ago when I suggested
> > using system_state for resume, Andrew thought that was a very
> > bad idea.  Andrew, do you still feel that way?
> 
> yep.  We've had problems in the past with system_state, where people add
> new states, and old code breaks.  Plus as we add more dependencies on
> system_state, that reduces our ability to add new states and makes it
> harder to alter (ie: fix) system_state transitions, etc.  Just run
> away!
> 
> As I said above, if we have a piece of code which wants to know when a
> separate piece of code is in a particualr state, it is better to add a
> new state flag just for that application, rather than trying to infer
> things from the heavily overloaded system_state.
> 
> 
> Obviously, it is even better to do neither.  It is a basic and
> oft-reoccurring design mistake for a low-level piece of code to
> hardwire its GFP_foo decision.  The gfp_t should be passed in from the
> callers, all the way down the chain from the top-level code which
> actually knows what state this thread of control is in.

Here the caller does not know.

The crux of the problem it that the AML interpreter
may need to allocate memory and thus may sleep.
Under nominal conditions the interpreter only runs in 
user-context and allocatges with GFP_KERNEL
so sleeping is just dandy.

But AML also needs to run at boot time and at resume time
to do things like configure interrupts before interrupts are
enabled...

boot-time is handled by _cond_resched()
not calling __cond_resched unless
system_state == SYSTEM_RUNNING

I suppose I could do something like this,
though I'm not sure of the prettiest place
to check system_resume_irqsoff == true,
so that is left out for now...

-- Len Brown, Intel Open Source Technology Center

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index e52ad91..def91fa 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -320,7 +320,7 @@ static int acpi_pci_link_set(struct acpi_pci_link *link, int irq)
 	if (!link || !irq)
 		return -EINVAL;
 
-	resource = kzalloc(sizeof(*resource) + 1, irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
+	resource = kzalloc(sizeof(*resource) + 1, GFP_KERNEL);
 	if (!resource)
 		return -ENOMEM;
 
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index bb7d50d..27243f9 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -218,8 +218,7 @@ static int acpi_power_on(acpi_handle handle, struct acpi_device *dev)
 	}
 
 	if (!found) {
-		ref = kmalloc(sizeof (struct acpi_power_reference),
-		    irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
+		ref = kmalloc(sizeof (struct acpi_power_reference), GFP_KERNEL);
 		if (!ref) {
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO, "kmalloc() failed\n"));
 			mutex_unlock(&resource->resource_lock);
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 029c8c0..9fbf73f 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -121,17 +121,16 @@ static inline acpi_thread_id acpi_os_get_thread_id(void)
 #include <acpi/actypes.h>
 static inline void *acpi_os_allocate(acpi_size size)
 {
-	return kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kmalloc(size, GFP_KERNEL);
 }
 static inline void *acpi_os_allocate_zeroed(acpi_size size)
 {
-	return kzalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kzalloc(size, GFP_KERNEL);
 }
 
 static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 {
-	return kmem_cache_zalloc(cache,
-				 irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kmem_cache_zalloc(cache, GFP_KERNEL);
 }
 
 #define ACPI_ALLOCATE(a)	acpi_os_allocate(a)
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 2ce8207..a716de8 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -128,9 +128,16 @@ extern void arch_suspend_disable_irqs(void);
  */
 extern void arch_suspend_enable_irqs(void);
 
+/**
+ * suspend_irqs_off
+ *
+ * flag to indicate that IRQs are off for the benefit of suspend
+ */
+extern bool system_suspend_irqs_off;
 extern int pm_suspend(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
+#define system_suspend_irqs_off false
 
 static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
diff --git a/kernel/power/main.c b/kernel/power/main.c
index b8f7ce9..2eadae7 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -268,16 +268,20 @@ static int suspend_prepare(void)
 	return error;
 }
 
+bool system_resume_irqsoff;	/* IRQs are off for resume */
+
 /* default implementation */
 void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
 {
 	local_irq_disable();
+	system_resume_irqsoff = true;
 }
 
 /* default implementation */
 void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
 {
 	local_irq_enable();
+	system_resume_irqsoff = false;
 }
 
 /**
