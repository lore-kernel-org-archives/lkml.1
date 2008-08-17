Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYHQTnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYHQTnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYHQTlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11381 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYHQTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vyKefOgPDWPLqJE2XH0FiHL2eNPIkGN8I4xE639CPNrLX9QWP9jxCHk6P00EdXE9kB
         rLlNt13qaTFM3YGLyEvNsooD4vq3xGfXaYtxMTVJy2LBNJMLT7mOmVMH+JA2L0Kx6v2J
         m1hYow/im7cRRa5dMyi7bL3E+Vt2gAkho/mvw=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 3/9] x86: apic - unify disable_local_APIC
Date: Sun, 17 Aug 2008 23:41:41 +0400
Message-Id: <a1cf35b9539ae967d921385b5f71ac05dba170dd.1219001352.git.gorcunov@gmail.com>
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
 arch/x86/kernel/apic_32.c |    4 +++-
 arch/x86/kernel/apic_64.c |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 80db3e0..13c4b79 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -796,7 +796,7 @@ void clear_local_APIC(void)
  */
 void disable_local_APIC(void)
 {
-	unsigned long value;
+	unsigned int value;
 
 	clear_local_APIC();
 
@@ -808,6 +808,7 @@ void disable_local_APIC(void)
 	value &= ~APIC_SPIV_APIC_ENABLED;
 	apic_write(APIC_SPIV, value);
 
+#ifdef CONFIG_X86_32
 	/*
 	 * When LAPIC was disabled by the BIOS and enabled by the kernel,
 	 * restore the disabled state.
@@ -819,6 +820,7 @@ void disable_local_APIC(void)
 		l &= ~MSR_IA32_APICBASE_ENABLE;
 		wrmsr(MSR_IA32_APICBASE, l, h);
 	}
+#endif
 }
 
 /*
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 6aa0f60..35e0e2e 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -691,6 +691,20 @@ void disable_local_APIC(void)
 	value = apic_read(APIC_SPIV);
 	value &= ~APIC_SPIV_APIC_ENABLED;
 	apic_write(APIC_SPIV, value);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * When LAPIC was disabled by the BIOS and enabled by the kernel,
+	 * restore the disabled state.
+	 */
+	if (enabled_via_apicbase) {
+		unsigned int l, h;
+
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		l &= ~MSR_IA32_APICBASE_ENABLE;
+		wrmsr(MSR_IA32_APICBASE, l, h);
+	}
+#endif
 }
 
 void lapic_shutdown(void)
-- 
1.6.0.rc1.34.g0fe8c

