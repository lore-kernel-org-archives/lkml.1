Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZDFVn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZDFVn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbZDFVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:43:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbZDFVnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:43:14 -0400
Message-ID: <49DA7791.7030603@redhat.com>
Date: Mon, 06 Apr 2009 17:43:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>
Subject: [RFC][PROTO][PATCH -tip 7/7] kprobes: x86: check specified probe
 can be optimized
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce can_optimize() function for ensuring that user specified probe
address can be jump optimized by decoding instructions.
This function decodes whole of a function in which probe is inserted, and
checks following condition:
 - There is no indirect jump instruction, because it will jumps into
   the address range which is replaced by jump oprand.
 - There is no jump/loop instruction which jumps into the address range
   which is replaced by jump oprand.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 arch/x86/kernel/kprobes.c |   75 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 5635e02..1386e34 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1253,6 +1253,78 @@ static int __kprobes prepare_copied_insn(u8 *buf, struct optimized_kprobe *op)
 	return len;
 }

+/* Dummy buffers for lookup_symbol_attrs */
+static char __dummy_buf[KSYM_NAME_LEN];
+
+/* Check whether insn is indirect jump */
+static int insn_is_indirect_jump(struct insn *insn)
+{
+	return (OPCODE1(insn) == 0xff || OPCODE1(insn) == 0xea);
+}
+
+/* Check whether insn jumps into specified address range */
+static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
+{
+	unsigned long target = 0;
+	switch (OPCODE1(insn)) {
+	case 0xe0:	/* loopne */
+	case 0xe1:	/* loope */
+	case 0xe2:	/* loop */
+	case 0xe3:	/* jcxz */
+	case 0xe9:	/* near relative jump */
+	case 0xeb:	/* short relative jump */
+		break;
+	case 0x0f:
+		if ((OPCODE2(insn) & 0xf0) == 0x80) /* jcc near */
+			break;
+		return 0;
+	default:
+		if ((OPCODE1(insn) & 0xf0) == 0x70) /* jcc short */
+			break;
+		return 0;
+	}
+	target = (unsigned long)insn->next_byte + insn->immediate.value;
+	return (start <= target && target <= start + len);
+}
+
+/* Decode whole function to ensure any instructions don't jump into target */
+static int __kprobes can_optimize(unsigned long paddr)
+{
+	int ret;
+	unsigned long addr, size = 0, offset = 0;
+	struct insn insn;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+
+	/* Lookup symbol including addr */
+	if (!kallsyms_lookup(paddr, &size, &offset, NULL, __dummy_buf))
+		return 0;
+
+	/* Decode instructions */
+	addr = paddr - offset;
+	while (addr < paddr - offset + size) { /* Decode until function end */
+		insn_init_kernel(&insn, (void *)addr);
+		insn_get_opcode(&insn);
+		if (OPCODE1(&insn) == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf, addr);
+			if (ret)
+				return 0;
+			insn_init_kernel(&insn, buf);
+		}
+		insn_get_length(&insn);
+		/* Recover address */
+		insn.kaddr = (void *)addr;
+		insn.next_byte = (void *)(addr + insn.length);
+		/* Check any instructions don't jump into target */
+		if (insn_is_indirect_jump(&insn) ||
+		    insn_jump_into_range(&insn, addr + INT3_SIZE,
+					 RELATIVE_ADDR_SIZE))
+			return 0;
+		addr += insn.length;
+	}
+
+	return 1;
+}
+
 int arch_optimized_kprobe_address(struct optimized_kprobe *op,
 				  unsigned long addr)
 {
@@ -1269,6 +1341,9 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 	u8 *buf;
 	int ret, i;

+	if (!can_optimize((unsigned long)op->kp.addr))
+		return -EINVAL;
+
 	op->optinsn.insn = get_optinsn_slot();
 	if (!op->optinsn.insn)
 		return -ENOMEM;
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

