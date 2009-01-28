Return-Path: <linux-kernel-owner+w=401wt.eu-S1761876AbZA2AMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876AbZA2AMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbZA1Xp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:53142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572AbZA1Xp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:56 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 071/114] x86: remove mach_apicdef.h
Date: Wed, 28 Jan 2009 23:42:17 +0000
Message-Id: <1233186180-29883-72-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move its definitions into apic.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h                      |   16 ++++++++++++++++
 arch/x86/include/asm/mach-default/mach_apic.h    |    1 -
 arch/x86/include/asm/mach-default/mach_apicdef.h |   22 ----------------------
 arch/x86/include/asm/mach-generic/mach_apicdef.h |    8 --------
 arch/x86/include/asm/smp.h                       |    4 ++--
 arch/x86/kernel/apic.c                           |    1 -
 arch/x86/kernel/genapic_flat_64.c                |    1 -
 arch/x86/kernel/io_apic.c                        |    1 -
 arch/x86/kernel/mpparse.c                        |    3 ---
 arch/x86/mach-generic/default.c                  |    1 -
 10 files changed, 18 insertions(+), 40 deletions(-)
 delete mode 100644 arch/x86/include/asm/mach-default/mach_apicdef.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_apicdef.h

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e8f0304..3a32020 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -211,4 +211,20 @@ static inline void disable_local_APIC(void) { }
 
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
+#ifdef CONFIG_X86_64
+#define	SET_APIC_ID(x)		(apic->set_apic_id(x))
+#else
+
+static inline unsigned default_get_apic_id(unsigned long x) 
+{
+	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
+
+	if (APIC_XAPIC(ver))
+		return (x >> 24) & 0xFF;
+	else
+		return (x >> 24) & 0x0F;
+}
+
+#endif
+
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 2e4104c..b60b767 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
-#include <mach_apicdef.h>
 #include <asm/smp.h>
 
 #define APIC_DFR_VALUE	(APIC_DFR_FLAT)
diff --git a/arch/x86/include/asm/mach-default/mach_apicdef.h b/arch/x86/include/asm/mach-default/mach_apicdef.h
deleted file mode 100644
index 5141085..0000000
--- a/arch/x86/include/asm/mach-default/mach_apicdef.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _ASM_X86_MACH_DEFAULT_MACH_APICDEF_H
-#define _ASM_X86_MACH_DEFAULT_MACH_APICDEF_H
-
-#include <asm/apic.h>
-
-#ifdef CONFIG_X86_64
-#define	SET_APIC_ID(x)		(apic->set_apic_id(x))
-#else
-
-static inline unsigned default_get_apic_id(unsigned long x) 
-{
-	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
-
-	if (APIC_XAPIC(ver))
-		return (x >> 24) & 0xFF;
-	else
-		return (x >> 24) & 0x0F;
-} 
-
-#endif
-
-#endif /* _ASM_X86_MACH_DEFAULT_MACH_APICDEF_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_apicdef.h b/arch/x86/include/asm/mach-generic/mach_apicdef.h
deleted file mode 100644
index 61caa65..0000000
--- a/arch/x86/include/asm/mach-generic/mach_apicdef.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_APICDEF_H
-#define _ASM_X86_MACH_GENERIC_MACH_APICDEF_H
-
-#ifndef APIC_DEFINITION
-#include <asm/genapic.h>
-#endif
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_APICDEF_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index c63d480..d4ac4de 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -173,6 +173,8 @@ extern int safe_smp_processor_id(void);
 
 #endif
 
+#include <asm/genapic.h>
+
 #ifdef CONFIG_X86_LOCAL_APIC
 
 #ifndef CONFIG_X86_64
@@ -182,7 +184,6 @@ static inline int logical_smp_processor_id(void)
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
 }
 
-#include <mach_apicdef.h>
 static inline unsigned int read_apic_id(void)
 {
 	unsigned int reg;
@@ -197,7 +198,6 @@ static inline unsigned int read_apic_id(void)
 # if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
 extern int hard_smp_processor_id(void);
 # else
-#include <mach_apicdef.h>
 static inline int hard_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 84b8e7c..e622080 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -50,7 +50,6 @@
 #include <asm/smp.h>
 
 #include <mach_apic.h>
-#include <mach_apicdef.h>
 #include <mach_ipi.h>
 
 /*
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index e9237f5..19bffb3 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -19,7 +19,6 @@
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
-#include <mach_apicdef.h>
 
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index e90970c..abae819 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -64,7 +64,6 @@
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
-#include <mach_apicdef.h>
 
 #define __apicdebuginit(type) static type __init
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c693016..a1452a5 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -30,9 +30,6 @@
 #include <asm/smp.h>
 
 #include <mach_apic.h>
-#ifdef CONFIG_X86_32
-#include <mach_apicdef.h>
-#endif
 
 /*
  * Checksum an MP configuration block.
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 6485e57..07817b2 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -5,7 +5,6 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <asm/mpspec.h>
-#include <asm/mach-default/mach_apicdef.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
-- 
1.6.0.2

