Return-Path: <linux-kernel-owner+w=401wt.eu-S1763125AbZJOWbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763125AbZJOWbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763045AbZJOWbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:31:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:41125 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811AbZJOWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:31:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B3GY+Zsuq+ZBjhtElST7ABYjkUqqlOPc0Y5uEazXMMkWYtR7+Gx4OZsRnXfDh/3pyG
         0l3EqvphqgVmGx7A18OA6gMThC+/Ixf6aWYYJ6JKV0m0OQAv2ukd1f7vFV+8mvepb2AU
         4nmYsbYA/hf2dv+hcb88kwsDT6zppCar6vhBM=
From: Bryan Donlan <bdonlan@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org,
       Bryan Donlan <bdonlan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: [PATCH] Add quirk for ACPI reboots on Intel DP55KG boards.
Date: Thu, 15 Oct 2009 18:29:56 -0400
Message-Id: <1255645796-29944-1-git-send-email-bdonlan@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan>
References: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keyboard-based and BIOS-based reboots don't work on Intel DP55KG boards;
use ACPI reboots instead.

Reported-By: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
---
 arch/x86/kernel/reboot.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

Justin, could you give this patch a try? It should make the reboot=acpi
workaround automatic.
(x86 maintainers CC'd)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index a1a3cdd..67bfcef 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -134,6 +134,21 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+/*
+ * Some machines require the "reboot=a" commandline option.
+ * This quirk makes that automatic.
+ */
+static int __init set_acpi_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_ACPI) {
+		reboot_type = BOOT_ACPI;
+		printk(KERN_INFO "%s series board detected. Selecting ACPI "
+				"method for reboots.\n", d->ident);
+	}
+	return 0;
+}
+
+
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
@@ -259,6 +274,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
 		},
 	},
+	{	/* Handle problems with rebooting on Intel DP55KG */
+		.callback = set_acpi_reboot,
+		.ident = "Intel DP55KG",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "DP55KG"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.3.3

