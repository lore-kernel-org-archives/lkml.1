Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZA2AFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZA2AFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbZA1Xp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:53040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636AbZA1XpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:23 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 056/114] x86, apic: refactor ->apic_id_mask & APIC_ID_MASK
Date: Wed, 28 Jan 2009 23:42:02 +0000
Message-Id: <1233186180-29883-57-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- spread out the namespace on a per driver basis

 - get rid of wrapper macros

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apicdef.h            |    2 +-
 arch/x86/include/asm/es7000/apicdef.h            |    2 +-
 arch/x86/include/asm/mach-default/mach_apicdef.h |    3 +--
 arch/x86/include/asm/mach-generic/mach_apicdef.h |    2 --
 arch/x86/include/asm/numaq/apicdef.h             |    2 +-
 arch/x86/include/asm/summit/apicdef.h            |    2 +-
 arch/x86/kernel/apic.c                           |    4 ++--
 arch/x86/kernel/genapic_flat_64.c                |    2 +-
 arch/x86/mach-generic/bigsmp.c                   |    2 +-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mach-generic/es7000.c                   |    2 +-
 arch/x86/mach-generic/numaq.c                    |    2 +-
 arch/x86/mach-generic/summit.c                   |    2 +-
 13 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apicdef.h b/arch/x86/include/asm/bigsmp/apicdef.h
index ed25dd6..6e58781 100644
--- a/arch/x86/include/asm/bigsmp/apicdef.h
+++ b/arch/x86/include/asm/bigsmp/apicdef.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_MACH_APICDEF_H
 #define __ASM_MACH_APICDEF_H
 
-#define		APIC_ID_MASK		(0xFF<<24)
+#define		BIGSMP_APIC_ID_MASK		(0xFF<<24)
 
 static inline unsigned bigsmp_get_apic_id(unsigned long x)
 {
diff --git a/arch/x86/include/asm/es7000/apicdef.h b/arch/x86/include/asm/es7000/apicdef.h
index e237917..476da0c 100644
--- a/arch/x86/include/asm/es7000/apicdef.h
+++ b/arch/x86/include/asm/es7000/apicdef.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_ES7000_APICDEF_H
 #define __ASM_ES7000_APICDEF_H
 
-#define		APIC_ID_MASK		(0xFF<<24)
+#define		ES7000_APIC_ID_MASK		(0xFF<<24)
 
 static inline unsigned int es7000_get_apic_id(unsigned long x)
 {
diff --git a/arch/x86/include/asm/mach-default/mach_apicdef.h b/arch/x86/include/asm/mach-default/mach_apicdef.h
index e84d437..8318d12 100644
--- a/arch/x86/include/asm/mach-default/mach_apicdef.h
+++ b/arch/x86/include/asm/mach-default/mach_apicdef.h
@@ -4,10 +4,9 @@
 #include <asm/apic.h>
 
 #ifdef CONFIG_X86_64
-#define	APIC_ID_MASK		(apic->apic_id_mask)
 #define	SET_APIC_ID(x)		(apic->set_apic_id(x))
 #else
-#define		APIC_ID_MASK		(0xF<<24)
+#define		DEFAULT_APIC_ID_MASK	(0x0F<<24)
 
 static inline unsigned default_get_apic_id(unsigned long x) 
 {
diff --git a/arch/x86/include/asm/mach-generic/mach_apicdef.h b/arch/x86/include/asm/mach-generic/mach_apicdef.h
index 645520b..61caa65 100644
--- a/arch/x86/include/asm/mach-generic/mach_apicdef.h
+++ b/arch/x86/include/asm/mach-generic/mach_apicdef.h
@@ -3,8 +3,6 @@
 
 #ifndef APIC_DEFINITION
 #include <asm/genapic.h>
-
-#define APIC_ID_MASK (apic->apic_id_mask)
 #endif
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_APICDEF_H */
diff --git a/arch/x86/include/asm/numaq/apicdef.h b/arch/x86/include/asm/numaq/apicdef.h
index 29f5e3d..6f2cc5d 100644
--- a/arch/x86/include/asm/numaq/apicdef.h
+++ b/arch/x86/include/asm/numaq/apicdef.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_NUMAQ_APICDEF_H
 #define __ASM_NUMAQ_APICDEF_H
 
-#define APIC_ID_MASK (0xF<<24)
+#define NUMAQ_APIC_ID_MASK (0xF<<24)
 
 static inline unsigned int numaq_get_apic_id(unsigned long x)
 {
diff --git a/arch/x86/include/asm/summit/apicdef.h b/arch/x86/include/asm/summit/apicdef.h
index 4286528..0373f0c 100644
--- a/arch/x86/include/asm/summit/apicdef.h
+++ b/arch/x86/include/asm/summit/apicdef.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_SUMMIT_APICDEF_H
 #define __ASM_SUMMIT_APICDEF_H
 
-#define		APIC_ID_MASK		(0xFF<<24)
+#define		SUMMIT_APIC_ID_MASK		(0xFF<<24)
 
 static inline unsigned summit_get_apic_id(unsigned long x)
 {
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 9d6374d..5f7f3a9 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1009,11 +1009,11 @@ int __init verify_local_APIC(void)
 	 */
 	reg0 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
-	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
+	apic_write(APIC_ID, reg0 ^ apic->apic_id_mask);
 	reg1 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
 	apic_write(APIC_ID, reg0);
-	if (reg1 != (reg0 ^ APIC_ID_MASK))
+	if (reg1 != (reg0 ^ apic->apic_id_mask))
 		return 0;
 
 	/*
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index ab47091..78baa55 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -352,7 +352,7 @@ struct genapic apic_physflat =  {
 
 	.get_apic_id			= flat_get_apic_id,
 	.set_apic_id			= set_apic_id,
-	.apic_id_mask			= 0xFFu<<24,
+	.apic_id_mask			= 0xFFu << 24,
 
 	.cpu_mask_to_apicid		= physflat_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= physflat_cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 9eca977..1f4ad4f 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -92,7 +92,7 @@ struct genapic apic_bigsmp = {
 
 	.get_apic_id			= bigsmp_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= APIC_ID_MASK,
+	.apic_id_mask			= BIGSMP_APIC_ID_MASK,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index d51a3f0..239af25 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -73,7 +73,7 @@ struct genapic apic_default = {
 
 	.get_apic_id			= default_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= APIC_ID_MASK,
+	.apic_id_mask			= DEFAULT_APIC_ID_MASK,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 1944675..21fb33e 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -128,7 +128,7 @@ struct genapic apic_es7000 = {
 
 	.get_apic_id			= es7000_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= APIC_ID_MASK,
+	.apic_id_mask			= ES7000_APIC_ID_MASK,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index fcbba84..27d2d1f 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -92,7 +92,7 @@ struct genapic apic_numaq = {
 
 	.get_apic_id			= numaq_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= APIC_ID_MASK,
+	.apic_id_mask			= NUMAQ_APIC_ID_MASK,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 5650eaf..f24cba1 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -72,7 +72,7 @@ struct genapic apic_summit = {
 
 	.get_apic_id			= summit_get_apic_id,
 	.set_apic_id			= NULL,
-	.apic_id_mask			= APIC_ID_MASK,
+	.apic_id_mask			= SUMMIT_APIC_ID_MASK,
 
 	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
-- 
1.6.0.2

