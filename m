Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZDLR6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZDLR6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZDLR60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:58:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:39351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZDLR6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:58:24 -0400
Date: Sun, 12 Apr 2009 17:57:46 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090412165058.535921550@openvz.org>
References: <20090412165058.535921550@openvz.org>
Subject: [tip:x86/apic] x86: apic - introduce imcr_ helpers
Message-ID: <tip-c0eaa4536f08b98fbcfa7fce5b7b0de1bebcb0e1@git.kernel.org>
Git-Commit-ID: c0eaa4536f08b98fbcfa7fce5b7b0de1bebcb0e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 17:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0eaa4536f08b98fbcfa7fce5b7b0de1bebcb0e1
Gitweb:     http://git.kernel.org/tip/c0eaa4536f08b98fbcfa7fce5b7b0de1bebcb0e1
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 12 Apr 2009 20:47:40 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 19:23:53 +0200

x86: apic - introduce imcr_ helpers

Impact: cleanup

Distinguish port writting magic into helpers with comments.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090412165058.535921550@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 098ec84..c3be10f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -98,6 +98,29 @@ early_param("lapic", parse_lapic);
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
@@ -1727,8 +1750,7 @@ void __init connect_bsp_APIC(void)
 		 */
 		apic_printk(APIC_VERBOSE, "leaving PIC mode, "
 				"enabling APIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x01, 0x23);
+		imcr_pic_to_apic();
 	}
 #endif
 	if (apic->enable_apic_mode)
@@ -1756,8 +1778,7 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 		 */
 		apic_printk(APIC_VERBOSE, "disabling APIC mode, "
 				"entering PIC mode.\n");
-		outb(0x70, 0x22);
-		outb(0x00, 0x23);
+		imcr_apic_to_pic();
 		return;
 	}
 #endif
