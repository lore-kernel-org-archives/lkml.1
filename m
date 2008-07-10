Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYGJAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYGJAJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYGJAGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:06:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbYGJAGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:06:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 8/8] ACPI PM: Add DMI quirk list for ACPI 1.0 suspend ordering
Date: Thu, 10 Jul 2008 02:07:02 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Andi Kleen <andi@firstfloor.org>
References: <200807100152.17755.rjw@sisk.pl>
In-Reply-To: <200807100152.17755.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807100207.03636.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: ACPI PM: Add DMI quirk list for ACPI 1.0 suspend ordering

There are a few BIOS' that we know of already that need to use the
ACPI 1.0 suspend order. This appears to be only be a small minority of
mostly nVidia based systems.

Based on observation of Windows behaviour, it's clear that Windows is
also doing maintaining its own list of broken hardware that needs this
workaround.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

 drivers/acpi/sleep/main.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


Index: linux-next/drivers/acpi/sleep/main.c
===================================================================
--- linux-next.orig/drivers/acpi/sleep/main.c
+++ linux-next/drivers/acpi/sleep/main.c
@@ -280,6 +280,24 @@ static struct platform_suspend_ops acpi_
 	.end = acpi_pm_end,
 	.recover = acpi_pm_finish,
 };
+
+static int __init init_old_suspend_ordering(const struct dmi_system_id *d)
+{
+	old_suspend_ordering = true;
+	return 0;
+}
+
+static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "Abit KN9 (nForce4 variant)",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "http://www.abit.com.tw/"),
+		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
+		},
+	},
+	{},
+};
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
@@ -531,6 +549,8 @@ int __init acpi_sleep_init(void)
 	u8 type_a, type_b;
 #ifdef CONFIG_SUSPEND
 	int i = 0;
+
+	dmi_check_system(acpisleep_dmi_table);
 #endif
 
 	if (acpi_disabled)

