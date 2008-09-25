Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbYIYCKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbYIYCKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYIYCKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:10:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27999 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYIYCKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:10:31 -0400
Message-ID: <48DAF315.7070700@ct.jp.nec.com>
Date: Wed, 24 Sep 2008 19:10:29 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: signal_32.c: introduce signr_convert()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Introduce signr_convert().
This function will help unification of setup_rt_frame().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index bb05917..b1bc90f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -482,18 +482,21 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 /*
  * OK, we're invoking a handler:
  */
+static int signr_convert(int sig)
+{
+	struct thread_info *info = current_thread_info();
+
+	if (info->exec_domain && info->exec_domain->signal_invmap && sig < 32)
+		return info->exec_domain->signal_invmap[sig];
+	return sig;
+}
+
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs)
 {
+	int usig = signr_convert(sig);
 	int ret;
-	int usig;
-
-	usig = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
 
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
-- 
1.5.6

