Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbYEWBVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbYEWBVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYEWBVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:21:40 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:37565 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYEWBVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Kqa1abh4X5Ymf6u0Zt4hxcqUzdtwb/XvACyY8kkXEA7vcQsoqEXZ4rBDLfh4Y0FCFCIalhD+jacZ1RdXXgC6lk4vS8VIFM4DCR0CNPwmHETlSjwRwTATV3ZsblrAGwWZyyMuqw6vT3ak3hG/hqYo/IHPNHiKWtyJFpPJoiH7OWE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: [PATCH] x86: fix APIC warning on 32bit v2
Date: Thu, 22 May 2008 18:22:30 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200805221735.22482.yhlu.kernel@gmail.com>
In-Reply-To: <200805221735.22482.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221822.31120.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for
http://bugzilla.kernel.org/show_bug.cgi?id=10613

BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)

v2: fix 64 bit compilation

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -242,12 +242,19 @@ static int __init acpi_parse_madt(struct
 
 static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
+	unsigned int ver = 0;
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
 	}
 
-	generic_processor_info(id, 0);
+#ifdef CONFIG_X86_32
+	if (boot_cpu_physical_apicid != -1U)
+		ver = apic_version[boot_cpu_physical_apicid];
+#endif
+
+	generic_processor_info(id, ver);
 }
 
 static int __init
@@ -763,8 +770,13 @@ static void __init acpi_register_lapic_a
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
-	if (boot_cpu_physical_apicid == -1U)
+	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = GET_APIC_ID(read_apic_id());
+#ifdef CONFIG_X86_32
+		apic_version[boot_cpu_physical_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
+#endif
+	}
 }
 
 static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
