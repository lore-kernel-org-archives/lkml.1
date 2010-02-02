Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0BBUW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:22:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0BBUW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:22:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: [PATCH] ACPI / EC: Remover race between EC driver and suspend process (was: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the middle of EC transaction)
Date: Tue, 2 Feb 2010 21:23:33 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <201001310029.48717.rjw@sisk.pl> <4B66AB7F.7050908@suse.de> <201002012342.50074.rjw@sisk.pl>
In-Reply-To: <201002012342.50074.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002022123.34061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Rafael J. Wysocki wrote:
> On Monday 01 February 2010, Alexey Starikovskiy wrote:
> > Henrique de Moraes Holschuh пишет:
> > > On Sun, 31 Jan 2010, Maxim Levitsky wrote:
> > >> Unfortunately, this patch even causes regressions on my notebook (it
> > >> survive 63 hibernate cycles), but now I battery driver reports 'battery
> > >> absent', backlight driver reports 0 brightness, but reload helped.
> > > 
> > > ...
> > > 
> > >> I think that not only _PTS ans _WAK are problematic. What about other
> > >> ACPI drivers that start accessing the EC before it is resumed?
> > >> I think that these cause the problems I observe.
> > > 
> > > ACPI drivers might access the EC (even indirectly, through the DSDT).  And
> > > platform drivers do often access the EC both at suspend and resume time.
> > Actually, only SBS and thinkpad-acpi access EC directly. All others go through
> > DSDT for access. Still, stopping EC in .suspend is too early, IMHO...
> 
> That's very likely the case, although that's kind of the latest we can do that
> without major modifications.
> 
> Is there a possibility to have more than one EC in a system in practice?
> 
> > > This needs some sort of strong ordering, the EC must suspend last, and
> > > resume first (as seen by any ACPI and ACPI-aware drivers such as libata,
> > > some platform drivers, etc).  If EC interrupts are a problem, maybe it can
> > > be kicked to poll mode for the suspend/resume transition?
> > It's this way already for about a year now... The problem is that EC driver might be 
> > stopped in middle of the transaction, thus leaving EC in unknown state for BIOS or 
> > switch-over kernel.
> 
> Exactly.
> 
> In theory I can try to disable EC transactions from the ACPI platform
> suspend/resume callbacks, but then there still is a problem with the global
> lock, since we shouldn't try to acquire it after disabling device interrupts,
> because an SCI is waited for in case we don't acquire it immediately.
> 
> So, perhaps instead we should disable the GPEs and call _PTS before the late
> suspend phase (and analogously, execute _WAK after the early resume phase)
> and disable the EC transacations right after that?
> 
> This leaves the problem with PCI devices that may require ACPI support during
> late suspend/early resume, but well.

I'm going to send a more in-depth analysis of the ACPI vs suspend problems I
see in our current code later.  For now, appended is an alternative to the
$subject patch that turns off the EC transactions after executing _PTS, but
assumes that there's only one EC in the system.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / EC: Remover race between EC driver and suspend process

There is a race between the suspend process and the EC driver that
may result in suspending in the middle of an EC transaction in
progress, which may lead to unpredictable behavior of the platform.

To remove that race condition, add functions for suspending and
resuming the EC transactions in a safe way to be executed by the 
ACPI platform suspend/resume callbacks.  Modify these callbacks so
that the EC transactions are suspended right after executing the _PTS
global control method and resumed right before executing the _WAK
global control method.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/ec.c       |   33 ++++++++++++++++++++++++++++++++-
 drivers/acpi/internal.h |    2 ++
 drivers/acpi/sleep.c    |   41 ++++++++++++++++++++++++-----------------
 3 files changed, 58 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/acpi/ec.c
