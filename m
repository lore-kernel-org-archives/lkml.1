Return-Path: <linux-kernel-owner+w=401wt.eu-S935330AbYBAEv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935330AbYBAEv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbYBAEmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:45 -0500
Received: from mga10.intel.com ([192.55.52.92]:64964 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763142AbYBAEmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:42:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516629"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 31/37] ACPI hibernation: Call _PTS before suspending devices
Date: Thu, 31 Jan 2008 23:37:02 -0500
Message-Id: <d629dee14e037644f4ddcd42f74674c782fb3ecf.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The ACPI 1.0 specification wants us to put devices into low power
states after executing the _PTS global control method, while ACPI
2.0 and later want us to do that in the reverse order.  The current
hibernation code follows ACPI 2.0 in that respect which may cause some
ACPI 1.0x systems to hang during hibernation (ref.
http://bugzilla.kernel.org/show_bug.cgi?id=9528).

Make the hibernation code execute _PTS before putting devices into
low power states (ie. in accordance with ACPI 1.0x) with the
possibility to override that using the 'acpi_new_pts_ordering' kernel
command line option.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sleep/main.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 31e8e58..10db899 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -283,22 +283,34 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 #ifdef CONFIG_HIBERNATION
 static int acpi_hibernation_begin(void)
 {
+	int error;
+
 	acpi_target_sleep_state = ACPI_STATE_S4;
-	return 0;
+	if (new_pts_ordering)
+		return 0;
+
+	error = acpi_sleep_prepare(ACPI_STATE_S4);
+	if (error)
+		acpi_target_sleep_state = ACPI_STATE_S0;
+	else
+		acpi_sleep_finish_wake_up = true;
+
+	return error;
 }
 
 static int acpi_hibernation_prepare(void)
 {
-	int error;
-
-	error = acpi_sleep_prepare(ACPI_STATE_S4);
-	if (error)
-		return error;
+	if (new_pts_ordering) {
+		int error = acpi_sleep_prepare(ACPI_STATE_S4);
 
-	if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
-		error = -EFAULT;
+		if (error) {
+			acpi_target_sleep_state = ACPI_STATE_S0;
+			return error;
+		}
+		acpi_sleep_finish_wake_up = true;
+	}
 
-	return error;
+	return ACPI_SUCCESS(acpi_hw_disable_all_gpes()) ? 0 : -EFAULT;
 }
 
 static int acpi_hibernation_enter(void)
@@ -339,15 +351,17 @@ static void acpi_hibernation_finish(void)
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
+	acpi_sleep_finish_wake_up = false;
 }
 
 static void acpi_hibernation_end(void)
 {
 	/*
 	 * This is necessary in case acpi_hibernation_finish() is not called
-	 * during a failing transition to the sleep state.
+	 * directly during a failing transition to the sleep state.
 	 */
-	acpi_target_sleep_state = ACPI_STATE_S0;
+	if (acpi_sleep_finish_wake_up)
+		acpi_hibernation_finish();
 }
 
 static int acpi_hibernation_pre_restore(void)
-- 
1.5.4.rc5.16.gc0279

