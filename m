Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZITSaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZITSaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZITSae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:30:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:52192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbZITSa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:30:29 -0400
Date: Sun, 20 Sep 2009 18:29:51 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AA0E8F60200007800013703@vpn.id2.novell.com>
References: <4AA0E8F60200007800013703@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: cpuinit-annotate SMP boot trampolines properly
Message-ID: <tip-5f68563996e812f9ca35b3939ad2a42e5d254d66@git.kernel.org>
Git-Commit-ID: 5f68563996e812f9ca35b3939ad2a42e5d254d66
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:29:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f68563996e812f9ca35b3939ad2a42e5d254d66
Gitweb:     http://git.kernel.org/tip/5f68563996e812f9ca35b3939ad2a42e5d254d66
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 4 Sep 2009 09:16:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:23:37 +0200

x86: cpuinit-annotate SMP boot trampolines properly

Add missing annotations, and make use of include/linux/init.h's
macros.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4AA0E8F60200007800013703@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/trampoline.c    |    4 ++--
 arch/x86/kernel/trampoline_32.S |    8 ++------
 arch/x86/kernel/trampoline_64.S |    5 +++--
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index 808031a..699f7ee 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -4,7 +4,7 @@
 #include <asm/e820.h>
 
 /* ready for x86_64 and x86 */
-unsigned char *trampoline_base = __va(TRAMPOLINE_BASE);
+unsigned char *__cpuinitdata trampoline_base = __va(TRAMPOLINE_BASE);
 
 void __init reserve_trampoline_memory(void)
 {
@@ -26,7 +26,7 @@ void __init reserve_trampoline_memory(void)
  * bootstrap into the page concerned. The caller
  * has made sure it's suitably aligned.
  */
-unsigned long setup_trampoline(void)
+unsigned long __cpuinit setup_trampoline(void)
 {
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
 	return virt_to_phys(trampoline_base);
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 66d874e..8508237 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -28,16 +28,12 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
-#ifndef CONFIG_HOTPLUG_CPU
-.section ".cpuinit.data","aw",@progbits
-#else
-.section .rodata,"a",@progbits
-#endif
-
+__CPUINITRODATA
 .code16
 
 ENTRY(trampoline_data)
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index cddfb8d..596d54c 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -25,14 +25,15 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/pgtable_types.h>
 #include <asm/page_types.h>
 #include <asm/msr.h>
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
 
-.section .rodata, "a", @progbits
-
+/* We can free up the trampoline after bootup if cpu hotplug is not supported. */
+__CPUINITRODATA
 .code16
 
 ENTRY(trampoline_data)
