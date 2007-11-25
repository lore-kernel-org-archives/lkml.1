Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXKYWG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXKYWG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbXKYWFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:05:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580AbXKYWFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:05:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 19/27] x86-32 ptrace debugreg cleanup
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125220519.092D126F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:05:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the 32-bit ptrace code to separate the guts of the
debug register access from the implementation of PTRACE_PEEKUSR and
PTRACE_POKEUSR.  The new functions ptrace_[gs]et_debugreg match the
new 64-bit entry points for parity, but they don't need to be global.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_32.c |  119 +++++++++++++++++++++++++------------------
 1 files changed, 69 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 7c33244..0aa3756 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -119,6 +119,72 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 }
 
 /*
+ * This function is trivial and will be inlined by the compiler.
+ * Having it separates the implementation details of debug
+ * registers from the interface details of ptrace.
+ */
+static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
+{
+	return child->thread.debugreg[n];
+}
+
+static int ptrace_set_debugreg(struct task_struct *child,
+			       int n, unsigned long data)
+{
+	if (unlikely(n == 4 || n == 5))
+		return -EIO;
+
+	if (n < 4 && unlikely(data >= TASK_SIZE - 3))
+		return -EIO;
+
+	if (n == 7) {
+		/*
+		 * Sanity-check data. Take one half-byte at once with
+		 * check = (val >> (16 + 4*i)) & 0xf. It contains the
+		 * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
+		 * 2 and 3 are LENi. Given a list of invalid values,
+		 * we do mask |= 1 << invalid_value, so that
+		 * (mask >> check) & 1 is a correct test for invalid
+		 * values.
+		 *
+		 * R/Wi contains the type of the breakpoint /
+		 * watchpoint, LENi contains the length of the watched
+		 * data in the watchpoint case.
+		 *
+		 * The invalid values are:
+		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.
+		 * - R/Wi == 0x10 (break on I/O reads or writes), so
+		 *   mask |= 0x4444.
+		 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
+		 *   0x1110.
+		 *
+		 * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
+		 *
+		 * See the Intel Manual "System Programming Guide",
+		 * 15.2.4
+		 *
+		 * Note that LENi == 0x10 is defined on x86_64 in long
+		 * mode (i.e. even for 32-bit userspace software, but
+		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
+		 * See the AMD manual no. 24593 (AMD64 System Programming)
+		 */
+		int i;
+		data &= ~DR_CONTROL_RESERVED;
+		for (i = 0; i < 4; i++)
+			if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
+				return -EIO;
+		if (data)
+			set_tsk_thread_flag(child, TIF_DEBUG);
+		else
+			clear_tsk_thread_flag(child, TIF_DEBUG);
+	}
+
+	child->thread.debugreg[n] = data;
+
+	return 0;
+}
+
+/*
  * Called by kernel/ptrace.c when detaching..
  *
  * Make sure the single step bit is not set.
@@ -158,7 +224,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		   addr <= (long) &dummy->u_debugreg[7]){
 			addr -= (long) &dummy->u_debugreg[0];
 			addr = addr >> 2;
-			tmp = child->thread.debugreg[addr];
+			tmp = ptrace_get_debugreg(child, addr);
 		}
 		ret = put_user(tmp, datap);
 		break;
@@ -188,56 +254,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		  ret = -EIO;
 		  if(addr >= (long) &dummy->u_debugreg[0] &&
 		     addr <= (long) &dummy->u_debugreg[7]){
-
-			  if(addr == (long) &dummy->u_debugreg[4]) break;
-			  if(addr == (long) &dummy->u_debugreg[5]) break;
-			  if(addr < (long) &dummy->u_debugreg[4] &&
-			     ((unsigned long) data) >= TASK_SIZE-3) break;
-
-			  /* Sanity-check data. Take one half-byte at once with
-			   * check = (val >> (16 + 4*i)) & 0xf. It contains the
-			   * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
-			   * 2 and 3 are LENi. Given a list of invalid values,
-			   * we do mask |= 1 << invalid_value, so that
-			   * (mask >> check) & 1 is a correct test for invalid
-			   * values.
-			   *
-			   * R/Wi contains the type of the breakpoint /
-			   * watchpoint, LENi contains the length of the watched
-			   * data in the watchpoint case.
-			   *
-			   * The invalid values are:
-			   * - LENi == 0x10 (undefined), so mask |= 0x0f00.
-			   * - R/Wi == 0x10 (break on I/O reads or writes), so
-			   *   mask |= 0x4444.
-			   * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
-			   *   0x1110.
-			   *
-			   * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
-			   *
-			   * See the Intel Manual "System Programming Guide",
-			   * 15.2.4
-			   *
-			   * Note that LENi == 0x10 is defined on x86_64 in long
-			   * mode (i.e. even for 32-bit userspace software, but
-			   * 64-bit kernel), so the x86_64 mask value is 0x5454.
-			   * See the AMD manual no. 24593 (AMD64 System
-			   * Programming)*/
-
-			  if(addr == (long) &dummy->u_debugreg[7]) {
-				  data &= ~DR_CONTROL_RESERVED;
-				  for(i=0; i<4; i++)
-					  if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
-						  goto out_tsk;
-				  if (data)
-					  set_tsk_thread_flag(child, TIF_DEBUG);
-				  else
-					  clear_tsk_thread_flag(child, TIF_DEBUG);
-			  }
 			  addr -= (long) &dummy->u_debugreg;
 			  addr = addr >> 2;
-			  child->thread.debugreg[addr] = data;
-			  ret = 0;
+			  ret = ptrace_set_debugreg(child, addr, data);
 		  }
 		  break;
 
@@ -335,7 +354,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
- out_tsk:
+
 	return ret;
 }
 
