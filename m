Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYHHGBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYHHGBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYHHGBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:01:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58125
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbYHHGBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:01:39 -0400
Date: Thu, 07 Aug 2008 23:01:39 -0700 (PDT)
Message-Id: <20080807.230139.220174417.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: mikpe@it.uu.se, kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670807070859y74f529b5i60f04e0a37a01cd3@mail.gmail.com>
References: <20080707.040126.178187777.davem@davemloft.net>
	<18546.5247.797478.66373@harpo.it.uu.se>
	<a4423d670807070859y74f529b5i60f04e0a37a01cd3@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Mon, 7 Jul 2008 19:59:04 +0400

> I have turned off LOCKDEP and it boots properly.
> 2.6.26-rc9-00005-g1b40a89
> 
> Mikael's config also does not contain LOCKDEP.

I have finally reproduced the problem locally and figured out the
bug.

Please try this patch:

sparc64: Fix end-of-stack checking in save_stack_trace().

Bug reported by Alexander Beregalov.

Before we dereference the stack frame or try to peek at the
pt_regs magic value, make sure the entire object is within
the kernel stack bounds.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/stacktrace.c b/arch/sparc64/kernel/stacktrace.c
index c73ce3f..c5576e8 100644
--- a/arch/sparc64/kernel/stacktrace.c
+++ b/arch/sparc64/kernel/stacktrace.c
@@ -25,13 +25,15 @@ void save_stack_trace(struct stack_trace *trace)
 
 		/* Bogus frame pointer? */
 		if (fp < (thread_base + sizeof(struct thread_info)) ||
-		    fp >= (thread_base + THREAD_SIZE))
+		    fp > (thread_base + THREAD_SIZE - sizeof(struct sparc_stackf)))
 			break;
 
 		sf = (struct sparc_stackf *) fp;
 		regs = (struct pt_regs *) (sf + 1);
 
-		if ((regs->magic & ~0x1ff) == PT_REGS_MAGIC) {
+		if (((unsigned long)regs <=
+		     (thread_base + THREAD_SIZE - sizeof(*regs))) &&
+		    (regs->magic & ~0x1ff) == PT_REGS_MAGIC) {
 			if (!(regs->tstate & TSTATE_PRIV))
 				break;
 			pc = regs->tpc;
