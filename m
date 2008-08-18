Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYHRTHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYHRTHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762649AbYHRTEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:04:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762648AbYHRTEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:04:36 -0400
Date: Mon, 18 Aug 2008 11:45:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 49/60] sparc64: Make global reg dumping even more useful.
Message-ID: <20080818184521.GX29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0004-sparc64-Make-global-reg-dumping-even-more-useful.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 5afe27380bc42454254c9c83c045240249c15e35 ]

Record one more level of stack frame program counter.

Particularly when lockdep and all sorts of spinlock debugging is
enabled, figuring out the caller of spin_lock() is difficult when the
cpu is stuck on the lock.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/process.c |   35 +++++++++++++++++++++++++++++------
 arch/sparc64/mm/ultra.S       |    7 +++++++
 include/asm-sparc64/ptrace.h  |    8 ++++----
 3 files changed, 40 insertions(+), 10 deletions(-)

--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -305,6 +305,19 @@ void show_regs(struct pt_regs *regs)
 struct global_reg_snapshot global_reg_snapshot[NR_CPUS];
 static DEFINE_SPINLOCK(global_reg_snapshot_lock);
 
+static bool kstack_valid(struct thread_info *tp, struct reg_window *rw)
+{
+	unsigned long thread_base, fp;
+
+	thread_base = (unsigned long) tp;
+	fp = (unsigned long) rw;
+
+	if (fp < (thread_base + sizeof(struct thread_info)) ||
+	    fp >= (thread_base + THREAD_SIZE))
+		return false;
+	return true;
+}
+
 static void __global_reg_self(struct thread_info *tp, struct pt_regs *regs,
 			      int this_cpu)
 {
@@ -316,14 +329,22 @@ static void __global_reg_self(struct thr
 	global_reg_snapshot[this_cpu].o7 = regs->u_regs[UREG_I7];
 
 	if (regs->tstate & TSTATE_PRIV) {
+		struct thread_info *tp = current_thread_info();
 		struct reg_window *rw;
 
 		rw = (struct reg_window *)
 			(regs->u_regs[UREG_FP] + STACK_BIAS);
-		global_reg_snapshot[this_cpu].i7 = rw->ins[7];
-	} else
+		if (kstack_valid(tp, rw)) {
+			global_reg_snapshot[this_cpu].i7 = rw->ins[7];
+			rw = (struct reg_window *)
+				(rw->ins[6] + STACK_BIAS);
+			if (kstack_valid(tp, rw))
+				global_reg_snapshot[this_cpu].rpc = rw->ins[7];
+		}
+	} else {
 		global_reg_snapshot[this_cpu].i7 = 0;
-
+		global_reg_snapshot[this_cpu].rpc = 0;
+	}
 	global_reg_snapshot[this_cpu].thread = tp;
 }
 
@@ -384,12 +405,14 @@ static void sysrq_handle_globreg(int key
 			sprint_symbol(buffer, gp->o7);
 			printk("O7[%s] ", buffer);
 			sprint_symbol(buffer, gp->i7);
-			printk("I7[%s]\n", buffer);
+			printk("I7[%s] ", buffer);
+			sprint_symbol(buffer, gp->rpc);
+			printk("RPC[%s]\n", buffer);
 		} else
 #endif
 		{
-			printk("             TPC[%lx] O7[%lx] I7[%lx]\n",
-			       gp->tpc, gp->o7, gp->i7);
+			printk("             TPC[%lx] O7[%lx] I7[%lx] RPC[%lx]\n",
+			       gp->tpc, gp->o7, gp->i7, gp->rpc);
 		}
 	}
 
--- a/arch/sparc64/mm/ultra.S
+++ b/arch/sparc64/mm/ultra.S
@@ -531,6 +531,13 @@ xcall_fetch_glob_regs:
 	stx		%g7, [%g1 + GR_SNAP_TNPC]
 	stx		%o7, [%g1 + GR_SNAP_O7]
 	stx		%i7, [%g1 + GR_SNAP_I7]
+	/* Don't try this at home kids... */
+	rdpr		%cwp, %g2
+	sub		%g2, 1, %g7
+	wrpr		%g7, %cwp
+	mov		%i7, %g7
+	wrpr		%g2, %cwp
+	stx		%g7, [%g1 + GR_SNAP_RPC]
 	sethi		%hi(trap_block), %g7
 	or		%g7, %lo(trap_block), %g7
 	sllx		%g2, TRAP_BLOCK_SZ_SHIFT, %g2
--- a/include/asm-sparc64/ptrace.h
+++ b/include/asm-sparc64/ptrace.h
@@ -134,9 +134,9 @@ struct global_reg_snapshot {
 	unsigned long		tnpc;
 	unsigned long		o7;
 	unsigned long		i7;
+	unsigned long		rpc;
 	struct thread_info	*thread;
 	unsigned long		pad1;
-	unsigned long		pad2;
 };
 
 #define __ARCH_WANT_COMPAT_SYS_PTRACE
@@ -314,9 +314,9 @@ extern void __show_regs(struct pt_regs *
 #define GR_SNAP_TNPC	0x10
 #define GR_SNAP_O7	0x18
 #define GR_SNAP_I7	0x20
-#define GR_SNAP_THREAD	0x28
-#define GR_SNAP_PAD1	0x30
-#define GR_SNAP_PAD2	0x38
+#define GR_SNAP_RPC	0x28
+#define GR_SNAP_THREAD	0x30
+#define GR_SNAP_PAD1	0x38
 
 #endif  /*  __KERNEL__  */
 

-- 
