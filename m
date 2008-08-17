Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYHQTnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYHQTnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYHQTlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15010 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYHQTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qIw3i+b/lb3iBhBhN3kWMuNhuj1xQT37wM8ZYJZY9/gl1ETDateU8o5JOvX0y15Efg
         4Toi2k9tky9kXfeHBU6h8B2+XotD59Fq3WACxszaDv0V/dbzpLwj/FHPwoEH3i2YwTK+
         7EpShgiNIS/a9WrcG9RidZ+7v2U05vi6SXbPQ=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 5/9] x86: apic - unify connect_bsp_APIC
Date: Sun, 17 Aug 2008 23:41:43 +0400
Message-Id: <35ce95a46281c17089daf07f70c75598fd40d0d2.1219001352.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
References: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    2 ++
 arch/x86/kernel/apic_64.c |   20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d4efe86..6d230e9 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1387,6 +1387,7 @@ void smp_error_interrupt(struct pt_regs *regs)
  */
 void __init connect_bsp_APIC(void)
 {
+#ifdef CONFIG_X86_32
 	if (pic_mode) {
 		/*
 		 * Do not trust the local APIC being empty at bootup.
@@ -1401,6 +1402,7 @@ void __init connect_bsp_APIC(void)
 		outb(0x70, 0x22);
 		outb(0x01, 0x23);
 	}
+#endif
 	enable_apic_mode();
 }
 
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index cbca413..600ce2f 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1285,10 +1285,26 @@ asmlinkage void smp_error_interrupt(void)
 }
 
 /**
- *  * connect_bsp_APIC - attach the APIC to the interrupt system
- *   */
+ * connect_bsp_APIC - attach the APIC to the interrupt system
+ */
 void __init connect_bsp_APIC(void)
 {
+#ifdef CONFIG_X86_32
+	if (pic_mode) {
+		/*
+		 * Do not trust the local APIC being empty at bootup.
+		 */
+		clear_local_APIC();
+		/*
+		 * PIC mode, enable APIC mode in the IMCR, i.e.  connect BSP's
+		 * local APIC to INT and NMI lines.
+		 */
+		apic_printk(APIC_VERBOSE, "leaving PIC mode, "
+				"enabling APIC mode.\n");
+		outb(0x70, 0x22);
+		outb(0x01, 0x23);
+	}
+#endif
 	enable_apic_mode();
 }
 
-- 
1.6.0.rc1.34.g0fe8c

