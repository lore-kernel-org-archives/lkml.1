Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXHaGEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXHaGEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 02:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbXHaGEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 02:04:25 -0400
Received: from ozlabs.org ([203.10.76.45]:54424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbXHaGEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 02:04:24 -0400
Subject: Re: [PATCH] Fix out-by-one error in traps.c
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Frederik Deweerdt <deweerdt@free.fr>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <alpine.LFD.0.999.0708302140480.25853@woody.linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070822202551.GB31846@slug>
	 <20070823145038.9895784f.akpm@linux-foundation.org>
	 <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
	 <20070824082249.GG31846@slug>
	 <1188043649.20041.81.camel@localhost.localdomain>
	 <20070825122324.GA6138@slug> <20070825211405.GA18217@slug>
	 <1188230999.5531.15.camel@localhost.localdomain>
	 <20070830163812.GA22190@slug>
	 <1188512066.6353.5.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708302140480.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 16:03:58 +1000
Message-Id: <1188540238.6004.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 21:44 -0700, Linus Torvalds wrote:
> 
> On Fri, 31 Aug 2007, Rusty Russell wrote:
> >
> > We don't care if ebp is on the stack, we care about ebp + 4.  Without
> > this, lguest (with CONFIG_DEBUG_LOCKDEP) can touch a page unmapped by
> > CONFIG_DEBUG_PAGEALLOC.
> 
> Hmm.. This *really* cannot happen with a normal kernel - it implies that 
> the stack has crossed into an invalid page. 

AFAICT, a corrupt stack could lead us to touch a page which isn't
mapped.  If we assume the stack isn't corrupt, we don't have to do the
valid_stack_ptr() check at all...

> Why is that allowed with lguest? What kind of code could validly *ever* 
> come in here and cause problems?

head.S pushes a "$0" on the stack to stop the unwinder, lguest doesn't.

Here's the lguest fix, but I still think the real fix posted previously
is more important.

Cheers,
Rusty.
===
lguest doesn't terminate stack, upsets unwinder

Copy head.S, which puts a 0 on the stack to terminate ebp-chasing
backtrace code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 926e5cc964fd drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S	Fri Aug 31 08:02:08 2007 +1000
+++ b/drivers/lguest/lguest_asm.S	Fri Aug 31 16:01:25 2007 +1000
@@ -19,6 +19,8 @@
  	movl $(init_thread_union+THREAD_SIZE),%esp
 	movl %esi, %eax
 	addl $__PAGE_OFFSET, %eax
+	/* Fake value to stop backtraces with CONFIG_FRAME_POINTER */
+	pushl $0
 	jmp lguest_init
 
 /*G:055 We create a macro which puts the assembler code between lgstart_ and


