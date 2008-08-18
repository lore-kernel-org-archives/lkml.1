Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYHRQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYHRQrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYHRQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24576 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYHRQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xkoUFKcx8J8zds76Rztys9fn4T16buozmZM3wX2nt2Qy8WVWUhTwHQz9QgjSUES4Mx
         WvdTrpF9nFJNvNXKVy3B85dVv3iL6XvyH1Sph3nORFU23GGtgLEmEITkiCGsTu4exJEE
         oc17ruYjaLds9FyjqHfMEBdDGgiG/iBA1dnxQ=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 05/15] x86: apic - unify connect_bsp_APIC
Date: Mon, 18 Aug 2008 20:45:53 +0400
Message-Id: <b6ae50995b6d03ea0021879833c1682b3cb880f0.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
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
index 4880654..5579e21 100644
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

