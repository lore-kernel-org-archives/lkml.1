Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYAUW6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYAUW6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYAUW5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:57:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:20454 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYAUW5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oBforxIukajoQpWWUDu4pYB1yqYSO1Gp72KRuci5LND8p6N+xflsByyyfCY1NrafMi8LfSUKSpcfD60lvzoi2dPqs6Akz882UAO/qrnGl/15yzuhuaG5EZz+GMzJyGq0Kt6YD3dbL1GiEhVrkFkXXNkEkwnlqJdLEK3snJqh9r4=
Subject: [PATCH 1/3] x86: make printk_address available on X86_32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 14:57:55 -0800
Message-Id: <1200956275.16972.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small fomatting fixes to 64-bit as well, trailing whitespace
and extra semicolon, also move the ifdefs for CONFIG_KALLSYMS
into the function itself.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Replacements for the 2-patch series I sent earlier.

 arch/x86/kernel/traps_32.c |   28 ++++++++++++++++++++++++++++
 arch/x86/kernel/traps_64.c |   11 ++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index e0a7615..0ec7621 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -102,6 +102,34 @@ asmlinkage void machine_check(void);
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
 
+void printk_address(unsigned long address, int reliable)
+{
+#ifdef CONFIG_KALLSYMS
+	unsigned long offset = 0, symsize;
+	const char *symname;
+	char *modname;
+	char *delim = ":";
+	char namebuf[128];
+	char reliab[4] = "";
+
+	symname = kallsyms_lookup(address, &symsize, &offset,
+					&modname, namebuf);
+	if (!symname) {
+		printk(" [<%08lx>]\n", address);
+		return;
+	}
+	if (!reliable)
+		strcpy(reliab, "? ");
+
+	if (!modname)
+		modname = delim = "";
+	printk(" [<%08lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
+		address, reliab, delim, modname, delim, symname, offset, symsize);
+#else
+	printk(" [<%08lx>]\n", address);
+#endif
+}
+
 static inline int valid_stack_ptr(struct thread_info *tinfo, void *p, unsigned size)
 {
 	return	p > (void *)tinfo &&
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 2289f80..1dd5b48 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -100,15 +100,15 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 
 int kstack_depth_to_print = 12;
 
-#ifdef CONFIG_KALLSYMS
 void printk_address(unsigned long address, int reliable)
 {
+#ifdef CONFIG_KALLSYMS
 	unsigned long offset = 0, symsize;
 	const char *symname;
 	char *modname;
 	char *delim = ":";
 	char namebuf[128];
-	char reliab[4] = "";;
+	char reliab[4] = "";
 
 	symname = kallsyms_lookup(address, &symsize, &offset,
 					&modname, namebuf);
@@ -120,16 +120,13 @@ void printk_address(unsigned long address, int reliable)
 		strcpy(reliab, "? ");
 
 	if (!modname)
-		modname = delim = ""; 		
+		modname = delim = "";
 	printk(" [<%016lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
 		address, reliab, delim, modname, delim, symname, offset, symsize);
-}
 #else
-void printk_address(unsigned long address, int reliable)
-{
 	printk(" [<%016lx>]\n", address);
-}
 #endif
+}
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 					unsigned *usedp, char **idp)
-- 
1.5.4.rc3.1118.gf6754c


