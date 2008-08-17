Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYHQTnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYHQTnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHQTlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9804 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYHQTli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BaWfaJ5ZNIEQEIpc700JgYbsuuALSuGEd/h/0BmDaSJHg6DAkZYtRLs/Nk3wC941eM
         youCAX1MlUl01UTeXi4e5LM1MUZ6KnFATtfrEmE/m7seOCALDXgZAX9hInbcJGdz6Xx0
         xjRCnSEtapF+XlRmlEjlFMkH50XqL7am2tdos=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 8/9] x86: apic - unify disconnect_bsp_APIC
Date: Sun, 17 Aug 2008 23:41:46 +0400
Message-Id: <e6cd9e5cff1f01ade8b6b446424e7ecb5935a65e.1219001352.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
References: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- just #ifdef added

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   66 +++++++++++++++++++++++---------------------
 arch/x86/kernel/apic_64.c |   23 ++++++++++++++-
 2 files changed, 55 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 65419c7..3095bb7 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1420,6 +1420,7 @@ void __init connect_bsp_APIC(void)
  */
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
+#ifdef CONFIG_X86_32
 	if (pic_mode) {
 		/*
 		 * Put the board back into PIC mode (has an effect only on
@@ -1431,47 +1432,48 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 				"entering PIC mode.\n");
 		outb(0x70, 0x22);
 		outb(0x00, 0x23);
-	} else {
-		/* Go back to Virtual Wire compatibility mode */
-		unsigned long value;
+		return;
+	}
+#endif
 
-		/* For the spurious interrupt use vector F, and enable it */
-		value = apic_read(APIC_SPIV);
-		value &= ~APIC_VECTOR_MASK;
-		value |= APIC_SPIV_APIC_ENABLED;
-		value |= 0xf;
-		apic_write(APIC_SPIV, value);
+	/* Go back to Virtual Wire compatibility mode */
+	unsigned int value;
 
-		if (!virt_wire_setup) {
-			/*
-			 * For LVT0 make it edge triggered, active high,
-			 * external and enabled
-			 */
-			value = apic_read(APIC_LVT0);
-			value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
-				APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
-				APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
-			value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
-			value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
-			apic_write(APIC_LVT0, value);
-		} else {
-			/* Disable LVT0 */
-			apic_write(APIC_LVT0, APIC_LVT_MASKED);
-		}
+	/* For the spurious interrupt use vector F, and enable it */
+	value = apic_read(APIC_SPIV);
+	value &= ~APIC_VECTOR_MASK;
+	value |= APIC_SPIV_APIC_ENABLED;
+	value |= 0xf;
+	apic_write(APIC_SPIV, value);
 
+	if (!virt_wire_setup) {
 		/*
-		 * For LVT1 make it edge triggered, active high, nmi and
-		 * enabled
+		 * For LVT0 make it edge triggered, active high,
+		 * external and enabled
 		 */
-		value = apic_read(APIC_LVT1);
-		value &= ~(
-			APIC_MODE_MASK | APIC_SEND_PENDING |
+		value = apic_read(APIC_LVT0);
+		value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
 			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
 			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
 		value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
-		value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_NMI);
-		apic_write(APIC_LVT1, value);
+		value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
+		apic_write(APIC_LVT0, value);
+	} else {
+		/* Disable LVT0 */
+		apic_write(APIC_LVT0, APIC_LVT_MASKED);
 	}
+
+	/*
+	 * For LVT1 make it edge triggered, active high,
+	 * nmi and enabled
+	 */
+	value = apic_read(APIC_LVT1);
+	value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
+			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
+			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
+	value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
+	value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_NMI);
+	apic_write(APIC_LVT1, value);
 }
 
 void __cpuinit generic_processor_info(int apicid, int version)
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index a814612..30b1097 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1348,8 +1348,24 @@ void __init connect_bsp_APIC(void)
  */
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
+#ifdef CONFIG_X86_32
+	if (pic_mode) {
+		/*
+		 * Put the board back into PIC mode (has an effect only on
+		 * certain older boards).  Note that APIC interrupts, including
+		 * IPIs, won't work beyond this point!  The only exception are
+		 * INIT IPIs.
+		 */
+		apic_printk(APIC_VERBOSE, "disabling APIC mode, "
+				"entering PIC mode.\n");
+		outb(0x70, 0x22);
+		outb(0x00, 0x23);
+		return;
+	}
+#endif
+
 	/* Go back to Virtual Wire compatibility mode */
-	unsigned long value;
+	unsigned int value;
 
 	/* For the spurious interrupt use vector F, and enable it */
 	value = apic_read(APIC_SPIV);
@@ -1375,7 +1391,10 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 		apic_write(APIC_LVT0, APIC_LVT_MASKED);
 	}
 
-	/* For LVT1 make it edge triggered, active high, nmi and enabled */
+	/*
+	 * For LVT1 make it edge triggered, active high,
+	 * nmi and enabled
+	 */
 	value = apic_read(APIC_LVT1);
 	value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
 			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
-- 
1.6.0.rc1.34.g0fe8c

