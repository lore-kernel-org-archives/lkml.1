Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZCHQvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZCHQvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZCHQsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:48:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37650 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbZCHQsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:48:53 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 10/13] [VOYAGER] x86: make disabling the apics functional instead of a flag
Date: Sun,  8 Mar 2009 11:48:23 -0500
Message-Id: <1236530906-7175-11-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236530906-7175-10-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-9-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-10-git-send-email-James.Bottomley@HansenPartnership.com>
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
index 4ef949c..930ebf5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -230,12 +230,18 @@ static inline int apic_is_clustered_box(void)
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
index ee68005..cb6e5b8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1508,6 +1508,9 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
+	if (disable_apic)
+		return;
+
 #ifdef CONFIG_X86_X2APIC
 	if (x2apic) {
 		boot_cpu_physical_apicid = read_apic_id();
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 141c99a..770b5c4 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -225,6 +225,9 @@ void __init generic_bigsmp_probe(void)
 
 void __init generic_apic_probe(void)
 {
+	if (disable_apic)
+		return;
+
 	if (!cmdline_apic) {
 		int i;
 		for (i = 0; apic_probe[i]; i++) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bae35f9..62e9f59 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -750,9 +750,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_early_setup_data();
 
 	if (acpi_mps_check()) {
-#ifdef CONFIG_X86_LOCAL_APIC
-		disable_apic = 1;
-#endif
+		disable_APIC();
 		setup_clear_cpu_cap(X86_FEATURE_APIC);
 	}
 
-- 
1.6.1.3

