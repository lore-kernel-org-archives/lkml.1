Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbXCSV4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbXCSV4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030586AbXCSV4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:56:00 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:46765 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXCSVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:55:59 -0400
Message-ID: <45FF06D1.3040405@cosmosbay.com>
Date: Mon, 19 Mar 2007 22:55:29 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] x86_64 : Suppress __jiffies
References: <20070318193030.GB71548@muc.de> <200703191157.29780.ak@suse.de> <20070319.120854.30182994.davem@davemloft.net> <200703192159.42396.ak@suse.de>
In-Reply-To: <200703192159.42396.ak@suse.de>
Content-Type: multipart/mixed;
 boundary="------------040202000105070103020803"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 19 Mar 2007 22:55:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040202000105070103020803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andi

I was considering re-submiting patch to group together 
xtime_lock/xtime/jiffies in the same cache line. Before doing so, I believe 
the following cleanup patch could prepare the x86_64 port to be similar with 
other arches.

Thank you

[PATCH] x86_64 : Suppress __jiffies

x86_64 arch currently specially defines __jiffies, as a relic of old vsyscall 
implementation. It is currently used to validate vgetcpu() user cache as a 
token. If we use another token, more opaque like the seqlock sequence, we can 
get rid of special __jiffies handling. As a result, jiffies_64 is no more 
included in vsyscall page. This patch prepares the introduction of time_data.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------040202000105070103020803
Content-Type: text/plain;
 name="no__jiffies.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="no__jiffies.patch"

diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index b43c698..ac4d865 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -62,6 +62,14 @@ struct vsyscall_gtod_data_t __vsyscall_g
 	.sysctl_enabled = 1,
 };
 
+/*
+ * vgetcpu_token is an opaque token used to validate vgetcpu() user cache.
+ * We need something that change like jiffies. It used to be jiffies
+ * but using seqlock __vsyscall_gtod_data.lock sequence is better because
+ * we prefer not let user read jiffies.
+ */
+#define vgetcpu_token() read_seqbegin(&__vsyscall_gtod_data.lock)
+
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
 	unsigned long flags;
@@ -180,7 +188,7 @@ vgetcpu(unsigned *cpu, unsigned *node, s
 	   We do this here because otherwise user space would do it on
 	   its own in a likely inferior way (no access to jiffies).
 	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] == (j = __jiffies)) {
+	if (tcache && tcache->blob[0] == (j = vgetcpu_token())) {
 		p = tcache->blob[1];
 	} else if (__vgetcpu_mode == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 75d73a9..5a44c11 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -53,7 +53,6 @@ DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 DEFINE_SPINLOCK(i8253_lock);
 
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
 unsigned long profile_pc(struct pt_regs *regs)
 {
diff --git a/arch/x86_64/kernel/vmlinux.lds.S b/arch/x86_64/kernel/vmlinux.lds.S
index b73212c..6ca4660 100644
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -12,7 +12,7 @@ #undef i386	/* in case the preprocessor 
 OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
+jiffies = jiffies_64;
 _proxy_pda = 0;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
@@ -97,10 +97,6 @@ #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET
   .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
   vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
-  jiffies = VVIRT(.jiffies);
-
   .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
 		{ *(.vsyscall_1) }
   .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
diff --git a/include/asm-x86_64/vsyscall.h b/include/asm-x86_64/vsyscall.h
index 82b4afe..1fb09dc 100644
--- a/include/asm-x86_64/vsyscall.h
+++ b/include/asm-x86_64/vsyscall.h
@@ -17,7 +17,6 @@ #ifdef __KERNEL__
 #include <linux/seqlock.h>
 
 #define __section_vgetcpu_mode __attribute__ ((unused, __section__ (".vgetcpu_mode"), aligned(16)))
-#define __section_jiffies __attribute__ ((unused, __section__ (".jiffies"), aligned(16)))
 
 /* Definitions for CONFIG_GENERIC_TIME definitions */
 #define __section_vsyscall_gtod_data __attribute__ \
@@ -31,7 +30,6 @@ #define hpet_readl(a)           readl((c
 #define hpet_writel(d,a)        writel(d, (void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
 
 extern int __vgetcpu_mode;
-extern volatile unsigned long __jiffies;
 
 /* kernel space (writeable) */
 extern int vgetcpu_mode;

--------------040202000105070103020803--
