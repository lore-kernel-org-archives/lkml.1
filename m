Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXD3Kaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXD3Kaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbXD3K2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:51228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965254AbXD3K2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:01 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, rusty@rustcorp.com.au, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [26/40] i386: cleanups to help using per-cpu variables from asm
Message-Id: <20070430102800.923D4151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
This patch does a few small cleanups:
 - use PER_CPU_NAME to generate the names of per-cpu variables
 - use lea to add the per_cpu offset in PER_CPU(), because it doesn't
   affect condition flags
 - add PER_CPU_VAR which allows direct access to pre-cpu variables
   with the %fs: prefix on SMP.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>

---
 include/asm-i386/percpu.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

===================================================================
Index: linux/include/asm-i386/percpu.h
===================================================================
--- linux.orig/include/asm-i386/percpu.h
+++ linux/include/asm-i386/percpu.h
@@ -16,12 +16,14 @@
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-#define PER_CPU(var, reg)			\
-	movl %fs:per_cpu__this_cpu_off, reg;		\
-	addl $per_cpu__##var, reg
+#define PER_CPU(var, reg)				\
+	movl %fs:per_cpu__##this_cpu_off, reg;		\
+	lea per_cpu__##var(reg), reg
+#define PER_CPU_VAR(var)	%fs:per_cpu__##var
 #else /* ! SMP */
-#define PER_CPU(var, reg) \
-	movl $per_cpu__##var, reg;
+#define PER_CPU(var, reg)			\
+	movl $per_cpu__##var, reg
+#define PER_CPU_VAR(var)	per_cpu__##var
 #endif	/* SMP */
 
 #else /* ...!ASSEMBLY */
