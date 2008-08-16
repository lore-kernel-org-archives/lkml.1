Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYHPTWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYHPTWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYHPTVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:21:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:19723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYHPTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dC1yOO5Nr3r0aLUMoKvK8I5d4gc+dPz2FZEK6sHzbPh/aJ9X42zJofUEjfXg4+cW22
         cWsVocdAUuxg0SPt4AxfEnhIK/wPMSZBmqTUW3TQSr3Y/lH2DciLY5DWqkgivABzchfV
         T/CRg34130b03dFhRYI8GEyeGcytskF/01a4o=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/6] x86: apic - unify clear_local_APIC
Date: Sat, 16 Aug 2008 23:21:50 +0400
Message-Id: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove redundant masking of APIC_LVTTHMR register in apic_32.c

- Add masking of APIC_LVTTHMR register to apic_64.c. We use a bit
  complicated #ifdef here: CONFIG_X86_MCE_P4THERMAL is 32bit specific
  and X86_MCE_INTEL is 64bit specific so the appropriate config variable
  will be set by Kconfig.

- the APIC_ESR register clearing in apic_64.c now uses not straightforward
  way but this is allowed tradeoff.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    6 +-----
 arch/x86/kernel/apic_64.c |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 16d9721..3131603 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -754,7 +754,7 @@ void clear_local_APIC(void)
 	}
 
 	/* lets not touch this if we didn't frob it */
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(X86_MCE_INTEL)
 	if (maxlvt >= 5) {
 		v = apic_read(APIC_LVTTHMR);
 		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
@@ -771,10 +771,6 @@ void clear_local_APIC(void)
 	if (maxlvt >= 4)
 		apic_write(APIC_LVTPC, APIC_LVT_MASKED);
 
-#ifdef CONFIG_X86_MCE_P4THERMAL
-	if (maxlvt >= 5)
-		apic_write(APIC_LVTTHMR, APIC_LVT_MASKED);
-#endif
 	/* Integrated APIC (!82489DX) ? */
 	if (lapic_is_integrated()) {
 		if (maxlvt > 3)
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 99d18b8..d834b75 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -630,6 +630,13 @@ void clear_local_APIC(void)
 		apic_write(APIC_LVTPC, v | APIC_LVT_MASKED);
 	}
 
+	/* lets not touch this if we didn't frob it */
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(X86_MCE_INTEL)
+	if (maxlvt >= 5) {
+		v = apic_read(APIC_LVTTHMR);
+		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
+	}
+#endif
 	/*
 	 * Clean APIC state for other OSs:
 	 */
@@ -640,8 +647,14 @@ void clear_local_APIC(void)
 		apic_write(APIC_LVTERR, APIC_LVT_MASKED);
 	if (maxlvt >= 4)
 		apic_write(APIC_LVTPC, APIC_LVT_MASKED);
-	apic_write(APIC_ESR, 0);
-	apic_read(APIC_ESR);
+
+	/* Integrated APIC (!82489DX) ? */
+	if (lapic_is_integrated()) {
+		if (maxlvt > 3)
+			/* Clear ESR due to Pentium errata 3AP and 11AP */
+			apic_write(APIC_ESR, 0);
+		apic_read(APIC_ESR);
+	}
 }
 
 /**
-- 
1.6.0.rc1.34.g0fe8c

