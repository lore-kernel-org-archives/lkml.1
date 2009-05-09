Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbZEIAqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbZEIAqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 20:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762122AbZEIApy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 20:45:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55654 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761085AbZEIApx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 20:45:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5 2/7] kprobes: checks probe address is instruction
	boudary on x86
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 08 May 2009 20:48:47 -0400
Message-ID: <20090509004847.5505.37957.stgit@localhost.localdomain>
In-Reply-To: <20090509004829.5505.38720.stgit@localhost.localdomain>
References: <20090509004829.5505.38720.stgit@localhost.localdomain>
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
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/kprobes.c |   54 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7b5169d..3d5e85f 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -48,12 +48,14 @@
 #include <linux/preempt.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
+#include <linux/kallsyms.h>
 
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
+#include <asm/insn.h>
 
 void jprobe_return_end(void);
 
@@ -244,6 +246,56 @@ retry:
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
+	 * Don't use p->ainsn.insn, which could be modified -- e.g.,
+	 * by fix_riprel().
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
+	/* Lookup symbol including addr */
+	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
+		return 0;
+
+	/* Decode instructions */
+	addr = paddr - offset;
+	while (addr < paddr) {
+		insn_init_kernel(&insn, (void *)addr);
+		insn_get_opcode(&insn);
+		if (OPCODE1(&insn) == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf, addr);
+			if (ret)
+				return 0;
+			insn_init_kernel(&insn, buf);
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
@@ -359,6 +411,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 
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
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
