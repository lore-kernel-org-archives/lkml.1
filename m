Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZGIUUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZGIUUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZGIUT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:19:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41266 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbZGIUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:19:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip -v11 03/11] kprobes: checks probe address is instruction
	boudary on x86
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 09 Jul 2009 16:22:41 -0400
Message-ID: <20090709202241.13223.11317.stgit@localhost.localdomain>
In-Reply-To: <20090709202220.13223.97114.stgit@localhost.localdomain>
References: <20090709202220.13223.97114.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure safeness of inserting kprobes by checking whether the specified
address is at the first byte of a instruction on x86.
This is done by decoding probed function from its head to the probe point.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/kprobes.c |   69 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b5b1848..5341842 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -48,6 +48,7 @@
 #include <linux/preempt.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
+#include <linux/kallsyms.h>
 
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
@@ -55,6 +56,7 @@
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
 #include <asm/debugreg.h>
+#include <asm/insn.h>
 
 void jprobe_return_end(void);
 
@@ -245,6 +247,71 @@ retry:
 	}
 }
 
+/* Recover the probed instruction at addr for further analysis. */
+static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
+{
+	struct kprobe *kp;
+	kp = get_kprobe((void *)addr);
+	if (!kp)
+		return -EINVAL;
+
+	/*
+	 *  Basically, kp->ainsn.insn has an original instruction.
+	 *  However, RIP-relative instruction can not do single-stepping
+	 *  at different place, fix_riprel() tweaks the displacement of
+	 *  that instruction. In that case, we can't recover the instruction
+	 *  from the kp->ainsn.insn.
+	 *
+	 *  On the other hand, kp->opcode has a copy of the first byte of
+	 *  the probed instruction, which is overwritten by int3. And
+	 *  the instruction at kp->addr is not modified by kprobes except
+	 *  for the first byte, we can recover the original instruction
+	 *  from it and kp->opcode.
+	 */
+	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	buf[0] = kp->opcode;
+	return 0;
+}
+
+/* Dummy buffers for kallsyms_lookup */
+static char __dummy_buf[KSYM_NAME_LEN];
+
+/* Check if paddr is at an instruction boundary */
+static int __kprobes can_probe(unsigned long paddr)
+{
+	int ret;
+	unsigned long addr, offset = 0;
+	struct insn insn;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+
+	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
+		return 0;
+
+	/* Decode instructions */
+	addr = paddr - offset;
+	while (addr < paddr) {
+		kernel_insn_init(&insn, (void *)addr);
+		insn_get_opcode(&insn);
+
+		/* Check if the instruction has been modified. */
+		if (OPCODE1(&insn) == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf, addr);
+			if (ret)
+				/*
+				 * Another debugging subsystem might insert
+				 * this breakpoint. In that case, we can't
+				 * recover it.
+				 */
+				return 0;
+			kernel_insn_init(&insn, buf);
+		}
+		insn_get_length(&insn);
+		addr += insn.length;
+	}
+
+	return (addr == paddr);
+}
+
 /*
  * Returns non-zero if opcode modifies the interrupt flag.
  */
@@ -360,6 +427,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
+	if (!can_probe((unsigned long)p->addr))
+		return -EILSEQ;
 	/* insn: must be on special executable page on x86. */
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
