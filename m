Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbXGPSDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbXGPSDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbXGPSCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:02:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56762 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbXGPSB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:01:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=WC0d1yNlGjgBMGcnsBitlQn5n2YmUlgadbL2aSwMQQcHxy2EuAlUJCbyvecYCdGHG
	P7QEAJkx7u7bJNLAAUhfQ==
Date: Mon, 16 Jul 2007 11:01:28 -0700
From: Aaron Durbin <adurbin@google.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@osdl.org
Subject: [PATCH] x86_64: Add ACPI reboot option
Message-ID: <20070716180128.GA5352@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add the ability to reboot an x86_64 based machine using the RESET_REG in the
FADT ACPI table.

Signed-off-by: Aaron Durbin <adurbin@google.com>
----

This patch relies on the ACPI reboot mechanism patch.

diff --git a/Documentation/x86_64/boot-options.txt b/Documentation/x86_64/boot-options.txt
index 6177d88..a9253bc 100644
--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
@@ -108,12 +108,15 @@ Idle loop
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | a[cpi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
+          ACPI reset does not work, the reboot path attempts the reset using
+          the keyboard controller.
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
index 7503068..239b576 100644
--- a/arch/x86_64/kernel/reboot.c
+++ b/arch/x86_64/kernel/reboot.c
@@ -9,6 +9,7 @@ #include <linux/string.h>
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/hw_irq.h>
@@ -26,7 +27,8 @@ EXPORT_SYMBOL(pm_power_off);
 static long no_idt[3];
 static enum { 
 	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k'
+	BOOT_KBD = 'k',
+	BOOT_ACPI = 'a'
 } reboot_type = BOOT_KBD;
 static int reboot_mode = 0;
 int reboot_force;
@@ -36,6 +38,7 @@ int reboot_force;
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   acpi   Use the RESET_REG in the FADT
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -51,6 +54,7 @@ static int __init reboot_setup(char *str
 			break;
 
 		case 't':
+		case 'a':
 		case 'b':
 		case 'k':
 			reboot_type = *str;
@@ -137,6 +141,11 @@ void machine_emergency_restart(void)
 
 			reboot_type = BOOT_KBD;
 			break;
+
+		case BOOT_ACPI:
+			acpi_reboot();
+			reboot_type = BOOT_KBD;
+			break;
 		}      
 	}      
 }
