Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0CDAuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:50:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44974 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab0CDAuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:50:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [Resend][PATCH] ACPI / EC: Remove race between EC driver and suspend process (rev. 3)
Date: Thu, 4 Mar 2010 01:52:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
References: <201002272140.36891.rjw@sisk.pl> <alpine.LFD.2.00.1003031644410.1044@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003031644410.1044@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003040152.58437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 March 2010, Len Brown wrote:
> For the record, Rafael, Alexey and I discusseed this a bit further...
> 
> We reasoned that this failure is impossible during the Suspend-to-RAM 
> path, and the failure is specific to the hibernate reboot kernel handoff
> to the resume image.

Below is a simplified version of the patch that also should fix the problem.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / EC / PM: Close race between EC and resume from hibernation

There is a race between resume from hibernation and the EC driver
that may result in restoring the hibernation image in the middle of
an EC transaction in progress, which in turn may lead to
unpredictable behavior of the platform.

To remove that race condition, add a helpers for suspending and
resuming EC transactions in a safe way to be executed by the ACPI
platform hibernate pre-restore and restore cleanup callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/acpi/ec.c       |   33 ++++++++++++++++++++++++++++++++-
 drivers/acpi/internal.h |    2 ++
 drivers/acpi/sleep.c    |   19 ++++++++++++++-----
 3 files changed, 48 insertions(+), 6 deletions(-)

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
+	EC_FLAGS_FROZEN,		/* Transactions are suspended */
 };
 
 /* If we find an EC via the ECDT, we need to keep a ptr to its context */
@@ -291,6 +292,10 @@ static int acpi_ec_transaction(struct ac
 	if (t->rdata)
 		memset(t->rdata, 0, t->rlen);
 	mutex_lock(&ec->lock);
+	if (test_bit(EC_FLAGS_FROZEN, &ec->flags)) {
+		status = -EINVAL;
+		goto unlock;
+	}
 	if (ec->global_lock) {
 		status = acpi_acquire_global_lock(ACPI_EC_UDELAY_GLK, &glk);
 		if (ACPI_FAILURE(status)) {
@@ -453,6 +458,32 @@ int ec_transaction(u8 command,
 
 EXPORT_SYMBOL(ec_transaction);
 
+void acpi_ec_suspend_transactions(void)
+{
+	struct acpi_ec *ec = first_ec;
+
+	if (!ec)
+		return;
+
+	mutex_lock(&ec->lock);
+	/* Prevent transactions from being carried out */
+	set_bit(EC_FLAGS_FROZEN, &ec->flags);
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
+	/* Allow transactions to be carried out again */
+	clear_bit(EC_FLAGS_FROZEN, &ec->flags);
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
@@ -552,8 +552,17 @@ static void acpi_hibernation_leave(void)
 	hibernate_nvs_restore();
 }
 
-static void acpi_pm_enable_gpes(void)
+static int acpi_pm_pre_restore(void)
 {
+	acpi_disable_all_gpes();
+	acpi_os_wait_events_complete(NULL);
+	acpi_ec_suspend_transactions();
+	return 0;
+}
+
+static void acpi_pm_restore_cleanup(void)
+{
+	acpi_ec_resume_transactions();
 	acpi_enable_all_runtime_gpes();
 }
 
@@ -565,8 +574,8 @@ static struct platform_hibernation_ops a
 	.prepare = acpi_pm_prepare,
 	.enter = acpi_hibernation_enter,
 	.leave = acpi_hibernation_leave,
-	.pre_restore = acpi_pm_disable_gpes,
-	.restore_cleanup = acpi_pm_enable_gpes,
+	.pre_restore = acpi_pm_pre_restore,
+	.restore_cleanup = acpi_pm_restore_cleanup,
 };
 
 /**
@@ -618,8 +627,8 @@ static struct platform_hibernation_ops a
 	.prepare = acpi_pm_disable_gpes,
 	.enter = acpi_hibernation_enter,
 	.leave = acpi_hibernation_leave,
-	.pre_restore = acpi_pm_disable_gpes,
-	.restore_cleanup = acpi_pm_enable_gpes,
+	.pre_restore = acpi_pm_pre_restore,
+	.restore_cleanup = acpi_pm_restore_cleanup,
 	.recover = acpi_pm_finish,
 };
 #endif /* CONFIG_HIBERNATION */