===================================================================
--- linux-2.6.orig/drivers/acpi/ec.c
+++ linux-2.6/drivers/acpi/ec.c
@@ -76,8 +76,9 @@ enum ec_command {
 enum {
 	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
 	EC_FLAGS_GPE_STORM,		/* GPE storm detected */
-	EC_FLAGS_HANDLERS_INSTALLED	/* Handlers for GPE and
+	EC_FLAGS_HANDLERS_INSTALLED,	/* Handlers for GPE and
 					 * OpReg are installed */
+	EC_FLAGS_SUSPENDED,		/* Driver is suspended */
 };
 
 /* If we find an EC via the ECDT, we need to keep a ptr to its context */
@@ -291,6 +292,10 @@ static int acpi_ec_transaction(struct ac
 	if (t->rdata)
 		memset(t->rdata, 0, t->rlen);
 	mutex_lock(&ec->lock);
+	if (test_bit(EC_FLAGS_SUSPENDED, &ec->flags)) {
+		status = -EBUSY;
+		goto unlock;
+	}
 	if (ec->global_lock) {
 		status = acpi_acquire_global_lock(ACPI_EC_UDELAY_GLK, &glk);
 		if (ACPI_FAILURE(status)) {
@@ -445,6 +450,32 @@ int ec_transaction(u8 command,
 
 EXPORT_SYMBOL(ec_transaction);
 
+void acpi_ec_suspend_transactions(void)
+{
+	struct acpi_ec *ec = first_ec;
+
+	if (!ec)
+		return;
+
+	mutex_lock(&ec->lock);
+	/* Prevent transactions from happening while suspended */
+	set_bit(EC_FLAGS_SUSPENDED, &ec->flags);
+	mutex_unlock(&ec->lock);
+}
+
+void acpi_ec_resume_transactions(void)
+{
+	struct acpi_ec *ec = first_ec;
+
+	if (!ec)
+		return;
+
+	mutex_lock(&ec->lock);
+	/* Allow transactions to happen again */
+	clear_bit(EC_FLAGS_SUSPENDED, &ec->flags);
+	mutex_unlock(&ec->lock);
+}
+
 static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
 {
 	int result;
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -49,6 +49,8 @@ void acpi_early_processor_set_pdc(void);
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);
+void acpi_ec_suspend_transactions(void);
+void acpi_ec_resume_transactions(void);
 
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -112,9 +112,10 @@ void __init acpi_old_suspend_ordering(vo
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
-static int acpi_pm_disable_gpes(void)
+static int acpi_pm_disable_gpes_and_ec(void)
 {
 	acpi_disable_all_gpes();
+	acpi_ec_suspend_transactions();
 	return 0;
 }
 
@@ -142,7 +143,8 @@ static int acpi_pm_prepare(void)
 	int error = __acpi_pm_prepare();
 
 	if (!error)
-		acpi_disable_all_gpes();
+		acpi_pm_disable_gpes_and_ec();
+
 	return error;
 }
 
@@ -286,6 +288,12 @@ static int acpi_suspend_enter(suspend_st
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
 
+static void acpi_suspend_finish(void)
+{
+	acpi_ec_resume_transactions();
+	acpi_pm_finish();
+}
+
 static int acpi_suspend_state_valid(suspend_state_t pm_state)
 {
 	u32 acpi_state;
@@ -307,7 +315,7 @@ static struct platform_suspend_ops acpi_
 	.begin = acpi_suspend_begin,
 	.prepare_late = acpi_pm_prepare,
 	.enter = acpi_suspend_enter,
-	.wake = acpi_pm_finish,
+	.wake = acpi_suspend_finish,
 	.end = acpi_pm_end,
 };
 
@@ -333,9 +341,9 @@ static int acpi_suspend_begin_old(suspen
 static struct platform_suspend_ops acpi_suspend_ops_old = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin_old,
-	.prepare_late = acpi_pm_disable_gpes,
+	.prepare_late = acpi_pm_disable_gpes_and_ec,
 	.enter = acpi_suspend_enter,
-	.wake = acpi_pm_finish,
+	.wake = acpi_suspend_finish,
 	.end = acpi_pm_end,
 	.recover = acpi_pm_finish,
 };
@@ -530,6 +538,7 @@ static int acpi_hibernation_enter(void)
 static void acpi_hibernation_finish(void)
 {
 	hibernate_nvs_free();
+	acpi_ec_resume_transactions();
 	acpi_pm_finish();
 }
 
@@ -552,8 +561,9 @@ static void acpi_hibernation_leave(void)
 	hibernate_nvs_restore();
 }
 
-static void acpi_pm_enable_gpes(void)
+static void acpi_pm_enable_gpes_and_ec(void)
 {
+	acpi_ec_resume_transactions();
 	acpi_enable_all_runtime_gpes();
 }
 
@@ -565,8 +575,8 @@ static struct platform_hibernation_ops a
 	.prepare = acpi_pm_prepare,
 	.enter = acpi_hibernation_enter,
 	.leave = acpi_hibernation_leave,
-	.pre_restore = acpi_pm_disable_gpes,
-	.restore_cleanup = acpi_pm_enable_gpes,
+	.pre_restore = acpi_pm_disable_gpes_and_ec,
+	.restore_cleanup = acpi_pm_enable_gpes_and_ec,
 };
 
 /**
@@ -598,12 +608,9 @@ static int acpi_hibernation_begin_old(vo
 
 static int acpi_hibernation_pre_snapshot_old(void)
 {
-	int error = acpi_pm_disable_gpes();
-
-	if (!error)
-		hibernate_nvs_save();
-
-	return error;
+	acpi_pm_disable_gpes_and_ec();
+	hibernate_nvs_save();
+	return 0;
 }
 
 /*
@@ -615,11 +622,11 @@ static struct platform_hibernation_ops a
 	.end = acpi_pm_end,
 	.pre_snapshot = acpi_hibernation_pre_snapshot_old,
 	.finish = acpi_hibernation_finish,
-	.prepare = acpi_pm_disable_gpes,
+	.prepare = acpi_pm_disable_gpes_and_ec,
 	.enter = acpi_hibernation_enter,
 	.leave = acpi_hibernation_leave,
-	.pre_restore = acpi_pm_disable_gpes,
-	.restore_cleanup = acpi_pm_enable_gpes,
+	.pre_restore = acpi_pm_disable_gpes_and_ec,
+	.restore_cleanup = acpi_pm_enable_gpes_and_ec,
 	.recover = acpi_pm_finish,
 };
 #endif /* CONFIG_HIBERNATION */
