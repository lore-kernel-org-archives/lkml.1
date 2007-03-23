Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXCWV0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXCWV0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbXCWV0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:26:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356AbXCWV0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:26:39 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] i386: clear segment register padding in core dumps
Message-Id: <20070323212633.44D631801C4@magilla.sf.frob.com>
Date: Fri, 23 Mar 2007 14:26:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The segment register slots in struct pt_regs are padded to 32 bits.
Some of these are stored with instructions like "pushl %es", which
leaves the high 16 bits as they were.  So the high bits of these
fields in struct pt_regs contain kernel stack garbage.  These bits are
ignored by everything and never leak to user space, except in core
dumps.  The user struct pt_regs is always at the base of the thread's
kernel stack and so it seems unlikely the information that leaks from
here is ever worthwhile so as to be a security concern, but I'm not
sure about that.  It has been this way for ages; userland consumers of
core dumps all mask off these high bits themselves.  So it is not urgent.

This change masks off the padding bits of the segment register slots
in core dumps.  ptrace already masks off these high bits, so this
makes the values in core dumps consistent with what ptrace would
report just before the process died.

As I read the processor manuals, the cs and ss values will always be
padded with zero bits rather than stack garbage.  But unlike "pushl %es",
this is not simple to test with a userland program.  So I added the two
instructions rather than wonder if they are really never necessary.

I think that x86_64 does not have this problem (for either 32-bit or
64-bit processes).  It only uses "mov" instructions from segment
registers, which zero-extend.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-i386/elf.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-i386/elf.h b/include/asm-i386/elf.h
index 8d33c9b..793bbd1 100644  
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -88,16 +88,16 @@ typedef struct user_fxsr_struct elf_fpxr
 	pr_reg[4] = regs->edi;				\
 	pr_reg[5] = regs->ebp;				\
 	pr_reg[6] = regs->eax;				\
-	pr_reg[7] = regs->xds;				\
-	pr_reg[8] = regs->xes;				\
-	pr_reg[9] = regs->xfs;				\
+	pr_reg[7] = regs->xds & 0xffff;			\
+	pr_reg[8] = regs->xes & 0xffff;			\
+	pr_reg[9] = regs->xfs & 0xffff;			\
 	savesegment(gs,pr_reg[10]);			\
 	pr_reg[11] = regs->orig_eax;			\
 	pr_reg[12] = regs->eip;				\
-	pr_reg[13] = regs->xcs;				\
+	pr_reg[13] = regs->xcs & 0xffff;		\
 	pr_reg[14] = regs->eflags;			\
 	pr_reg[15] = regs->esp;				\
-	pr_reg[16] = regs->xss;
+	pr_reg[16] = regs->xss & 0xffff;
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports.  This could be done in user space,
