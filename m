Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXCYO5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXCYO5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXCYO5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:57:25 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34024 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbXCYO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:57:24 -0400
Date: Sun, 25 Mar 2007 16:57:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [-mm patch] lguest: remove check_bug_kill()
Message-ID: <20070325145728.GE16477@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070324130639.GG752@stusta.de> <1174808025.6281.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1174808025.6281.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 05:33:45PM +1000, Rusty Russell wrote:
> On Sat, 2007-03-24 at 14:06 +0100, Adrian Bunk wrote:
> > On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
> > >...
> > > Changes since 2.6.21-rc3-mm1:
> > >...
> > > +lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
> > >...
> > >  x86/x86_64 updates
> > >...
> > 
> > 
> > check_bug_kill() is no longer used.
> 
> Thanks Adrian, that was actually an oversight.  However, this function
> is most useful in early bringup, so I didn't notice it was gone.
> 
> I'd prefer a patch which eliminates it altogether, rather than #if 0 it
> out.

Patch below.

> Thanks!
> Rusty.

cu
Adrian


<--  snip  -->


check_bug_kill() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/lguest/interrupts_and_traps.c |   27 ------------------------
 arch/i386/lguest/lg.h                   |    1 
 2 files changed, 28 deletions(-)

--- linux-2.6.21-rc4-mm1/arch/i386/lguest/lg.h.old	2007-03-25 14:38:22.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/lguest/lg.h	2007-03-25 14:41:13.000000000 +0200
@@ -195,7 +195,6 @@
 /* interrupts_and_traps.c: */
 void maybe_do_interrupt(struct lguest *lg);
 int deliver_trap(struct lguest *lg, unsigned int num);
-void check_bug_kill(struct lguest *lg);
 void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
 void pin_stack_pages(struct lguest *lg);
 void pin_trap_pages(struct lguest *lg);
--- linux-2.6.21-rc4-mm1/arch/i386/lguest/interrupts_and_traps.c.old	2007-03-25 14:38:46.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/lguest/interrupts_and_traps.c	2007-03-25 14:41:25.000000000 +0200
@@ -118,33 +118,6 @@
 	return 1;
 }
 
-void check_bug_kill(struct lguest *lg)
-{
-#ifdef CONFIG_BUG
-	u32 eip = lg->regs->eip - PAGE_OFFSET;
-	u16 insn;
-
-	/* This only works for addresses in linear mapping... */
-	if (lg->regs->eip < PAGE_OFFSET)
-		return;
-	lhread(lg, &insn, eip, sizeof(insn));
-	if (insn == 0x0b0f) {
-#ifdef CONFIG_DEBUG_BUGVERBOSE
-		u16 l;
-		u32 f;
-		char file[128];
-		lhread(lg, &l, eip+sizeof(insn), sizeof(l));
-		lhread(lg, &f, eip+sizeof(insn)+sizeof(l), sizeof(f));
-		lhread(lg, file, f - PAGE_OFFSET, sizeof(file));
-		file[sizeof(file)-1] = 0;
-		kill_guest(lg, "BUG() at %#x %s:%u", eip, file, l);
-#else
-		kill_guest(lg, "BUG() at %#x", eip);
-#endif	/* CONFIG_DEBUG_BUGVERBOSE */
-	}
-#endif	/* CONFIG_BUG */
-}
-
 static int direct_trap(const struct lguest *lg,
 		       const struct desc_struct *trap,
 		       unsigned int num)

