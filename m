Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXL0SCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXL0SCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXL0SBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:01:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43407 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbXL0SBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:01:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][PATCH 3/7] ACPI: Separate disabling of GPEs from _PTS
Date: Thu, 27 Dec 2007 19:16:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl>
In-Reply-To: <200712271903.53961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271916.28675.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The preparation to enter an ACPI system sleep state is now tied to
the disabling of GPEs, but the GPEs should not be disabled before
suspending devices.  Since on ACPI 1.0x systems the _PTS global
control method should be executed before suspending devices, we
need to disable GPEs separately.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/hardware/hwsleep.c |    4 ----
 drivers/acpi/sleep/main.c       |   17 +++++++++++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6/drivers/acpi/hardware/hwsleep.c
@@ -229,10 +229,6 @@ acpi_status acpi_enter_sleep_state_prep(
 				"While executing method _SST"));
 	}
 
-	/* Disable/Clear all GPEs */
-
-	status = acpi_hw_disable_all_gpes();
-
 	return_ACPI_STATUS(status);
 }
 
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -91,10 +91,13 @@ static int acpi_pm_open(suspend_state_t 
 
 static int acpi_pm_prepare(void)
 {
-	int error = acpi_sleep_prepare(acpi_target_sleep_state);
+	int error;
 
+	error = acpi_sleep_prepare(acpi_target_sleep_state);
 	if (error)
 		acpi_target_sleep_state = ACPI_STATE_S0;
+	else if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
+		error = -EFAULT;
 
 	return error;
 }
@@ -261,7 +264,16 @@ static int acpi_hibernation_start(void)
 
 static int acpi_hibernation_prepare(void)
 {
-	return acpi_sleep_prepare(ACPI_STATE_S4);
+	int error;
+
+	error = acpi_sleep_prepare(ACPI_STATE_S4);
+	if (error)
+		return error;
+
+	if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
+		error = -EFAULT;
+
+	return error;
 }
 
 static int acpi_hibernation_enter(void)
@@ -432,6 +444,7 @@ static void acpi_power_off_prepare(void)
 {
 	/* Prepare to power off the system */
 	acpi_sleep_prepare(ACPI_STATE_S5);
+	acpi_hw_disable_all_gpes();
 }
 
 static void acpi_power_off(void)
