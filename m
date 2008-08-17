Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYHQTmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYHQTmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHQTlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9804 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYHQTle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=raLq5tXbb4f4YRma4XaY7nhmoNkbMXFD59C7+ZrUaN4aGA09vGpvQRsgSHvw6FynDH
         70efpniEAfLyVFyowaagqj6plTPPW7VjU6BWQQG3oZLIXN2V+z9NHX2TotOTsmeFYL0D
         IM56TyI/DAlHHIzY/YAN5i4Gvl7pyRgzoJxEY=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 4/9] x86: apic - unify disable_local_APIC
Date: Sun, 17 Aug 2008 23:41:42 +0400
Message-Id: <e5bf2b24046ad3e9a7b54e4e16e1ac54098bdcee.1219001352.git.gorcunov@gmail.com>
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
 arch/x86/kernel/apic_32.c |    9 ++++++---
 arch/x86/kernel/apic_64.c |   14 +++++++++++++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 13c4b79..d4efe86 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -838,10 +838,13 @@ void lapic_shutdown(void)
 
 	local_irq_save(flags);
 
-	if (enabled_via_apicbase)
-		disable_local_APIC();
-	else
+#ifdef CONFIG_X86_32
+	if (!enabled_via_apicbase)
 		clear_local_APIC();
+	else
+#endif
+		disable_local_APIC();
+
 
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 35e0e2e..cbca413 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -707,6 +707,12 @@ void disable_local_APIC(void)
 #endif
 }
 
+/*
+ * If Linux enabled the LAPIC against the BIOS default disable it down before
+ * re-entering the BIOS on shutdown.  Otherwise the BIOS may get confused and
+ * not power-off.  Additionally clear all LVT entries before disable_local_APIC
+ * for the case where Linux didn't enable the LAPIC.
+ */
 void lapic_shutdown(void)
 {
 	unsigned long flags;
@@ -716,7 +722,13 @@ void lapic_shutdown(void)
 
 	local_irq_save(flags);
 
-	disable_local_APIC();
+#ifdef CONFIG_X86_32
+	if (!enabled_via_apicbase)
+		clear_local_APIC();
+	else
+#endif
+		disable_local_APIC();
+
 
 	local_irq_restore(flags);
 }
-- 
1.6.0.rc1.34.g0fe8c

