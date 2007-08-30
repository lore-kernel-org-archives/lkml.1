Return-Path: <linux-kernel-owner+w=401wt.eu-S1763311AbXH3Wob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311AbXH3Wob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763375AbXH3WoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:44:11 -0400
Received: from ozlabs.org ([203.10.76.45]:47250 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763343AbXH3WoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:44:10 -0400
Subject: [PATCH] Fix out-by-one error in traps.c
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Frederik Deweerdt <deweerdt@free.fr>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <20070830163812.GA22190@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070822202551.GB31846@slug>
	 <20070823145038.9895784f.akpm@linux-foundation.org>
	 <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
	 <20070824082249.GG31846@slug>
	 <1188043649.20041.81.camel@localhost.localdomain>
	 <20070825122324.GA6138@slug> <20070825211405.GA18217@slug>
	 <1188230999.5531.15.camel@localhost.localdomain>
	 <20070830163812.GA22190@slug>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 08:14:26 +1000
Message-Id: <1188512066.6353.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't care if ebp is on the stack, we care about ebp + 4.  Without
this, lguest (with CONFIG_DEBUG_LOCKDEP) can touch a page unmapped by
CONFIG_DEBUG_PAGEALLOC.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r b0b1ab8ecf48 arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c	Fri Aug 31 03:25:06 2007 +1000
+++ b/arch/i386/kernel/traps.c	Fri Aug 31 07:57:35 2007 +1000
@@ -100,7 +100,7 @@ print_context_stack(struct thread_info *tinfo,
 	unsigned long addr;
 
 #ifdef	CONFIG_FRAME_POINTER
-	while (valid_stack_ptr(tinfo, (void *)ebp)) {
+	while (valid_stack_ptr(tinfo, (void *)ebp + 4)) {
 		unsigned long new_ebp;
 		addr = *(unsigned long *)(ebp + 4);
 		ops->address(data, addr);


