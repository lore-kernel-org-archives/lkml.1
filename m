Return-Path: <linux-kernel-owner+w=401wt.eu-S934480AbZDBR0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480AbZDBR0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764126AbZDBRYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:24:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764524AbZDBRYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:24:37 -0400
Message-ID: <49D4F4E9.2030809@redhat.com>
Date: Thu, 02 Apr 2009 13:24:57 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>, kvm@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -tip 4/6 V4] x86: kprobes checks safeness of insertion address.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure safeness of inserting kprobes by checking whether the specified
address is at the first byte of a instruction. This is done by decoding
probed function from its head to the probe point.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/kprobes.c |   51 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7b5169d..39c79cc 100644
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

@@ -244,6 +246,53 @@ retry:
 	}
 }

+/* Recover original instruction */
+static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
+{
+	struct kprobe *kp;
+	kp = get_kprobe((void *)addr);
+	if (!kp)
+		return -EINVAL;
+
+	/* Don't use p->ainsn.insn; which will be modified by fix_riprel */
+	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	buf[0] = kp->opcode;
+	return 0;
+}
+
+/* Dummy buffers for lookup_symbol_attrs */
+static char __dummy_buf[KSYM_NAME_LEN];
+
+/* Check whether the address can be probed */
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
@@ -359,6 +408,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)

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

