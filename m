Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbYHRKdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbYHRKdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYHRKdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:33:32 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:41828 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYHRKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:33:29 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       michael@free-electrons.com, thomas.petazzoni@free-electrons.com
Subject: [PATCH] [x86] Make movsl_mask definition non-CPU specific
Date: Mon, 18 Aug 2008 12:33:20 +0200
Message-Id: <1219055602-8046-1-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
In-Reply-To: <20080815143843.GA519@elte.hu>
References: <20080815143843.GA519@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

movsl_mask is currently defined in arch/x86/kernel/cpu/intel.c, which
contains code specific to Intel CPUs. However, movsl_mask is used in
the non-CPU specific code in arch/x86/lib/usercopy_32.c, which breaks
the compilation when support for Intel CPUs is compiled out.

This patch solves this problem by moving movsl_mask's definition close
to its users in arch/x86/lib/usercopy_32.c.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 arch/x86/kernel/cpu/intel.c |    7 -------
 arch/x86/lib/usercopy_32.c  |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index b75f256..5c8959b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -23,13 +23,6 @@
 #include <mach_apic.h>
 #endif
 
-#ifdef CONFIG_X86_INTEL_USERCOPY
-/*
- * Alignment at which movsl is preferred for bulk memory copies.
- */
-struct movsl_mask movsl_mask __read_mostly;
-#endif
-
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 24e6094..9e68075 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -14,6 +14,13 @@
 #include <asm/uaccess.h>
 #include <asm/mmx.h>
 
+#ifdef CONFIG_X86_INTEL_USERCOPY
+/*
+ * Alignment at which movsl is preferred for bulk memory copies.
+ */
+struct movsl_mask movsl_mask __read_mostly;
+#endif
+
 static inline int __movsl_is_ok(unsigned long a1, unsigned long a2, unsigned long n)
 {
 #ifdef CONFIG_X86_INTEL_USERCOPY
-- 
1.5.4.3

