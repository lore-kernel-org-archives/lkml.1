Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214Ab0A3X3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0A3X3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 18:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928Ab0A3X3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 18:29:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab0A3X3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 18:29:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][RFT][PATCH] ACPI: Protection from suspending in the middle of EC transaction
Date: Sun, 31 Jan 2010 00:29:48 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001310029.48717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While Maxim is testing if the patch below helps with
http://bugzilla.kernel.org/show_bug.cgi?id=14668
I think it's necessary anyway.

The problem is that currently there's nothing to prevent us from suspending in
the middle of an EC transaction in progress, at least as far as I can see.
As a result, we can suspend with the ACPI global lock held or something like
this, which leads to problems especially for hibernation (if the resume kernel
passes control to the image kernel in the middle of an EC transaction, things
aren't nice).  For this reason I think we should wait until there are no EC
transactions in progress before we suspend and we should prevent any new
EC transactions from starting after that point.  The patch below does that.

However, it does that in the EC's suspend callback, which may be too early,
because there still is _PTS to run, so it might be necessary to do that later.
On the other hand, the mechanics behind the ACPI global lock, which is
acquired in acpi_ec_transaction(), requires that interrupts work, because
otherwise there may be a problem if the global lock is not actually acquired
after ACPI_ACQUIRE_GLOBAL_LOCK(), so the last place in which to
wait for EC transactions to complete seems to be the platform suspend
.prepare() callback.  Unfortunately, it's not implemented at the moment for
ACPI and it doesn't have a hibernate counterpart and that's why I'd rather use
the patch below, unless it's known to break things for someone.  So, if you
can, please test it and tell me if you have any problems with it.

Of course, comments are welcome as well.

Thanks,
Rafael

---
 drivers/acpi/ec.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

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
@@ -1059,16 +1064,26 @@ error:
 static int acpi_ec_suspend(struct acpi_device *device, pm_message_t state)
 {
 	struct acpi_ec *ec = acpi_driver_data(device);
+
+	mutex_lock(&ec->lock);
+	/* Prevent transactions from happening while suspended */
+	set_bit(EC_FLAGS_SUSPENDED, &ec->flags);
 	/* Stop using GPE */
 	acpi_disable_gpe(NULL, ec->gpe);
+	mutex_unlock(&ec->lock);
 	return 0;
 }
 
 static int acpi_ec_resume(struct acpi_device *device)
 {
 	struct acpi_ec *ec = acpi_driver_data(device);
+
+	mutex_lock(&ec->lock);
 	/* Enable use of GPE back */
 	acpi_enable_gpe(NULL, ec->gpe);
+	/* Allow transactions to happen again */
+	set_bit(EC_FLAGS_SUSPENDED, &ec->flags);
+	mutex_unlock(&ec->lock);
 	return 0;
 }
 
