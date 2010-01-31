Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581Ab0AaWb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0AaWb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 17:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508Ab0AaWb0
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 17:31:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50039 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0AaWb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 17:31:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the middle of EC transaction
Date: Sun, 31 Jan 2010 23:31:50 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <201001310029.48717.rjw@sisk.pl> <1264970500.5544.0.camel@maxim-laptop> <201001312209.21212.rjw@sisk.pl>
In-Reply-To: <201001312209.21212.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001312331.50321.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 January 2010, Rafael J. Wysocki wrote:
> On Sunday 31 January 2010, Maxim Levitsky wrote:
> > On Sun, 2010-01-31 at 00:29 +0100, Rafael J. Wysocki wrote: 
> ...
> > >  
> > >  static int acpi_ec_resume(struct acpi_device *device)
> > >  {
> > >  	struct acpi_ec *ec = acpi_driver_data(device);
> > > +
> > > +	mutex_lock(&ec->lock);
> > >  	/* Enable use of GPE back */
> > >  	acpi_enable_gpe(NULL, ec->gpe);
> > > +	/* Allow transactions to happen again */
> > > +	set_bit(EC_FLAGS_SUSPENDED, &ec->flags);
> >           ^^^^^^^^^^^^
> > Thats why it doesn't work here....
> > Will retest now.
> 
> Ouch, sorry.

Fixed version is appended, for the record.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / EC: Add protection from suspending in the middle of EC transaction

There is a race between the suspend process and the EC driver that
may result in suspending in the middle of an EC transaction in
progress, which may lead to unpredictable behavior of the platform.

To remove that race condition, make acpi_ec_suspend() and
acpi_ec_resume() acquire ec->lock and introduce a new EC flag,
EC_FLAGS_SUSPENDED, set in acpi_ec_suspend() and cleared in
acpi_ec_resume(), that will cause acpi_ec_transaction() to return
error code (-EBUSY) if set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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
+	clear_bit(EC_FLAGS_SUSPENDED, &ec->flags);
+	mutex_unlock(&ec->lock);
 	return 0;
 }
 
