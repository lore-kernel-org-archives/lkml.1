Return-Path: <linux-kernel-owner+w=401wt.eu-S1946288AbXBCCne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946288AbXBCCne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946281AbXBCCnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:43:20 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53505 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946276AbXBCCmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:42:46 -0500
Message-Id: <20070203024454.248049000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:48 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, akpm@osdl.org, jdike@addtoit.com,
       blaisorblade@yahoo.it, bunk@stusta.de, antoine@nagafix.co.uk
Subject: [patch 44/59] uml: fix signal frame alignment
Content-Disposition: inline; filename=uml-fix-signal-frame-alignment.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Jeff Dike <jdike@addtoit.com>

Use the same signal frame alignment calculations as the underlying
architecture.  x86_64 appeared to do this, but the "- 8" was really
subtracting 8 * sizeof(struct rt_sigframe) rather than 8 bytes.

UML/i386 might have been OK, but I changed the calculation to match
i386 just to be sure.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Antoine Martin <antoine@nagafix.co.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/um/sys-i386/signal.c   |    3 ++-
 arch/um/sys-x86_64/signal.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.19.2.orig/arch/um/sys-i386/signal.c
+++ linux-2.6.19.2/arch/um/sys-i386/signal.c
@@ -219,7 +219,8 @@ int setup_signal_stack_sc(unsigned long 
 	unsigned long save_sp = PT_REGS_SP(regs);
 	int err = 0;
 
-	stack_top &= -8UL;
+	/* This is the same calculation as i386 - ((sp + 4) & 15) == 0 */
+	stack_top = ((stack_top + 4) & -16UL) - 4;
 	frame = (struct sigframe __user *) stack_top - 1;
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return 1;
--- linux-2.6.19.2.orig/arch/um/sys-x86_64/signal.c
+++ linux-2.6.19.2/arch/um/sys-x86_64/signal.c
@@ -191,8 +191,9 @@ int setup_signal_stack_si(unsigned long 
 	struct task_struct *me = current;
 
 	frame = (struct rt_sigframe __user *)
-		round_down(stack_top - sizeof(struct rt_sigframe), 16) - 8;
-        frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128);
+		round_down(stack_top - sizeof(struct rt_sigframe), 16);
+	/* Subtract 128 for a red zone and 8 for proper alignment */
+        frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
 
 	if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
 		goto out;

--
