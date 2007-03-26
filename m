Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXCZL36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXCZL36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXCZL36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:29:58 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:1069 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbXCZL35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:29:57 -0400
Date: Mon, 26 Mar 2007 13:29:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rudolf Marek <r.marek@assembler.cz>,
       Alexey Dobriyan <adobriyan@openvz.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] MSR: Add support for safe variants
Message-Id: <20070326132937.7d518c08.khali@linux-fr.org>
In-Reply-To: <20070325142215.eff3af8f.akpm@linux-foundation.org>
References: <20070325141823.c0e9c4c7.khali@linux-fr.org>
	<20070325142215.eff3af8f.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sun, 25 Mar 2007 14:22:15 -0800, Andrew Morton wrote:
> On Sun, 25 Mar 2007 14:18:23 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Add support for _safe (exception handled) variants of rdmsr_on_cpu 
> > and wrmsr_on_cpu.  This is needed for the upcoming coretemp hardware
> > monitoring driver, which might step into non-existing (poorly
> > documented) MSR.
> 
> Crappy changelog.  What do these functions do?  What is "safe" about them? 
> This is described in neither the changelog nor the code comments, but it
> should be described in both.

This is needed when you attempt to access an MSR which might not
actually exist. Exactly what the changelog says... The core safe msr
functions (in include/asm/msr.h) also have a comment that says: "with
exception handling".

So I don't think this is as crappy as you say. But I still updated the
changelog and added a comment in the code, hope you like it better this
way.

> Also, Andi presently has several MSR patches queued (most prominently
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/patches/rwmsr-on-cpu)
> but I'm not including them in -mm due to rejects.  If I get a properly
> changlogged and commented version of this patch I can merge it, but it
> might get wrecked again when the x86_64 tree gets sorted out.

That patch you point me to is _already_ in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b077ffb3b767c3efb44d00b998385a9cb127255c
So I'm not suprised you get rejects... Andi seemingly didn't update his
tree for over a month now.

The patch from Rudolf Marek which I am posting here builds on top of
what is already in Linus' tree. Taking it in your tree should not cause
any problem.

Thanks.

* * * * * Updated patch * * * * *

From: Rudolf Marek <r.marek@assembler.cz>

Add safe (exception handled) variants of rdmsr_on_cpu and wrmsr_on_cpu.
You should use these when the target MSR may not actually exist, as
doing so could trigger an exception which the regular functions do not
handle. The safe variants are slower, though.

The upcoming coretemp hardware monitoring driver will need this.

Signed-off-by: Rudolf Marek <r.marek@assembler.cz>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 arch/i386/lib/msr-on-cpu.c |   73 ++++++++++++++++++++++++++++++++++++++++----
 include/asm-i386/msr.h     |   12 +++++++
 include/asm-x86_64/msr.h   |   11 +++++++
 3 files changed, 89 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc4.orig/arch/i386/lib/msr-on-cpu.c	2007-03-25 14:31:37.000000000 +0200
+++ linux-2.6.21-rc4/arch/i386/lib/msr-on-cpu.c	2007-03-26 13:11:26.000000000 +0200
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
@@ -38,21 +57,63 @@ static void __wrmsr_on_cpu(void *info)
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
+/* These "safe" variants are slower and should be used when the target MSR
+   may not actually exist. */
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
--- linux-2.6.21-rc4.orig/include/asm-i386/msr.h	2007-03-25 14:31:37.000000000 +0200
+++ linux-2.6.21-rc4/include/asm-i386/msr.h	2007-03-26 07:52:18.000000000 +0200
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
--- linux-2.6.21-rc4.orig/include/asm-x86_64/msr.h	2007-03-25 14:31:37.000000000 +0200
+++ linux-2.6.21-rc4/include/asm-x86_64/msr.h	2007-03-26 07:52:19.000000000 +0200
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
