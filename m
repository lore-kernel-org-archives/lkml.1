Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYIMADl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYIMADl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYIMADc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:03:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6275 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbYIMADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:03:32 -0400
Message-ID: <48CB0353.1020306@ct.jp.nec.com>
Date: Fri, 12 Sep 2008 17:03:31 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: signal: make do_rt_sigreturn()
References: <48CB02C5.4060805@ct.jp.nec.com>
In-Reply-To: <48CB02C5.4060805@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

make do_rt_sigreturn() to collect common part of sys_rt_sigreturn().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   12 +++++++++---
 arch/x86/kernel/signal_64.c |   11 ++++++++---
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d433861..da3cf32 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -215,9 +215,8 @@ badframe:
 	return 0;
 }
 
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+static long do_rt_sigreturn(struct pt_regs *regs)
 {
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
 	struct rt_sigframe __user *frame;
 	unsigned long ax;
 	sigset_t set;
@@ -243,10 +242,17 @@ asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 	return ax;
 
 badframe:
-	signal_fault(regs, frame, "rt sigreturn");
+	signal_fault(regs, frame, "rt_sigreturn");
 	return 0;
 }
 
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+{
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
+}
+
 /*
  * Set up a signal frame.
  */
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index a21c851..bf77d47 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -104,11 +104,11 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	return err;
 }
 
-asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+static long do_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	sigset_t set;
 	unsigned long ax;
+	sigset_t set;
 
 	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
@@ -131,10 +131,15 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	return ax;
 
 badframe:
-	signal_fault(regs, frame, "sigreturn");
+	signal_fault(regs, frame, "rt_sigreturn");
 	return 0;
 }
 
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+{
+	return do_rt_sigreturn(regs);
+}
+
 /*
  * Set up a signal frame.
  */
-- 
1.5.6

