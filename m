Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZCNAUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZCNAUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZCNAS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:27 -0400
Received: from kroah.org ([198.145.64.141]:46632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751228AbZCNAS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:39 2009
Message-Id: <20090314000739.505817345@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:14 -0700
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
Subject: [patch 06/96] sparc: We need to implement arch_ptrace_stop().
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=sparc-we-need-to-implement-arch_ptrace_stop.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 878a5535957b563c447d32866a9e606c55fef091 ]

In order to always provide fully synchronized state to the debugger,
we might need to do a synchronize_user_stack().

A pair of hooks, arch_ptrace_stop_needed() and arch_ptrace_stop(),
exist to handle this kind of situation.  It was created for
the sake of IA64.

Use them, to flush the kernel side cached register windows
to the user stack, when necessary.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/include/asm/ptrace_32.h |   10 ++++++++++
 arch/sparc/include/asm/ptrace_64.h |   10 ++++++++++
 2 files changed, 20 insertions(+)

--- a/arch/sparc/include/asm/ptrace_32.h
+++ b/arch/sparc/include/asm/ptrace_32.h
@@ -62,6 +62,8 @@ struct sparc_stackf {
 
 #ifdef __KERNEL__
 
+#include <asm/system.h>
+
 static inline bool pt_regs_is_syscall(struct pt_regs *regs)
 {
 	return (regs->psr & PSR_SYSCALL);
@@ -72,6 +74,14 @@ static inline bool pt_regs_clear_syscall
 	return (regs->psr &= ~PSR_SYSCALL);
 }
 
+#define arch_ptrace_stop_needed(exit_code, info) \
+({	flush_user_windows(); \
+	current_thread_info()->w_saved != 0;	\
+})
+
+#define arch_ptrace_stop(exit_code, info) \
+	synchronize_user_stack()
+
 #define user_mode(regs) (!((regs)->psr & PSR_PS))
 #define instruction_pointer(regs) ((regs)->pc)
 #define user_stack_pointer(regs) ((regs)->u_regs[UREG_FP])
--- a/arch/sparc/include/asm/ptrace_64.h
+++ b/arch/sparc/include/asm/ptrace_64.h
@@ -113,6 +113,8 @@ struct sparc_trapf {
 
 #ifdef __KERNEL__
 
+#include <asm/system.h>
+
 static inline int pt_regs_trap_type(struct pt_regs *regs)
 {
 	return regs->magic & 0x1ff;
@@ -128,6 +130,14 @@ static inline bool pt_regs_clear_syscall
 	return (regs->tstate &= ~TSTATE_SYSCALL);
 }
 
+#define arch_ptrace_stop_needed(exit_code, info) \
+({	flush_user_windows(); \
+	get_thread_wsaved() != 0; \
+})
+
+#define arch_ptrace_stop(exit_code, info) \
+	synchronize_user_stack()
+
 struct global_reg_snapshot {
 	unsigned long		tstate;
 	unsigned long		tpc;


