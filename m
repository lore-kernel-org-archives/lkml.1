Return-Path: <linux-kernel-owner+w=401wt.eu-S935056AbXLNWmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056AbXLNWmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934437AbXLNWip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:38:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32351 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934770AbXLNWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k+0N7gRf4xiDUyYFHMNzxK/fmP0pIVC37O0nGMC0d4kUIVIQd8PeieWpiKnfY1EUXE4dnhAn081vGeZZVKxQSe7jxwEBNpVY28snieyuVOYxT7rQl4em/fJYNZWMTEjrotEskJ/PiikydZZjpwyj2QnKT1W4t+fam27CtgscML4=
Subject: [PATCH] x86: Add temporary ifdefs to kprobes_{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 14:38:48 -0800
Message-Id: <1197671928.898.69.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep reducing the diff size moving code around.  This will get
cleaner in the final unified file.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   15 +++++++++++++++
 arch/x86/kernel/kprobes_64.c |   17 ++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index cebc077..f4ba584 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -915,12 +915,27 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+#ifdef CONFIG_X86_64
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+#endif
+
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
+#ifdef CONFIG_X86_64
+	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
+		return 1;
+#endif
 	return 0;
 }
 
 int __init arch_init_kprobes(void)
 {
+#ifdef CONFIG_X86_32
 	return 0;
+#else
+	return register_kprobe(&trampoline_p);
+#endif
 }
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 6f62a4a..13a92ef 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -869,20 +869,27 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+#ifdef CONFIG_X86_64
 static struct kprobe trampoline_p = {
 	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
 	.pre_handler = trampoline_probe_handler
 };
-
-int __init arch_init_kprobes(void)
-{
-	return register_kprobe(&trampoline_p);
-}
+#endif
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
+#ifdef CONFIG_X86_64
 	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
 		return 1;
+#endif
+	return 0;
+}
 
+int __init arch_init_kprobes(void)
+{
+#ifdef CONFIG_X86_32
 	return 0;
+#else
+	return register_kprobe(&trampoline_p);
+#endif
 }
-- 
1.5.4.rc0.1083.gf568



