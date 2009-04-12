Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbZDLQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbZDLQve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbZDLQvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:51:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43571 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZDLQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=UaCYN0GPCAUz7Wq+IFgJxGAwoAE7wl38zPiCCaVJMTiUrRNKT/dw4WG14rzc1Rl+es
         cr4dIbCZDRMs4G/iCM7ziT8p+doIiKpW6RY0KV3BnNR180BtH8Vum2M9dUoXV4OqTJuw
         WzyMYd5DwkhWJMZbsMsyY4z3l3xAk4t71pPVc=
Message-Id: <20090412165058.535921550@openvz.org>
User-Agent: quilt/0.47-1
Date: Sun, 12 Apr 2009 20:47:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: xemul@openvz.org, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       macro@linux-mips.org, andi@firstfloor.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 2/4] x86: apic - introduce imcr_ helpers
References: <20090412164738.967602112@openvz.org>
Content-Disposition: inline; filename=x86-apic-imcr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Distinguish port writting magic into helpers with comments.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -99,6 +99,29 @@ early_param("lapic", parse_lapic);
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
 
+/*
+ * Handle interrupt mode configuration register (IMCR).
+ * This register controls whether the interrupt signals
+ * that reach the BSP come from the master PIC or from the
+ * local APIC. Before entering Symmetric I/O Mode, either
+ * the BIOS or the operating system must switch out of
+ * PIC Mode by changing the IMCR.
+ */
+static inline imcr_pic_to_apic(void)
+{
+	/* select IMCR register */
+	outb(0x70, 0x22);
+	/* NMI and 8259 INTR go through APIC */
+	outb(0x01, 0x23);
+}
+
+static inline imcr_apic_to_pic(void)
+{
+	/* select IMCR register */
+	outb(0x70, 0x22);
+	/* NMI and 8259 INTR go directly to BSP */
+	outb(0x00, 0x23);
+}
 #endif
 
 #ifdef CONFIG_X86_64
@@ -1737,8 +1760,7 @@ void __init connect_bsp_APIC(void)
 		 */
 		apic_printk(APIC_VERBOSE, "leaving PIC mode, "
 				"enabling APIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x01, 0x23);
+		imcr_pic_to_apic();
 	}
 #endif
 	if (apic->enable_apic_mode)
@@ -1766,8 +1788,7 @@ void disconnect_bsp_APIC(int virt_wire_s
 		 */
 		apic_printk(APIC_VERBOSE, "disabling APIC mode, "
 				"entering PIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x00, 0x23);
+		imcr_apic_to_pic();
 		return;
 	}
 #endif

