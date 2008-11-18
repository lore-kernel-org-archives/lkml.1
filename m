Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYKRCuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYKRCuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 21:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYKRCuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 21:50:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:37771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKRCuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:50:06 -0500
Message-ID: <49222D24.5020601@kernel.org>
Date: Mon, 17 Nov 2008 18:49:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu> <4921FC19.1080803@kernel.org> <20081117232837.GA10308@elte.hu>
In-Reply-To: <20081117232837.GA10308@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

[PATCH] x86: use update_genapic to update inquire_remote_apic

Impact: clean up

So don't can comparing in that func when debug is disabled.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/es7000/wakecpu.h            |    3 +--
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    3 +--
 arch/x86/kernel/es7000_32.c                      |   11 ++++++++++-
 arch/x86/kernel/setup.c                          |    9 +++++++++
 4 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mach-default/mach_wakecpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ linux-2.6/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -28,8 +28,7 @@ extern void __inquire_remote_apic(int ap
 
 static inline void inquire_remote_apic(int apicid)
 {
-	if (apic_verbosity >= APIC_DEBUG)
-		__inquire_remote_apic(apicid);
+	__inquire_remote_apic(apicid);
 }
 
 #endif /* _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H */
Index: linux-2.6/arch/x86/kernel/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/es7000_32.c
+++ linux-2.6/arch/x86/kernel/es7000_32.c
@@ -181,14 +181,23 @@ static int wakeup_secondary_cpu_via_mip(
 
 	return 0;
 }
+#endif
+
+static void noop_inquire(void)
+{
+}
 
 static int __init es7000_update_genapic(void)
 {
+#ifdef CONFIG_ES7000_CLUSTERED_APIC
 	genapic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
+#endif
+
+	if (apic_verbosity < APIC_DEBUG)
+		genapic->inquire_remote_apic = noop_inquire;
 
 	return 0;
 }
-#endif
 
 void __init
 setup_unisys(void)
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -584,10 +584,19 @@ static int __init setup_elfcorehdr(char
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
+
+#if defined(CONFIG_X86_GENERICARCH) || defined(CONFIG_X86_64)
+static void noop_inquire(int apicid)
+{
+}
+#endif
 static int __init default_update_genapic(void)
 {
 #if defined(CONFIG_X86_GENERICARCH) || defined(CONFIG_X86_64)
 	genapic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
+
+	if (apic_verbosity < APIC_DEBUG)
+		genapic->inquire_remote_apic = noop_inquire;
 #endif
 
 	return 0;
Index: linux-2.6/arch/x86/include/asm/es7000/wakecpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/es7000/wakecpu.h
+++ linux-2.6/arch/x86/include/asm/es7000/wakecpu.h
@@ -30,8 +30,7 @@ extern void __inquire_remote_apic(int ap
 
 static inline void inquire_remote_apic(int apicid)
 {
-	if (apic_verbosity >= APIC_DEBUG)
-		__inquire_remote_apic(apicid);
+	__inquire_remote_apic(apicid);
 }
 
 #endif /* __ASM_MACH_WAKECPU_H */

