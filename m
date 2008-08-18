Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYHRQq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYHRQq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYHRQpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28003 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbYHRQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ioYKA9RWOFhduhRBWxMz2nMCZL1f0qeKU88S1/f+CmNAEMhaS3gXTyQzsh24vqVwDH
         YQkaKeSMDDUpxWZfJqiME7kpFYGh6OReowihnTx6ucc6Jgg+TGvXOjNCJROx1no86fxx
         6q5LjRWneHeXlO0C42qiBMpjalNhm2IFFVCro=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 03/15] x86: apic - unify disable_local_APIC
Date: Mon, 18 Aug 2008 20:45:51 +0400
Message-Id: <eaedeb100fb72586b8cb078b89b9391cf1ea3b67.1219073223.git.gorcunov@gmail.com>
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
index 46acb9b..4fb903b 100644
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

