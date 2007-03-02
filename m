Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXCBUhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXCBUhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXCBUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:37:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961AbXCBUhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:37:04 -0500
Date: Fri, 2 Mar 2007 21:29:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070302202931.GA5101@elte.hu>
References: <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu> <20070301153655.GB8217@2ka.mipt.ru> <20070302105713.GB15576@elte.hu> <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com> <20070302193941.GB8450@elte.hu> <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> I think that the "dirty" FPU context must, at least, follow the new 
> head. That's what the userspace sees, and you don't want an async_exec 
> to re-emerge with a different FPU context.

well. I think there's some confusion about terminology, so please let me 
describe everything in detail. This is how execution goes:

  outer loop() {
      call_threadlet();
  }

this all runs in the 'head' context. call_threadlet() always switches to 
the 'threadlet stack'. The 'outer context' runs in the 'head stack'. If, 
while executing the threadlet function, we block, then the 
threadlet-thread gets to keep the task (the threadlet stack and also the 
FPU), and blocks - and we pick a 'new head' from the thread pool and 
continue executing in that context - right after the call_threadlet() 
function, in the 'old' head's stack. I.e. it's as if we returned 
immediately from call_threadlet(), with a return code that signals that 
the 'threadlet went async'.

now, the FPU state that was when the threadlet blocked is totally 
meaningless to the 'new head' - that FPU state is from the middle of the 
threadlet execution.

and here is where thinking about threadlets as a function call and not 
as an asynchronous context helps alot: the classic gcc convention for 
FPU use & function calls should apply: gcc does not call an external 
function with an in-use FPU stack/register, it always neatly unuses it, 
as no FPU register is callee-saved, all are caller-saved.

> So, IMO, if the USEDFPU bit is set, we need to sync the dirty FPU 
> context with an early unlazy_fpu(), *and* copy the sync'd FPU context 
> to the new head. This should really be a fork of the dirty FPU context 
> IMO, and should only happen if the USEDFPU bit is set.

why? The only effect this will have is a slowdown :) The FPU context 
from the middle of the threadlet function is totally meaningless to the 
'new head'. It might be anything. (although in practice system calls are 
almost never called with a truly in-use FPU.)

	Ingo
