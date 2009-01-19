Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZASUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZASUBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZASUA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:00:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39382 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZASUAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:00:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Date: Mon, 19 Jan 2009 20:54:54 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org> <200901192053.50831.rjw@sisk.pl>
In-Reply-To: <200901192053.50831.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901192054.55536.rjw@sisk.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce boolean function system_entering_hibernation() returning
'true' during the last phase of hibernation, in which devices are
being put into low power states and the sleep state (for example,
ACPI S4) is finally entered.

Some device drivers need such a function to check if the system is
in the final phase of hibernation.  In particular, some SATA drivers
are going to use it for blacklisting systems in which the disks
should not be spun down during the last phase of hibernation (the
BIOS will do that anyway).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/suspend.h |    2 ++
 kernel/power/disk.c     |   10 ++++++++++
 2 files changed, 12 insertions(+)

Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -237,6 +237,7 @@ extern int hibernate_nvs_alloc(void);
 extern void hibernate_nvs_free(void);
 extern void hibernate_nvs_save(void);
 extern void hibernate_nvs_restore(void);
+extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
@@ -252,6 +253,7 @@ static inline int hibernate_nvs_alloc(vo
 static inline void hibernate_nvs_free(void) {}
 static inline void hibernate_nvs_save(void) {}
 static inline void hibernate_nvs_restore(void) {}
+static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
 #ifdef CONFIG_PM_SLEEP
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -71,6 +71,14 @@ void hibernation_set_ops(struct platform
 	mutex_unlock(&pm_mutex);
 }
 
+static bool entering_platform_hibernation;
+
+bool system_entering_hibernation(void)
+{
+	return entering_platform_hibernation;
+}
+EXPORT_SYMBOL(system_entering_hibernation);
+
 #ifdef CONFIG_PM_DEBUG
 static void hibernation_debug_sleep(void)
 {
@@ -411,6 +419,7 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Close;
 
+	entering_platform_hibernation = true;
 	suspend_console();
 	error = device_suspend(PMSG_HIBERNATE);
 	if (error) {
@@ -445,6 +454,7 @@ int hibernation_platform_enter(void)
  Finish:
 	hibernation_ops->finish();
  Resume_devices:
+	entering_platform_hibernation = false;
 	device_resume(PMSG_RESTORE);
 	resume_console();
  Close:

