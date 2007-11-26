Return-Path: <linux-kernel-owner+w=401wt.eu-S1751161AbXKZIYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbXKZIYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXKZIX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:23:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:28903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbXKZIX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:23:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,466,1188802800"; 
   d="scan'208";a="402681217"
Subject: [PATCH -mm 2/4 -v6] x86_64 EFI runtime service support: EFI
	runtime services
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Nov 2007 16:23:45 +0800
Message-Id: <1196065425.14142.16.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Nov 2007 08:19:35.0295 (UTC) FILETIME=[1442C8F0:01C83005]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for several EFI runtime services for EFI
x86_64 system.

The EFI support for emergency_restart is added.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/reboot_64.c         |   20 +++++++++++++-------
 include/asm-x86/emergency-restart.h |    9 +++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/reboot_64.c
+++ b/arch/x86/kernel/reboot_64.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/efi.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
@@ -27,20 +28,17 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static long no_idt[3];
-static enum { 
-	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k',
-	BOOT_ACPI = 'a'
-} reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_KBD;
 static int reboot_mode = 0;
 int reboot_force;
 
-/* reboot=t[riple] | k[bd] [, [w]arm | [c]old]
+/* reboot=t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
    acpi   Use the RESET_REG in the FADT
+   efi    Use efi reset_system runtime service
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -59,6 +57,7 @@ static int __init reboot_setup(char *str
 		case 'a':
 		case 'b':
 		case 'k':
+		case 'e':
 			reboot_type = *str;
 			break;
 		case 'f':
@@ -151,7 +150,14 @@ void machine_emergency_restart(void)
 			acpi_reboot();
 			reboot_type = BOOT_KBD;
 			break;
-		}      
+
+		case BOOT_EFI:
+			if (efi_enabled)
+				efi.reset_system(reboot_mode ? EFI_RESET_WARM : EFI_RESET_COLD,
+						 EFI_SUCCESS, 0, NULL);
+			reboot_type = BOOT_KBD;
+			break;
+		}
 	}      
 }
 
--- a/include/asm-x86/emergency-restart.h
+++ b/include/asm-x86/emergency-restart.h
@@ -1,6 +1,15 @@
 #ifndef _ASM_EMERGENCY_RESTART_H
 #define _ASM_EMERGENCY_RESTART_H
 
+enum reboot_type {
+	BOOT_TRIPLE = 't',
+	BOOT_KBD = 'k',
+	BOOT_ACPI = 'a',
+	BOOT_EFI = 'e'
+};
+
+extern enum reboot_type reboot_type;
+
 extern void machine_emergency_restart(void);
 
 #endif /* _ASM_EMERGENCY_RESTART_H */
