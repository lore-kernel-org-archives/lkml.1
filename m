Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZCNLlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZCNLlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbZCNLlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:41:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:40168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052AbZCNLlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:41:05 -0400
Date: Sat, 14 Mar 2009 11:39:32 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49BAB7FF.4030107@kernel.org>
References: <49BAB7FF.4030107@kernel.org>
Subject: [tip:x86/mtrr] x86: fix get_mtrr() warning about smp_processor_id() with CONFIG_PREEMPT=y
Message-ID: <tip-63516ef6d6a8379ee5c32463efc6a75f9da8a309@git.kernel.org>
Git-Commit-ID: 63516ef6d6a8379ee5c32463efc6a75f9da8a309
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 11:39:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63516ef6d6a8379ee5c32463efc6a75f9da8a309
Gitweb:     http://git.kernel.org/tip/63516ef6d6a8379ee5c32463efc6a75f9da8a309
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 13 Mar 2009 12:46:07 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 12:27:06 +0100

x86: fix get_mtrr() warning about smp_processor_id() with CONFIG_PREEMPT=y

Impact: fix debug warning

Jaswinder noticed that there is a warning about smp_processor_id()
in get_mtrr().

Fix it by wrapping the printout into a get/put_cpu() pair.

Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49BAB7FF.4030107@kernel.org>
[ changed to get/put_cpu(), cleaned up surrounding code a it. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/generic.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 950c434..641ee35 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -381,11 +381,14 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 {
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
 	unsigned int tmp, hi;
+	int cpu;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
 	 * from any cpu, so try to print it out directly.
 	 */
+	cpu = get_cpu();
+
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 
 	if ((mask_lo & 0x800) == 0) {
@@ -393,15 +396,16 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		*base = 0;
 		*size = 0;
 		*type = 0;
-		return;
+		goto out_put_cpu;
 	}
 
 	rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
 
-	/* Work out the shifted address mask. */
+	/* Work out the shifted address mask: */
 	tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
 	mask_lo = size_or_mask | tmp;
-	/* Expand tmp with high bits to all 1s*/
+
+	/* Expand tmp with high bits to all 1s: */
 	hi = fls(tmp);
 	if (hi > 0) {
 		tmp |= ~((1<<(hi - 1)) - 1);
@@ -412,15 +416,19 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		}
 	}
 
-	/* This works correctly if size is a power of two, i.e. a
-	   contiguous range. */
+	/*
+	 * This works correctly if size is a power of two, i.e. a
+	 * contiguous range:
+	 */
 	*size = -mask_lo;
 	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
 	*type = base_lo & 0xff;
 
 	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
-			smp_processor_id(), reg, *base, *size,
+			cpu, reg, *base, *size,
 			mtrr_attrib_to_str(*type & 0xff));
+out_put_cpu:
+	put_cpu();
 }
 
 /**
