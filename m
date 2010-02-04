Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0BDAcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:32:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0BDAcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:32:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / EC: Remove race between EC driver and suspend process (rev. 3)
Date: Thu, 4 Feb 2010 01:33:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
References: <201001310029.48717.rjw@sisk.pl> <201002030132.21406.rjw@sisk.pl>
In-Reply-To: <201002030132.21406.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002040133.22604.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010, Rafael J. Wysocki wrote:
> On Sunday 31 January 2010, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > While Maxim is testing if the patch below helps with
> > http://bugzilla.kernel.org/show_bug.cgi?id=14668
> > I think it's necessary anyway.
> > 
> > The problem is that currently there's nothing to prevent us from suspending in
> > the middle of an EC transaction in progress, at least as far as I can see.
> > As a result, we can suspend with the ACPI global lock held or something like
> > this, which leads to problems especially for hibernation (if the resume kernel
> > passes control to the image kernel in the middle of an EC transaction, things
> > aren't nice).  For this reason I think we should wait until there are no EC
> > transactions in progress before we suspend and we should prevent any new
> > EC transactions from starting after that point.  The patch below does that.
> 
> After discussing the patch with Alex I have a new version which is appended
> below.  This one causes EC transactions to be discarded after we've executed
> _PTS (which is reasonable IMO) and allows them to happen again very early
> during wake-up, so effectively the resume behavior should be unchanged.

Unfortunately I overlooked the fact that this patch would break the error paths
and test modes where we also have to allow EC transactions to happen again
after they've been "suspended".  Sorry about that.

Updated patch follows.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / EC: Remove race between EC driver and suspend process (rev. 3)

There is a race between the suspend process and the EC driver that
may result in suspending in the middle of an EC transaction in
progress, which in turn may lead to unpredictable behavior of the
platform.

To remove that race condition, add a helpers for suspending and
resuming EC transactions in a safe way to be executed by the ACPI
platform suspend/hibernate callbacks.  Modify these callbacks so
that the EC transactions are suspended right after executing the
_PTS global control method and are allowed to happen right after
the low-level wake-up.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/acpi/ec.c       |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/internal.h |    3 +++
 drivers/acpi/sleep.c    |   47 +++++++++++++++++++++++++++++------------------
 3 files changed, 76 insertions(+), 19 deletions(-)

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
@@ -291,6 +292,12 @@ static int acpi_ec_transaction(struct ac
 	if (t->rdata)
 		memset(t->rdata, 0, t->rlen);
 	mutex_lock(&ec->lock);
+	if (test_bit(EC_FLAGS_SUSPENDED, &ec->flags)) {
+		pr_err(PREFIX
+			"transaction discarded due to power transition\n");
+		status = -EINVAL;
+		goto unlock;
+	}
 	if (ec->global_lock) {
 		status = acpi_acquire_global_lock(ACPI_EC_UDELAY_GLK, &glk);
 		if (ACPI_FAILURE(status)) {
@@ -445,6 +452,42 @@ int ec_transaction(u8 command,
 
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
+void acpi_ec_resume_transactions_noirq(void)
+{
+	/*
+	 * Allow transactions to happen again (this function is called from
+	 * atomic context during wake-up, so we don't need to acquire the mutex)
+	 */
+	if (first_ec)
+		clear_bit(EC_FLAGS_SUSPENDED, &first_ec->flags);
+}
+
 static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
 {
 	int result;
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -49,6 +49,9 @@ void acpi_early_processor_set_pdc(void);
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);
+void acpi_ec_suspend_transactions(void);
+void acpi_ec_resume_transactions(void);
+void acpi_ec_resume_transactions_noirq(void);
 
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -110,11 +110,12 @@ void __init acpi_old_suspend_ordering(vo
 }
 
 /**
- *	acpi_pm_disable_gpes - Disable the GPEs.
+ *	acpi_pm_freeze - Disable the GPEs and suspend EC transactions.
  */
-static int acpi_pm_disable_gpes(void)
+static int acpi_pm_freeze(void)
 {
 	acpi_disable_all_gpes();
+	acpi_ec_suspend_transactions();
 	return 0;
 }
 
@@ -142,7 +143,8 @@ static int acpi_pm_prepare(void)
 	int error = __acpi_pm_prepare();
 
 	if (!error)
-		acpi_disable_all_gpes();
+		acpi_pm_freeze();
+
 	return error;
 }
 
@@ -276,6 +278,8 @@ static int acpi_suspend_enter(suspend_st
 	 */
 	acpi_disable_all_gpes();
 
+	acpi_ec_resume_transactions_noirq();
+
 	local_irq_restore(flags);
 	printk(KERN_DEBUG "Back to C!\n");
 
@@ -286,6 +290,12 @@ static int acpi_suspend_enter(suspend_st
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
@@ -307,7 +317,7 @@ static struct platform_suspend_ops acpi_
 	.begin = acpi_suspend_begin,
 	.prepare_late = acpi_pm_prepare,
 	.enter = acpi_suspend_enter,
-	.wake = acpi_pm_finish,
+	.wake = acpi_suspend_finish,
 	.end = acpi_pm_end,
 };
 
@@ -333,9 +343,9 @@ static int acpi_suspend_begin_old(suspen
 static struct platform_suspend_ops acpi_suspend_ops_old = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin_old,
-	.prepare_late = acpi_pm_disable_gpes,
+	.prepare_late = acpi_pm_freeze,
 	.enter = acpi_suspend_enter,
-	.wake = acpi_pm_finish,
+	.wake = acpi_suspend_finish,
 	.end = acpi_pm_end,
 	.recover = acpi_pm_finish,
 };
@@ -522,6 +532,7 @@ static int acpi_hibernation_enter(void)
 	status = acpi_enter_sleep_state(ACPI_STATE_S4);
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
+	acpi_ec_resume_transactions_noirq();
 	local_irq_restore(flags);
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
@@ -530,6 +541,7 @@ static int acpi_hibernation_enter(void)
 static void acpi_hibernation_finish(void)
 {
 	hibernate_nvs_free();
+	acpi_ec_resume_transactions();
 	acpi_pm_finish();
 }
 
@@ -550,10 +562,12 @@ static void acpi_hibernation_leave(void)
 	}
 	/* Restore the NVS memory area */
 	hibernate_nvs_restore();
+	acpi_ec_resume_transactions_noirq();
 }
 
-static void acpi_pm_enable_gpes(void)
+static void acpi_pm_thaw(void)
 {
+	acpi_ec_resume_transactions();
 	acpi_enable_all_runtime_gpes();
 }
 
@@ -565,8 +579,8 @@ static struct platform_hibernation_ops a
 	.prepare = acpi_pm_prepare,
 	.enter = acpi_hibernation_enter,
 	.leave = acpi_hibernation_leave,
-	.pre_restore = acpi_pm_disable_gpes,
-	.restore_cleanup = acpi_pm_enable_gpes,
+	.pre_restore = acpi_pm_freeze,
+	.restore_cleanup = acpi_pm_thaw,
 };
 
 /**
@@ -598,12 +612,9 @@ static int acpi_hibernation_begin_old(vo
 
 static int acpi_hibernation_pre_snapshot_old(void)
 {
-	int error = acpi_pm_disable_gpes();
-
-	if (!error)
-		hibernate_nvs_save();
-
-	return error;
+	acpi_pm_freeze();
+	hibernate_nvs_save();
+	return 0;
 }
 
 /*
@@ -615,11 +626,11 @@ static struct platform_hibernation_ops a
 	.end = acpi_pm_end,
 	.pre_snapshot = acpi_hibernation_pre_snapshot_old,
 	.finish = acpi_hibernation_finish,
-	.prepare = acpi_pm_disable_gpes,
+	.prepare = acpi_pm_freeze,
 	.enter = acpi_hibernation_enter,
 	.leave = acpi_hibernation_leave,
-	.pre_restore = acpi_pm_disable_gpes,
-	.restore_cleanup = acpi_pm_enable_gpes,
+	.pre_restore = acpi_pm_freeze,
+	.restore_cleanup = acpi_pm_thaw,
 	.recover = acpi_pm_finish,
 };
 #endif /* CONFIG_HIBERNATION */
