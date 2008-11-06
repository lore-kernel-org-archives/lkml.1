Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYKFCax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYKFCax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYKFCao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:30:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:12217 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYKFCao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:30:44 -0500
Message-ID: <491256C1.2060709@ct.jp.nec.com>
Date: Wed, 05 Nov 2008 18:30:25 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: signal_32: do save_i387_xstate() at get_sigframe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

move calling save_i387_xstate() into get_sigframe() from setup_sigcontext()
like 64bit.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index a0efc1b..6a05c74 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -303,11 +303,7 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
 
-	tmp = save_i387_xstate(fpstate);
-	if (tmp < 0)
-		err = 1;
-	else
-		err |= __put_user(tmp ? fpstate : NULL, &sc->fpstate);
+	err |= __put_user(fpstate, &sc->fpstate);
 
 	/* non-iBCS2 extensions.. */
 	err |= __put_user(mask, &sc->oldmask);
@@ -350,6 +346,8 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (used_math()) {
 		sp = sp - sig_xstate_size;
 		*fpstate = (struct _fpstate *) sp;
+		if (save_i387_xstate(*fpstate) < 0)
+			return (void __user *)-1L;
 	}
 
 	sp -= frame_size;
-- 
1.5.6

