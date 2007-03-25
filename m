Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXCYMS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXCYMS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXCYMS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:18:28 -0400
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:1468 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752808AbXCYMS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:18:27 -0400
Date: Sun, 25 Mar 2007 14:18:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Rudolf Marek <r.marek@assembler.cz>,
       Alexey Dobriyan <adobriyan@openvz.org>, Dave Jones <davej@redhat.com>
Subject: [PATCH 1/2] MSR: Add support for safe variants
Message-Id: <20070325141823.c0e9c4c7.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rudolf Marek <r.marek@assembler.cz>

Add support for _safe (exception handled) variants of rdmsr_on_cpu 
and wrmsr_on_cpu.  This is needed for the upcoming coretemp hardware
monitoring driver, which might step into non-existing (poorly
documented) MSR.

Signed-off-by: Rudolf Marek <r.marek@assembler.cz>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Andrew, can you please pick this patch? I don't want to keep it in my
hwmon tree, as it might useful for others as well.

 arch/i386/lib/msr-on-cpu.c |   71 ++++++++++++++++++++++++++++++++++++++++----
 include/asm-i386/msr.h     |   12 +++++++
 include/asm-x86_64/msr.h   |   11 +++++++
 3 files changed, 87 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc4.orig/arch/i386/lib/msr-on-cpu.c	2007-02-28 09:48:18.000000000 +0100
+++ linux-2.6.21-rc4/arch/i386/lib/msr-on-cpu.c	2007-03-24 20:50:05.000000000 +0100
@@ -6,6 +6,7 @@
 struct msr_info {
 	u32 msr_no;
 	u32 l, h;
+	int err;
 };
 
 static void __rdmsr_on_cpu(void *info)
@@ -15,20 +16,38 @@ static void __rdmsr_on_cpu(void *info)
 	rdmsr(rv->msr_no, rv->l, rv->h);
 }
 
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+static void __rdmsr_safe_on_cpu(void *info)
 {
+	struct msr_info *rv = info;
+
+	rv->err = rdmsr_safe(rv->msr_no, &rv->l, &rv->h);
+}
+
+static int _rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h, int safe)
+{
+	int err = 0;
 	preempt_disable();
 	if (smp_processor_id() == cpu)
-		rdmsr(msr_no, *l, *h);
+		if (safe)
+			err = rdmsr_safe(msr_no, l, h);
+		else
+			rdmsr(msr_no, *l, *h);
 	else {
 		struct msr_info rv;
 
 		rv.msr_no = msr_no;
-		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		if (safe) {
+			smp_call_function_single(cpu, __rdmsr_safe_on_cpu,
+						 &rv, 0, 1);
+			err = rv.err;
+		} else {
+			smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		}
 		*l = rv.l;
 		*h = rv.h;
 	}
 	preempt_enable();
+	return err;
 }
 
 static void __wrmsr_on_cpu(void *info)
@@ -38,21 +57,61 @@ static void __wrmsr_on_cpu(void *info)
 	wrmsr(rv->msr_no, rv->l, rv->h);
 }
 
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+static void __wrmsr_safe_on_cpu(void *info)
 {
+	struct msr_info *rv = info;
+
+	rv->err = wrmsr_safe(rv->msr_no, rv->l, rv->h);
+}
+
+static int _wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h, int safe)
+{
+	int err = 0;
 	preempt_disable();
 	if (smp_processor_id() == cpu)
-		wrmsr(msr_no, l, h);
+		if (safe)
+			err = wrmsr_safe(msr_no, l, h);
+		else
+			wrmsr(msr_no, l, h);
 	else {
 		struct msr_info rv;
 
 		rv.msr_no = msr_no;
 		rv.l = l;
 		rv.h = h;
-		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+		if (safe) {
+			smp_call_function_single(cpu, __wrmsr_safe_on_cpu,
+						 &rv, 0, 1);
+			err = rv.err;
+		} else {
+			smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+		}
 	}
 	preempt_enable();
+	return err;
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	_wrmsr_on_cpu(cpu, msr_no, l, h, 0);
+}
+
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	_rdmsr_on_cpu(cpu, msr_no, l, h, 0);
+}
+
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	return _wrmsr_on_cpu(cpu, msr_no, l, h, 1);
+}
+
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	return _rdmsr_on_cpu(cpu, msr_no, l, h, 1);
 }
 
 EXPORT_SYMBOL(rdmsr_on_cpu);
 EXPORT_SYMBOL(wrmsr_on_cpu);
+EXPORT_SYMBOL(rdmsr_safe_on_cpu);
+EXPORT_SYMBOL(wrmsr_safe_on_cpu);
--- linux-2.6.21-rc4.orig/include/asm-i386/msr.h	2007-02-28 09:48:21.000000000 +0100
+++ linux-2.6.21-rc4/include/asm-i386/msr.h	2007-03-24 20:50:05.000000000 +0100
@@ -4,7 +4,7 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-
+#include <linux/errno.h>
 /*
  * Access to machine-specific registers (available on 586 and better only)
  * Note: the rd* operations modify the parameters directly (without using
@@ -86,6 +86,8 @@ static inline void wrmsrl (unsigned long
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
 static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 {
@@ -95,6 +97,14 @@ static inline void wrmsr_on_cpu(unsigned
 {
 	wrmsr(msr_no, l, h);
 }
+static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	return rdmsr_safe(msr_no, l, h);
+}
+static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	return wrmsr_safe(msr_no, l, h);
+}
 #endif  /*  CONFIG_SMP  */
 
 /* symbolic names for some interesting MSRs */
--- linux-2.6.21-rc4.orig/include/asm-x86_64/msr.h	2007-02-28 09:48:21.000000000 +0100
+++ linux-2.6.21-rc4/include/asm-x86_64/msr.h	2007-03-24 20:50:05.000000000 +0100
@@ -2,6 +2,7 @@
 #define X86_64_MSR_H 1
 
 #ifndef __ASSEMBLY__
+#include <linux/errno.h>
 /*
  * Access to machine-specific registers (available on 586 and better only)
  * Note: the rd* operations modify the parameters directly (without using
@@ -163,6 +164,8 @@ static inline unsigned int cpuid_edx(uns
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
 static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 {
@@ -172,6 +175,14 @@ static inline void wrmsr_on_cpu(unsigned
 {
 	wrmsr(msr_no, l, h);
 }
+static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	return rdmsr_safe(msr_no, l, h);
+}
+static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	return wrmsr_safe(msr_no, l, h);
+}
 #endif  /*  CONFIG_SMP  */
 
 #endif


-- 
Jean Delvare
