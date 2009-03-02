Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZCBPqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZCBPqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZCBPpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:45:53 -0500
Received: from mx1.emlix.com ([193.175.82.87]:36090 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZCBPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:45:52 -0500
X-Greylist: delayed 1554 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2009 10:45:52 EST
Date: Mon, 02 Mar 2009 16:19:49 +0100
From: =?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: x86@kernel.org
CC: Bill Metzenthen <billm@suburbia.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, math-emu: fix init_fpu for task != current
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1Le9vp-00020J-AA@mailer.emlix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_fpu calls finit to initialize a task's xstate, while finit always
works on the current task. If we use PTRACE_GETFPREGS on another
process and both processes did not already use floating point, we get
a null pointer exception in finit.

This patch creates a new function finit_task that takes a task_struct
parameter. finit becomes a wrapper that simply calls finit_task with
current. On the plus side this avoids many calls to get_current which
would each resolve to an inline assembler mov instruction.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/x86/include/asm/i387.h |    1 +
 arch/x86/kernel/i387.c      |    2 +-
 arch/x86/math-emu/fpu_aux.c |   31 ++++++++++++++++++++-----------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 48f0004..10f349b 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -172,6 +172,7 @@ static inline void __save_init_fpu(struct task_struct *tsk)

 #else  /* CONFIG_X86_32 */

+extern void finit_task(struct task_struct *tsk);
 extern void finit(void);

 static inline void tolerant_fwait(void)
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index b0f61f0..f2f8540 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -136,7 +136,7 @@ int init_fpu(struct task_struct *tsk)
 #ifdef CONFIG_X86_32
 	if (!HAVE_HWFP) {
 		memset(tsk->thread.xstate, 0, xstate_size);
-		finit();
+		finit_task(tsk);
 		set_stopped_child_used_math(tsk);
 		return 0;
 	}
diff --git a/arch/x86/math-emu/fpu_aux.c b/arch/x86/math-emu/fpu_aux.c
index 491e737..aa09870 100644
--- a/arch/x86/math-emu/fpu_aux.c
+++ b/arch/x86/math-emu/fpu_aux.c
@@ -30,20 +30,29 @@ static void fclex(void)
 }

 /* Needs to be externally visible */
-void finit(void)
+void finit_task(struct task_struct *tsk)
 {
-	control_word = 0x037f;
-	partial_status = 0;
-	top = 0;		/* We don't keep top in the status word internally. */
-	fpu_tag_word = 0xffff;
+	struct i387_soft_struct *soft = &tsk->thread.xstate->soft;
+	struct address *oaddr, *iaddr;
+	soft->cwd = 0x037f;
+	soft->swd = 0;
+	soft->ftop = 0;	/* We don't keep top in the status word internally. */
+	soft->twd = 0xffff;
 	/* The behaviour is different from that detailed in
 	   Section 15.1.6 of the Intel manual */
-	operand_address.offset = 0;
-	operand_address.selector = 0;
-	instruction_address.offset = 0;
-	instruction_address.selector = 0;
-	instruction_address.opcode = 0;
-	no_ip_update = 1;
+	oaddr = (struct address *)&soft->foo;
+	oaddr->offset = 0;
+	oaddr->selector = 0;
+	iaddr = (struct address *)&soft->fip;
+	iaddr->offset = 0;
+	iaddr->selector = 0;
+	iaddr->opcode = 0;
+	soft->no_update = 1;
+}
+
+void finit(void)
+{
+	finit_task(current);
 }

 /*
-- 
1.5.6


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
