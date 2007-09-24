Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbXIXXvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbXIXXvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbXIXXu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:50:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbXIXXu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:50:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@redhat.com>
Subject: [PATCH 1/2] powerpc: ptrace CHECK_FULL_REGS
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Trenchant catatonic aluminum
   (2) Televised baskets
   (3) Parliamentary bums
   (4) Olympic Slanty-wise longitudes
Message-Id: <20070924235052.5AFC24D04B7@magilla.localdomain>
Date: Mon, 24 Sep 2007 16:50:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This restores the CHECK_FULL_REGS sanity check to every place that can
access the nonvolatile GPRs for ptrace.  This is already done for
native-bitwidth PTRACE_PEEKUSR, but was omitted for many other cases
(32-bit ptrace, PTRACE_GETREGS, etc.); I think there may have been more
uniform checks before that were lost in the recent cleanup of GETREGS et al.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c   |    4 ++++
 arch/powerpc/kernel/ptrace32.c |    8 ++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 8a177bd..40d34b3 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -331,6 +331,7 @@ static long arch_ptrace_old(struct task_struct *child, long request, long addr,
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned long __user *tmp = (unsigned long __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = put_user(*reg, tmp);
 			if (ret)
@@ -346,6 +347,7 @@ static long arch_ptrace_old(struct task_struct *child, long request, long addr,
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned long __user *tmp = (unsigned long __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = get_user(*reg, tmp);
 			if (ret)
@@ -517,6 +519,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret |= __put_user(ptrace_get_reg(child, ui),
@@ -537,6 +540,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret = __get_user(tmp, (unsigned long __user *) data);
diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 9e6baea..6b86960 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -53,6 +53,7 @@ static long compat_ptrace_old(struct task_struct *child, long request,
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned int __user *tmp = (unsigned int __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = put_user(*reg, tmp);
 			if (ret)
@@ -68,6 +69,7 @@ static long compat_ptrace_old(struct task_struct *child, long request,
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned int __user *tmp = (unsigned int __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = get_user(*reg, tmp);
 			if (ret)
@@ -164,6 +166,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		if ((addr & 3) || (index > PT_FPSCR32))
 			break;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		if (index < PT_FPR0) {
 			tmp = ptrace_get_reg(child, index);
 		} else {
@@ -210,6 +213,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		if ((addr & 3) || numReg > PT_FPSCR)
 			break;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		if (numReg >= PT_FPR0) {
 			flush_fp_to_thread(child);
 			tmp = ((unsigned long int *)child->thread.fpr)[numReg - PT_FPR0];
@@ -270,6 +274,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		if ((addr & 3) || (index > PT_FPSCR32))
 			break;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		if (index < PT_FPR0) {
 			ret = ptrace_put_reg(child, index, data);
 		} else {
@@ -307,6 +312,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		 */
 		if ((addr & 3) || (numReg > PT_FPSCR))
 			break;
+		CHECK_FULL_REGS(child->thread.regs);
 		if (numReg < PT_FPR0) {
 			unsigned long freg = ptrace_get_reg(child, numReg);
 			if (index % 2)
@@ -342,6 +348,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret |= __put_user(ptrace_get_reg(child, ui),
@@ -359,6 +366,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret = __get_user(tmp, (unsigned int __user *) data);
