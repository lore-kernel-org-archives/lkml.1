Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYKFCft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYKFCft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYKFCfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:35:40 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:13549 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYKFCfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:35:40 -0500
Message-ID: <49125756.70201@ct.jp.nec.com>
Date: Wed, 05 Nov 2008 18:32:54 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: ia32_signal: do save_i387_xstate_ia32 at get_sigframe()
References: <491256C1.2060709@ct.jp.nec.com>
In-Reply-To: <491256C1.2060709@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

move calling save_i387_xstate_ia32() into get_sigframe() from
setup_sigcontext().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index e82ebd6..bafc0b4 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -367,12 +367,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	err |= __put_user(regs->flags, &sc->flags);
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 
-	tmp = save_i387_xstate_ia32(fpstate);
-	if (tmp < 0)
-		err = -EFAULT;
-	else
-		err |= __put_user(ptr_to_compat(tmp ? fpstate : NULL),
-					&sc->fpstate);
+	err |= __put_user(ptr_to_compat(fpstate), &sc->fpstate);
 
 	/* non-iBCS2 extensions.. */
 	err |= __put_user(mask, &sc->oldmask);
@@ -408,6 +403,8 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
 		*fpstate = (struct _fpstate_ia32 *) sp;
+		if (save_i387_xstate_ia32(*fpstate) < 0)
+			return (void __user *) -1L;
 	}
 
 	sp -= frame_size;
-- 
1.5.6

