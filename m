Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXKSCMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXKSCMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 21:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXKSCMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 21:12:12 -0500
Received: from [222.73.24.84] ([222.73.24.84]:62616 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbXKSCML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 21:12:11 -0500
Message-ID: <4740F07E.1010301@cn.fujitsu.com>
Date: Mon, 19 Nov 2007 10:10:06 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] IA64 signal : remove redundant code in setup_sigcontext()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some redundant code in the function setup_sigcontext().

The registers ar.ccv,b7,r14,ar.csd,ar.ssd,r2-r3 and r16-r31 are not restored 
in restore_sigcontext() when (flags & IA64_SC_FLAG_IN_SYSCALL) is true. 
So we don't need to zero those variables in setup_sigcontext().

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 

---
diff  -urp linux-2.6.24-rc2.orig/arch/ia64/kernel/signal.c linux-2.6.24-rc2/arch/ia64/kernel/signal.c
--- linux-2.6.24-rc2.orig/arch/ia64/kernel/signal.c	2007-11-09 14:38:53.000000000 +0800
+++ linux-2.6.24-rc2/arch/ia64/kernel/signal.c	2007-11-13 13:30:00.000000000 +0800
@@ -280,15 +280,7 @@ setup_sigcontext (struct sigcontext __us
 	err |= __copy_to_user(&sc->sc_gr[15], &scr->pt.r15, 8);		/* r15 */
 	err |= __put_user(scr->pt.cr_iip + ia64_psr(&scr->pt)->ri, &sc->sc_ip);
 
-	if (flags & IA64_SC_FLAG_IN_SYSCALL) {
-		/* Clear scratch registers if the signal interrupted a system call. */
-		err |= __put_user(0, &sc->sc_ar_ccv);				/* ar.ccv */
-		err |= __put_user(0, &sc->sc_br[7]);				/* b7 */
-		err |= __put_user(0, &sc->sc_gr[14]);				/* r14 */
-		err |= __clear_user(&sc->sc_ar25, 2*8);			/* ar.csd & ar.ssd */
-		err |= __clear_user(&sc->sc_gr[2], 2*8);			/* r2-r3 */
-		err |= __clear_user(&sc->sc_gr[16], 16*8);			/* r16-r31 */
-	} else {
+	if (!(flags & IA64_SC_FLAG_IN_SYSCALL)) {
 		/* Copy scratch regs to sigcontext if the signal didn't interrupt a syscall. */
 		err |= __put_user(scr->pt.ar_ccv, &sc->sc_ar_ccv);		/* ar.ccv */
 		err |= __put_user(scr->pt.b7, &sc->sc_br[7]);			/* b7 */






