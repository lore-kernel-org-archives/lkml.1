Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYDII3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYDII3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYDII3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:29:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYDII3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:29:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/2] x86 vDSO: don't use disabled vDSO for signal trampoline
In-Reply-To: Roland McGrath's message of  Wednesday, 9 April 2008 01:27:03 -0700 <20080409082703.B805926F992@magilla.localdomain>
References: <20080409082703.B805926F992@magilla.localdomain>
X-Windows: flawed beyond belief.
Message-Id: <20080409082927.BD59E26F992@magilla.localdomain>
Date: Wed,  9 Apr 2008 01:29:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the vDSO was not mapped, don't use it as the "restorer" for a signal
handler.  Whether we have a pointer in mm->context.vdso depends on what
happened at exec time, so we shouldn't check any global flags now.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32_signal.c |    2 +-
 arch/x86/kernel/signal_32.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 5e7771a..05e155d 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -468,7 +468,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		restorer = ka->sa.sa_restorer;
 	} else {
 		/* Return stub is in 32bit vsyscall page */
-		if (current->binfmt->hasvdso)
+		if (current->mm->context.vdso)
 			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
 						 sigreturn);
 		else
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 0157a6f..011c62f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -365,7 +365,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 			goto give_sigsegv;
 	}
 
-	if (current->binfmt->hasvdso)
+	if (current->mm->context.vdso)
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
 	else
 		restorer = &frame->retcode;
