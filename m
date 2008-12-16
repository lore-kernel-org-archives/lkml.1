Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758715AbYLPXk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYLPXk4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYLPXko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:40:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57401 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYLPXkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:40:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: acpi_os_allocate(GFP_KERNEL) (was Re: acpi_evaluate_integer broken by design)
Date: Wed, 17 Dec 2008 00:40:07 +0100
User-Agent: KMail/1.9.9
Cc: pavel@suse.cz, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <20081125110508.GA1943@elf.ucw.cz> <20081215214140.9031d4c8.akpm@linux-foundation.org> <200812161634.25838.rjw@sisk.pl>
In-Reply-To: <200812161634.25838.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812170040.07977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16 of December 2008, Rafael J. Wysocki wrote:
> On Tuesday, 16 of December 2008, Andrew Morton wrote:
> > On Tue, 16 Dec 2008 00:24:43 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
[--snip--]
> > 
> > (please use __weak)
> > 
> > Whether it's "system_resume_irqsoff" or "system_suspend_irqs_off",
> > neither of them actually got used ;)
> > 
> > If the code is really this simple and localised then perhaps:
> > 
> > gfp_t acpi_aml_gfp_flags = GFP_ATOMIC;
> > 
> > void __weak arch_suspend_disable_irqs(void)
> > {
> > 	local_irq_disable();
> > 	acpi_aml_gfp_flags = GFP_ATOMIC;
> > }
> > 
> > /* default implementation */
> > void __weak arch_suspend_enable_irqs(void)
> > {
> > 	local_irq_enable();
> > 	acpi_aml_gfp_flags = GFP_KERNEL;
> > }
> > 
> > would suffice.  Dunno.
> 
> arch_suspend_disable_irqs() and arch_suspend_enable_irqs() are only used during
> suspend to RAM, but we have the 'suspend atomic context' during hibernation as
> well.

In fact, we should be using GFP_ATOMIC already while devices are being
suspended, so we can switch from GFP_KERNEL to GFP_ATOMIC even before
interrupts are enabled.

In particular, we can do that in the suspend/hibernation platform callback as
shown in the patch below.

The patch hasn't been tested and is indended for discussion.

[Note: I'm not sure where to place the definition of acpi_gfp_flags.
 Temporarily I put that into bus.c, but if there's a better place, please
 tell me.]

Thanks,
Rafael

---
 drivers/acpi/bus.c              |    3 +++
 drivers/acpi/pci_link.c         |    2 +-
 drivers/acpi/sleep/main.c       |   22 ++++++++++++++++++----
 include/acpi/platform/aclinux.h |   15 +++++++++------
 include/linux/acpi.h            |    1 +
 5 files changed, 32 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -122,6 +122,7 @@ void __init acpi_s4_no_nvs(void)
 static int acpi_pm_disable_gpes(void)
 {
 	acpi_hw_disable_all_gpes();
+	acpi_gfp_flags = GFP_ATOMIC;
 	return 0;
 }
 
@@ -148,8 +149,10 @@ static int acpi_pm_prepare(void)
 {
 	int error = __acpi_pm_prepare();
 
-	if (!error)
+	if (!error) {
 		acpi_hw_disable_all_gpes();
+		acpi_gfp_flags = GFP_ATOMIC;
+	}
 	return error;
 }
 
@@ -175,6 +178,8 @@ static void acpi_pm_finish(void)
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
+
+	acpi_gfp_flags = GFP_KERNEL;
 }
 
 /**
@@ -188,6 +193,7 @@ static void acpi_pm_end(void)
 	 */
 	acpi_target_sleep_state = ACPI_STATE_S0;
 	acpi_sleep_tts_switch(acpi_target_sleep_state);
+	acpi_gfp_flags = GFP_KERNEL;
 }
 #else /* !CONFIG_ACPI_SLEEP */
 #define acpi_target_sleep_state	ACPI_STATE_S0
