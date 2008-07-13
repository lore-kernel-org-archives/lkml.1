Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYGMF5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYGMF5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 01:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYGMF5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 01:57:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:22724 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYGMF5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 01:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=vToL6OetzAibWwvEKjrh1Kpi1wllqLkHkXIWPMVtpg6dMriKYSGrNG/g7amTMNEsd/
         SPpl9ZXCZ0RAI/581OjPBWQB/uhT/lUhUeozceN0XuUSgndQ34D3WRIa12QkljJJ6dNb
         rq7If9ej15zzXKBUi+0lt8kKbBhb5KCOUGfCo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix numaq_tsc_disable calling
Date: Sat, 12 Jul 2008 22:52:55 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807122252.55436.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


got
calling  numaq_tsc_disable+0x0/0x39
NUMAQ: disabling TSC
initcall numaq_tsc_disable+0x0/0x39 returned 0 after 0 msecs

we can not use arch_initcall to call it.

need to call it in setup_arch before time_init()/tsc_init()
and call it init_intel to make cpu feature right.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/intel.c |    4 ++++
 arch/x86/kernel/numaq_32.c  |    7 ++++---
 arch/x86/kernel/setup.c     |    8 ++++++++
 include/asm-x86/numaq.h     |    2 ++
 4 files changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -227,6 +227,10 @@ static void __cpuinit init_intel(struct
 
 	if (cpu_has_bts)
 		ptrace_bts_init_intel(c);
+
+#ifdef CONFIG_X86_NUMAQ
+	numaq_tsc_disable();
+#endif
 }
 
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -93,12 +93,13 @@ int __init get_memcfg_numaq(void)
 	return 1;
 }
 
-static int __init numaq_tsc_disable(void)
+void __init numaq_tsc_disable(void)
 {
+	if (!found_numaq)
+		return -1;
+
 	if (num_online_nodes() > 1) {
 		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
 		setup_clear_cpu_cap(X86_FEATURE_TSC);
 	}
-	return 0;
 }
-arch_initcall(numaq_tsc_disable);
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -859,6 +859,14 @@ void __init setup_arch(char **cmdline_p)
 	init_cpu_to_node();
 #endif
 
+#ifdef CONFIG_X86_NUMAQ
+	/*
+	 * need to check online nodes num, call it
+	 * here before time_init/tsc_init
+	 */
+	numaq_tsc_disable();
+#endif
+
 	init_apic_mappings();
 	ioapic_init_mappings();
 
Index: linux-2.6/include/asm-x86/numaq.h
===================================================================
--- linux-2.6.orig/include/asm-x86/numaq.h
+++ linux-2.6/include/asm-x86/numaq.h
@@ -157,6 +157,8 @@ struct sys_cfg_data {
 	struct		eachquadmem eq[MAX_NUMNODES];	/* indexed by quad id */
 };
 
+void numaq_tsc_disable(void);
+
 #else
 static inline int get_memcfg_numaq(void)
 {
