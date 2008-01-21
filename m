Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbYAUVUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbYAUVUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYAUVUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:20:41 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:6708 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbYAUVUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:20:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MwpmjDWbYxZMI3/aS7NNojbzGeS1KPwlb2/h7NVnx1PsWhmx8x2T4zbNEtxI3a4wC7Ihi410eYFyiaM9URNwW7UxaTc9TdWGBbbOtQLSQ9Rb7thNarTlVNyQgR9r2cpG0HvgoWyYJ4W1akE6/ITKX37IUGJGlu2DwHWo//QWmpY=
Subject: [PATCH 2/2] [RFC] x86: Make page fault oopses similar
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 13:20:46 -0800
Message-Id: <1200950446.16972.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce printk_address to X86_32 in a simplified form for
now.  Reformat X86_64 printk_address to avoid two declarations.

Change the printk formats on X86_32 and 64 to be similar.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, this changes oops printing format, consider this just to
get the discussion started on how people would like this to
look.

 arch/x86/kernel/traps_32.c |    5 +++++
 arch/x86/kernel/traps_64.c |    7 ++-----
 arch/x86/mm/fault_32.c     |   13 +++++++------
 arch/x86/mm/fault_64.c     |    9 ++++++---
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index e0a7615..9edad42 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -102,6 +102,11 @@ asmlinkage void machine_check(void);
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
 
+void printk_address(unsigned long address, int reliable)
+{
+	printk(" [<%08lx>]\n", address);
+}
+
 static inline int valid_stack_ptr(struct thread_info *tinfo, void *p, unsigned size)
 {
 	return	p > (void *)tinfo &&
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 2289f80..a462e2f 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -100,9 +100,9 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 
 int kstack_depth_to_print = 12;
 
-#ifdef CONFIG_KALLSYMS
 void printk_address(unsigned long address, int reliable)
 {
+#ifdef CONFIG_KALLSYMS
 	unsigned long offset = 0, symsize;
 	const char *symname;
 	char *modname;
@@ -123,13 +123,10 @@ void printk_address(unsigned long address, int reliable)
 		modname = delim = ""; 		
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
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index fda3997..93259f3 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -340,14 +340,15 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 				"(uid: %d)\n", current->uid);
 	}
 #endif
+	printk(KERN_ALERT "BUG: unable to handle kernel ");
 	if (address < PAGE_SIZE)
-		printk(KERN_ALERT "BUG: unable to handle kernel NULL "
-				"pointer dereference");
+		printk(KERN_CONT "NULL pointer dereference");
 	else
-		printk(KERN_ALERT "BUG: unable to handle kernel paging"
-				" request");
-	printk(" at virtual address %08lx\n", address);
-	printk(KERN_ALERT "printing ip: %08lx ", regs->ip);
+		printk(KERN_CONT "paging request");
+
+	printk(KERN_CONT " at %08lx\n", address);
+	printk(KERN_ALERT "IP:");
+	printk_address(regs->ip, 1);
 
 	dump_pagetable(address);
 }
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 1897704..97e6bb6 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -296,11 +296,14 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 			    unsigned long address)
 {
+	printk(KERN_ALERT "Unable to handle kernel ");
 	if (address < PAGE_SIZE)
-		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
+		printk(KERN_CONT "NULL pointer dereference");
 	else
-		printk(KERN_ALERT "Unable to handle kernel paging request");
-	printk(" at %016lx RIP: \n" KERN_ALERT, address);
+		printk(KERN_CONT "paging request");
+	printk(KERN_CONT " at %016lx\n", address);
+	printk(KERN_ALERT "IP:");
+
 	printk_address(regs->ip, 1);
 	dump_pagetable(address);
 }
-- 
1.5.4.rc3.1118.gf6754c

