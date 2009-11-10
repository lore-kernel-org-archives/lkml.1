Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZKJAaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZKJAaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbZKJAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:30:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbZKJAas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:30:48 -0500
Date: Tue, 10 Nov 2009 01:25:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Kumar Gala <galak@kernel.crashing.org>, Liu Yu <yu.liu@freescale.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: _exception: kill the obsolete code under
	is_global_init()
Message-ID: <20091110002542.GA1312@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code under "if (is_global_init())" is bogus, and is_global_init()
itself is not right in mt case.

Contrary to what the comment says, nowadays force_sig_info() does kill
init even if the handler is SIG_DFL. Note that force_sig_info() clears
SIGNAL_UNKILLABLE exactly for this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/powerpc/kernel/traps.c |   22 ----------------------
 1 file changed, 22 deletions(-)

--- TH/arch/powerpc/kernel/traps.c~PPC_EXCEPTION_DONT_CK_INIT	2009-11-10 01:03:23.000000000 +0100
+++ TH/arch/powerpc/kernel/traps.c	2009-11-10 01:06:41.000000000 +0100
@@ -198,28 +198,6 @@ void _exception(int signr, struct pt_reg
 	info.si_code = code;
 	info.si_addr = (void __user *) addr;
 	force_sig_info(signr, &info, current);
-
-	/*
-	 * Init gets no signals that it doesn't have a handler for.
-	 * That's all very well, but if it has caused a synchronous
-	 * exception and we ignore the resulting signal, it will just
-	 * generate the same exception over and over again and we get
-	 * nowhere.  Better to kill it and let the kernel panic.
-	 */
-	if (is_global_init(current)) {
-		__sighandler_t handler;
-
-		spin_lock_irq(&current->sighand->siglock);
-		handler = current->sighand->action[signr-1].sa.sa_handler;
-		spin_unlock_irq(&current->sighand->siglock);
-		if (handler == SIG_DFL) {
-			/* init has generated a synchronous exception
-			   and it doesn't have a handler for the signal */
-			printk(KERN_CRIT "init has generated signal %d "
-			       "but has no handler for it\n", signr);
-			do_exit(signr);
-		}
-	}
 }
 
 #ifdef CONFIG_PPC64

