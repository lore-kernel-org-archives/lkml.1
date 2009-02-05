Return-Path: <linux-kernel-owner+w=401wt.eu-S1762964AbZBETs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762964AbZBETs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762767AbZBETql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:46:41 -0500
Received: from mail.candelatech.com ([208.74.158.172]:40471 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763495AbZBETqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:46:40 -0500
Message-ID: <498B421D.9090609@candelatech.com>
Date: Thu, 05 Feb 2009 11:46:37 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: len.brown@intel.com
Subject: PATCH:  Allow over-ride of smp_found_cfg with kernel cmd-line option.
Content-Type: multipart/mixed;
 boundary="------------020007080406020202050101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020007080406020202050101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Allow user to keep smp_found_cfg set to 1 even if MADT
cannot be parsed.  This works around funky BIOS on FWA-7304
(VIA CN700 chipset) system, and possibly other systems as well.
Without this override, performance drops by around 15% on
network throughput tests on this system.

This is based on 2.6.29-rc3

Signed-Off-By:  Ben Greear <greearb@candelatech.com>


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------020007080406020202050101
Content-Type: text/x-patch;
 name="patch1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch1.patch"

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..e96bf19 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -87,6 +87,7 @@ u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
 int acpi_use_timer_override __initdata;
+int force_smp_found_cfg __initdata;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
@@ -1335,6 +1336,14 @@ static void __init early_acpi_process_madt(void)
 #endif
 }
 
+static int __init parse_force_smp_found_cfg(char *arg)
+{
+	force_smp_found_cfg = 1;
+	return 0;
+}
+early_param("force_smp_found_cfg", parse_force_smp_found_cfg);
+
+
 static void __init acpi_process_madt(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -1381,9 +1390,14 @@ static void __init acpi_process_madt(void)
  		 * Boot with "acpi=off" to use MPS on such a system.
  		 */
 		if (smp_found_config) {
-			printk(KERN_WARNING PREFIX
-				"No APIC-table, disabling MPS\n");
-			smp_found_config = 0;
+			if (force_smp_found_cfg)
+				printk(KERN_WARNING PREFIX
+				       "No APIC-table, wanted to disable MPS, but will not\n  due to force_smp_found_cfg=1\n");
+			else {
+				printk(KERN_WARNING PREFIX
+				       "No APIC-table, disabling MPS.  Use force_smp_found_cfg=1 to override\n");
+				smp_found_config = 0;
+			}
 		}
 	}
 

--------------020007080406020202050101--
