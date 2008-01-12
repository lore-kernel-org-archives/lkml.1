Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbYALBIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbYALBIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762707AbYALBIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:08:10 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53538 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762843AbYALBIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:08:09 -0500
Date: Fri, 11 Jan 2008 17:06:56 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mboton@gmail.com" <mboton@gmail.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: [PATCH] x86: refactor ioport unification
Message-ID: <20080112010656.GD3627@sequoia.sous-sol.org>
References: <4786AA11.5010805@gmail.com> <4786AB1B.4030004@zytor.com> <4786AF4C.6050509@gmail.com> <4786C2CF.4070204@zytor.com> <20080110220444.4c9efdec.kjwinchester@gmail.com> <20080111140346.GA13604@elte.hu> <20080112010443.GA5476@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112010443.GA5476@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor ioport unification to pull out common code.

Cc: mboton@gmail.com
Cc: Kevin Winchester <kjwinchester@gmail.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 Applies atop the ioport unification fix for 32-bit

 arch/x86/kernel/ioport.c |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index be72d80..50e5e4a 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -113,13 +113,9 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
  * on system-call entry - see also fork() and the signal handling
  * code.
  */
-#ifdef CONFIG_X86_32
-asmlinkage long sys_iopl(unsigned long regsp)
+static int do_iopl(unsigned int level, struct pt_regs *regs)
 {
-	struct pt_regs *regs = (struct pt_regs *)&regsp;
-	unsigned int level = regs->bx;
 	unsigned int old = (regs->flags >> 12) & 3;
-	struct thread_struct *t = &current->thread;
 
 	if (level > 3)
 		return -EINVAL;
@@ -128,25 +124,31 @@ asmlinkage long sys_iopl(unsigned long regsp)
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
 	}
-	t->iopl = level << 12;
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
-	set_iopl_mask(t->iopl);
+
 	return 0;
 }
-#else
-asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
+
+#ifdef CONFIG_X86_32
+asmlinkage long sys_iopl(unsigned long regsp)
 {
-	unsigned int old = (regs->flags >> 12) & 3;
+	struct pt_regs *regs = (struct pt_regs *)&regsp;
+	unsigned int level = regs->bx;
+	struct thread_struct *t = &current->thread;
+	int rc;
 
-	if (level > 3)
-		return -EINVAL;
-	/* Trying to gain more privileges? */
-	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-	}
-	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
+	rc = do_iopl(level, regs);
+	if (rc < 0)
+		goto out;
 
-	return 0;
+	t->iopl = level << 12;
+	set_iopl_mask(t->iopl);
+out:
+	return rc;
+}
+#else
+asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
+{
+	return do_iopl(level, regs);
 }
 #endif
