Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZCDSnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZCDSnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:43:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZCDSmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:42:53 -0500
Received: from mx1.emlix.com ([193.175.82.87]:44671 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbZCDSmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:42:52 -0500
Date: Wed, 04 Mar 2009 19:42:27 +0100
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, x86@kernel.org,
       Bill Metzenthen <billm@melbpc.org.au>, linux-kernel@vger.kernel.org
Subject: [PATCH -v2] x86, math-emu: fix init_fpu for task != current
References: <E1Le9vp-00020J-AA@mailer.emlix.com> <20090302195230.GA12252@elte.hu> <E1LetWv-0002Kq-Sq@mailer.emlix.com> <20090304175122.GA29823@elte.hu>
In-Reply-To: <20090304175122.GA29823@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-Id: <E1Lew31-0004il-Fg@mailer.emlix.com>
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

An empty finit_task has been added to i387.h to avoid linker errors in
case the compiler still emits the call in init_fpu when
CONFIG_MATH_EMULATION is not defined.

The declaration of finit in i387.h has been removed as the remaining
code using this function gets its prototype from fpu_proto.h.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/x86/include/asm/i387.h |    8 +++++++-
 arch/x86/kernel/i387.c      |    2 +-
 arch/x86/math-emu/fpu_aux.c |   31 ++++++++++++++++++++-----------
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 48f0004..71c9e51 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -172,7 +172,13 @@ static inline void __save_init_fpu(struct task_struct *tsk)

 #else  /* CONFIG_X86_32 */

-extern void finit(void);
+#ifdef CONFIG_MATH_EMULATION
+extern void finit_task(struct task_struct *tsk);
+#else
+static inline void finit_task(struct task_struct *tsk)
+{
+}
+#endif

 static inline void tolerant_fwait(void)
 {
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
