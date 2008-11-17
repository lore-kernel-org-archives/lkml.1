Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYKQW2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYKQW2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYKQW2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:28:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48553 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbYKQW2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:28:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI suspend: Blacklist boxes that require us to set SCI_EN directly on resume
Date: Mon, 17 Nov 2008 23:33:12 +0100
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Tino Keitel <tino.keitel@gmx.de>, Bob Copeland <me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811172333.13466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI suspend: Blacklist boxes that require us to set SCI_EN directly on resume

Some Apple boxes evidently require us to set SCI_EN on resume
directly, because if we don't do that, they hung somewhere in the
resume code path.  Moreover, on these boxes it is not sufficient to
use acpi_enable() to turn ACPI on during resume.  All of this is
against the ACPI specification which states that (1) the BIOS is
supposed to return from the S3 sleep state with ACPI enabled
(SCI_EN set) and (2) the SCI_EN bit is owned by the hardware and we
are not supposed to change it.

For this reason, blacklist the affected systems so that the SCI_EN
bit is set during resume on them.

[NOTE: Unconditional setting SCI_EN for all system on resume doesn't
 work, because it makes some other systems crash (that's to be
 expected).  Also, it is not entirely clear right now if all of the
 Apple boxes require this workaround.]

This patch fixes the recent regression tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12038

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Tino Keitel <tino.keitel@gmx.de>
Tested-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/acpi/sleep/main.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -104,6 +104,18 @@ void __init acpi_s4_no_nvs(void)
 	s4_no_nvs = true;
 }
 
+/*
+ * According to the ACPI specification the BIOS should make sure that ACPI is
+ * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
+ * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
+ * on such systems during resume.  Unfortunately that doesn't help in
+ * particularly pathological cases in which SCI_EN has to be set directly on
+ * resume, although the specification states very clearly that this flag is
+ * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
+ * cases.
+ */
+static bool set_sci_en_on_resume;
+
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
@@ -249,7 +261,11 @@ static int acpi_suspend_enter(suspend_st
 	}
 
 	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
-	acpi_enable();
+	if (set_sci_en_on_resume)
+		acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
+	else
+		acpi_enable();
+
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
@@ -337,6 +353,12 @@ static int __init init_old_suspend_order
 	return 0;
 }
 
+static int __init init_set_sci_en_on_resume(const struct dmi_system_id *d)
+{
+	set_sci_en_on_resume = true;
+	return 0;
+}
+
 static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	{
 	.callback = init_old_suspend_ordering,
@@ -354,6 +376,22 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
 		},
 	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Apple MacBook 1,1",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBook1,1"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Apple MacMini 1,1",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */
