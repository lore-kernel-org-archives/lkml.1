Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbYEWAej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbYEWAej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYEWAea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:34:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:62874 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375AbYEWAea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UCA2JGGiGKxnjbXbHzFbl+Xybf/3hbj84NoPEjLqSD7/TnH4YwX9jDY+77pY6Je7JxYHlKIUzHw44UMggSWQOQ7eoZhXNYOzeOdUAzhfAX/DfM2fUT+vSuOP2sM1HvUqsmaQqifQk0QnX+n9M2786KFhWh5mZ9Ck4N8etdt/Kps=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: [PATCH] x86: fix APIC warning on 32bit
Date: Thu, 22 May 2008 17:35:22 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221735.22482.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for
[Bug #10613] BIOS bug, APIC version is 0 for CPU#0!
http://bugzilla.kernel.org/show_bug.cgi?id=10613

BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -242,12 +242,17 @@ static int __init acpi_parse_madt(struct
 
 static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
+	unsigned int ver = 0;
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
 	}
 
-	generic_processor_info(id, 0);
+	if (boot_cpu_physical_apicid != -1U)
+		ver = apic_version[boot_cpu_physical_apicid];
+
+	generic_processor_info(id, ver);
 }
 
 static int __init
@@ -763,8 +768,11 @@ static void __init acpi_register_lapic_a
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
-	if (boot_cpu_physical_apicid == -1U)
+	if (boot_cpu_physical_apicid == -1U) {
+		unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
 		boot_cpu_physical_apicid  = GET_APIC_ID(read_apic_id());
+		apic_version[boot_cpu_physical_apicid] = ver;
+	}
 }
 
 static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
