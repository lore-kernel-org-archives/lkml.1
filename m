Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYDJPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYDJPL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbYDJPL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:11:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778AbYDJPL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:11:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] FRV: Add support for emulation of userspace atomic ops
	[try #2]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 10 Apr 2008 16:10:55 +0100
Message-ID: <20080410151055.3764.82755.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080410151044.3764.47511.stgit@warthog.procyon.org.uk>
References: <20080410151044.3764.47511.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Use traps 120-126 to emulate atomic cmpxchg32, xchg32, and XOR-, OR-, AND-, SUB-
and ADD-to-memory operations for userspace.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/entry-table.S |    8 +
 arch/frv/kernel/entry.S       |   20 ++++
 arch/frv/kernel/traps.c       |  227 +++++++++++++++++++++++++++++++++++++++++
 include/asm-frv/spr-regs.h    |   14 +++
 4 files changed, 268 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/entry-table.S b/arch/frv/kernel/entry-table.S
index d3b9253..bf35f33 100644
--- a/arch/frv/kernel/entry-table.S
+++ b/arch/frv/kernel/entry-table.S
@@ -316,8 +316,14 @@ __trap_fixup_kernel_data_tlb_miss:
 	.section	.trap.vector
 	.org		TBR_TT_TRAP0 >> 2
 	.long		system_call
-	.rept		126
+	.rept		119
 	.long		__entry_unsupported_trap
 	.endr
+
+	# userspace atomic op emulation, traps 120-126
+	.rept		7
+	.long		__entry_atomic_op
+	.endr
+	
 	.org		TBR_TT_BREAK >> 2
 	.long		__entry_debug_exception
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index f36d7f4..b8a4b94 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -656,6 +656,26 @@ __entry_debug_exception:
 
 ###############################################################################
 #
+# handle atomic operation emulation for userspace
+#
+###############################################################################
+	.globl		__entry_atomic_op
+__entry_atomic_op:
+	LEDS		0x6012
+	sethi.p		%hi(atomic_operation),gr5
+	setlo		%lo(atomic_operation),gr5
+	movsg		esfr1,gr8
+	movsg		epcr0,gr9
+	movsg		esr0,gr10
+
+	# now that we've accessed the exception regs, we can enable exceptions
+	movsg		psr,gr4
+	ori		gr4,#PSR_ET,gr4
+	movgs		gr4,psr
+	jmpl		@(gr5,gr0)	; call atomic_operation(esfr1,epcr0,esr0)
+
+###############################################################################
+#
 # handle media exception
 #
 ###############################################################################
diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index 2e6098c..2f7e668 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -102,6 +102,233 @@ asmlinkage void illegal_instruction(unsigned long esfr1, unsigned long epcr0, un
 
 /*****************************************************************************/
 /*
+ * handle atomic operations with errors
+ * - arguments in gr8, gr9, gr10
+ * - original memory value placed in gr5
+ * - replacement memory value placed in gr9
+ */
+asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
+				 unsigned long esr0)
+{
+	static DEFINE_SPINLOCK(atomic_op_lock);
+	unsigned long x, y, z, *p;
+	mm_segment_t oldfs;
+	siginfo_t info;
+	int ret;
+
+	y = 0;
+	z = 0;
+
+	oldfs = get_fs();
+	if (!user_mode(__frame))
+		set_fs(KERNEL_DS);
+
+	switch (__frame->tbr & TBR_TT) {
+		/* TIRA gr0,#120
+		 * u32 __atomic_user_cmpxchg32(u32 *ptr, u32 test, u32 new)
+		 */
+	case TBR_TT_ATOMIC_CMPXCHG32:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+		y = __frame->gr10;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			if (z != x)
+				goto done;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				if (z != x)
+					goto done2;
+
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#121
+		 * u32 __atomic_kernel_xchg32(void *v, u32 new)
+		 */
+	case TBR_TT_ATOMIC_XCHG32:
+		p = (unsigned long *) __frame->gr8;
+		y = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#122
+		 * ulong __atomic_kernel_XOR_return(ulong i, ulong *v)
+		 */
+	case TBR_TT_ATOMIC_XOR:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = x ^ z;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#123
+		 * ulong __atomic_kernel_OR_return(ulong i, ulong *v)
+		 */
+	case TBR_TT_ATOMIC_OR:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = x ^ z;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#124
+		 * ulong __atomic_kernel_AND_return(ulong i, ulong *v)
+		 */
+	case TBR_TT_ATOMIC_AND:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = x & z;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#125
+		 * int __atomic_user_sub_return(atomic_t *v, int i)
+		 */
+	case TBR_TT_ATOMIC_SUB:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = z - x;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+		/* TIRA gr0,#126
+		 * int __atomic_user_add_return(atomic_t *v, int i)
+		 */
+	case TBR_TT_ATOMIC_ADD:
+		p = (unsigned long *) __frame->gr8;
+		x = __frame->gr9;
+
+		for (;;) {
+			ret = get_user(z, p);
+			if (ret < 0)
+				goto error;
+
+			spin_lock_irq(&atomic_op_lock);
+
+			if (__get_user(z, p) == 0) {
+				y = z + x;
+				if (__put_user(y, p) == 0)
+					goto done2;
+				goto error2;
+			}
+
+			spin_unlock_irq(&atomic_op_lock);
+		}
+
+	default:
+		BUG();
+	}
+
+done2:
+	spin_unlock_irq(&atomic_op_lock);
+done:
+	if (!user_mode(__frame))
+		set_fs(oldfs);
+	__frame->gr5 = z;
+	__frame->gr9 = y;
+	return;
+
+error2:
+	spin_unlock_irq(&atomic_op_lock);
+error:
+	if (!user_mode(__frame))
+		set_fs(oldfs);
+	__frame->pc -= 4;
+
+	die_if_kernel("-- Atomic Op Error --\n");
+
+	info.si_signo	= SIGSEGV;
+	info.si_code	= SEGV_ACCERR;
+	info.si_errno	= 0;
+	info.si_addr	= (void *) __frame->pc;
+
+	force_sig_info(info.si_signo, &info, current);
+}
+
+/*****************************************************************************/
+/*
  *
  */
 asmlinkage void media_exception(unsigned long msr0, unsigned long msr1)
diff --git a/include/asm-frv/spr-regs.h b/include/asm-frv/spr-regs.h
index c2a541e..01e6af5 100644
--- a/include/asm-frv/spr-regs.h
+++ b/include/asm-frv/spr-regs.h
@@ -99,9 +99,23 @@
 #define TBR_TT_TRAP1		(0x81 << 4)
 #define TBR_TT_TRAP2		(0x82 << 4)
 #define TBR_TT_TRAP3		(0x83 << 4)
+#define TBR_TT_TRAP120		(0xf8 << 4)
+#define TBR_TT_TRAP121		(0xf9 << 4)
+#define TBR_TT_TRAP122		(0xfa << 4)
+#define TBR_TT_TRAP123		(0xfb << 4)
+#define TBR_TT_TRAP124		(0xfc << 4)
+#define TBR_TT_TRAP125		(0xfd << 4)
 #define TBR_TT_TRAP126		(0xfe << 4)
 #define TBR_TT_BREAK		(0xff << 4)
 
+#define TBR_TT_ATOMIC_CMPXCHG32	TBR_TT_TRAP120
+#define TBR_TT_ATOMIC_XCHG32	TBR_TT_TRAP121
+#define TBR_TT_ATOMIC_XOR	TBR_TT_TRAP122
+#define TBR_TT_ATOMIC_OR	TBR_TT_TRAP123
+#define TBR_TT_ATOMIC_AND	TBR_TT_TRAP124
+#define TBR_TT_ATOMIC_SUB	TBR_TT_TRAP125
+#define TBR_TT_ATOMIC_ADD	TBR_TT_TRAP126
+
 #define __get_TBR()	({ unsigned long x; asm volatile("movsg tbr,%0" : "=r"(x)); x; })
 
 /*