@@ -328,7 +334,9 @@ static int acpi_suspend_begin_old(suspen
 {
 	int error = acpi_suspend_begin(pm_state);
 
-	if (!error)
+	if (error)
+		acpi_gfp_flags = GFP_KERNEL;
+	else
 		error = __acpi_pm_prepare();
 	return error;
 }
@@ -423,7 +431,9 @@ static int acpi_hibernation_pre_snapshot
 {
 	int error = acpi_pm_prepare();
 
-	if (!error)
+	if (error)
+		acpi_gfp_flags = GFP_KERNEL;
+	else
 		hibernate_nvs_save();
 
 	return error;
@@ -475,6 +485,7 @@ static void acpi_hibernation_leave(void)
 static void acpi_pm_enable_gpes(void)
 {
 	acpi_hw_enable_all_runtime_gpes();
+	acpi_gfp_flags = GFP_KERNEL;
 }
 
 static struct platform_hibernation_ops acpi_hibernation_ops = {
@@ -520,7 +531,9 @@ static int acpi_hibernation_pre_snapshot
 {
 	int error = acpi_pm_disable_gpes();
 
-	if (!error)
+	if (error)
+		acpi_gfp_flags = GFP_KERNEL;
+	else
 		hibernate_nvs_save();
 
 	return error;
@@ -675,6 +688,7 @@ static void acpi_power_off_prepare(void)
 	/* Prepare to power off the system */
 	acpi_sleep_prepare(ACPI_STATE_S5);
 	acpi_hw_disable_all_gpes();
+	acpi_gfp_flags = GFP_ATOMIC;
 }
 
 static void acpi_power_off(void)
Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -46,6 +46,9 @@ struct acpi_device *acpi_root;
 struct proc_dir_entry *acpi_root_dir;
 EXPORT_SYMBOL(acpi_root_dir);
 
+gfp_t acpi_gfp_flags = GFP_KERNEL;
+EXPORT_SYMBOL(acpi_gfp_flags);
+
 #define STRUCT_TO_INT(s)	(*((int*)&s))
 
 static int set_power_nocheck(const struct dmi_system_id *id)
Index: linux-2.6/drivers/acpi/pci_link.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_link.c
+++ linux-2.6/drivers/acpi/pci_link.c
@@ -320,7 +320,7 @@ static int acpi_pci_link_set(struct acpi
 	if (!link || !irq)
 		return -EINVAL;
 
-	resource = kzalloc(sizeof(*resource) + 1, irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
+	resource = kzalloc(sizeof(*resource) + 1, acpi_gfp_flags);
 	if (!resource)
 		return -ENOMEM;
 
Index: linux-2.6/include/acpi/platform/aclinux.h
===================================================================
--- linux-2.6.orig/include/acpi/platform/aclinux.h
+++ linux-2.6/include/acpi/platform/aclinux.h
@@ -113,25 +113,28 @@ static inline acpi_thread_id acpi_os_get
 }
 
 /*
- * The irqs_disabled() check is for resume from RAM.
- * Interrupts are off during resume, just like they are for boot.
+ * acpi_gfp_flags is GFP_KERNEL except for the suspend-to-RAM and hibernation
+ * code paths, where it equals GFP_ATOMIC.
+ * Interrupts are off during suspend-resume, just like they are for boot.
  * However, boot has  (system_state != SYSTEM_RUNNING)
  * to quiet __might_sleep() in kmalloc() and resume does not.
  */
 #include <acpi/actypes.h>
+
+extern gfp_t acpi_gfp_flags;
+
 static inline void *acpi_os_allocate(acpi_size size)
 {
-	return kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kmalloc(size, acpi_gfp_flags);
 }
 static inline void *acpi_os_allocate_zeroed(acpi_size size)
 {
-	return kzalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kzalloc(size, acpi_gfp_flags);
 }
 
 static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 {
-	return kmem_cache_zalloc(cache,
-				 irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kmem_cache_zalloc(cache, acpi_gfp_flags);
 }
 
 #define ACPI_ALLOCATE(a)	acpi_os_allocate(a)
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -115,6 +115,7 @@ extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
+extern gfp_t acpi_gfp_flags;
 
 int acpi_register_gsi (u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
