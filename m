Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYGSLjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYGSLjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 07:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYGSLjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 07:39:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:7234 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYGSLjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 07:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=D8rdxbrOu8D9e4hdR7fVqGswfUfGz35hZsPDgAVVGRfydx7UNmPv70XzR42RTy39sx
         HvP7CfeaIiUMsrwPZ+/GRaP9ZjwLvpMRw6A7z/FOvLdeljdGp3d4shOSZrbW1L//wy00
         wJTtcls3BmvGvzKkz166qtdcjRbPcbAsVR6Ho=
Message-ID: <4881D273.9010004@tuffmail.co.uk>
Date: Sat, 19 Jul 2008 12:39:31 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] acpi: remove GPE polling
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de> <20080717162628.GB18457@khazad-dum.debian.net> <487F7724.5080905@tuffmail.co.uk> <20080717185032.GD18457@khazad-dum.debian.net> <487F986A.3070504@tuffmail.co.uk> <4881CE72.1090401@tuffmail.co.uk>
In-Reply-To: <4881CE72.1090401@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

This should fix "[regression] display dimming is slow and laggy",
<http://bugzilla.kernel.org/show_bug.cgi?id=10919>.  It has a similar effect
on my Asus EeePC.

Much of this is stolen from Alexey Starikovskiy's fix (see Bugzilla).  But
the previous two GPE fixes should have avoided the need to disable GPE
interrupts.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index e764011..1088903 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -79,7 +79,6 @@ enum {
 	EC_FLAGS_WAIT_GPE = 0,		/* Don't check status until GPE arrives */
 	EC_FLAGS_GPE_MODE,		/* Expect GPE to be sent for status change */
 	EC_FLAGS_NO_GPE,		/* Don't use GPE mode */
-	EC_FLAGS_RESCHEDULE_POLL	/* Re-schedule poll */
 };
 
 /* If we find an EC via the ECDT, we need to keep a ptr to its context */
@@ -105,7 +104,6 @@ static struct acpi_ec {
 	wait_queue_head_t wait;
 	struct list_head list;
 	struct delayed_work work;
-	atomic_t irq_count;
 	u8 handlers_installed;
 } *boot_ec, *first_ec;
 
@@ -154,24 +152,14 @@ static inline int acpi_ec_check_status(struct acpi_ec *ec, enum ec_event event)
 	return 0;
 }
 
-static void ec_schedule_ec_poll(struct acpi_ec *ec)
-{
-	if (test_bit(EC_FLAGS_RESCHEDULE_POLL, &ec->flags))
-		schedule_delayed_work(&ec->work,
-				      msecs_to_jiffies(ACPI_EC_DELAY));
-}
-
 static void ec_switch_to_poll_mode(struct acpi_ec *ec)
 {
 	set_bit(EC_FLAGS_NO_GPE, &ec->flags);
 	clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
-	acpi_disable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
-	set_bit(EC_FLAGS_RESCHEDULE_POLL, &ec->flags);
 }
 
 static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
 {
-	atomic_set(&ec->irq_count, 0);
 	if (likely(test_bit(EC_FLAGS_GPE_MODE, &ec->flags)) &&
 	    likely(!force_poll)) {
 		if (wait_event_timeout(ec->wait, acpi_ec_check_status(ec, event),
@@ -184,7 +172,6 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
 				pr_info(PREFIX "missing confirmations, "
 						"switch off interrupt mode.\n");
 			ec_switch_to_poll_mode(ec);
-			ec_schedule_ec_poll(ec);
 			return 0;
 		}
 	} else {
@@ -497,12 +484,6 @@ static u32 acpi_ec_gpe_handler(void *data)
 	u8 state = acpi_ec_read_status(ec);
 
 	pr_debug(PREFIX "~~~> interrupt\n");
-	atomic_inc(&ec->irq_count);
-	if (atomic_read(&ec->irq_count) > 5) {
-		pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
-		ec_switch_to_poll_mode(ec);
-		goto end;
-	}
 	clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
 	if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags))
 		wake_up(&ec->wait);
@@ -519,10 +500,8 @@ static u32 acpi_ec_gpe_handler(void *data)
 			pr_info(PREFIX "non-query interrupt received,"
 				" switching to interrupt mode\n");
 		set_bit(EC_FLAGS_GPE_MODE, &ec->flags);
-		clear_bit(EC_FLAGS_RESCHEDULE_POLL, &ec->flags);
 	}
-end:
-	ec_schedule_ec_poll(ec);
+
 	return ACPI_SUCCESS(status) ?
 	    ACPI_INTERRUPT_HANDLED : ACPI_INTERRUPT_NOT_HANDLED;
 }
@@ -530,7 +509,6 @@ end:
 static void do_ec_poll(struct work_struct *work)
 {
 	struct acpi_ec *ec = container_of(work, struct acpi_ec, work.work);
-	atomic_set(&ec->irq_count, 0);
 	(void)acpi_ec_gpe_handler(ec);
 }
 
@@ -675,7 +653,6 @@ static struct acpi_ec *make_acpi_ec(void)
 	init_waitqueue_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
 	INIT_DELAYED_WORK_DEFERRABLE(&ec->work, do_ec_poll);
-	atomic_set(&ec->irq_count, 0);
 	return ec;
 }
 
@@ -714,15 +691,8 @@ ec_parse_device(acpi_handle handle, u32 Level, void *context, void **retval)
 	return AE_CTRL_TERMINATE;
 }
 
-static void ec_poll_stop(struct acpi_ec *ec)
-{
-	clear_bit(EC_FLAGS_RESCHEDULE_POLL, &ec->flags);
-	cancel_delayed_work(&ec->work);
-}
-
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
-	ec_poll_stop(ec);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 		pr_err(PREFIX "failed to remove space handler\n");
@@ -863,7 +833,6 @@ static int acpi_ec_start(struct acpi_device *device)
 
 	ret = ec_install_handlers(ec);
 
-	ec_schedule_ec_poll(ec);
 	return ret;
 }
 


