Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYJDVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYJDVRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYJDVRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:17:06 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:4811 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbYJDVRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:17:05 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumpstack: x86: make printk_address equal
Date: Sat,  4 Oct 2008 23:12:41 +0200
Message-Id: <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:16:49 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - x86_64: use %p to print an address
 - make i386-version the same as the above

The result should be the same on x86_64; on i386 the
output only changes if CONFIG_KALLSYMS is turned off,
in which case the address is printed twice.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   27 ++-------------------------
 arch/x86/kernel/dumpstack_64.c |    4 ++--
 2 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index fd9b439..62f71c8 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -23,31 +23,8 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-#ifdef CONFIG_KALLSYMS
-	unsigned long offset = 0;
-	unsigned long symsize;
-	const char *symname;
-	char *modname;
-	char *delim = ":";
-	char namebuf[KSYM_NAME_LEN];
-	char reliab[4] = "";
-
-	symname = kallsyms_lookup(address, &symsize, &offset,
-					&modname, namebuf);
-	if (!symname) {
-		printk(" [<%08lx>]\n", address);
-		return;
-	}
-	if (!reliable)
-		strcpy(reliab, "? ");
-
-	if (!modname)
-		modname = delim = "";
-	printk(" [<%08lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
-		address, reliab, delim, modname, delim, symname, offset, symsize);
-#else
-	printk(" [<%08lx>]\n", address);
-#endif
+	printk(" [<%p>] %s%pS\n", (void *) address,
+			reliable ? "" : "? ", (void *) address);
 }
 
 static inline int valid_stack_ptr(struct thread_info *tinfo,
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 11f22d2..f215f1c 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -23,8 +23,8 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%016lx>] %s%pS\n",
-			address, reliable ?	"" : "? ", (void *) address);
+	printk(" [<%p>] %s%pS\n", (void *) address,
+			reliable ? "" : "? ", (void *) address);
 }
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-- 
1.5.4.3

