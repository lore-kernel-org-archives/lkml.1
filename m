Return-Path: <linux-kernel-owner+w=401wt.eu-S934598AbXGQQEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598AbXGQQEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXGQQEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:04:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46610 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbXGQQEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:04:43 -0400
Date: Tue, 17 Jul 2007 18:04:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Chuck Ebbert <76306.1226@compuserve.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [patch] i386: remove unnecessary code
Message-ID: <20070717160425.GA26401@elte.hu>
References: <20070717154638.GA342@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717154638.GA342@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> I am really puzzled by set_fs(USER_DS) in setup_frame/setup_rt_frame.
> 
> How is it possible that current->addr_limit != USER_DS ? If this _is_ 
> possible, how can can we trust the result of access_ok() above?

hm, this is _ancient_ code (possibly dating back to the pharaohs). If we 
are in KERNEL_DS then we call do_signal() then we are most likely a 
kernel thread and regs->esp points to the kernel stack ... the result of 
which would be a quite spectacular crash anyway.

Patch below.

	Ingo

----------------------------->
Subject: [patch] i386: remove unnecessary code
From: Ingo Molnar <mingo@elte.hu>

Oleg Nesterov pointed out that the set_fs() calls in setup_frame()
and setup_rt_frame() were superfluous.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/signal.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/arch/i386/kernel/signal.c
===================================================================
--- linux.orig/arch/i386/kernel/signal.c
+++ linux/arch/i386/kernel/signal.c
@@ -380,7 +380,6 @@ static int setup_frame(int sig, struct k
 	regs->edx = (unsigned long) 0;
 	regs->ecx = (unsigned long) 0;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
@@ -474,7 +473,6 @@ static int setup_rt_frame(int sig, struc
 	regs->edx = (unsigned long) &frame->info;
 	regs->ecx = (unsigned long) &frame->uc;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
