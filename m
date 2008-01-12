Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbYALBFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbYALBFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761552AbYALBFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:05:22 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60338 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859AbYALBFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:05:22 -0500
Date: Fri, 11 Jan 2008 17:04:44 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mboton@gmail.com" <mboton@gmail.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: [PATCH] x86: fix ioport unification on 32-bit [was: Re: hwclock
	failure in x86.git]
Message-ID: <20080112010443.GA5476@sequoia.sous-sol.org>
References: <4786AA11.5010805@gmail.com> <4786AB1B.4030004@zytor.com> <4786AF4C.6050509@gmail.com> <4786C2CF.4070204@zytor.com> <20080110220444.4c9efdec.kjwinchester@gmail.com> <20080111140346.GA13604@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111140346.GA13604@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> thanks for tracking it down. I pulled that commit for now. But it would 
> be nice to figure out what's going on there.

Zach was right. The unification was broken for 32-bit; it was missing
the actual pushf/popf EFLAGS manipluation (set_iopl_mask()) and would've
broken task switching between processes w/ different iopl in paravirt
guests too.  64-bit sys_iopl just does pt_regs->flags modification and
lets syscall/sysret plus ptregscall sync and do EFLAGS update.

Also, use of volatile looks like leftover cruft.

This patch in on top of Miguel's (can respin to standalone if that's better).
Tested (on both 32 and 64-bit) with simple:

  #include <stdlib.h>
  #include <sys/io.h>
  
  main()
  {
  	if (iopl(3) == 0)
  		asm ("cli\nsti\n"::);
  }

thanks,
-chris
--

From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] x86: fix ioport unification on 32-bit

ioport unification was broken for 32-bit; it was missing
the acutal pushf/popf EFLAGS manipulation (set_iopl_mask()).
Also, use of volatile looks like leftover cruft.

Cc: mboton@gmail.com
Cc: Kevin Winchester <kjwinchester@gmail.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/ioport.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index e723ff3..be72d80 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -116,9 +116,10 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 #ifdef CONFIG_X86_32
 asmlinkage long sys_iopl(unsigned long regsp)
 {
-	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
+	struct pt_regs *regs = (struct pt_regs *)&regsp;
 	unsigned int level = regs->bx;
 	unsigned int old = (regs->flags >> 12) & 3;
+	struct thread_struct *t = &current->thread;
 
 	if (level > 3)
 		return -EINVAL;
@@ -127,8 +128,9 @@ asmlinkage long sys_iopl(unsigned long regsp)
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
 	}
+	t->iopl = level << 12;
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
-
+	set_iopl_mask(t->iopl);
 	return 0;
 }
 #else
