Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZDNPzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZDNPzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZDNPvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46002 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462AbZDNPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:50 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 10/14] [VOYAGER] x86: make disabling the apics functional instead of a flag
Date: Tue, 14 Apr 2009 10:51:36 -0500
Message-Id: <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the elimination of some ifdef guards in setup.c.
Additionally probe_32.c doesn't need to run through the apics in
generic_apic_probe() if they're disabled.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/apic.h     |    6 ++++++
 arch/x86/kernel/apic/apic.c     |    3 +++
 arch/x86/kernel/apic/probe_32.c |    3 +++
 arch/x86/kernel/setup.c         |    4 +---
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..391c464 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -246,12 +246,18 @@ static inline int apic_is_clustered_box(void)
 extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
 extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 
+static inline void disable_APIC(void)
+{
+	disable_local_APIC();
+	disable_apic = 1;
+}
 
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
 #define local_apic_timer_c2_ok		1
 static inline void init_apic_mappings(void) { }
 static inline void disable_local_APIC(void) { }
+static inline void disable_APIC(void) { }
 
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f9e830e..aa96dbe 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1539,6 +1539,9 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
+	if (disable_apic)
+		return;
+
 	if (x2apic) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 01eda2a..049d7a0 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -226,6 +226,9 @@ void __init generic_bigsmp_probe(void)
 
 void __init generic_apic_probe(void)
 {
+	if (disable_apic)
+		return;
+
 	if (!cmdline_apic) {
 		int i;
 		for (i = 0; apic_probe[i]; i++) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bee0914..13779e2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -770,9 +770,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_early_setup_data();
 
 	if (acpi_mps_check()) {
-#ifdef CONFIG_X86_LOCAL_APIC
-		disable_apic = 1;
-#endif
+		disable_APIC();
 		setup_clear_cpu_cap(X86_FEATURE_APIC);
 	}
 
-- 
1.6.2.1

