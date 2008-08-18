Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYHRQrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYHRQrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYHRQpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28003 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbYHRQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ILM+C+QLLzV83bZKizHL1kbCptzelW4SOaODLAS+nqbSUtxy6ElRWeXEFxiQJXgMSm
         IC3isnXA7zePPuP5bFX4JH8DKOP4EcN42k0hBxxBA99IRtE5ZAKcRw+Kw9Iq1CwzaIig
         13BvPZKVdycJZ/Bdq/s7OzlKNQZXMQvj9+0Yo=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 08/15] x86: apic - unify disconnect_bsp_APIC
Date: Mon, 18 Aug 2008 20:45:56 +0400
Message-Id: <768377a8b63946b98e162c1496cca85cb1db2fdc.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
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
index fe57db9..0d96910 100644
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

