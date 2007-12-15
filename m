Return-Path: <linux-kernel-owner+w=401wt.eu-S933619AbXLOAzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbXLOAzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXLOAzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:55:07 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:52904 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbXLOAzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:55:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vWaBHBA50Iz9rfXeCa8XVjGS1PbHLhyTBoHceWqSw/WKBBs2eW+daj2G1pwnKjWdE1QgseuzysGZn09KbRDDZEV5CAnxulRJPoHPTxoQ5uB7z/t/Gm4N528PX3uA3u+JEi/neUR8swEQfX9ZJNHTxecXOUJVG0VxHDT+zo1rsw0=
Subject: [PATCH] x86: Use helper in kprobes{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 16:55:07 -0800
Message-Id: <1197680107.898.81.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   18 +++++++++++-------
 arch/x86/kernel/kprobes_64.c |   14 ++++++++++++--
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 2a8acd6..878b0c4 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -239,13 +239,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (!p->ainsn.insn)
 		return -ENOMEM;
 
-	memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
-	if (can_boost(p->addr)) {
-		p->ainsn.boostable = 0;
-	} else {
-		p->ainsn.boostable = -1;
-	}
+	arch_copy_kprobe(p);
 	return 0;
 }
 
@@ -303,6 +297,15 @@ static s32 __kprobes *is_riprel(u8 *insn)
 
 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
+#ifdef CONFIG_X86_32
+	memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
+	p->opcode = *p->addr;
+	if (can_boost(p->addr)) {
+		p->ainsn.boostable = 0;
+	} else {
+		p->ainsn.boostable = -1;
+	}
+#else
 	s32 *ripdisp;
 	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
 	ripdisp = is_riprel(p->ainsn.insn);
@@ -325,6 +328,7 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 		*ripdisp = disp;
 	}
 	p->opcode = *p->addr;
+#endif
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 5f02e75..b437f7a 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -245,9 +245,9 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	/* insn: must be on special executable page on x86_32|64. */
 	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn) {
+	if (!p->ainsn.insn)
 		return -ENOMEM;
-	}
+
 	arch_copy_kprobe(p);
 	return 0;
 }
@@ -306,6 +306,15 @@ static s32 __kprobes *is_riprel(u8 *insn)
 
 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
+#ifdef CONFIG_X86_32
+	memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
+	p->opcode = *p->addr;
+	if (can_boost(p->addr)) {
+		p->ainsn.boostable = 0;
+	} else {
+		p->ainsn.boostable = -1;
+	}
+#else
 	s32 *ripdisp;
 	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
 	ripdisp = is_riprel(p->ainsn.insn);
@@ -328,6 +337,7 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 		*ripdisp = disp;
 	}
 	p->opcode = *p->addr;
+#endif
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
-- 
1.5.4.rc0.1083.gf568



