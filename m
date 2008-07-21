Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbYGURls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbYGURls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYGURlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:41:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38914 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYGURlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:41:39 -0400
Date: Mon, 21 Jul 2008 18:41:26 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: BUILD_IRQ say .text to avoid .data.percpu
Message-ID: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I edit the x86_64 Makefile to -fno-unit-at-a-time, bootup panics
on 0xCCs in IRQ0x3e_interrupt(): IRQ0x20_interrupt etc. have got linked
into .data.percpu.  Perhaps there are other ways of triggering that:
specify ".text" in the BUILD_IRQ() macro for safety.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I've been using -fno-unit-at-a-time (to lessen inlining, for easier
debugging) for a long time, but never saw this until Mike's percpu mods
came in: I mention this so you're on the lookout, just in case other
things are more likely to go into the wrong section now.  (I did give
Mike a private headsup on this a couple of weeks ago, in case it helped
with problems he was having with percpu, but in fact it didn't help.)

 arch/x86/kernel/irqinit_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.26-git/arch/x86/kernel/irqinit_64.c	2008-07-18 11:33:31.000000000 +0100
+++ linux/arch/x86/kernel/irqinit_64.c	2008-07-18 16:07:00.000000000 +0100
@@ -43,7 +43,7 @@
 
 #define BUILD_IRQ(nr)				\
 	asmlinkage void IRQ_NAME(nr);		\
-	asm("\n.p2align\n"			\
+	asm("\n.text\n.p2align\n"		\
 	    "IRQ" #nr "_interrupt:\n\t"		\
 	    "push $~(" #nr ") ; "		\
 	    "jmp common_interrupt");
