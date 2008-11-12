Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbYKLDJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbYKLDJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYKLDJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:09:31 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:36065 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYKLDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:09:30 -0500
Message-ID: <491A48E9.8020909@ct.jp.nec.com>
Date: Tue, 11 Nov 2008 19:09:29 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: signal_32: introduce retcode and rt_retcode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce retcode and rt_retcode to replace setting up frame->retcode.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 27a5c81..514171a 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -45,6 +45,28 @@
 # define FIX_EFLAGS	__FIX_EFLAGS
 #endif
 
+static const struct {
+	u16 poplmovl;
+	u32 val;
+	u16 int80;
+} __attribute__((packed)) retcode = {
+	0xb858,		/* popl %eax; movl $..., %eax */
+	__NR_sigreturn,
+	0x80cd,		/* int $0x80 */
+};
+
+static const struct {
+	u8  movl;
+	u32 val;
+	u16 int80;
+	u8  pad;
+} __attribute__((packed)) rt_retcode = {
+	0xb8,		/* movl $..., %eax */
+	__NR_rt_sigreturn,
+	0x80cd,		/* int $0x80 */
+	0
+};
+
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
  */
@@ -427,9 +449,7 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(0xb858, (short __user *)(frame->retcode+0));
-	err |= __put_user(__NR_sigreturn, (int __user *)(frame->retcode+2));
-	err |= __put_user(0x80cd, (short __user *)(frame->retcode+6));
+	err |= __put_user(*((u64 *)&retcode), (u64 *)frame->retcode);
 
 	if (err)
 		return -EFAULT;
@@ -498,9 +518,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(0xb8, (char __user *)(frame->retcode+0));
-	err |= __put_user(__NR_rt_sigreturn, (int __user *)(frame->retcode+1));
-	err |= __put_user(0x80cd, (short __user *)(frame->retcode+5));
+	err |= __put_user(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
 
 	if (err)
 		return -EFAULT;
-- 
1.5.6

