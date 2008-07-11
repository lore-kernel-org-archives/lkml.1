Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYGKFb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYGKFb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbYGKFaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:30:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:2252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbYGKFaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:30:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,342,1212390000"; 
   d="scan'208";a="590292047"
Subject: [linux-next] [PATCH V2 4/4] introduce new kernel parameter
	acpi_sleep=s4_nvs_nosave
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 11 Jul 2008 13:29:14 +0800
Message-Id: <1215754154.1617.61.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce new kernel parameter acpi_sleep=s4_nvs_nosave.

This can be used to prevent OS from saving/restoring ACPI NVS memory.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/kernel-parameters.txt |    5 ++++-
 arch/x86/kernel/acpi/sleep.c        |    3 +++
 drivers/acpi/sleep/main.c           |    3 +++
 include/asm-x86/acpi.h              |    3 +++
 4 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-next/Documentation/kernel-parameters.txt
===================================================================
--- linux-next.orig/Documentation/kernel-parameters.txt	2008-07-11 13:04:46.000000000 +0800
+++ linux-next/Documentation/kernel-parameters.txt	2008-07-11 13:05:15.000000000 +0800
@@ -147,7 +147,8 @@
 			default: 0
 
 	acpi_sleep=	[HW,ACPI] Sleep options
-			Format: { s3_bios, s3_mode, s3_beep, old_ordering }
+			Format: { s3_bios, s3_mode, s3_beep, old_ordering,
+				  s4_nvs_nosave }
 			See Documentation/power/video.txt for s3_bios and s3_mode.
 			s3_beep is for debugging; it makes the PC's speaker beep
 			as soon as the kernel's real-mode entry point is called.
@@ -155,6 +156,8 @@
 			control method, wrt putting devices into low power
 			states, to be enforced (the ACPI 2.0 ordering of _PTS is
 			used by default).
+			s4_nvs_nosave prevents kernel from saving/restoring
+			ACPI NVS memory during hibernation.
 
 	acpi_sci=	[HW,ACPI] ACPI System Control Interrupt trigger mode
 			Format: { level | edge | high | low }
Index: linux-next/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-next.orig/arch/x86/kernel/acpi/sleep.c	2008-07-11 13:04:46.000000000 +0800
+++ linux-next/arch/x86/kernel/acpi/sleep.c	2008-07-11 13:05:15.000000000 +0800
@@ -15,6 +15,7 @@
 
 unsigned long acpi_wakeup_address;
 unsigned long acpi_realmode_flags;
+int acpi_sleep_flags;
 
 /* address in low memory of the wakeup routine. */
 static unsigned long acpi_realmode;
@@ -142,6 +143,8 @@
 			acpi_realmode_flags |= 4;
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
+		if (strncmp(str, "s4_nvs_nosave", 13) == 0)
+			acpi_sleep_flags |= ACPI_HIBERNATION_NVS_NOSAVE;
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");
Index: linux-next/drivers/acpi/sleep/main.c
===================================================================
--- linux-next.orig/drivers/acpi/sleep/main.c	2008-07-11 13:04:46.000000000 +0800
+++ linux-next/drivers/acpi/sleep/main.c	2008-07-11 13:05:15.000000000 +0800
@@ -297,6 +297,9 @@
 {
 	struct nvs_page *pos, *next;
 
+	if (acpi_sleep_flags & ACPI_HIBERNATION_NVS_NOSAVE)
+		return 0;
+
 	while (start <= end) {
 		pos = kzalloc(sizeof(struct nvs_page), GFP_KERNEL);
 		if (!pos)
Index: linux-next/include/asm-x86/acpi.h
===================================================================
--- linux-next.orig/include/asm-x86/acpi.h	2008-07-10 13:29:18.000000000 +0800
+++ linux-next/include/asm-x86/acpi.h	2008-07-11 13:05:15.000000000 +0800
@@ -94,6 +94,9 @@
 extern int acpi_sci_override_gsi;
 void acpi_pic_sci_set_trigger(unsigned int, u16);
 
+#define ACPI_HIBERNATION_NVS_NOSAVE 1
+extern int acpi_sleep_flags;
+
 static inline void disable_acpi(void)
 {
 	acpi_disabled = 1;


