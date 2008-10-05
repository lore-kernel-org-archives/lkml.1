Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYJEKOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYJEKOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYJEKNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:13:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYJEKNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:13:54 -0400
Date: Sun, 5 Oct 2008 12:13:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081005101341.GH29909@elte.hu>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com> <20081004144423.GA14918@elte.hu> <20081004174121.GA1337@elte.hu> <20081004222713.GA1813@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004222713.GA1813@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> explains that code modification on x86 SMP systems is not only a 
> matter of atomicity, but also a matter of not changing the code 
> underneath a running CPU which is making assumptions that it won't 
> change underneath without issuing a synchronizing instruction before 
> the new code is used by the CPU. The scheme you propose here takes 
> care of atomicity, but does not take care of the synchronization 
> problem. A sync_core() would probably be required when such 
> modification is detected.

that's wrong, my scheme protects against these cases: before _any_ code 
is modified we set the redo_pending atomic flag, and make sure that 
previous NMI handlers have stopped executing. (easy enough)

then the atomic update of redo_pending should be a sufficient barrier 
for another CPU to notice the pending transaction.

Note that the cross-CPU modification can still be 'half done' when the 
NMI hits, that's why we execute modify_code_redo() to 'redo' the full 
modification before executing further NMI code. That is executed _on the 
CPU_ that triggers an NMI, and the CPU itself is self-consistent.

( The modify_code_redo() will have to do a sync_cores() of course, like 
  all self-modifying code, to flush speculative execution. )

> Also, speaking of plain atomicity, you scheme does not seem to protect 
> against NMIs running on a different CPU, because the non-atomic change 
> could race with such NMI.

That's wrong too. Another CPU will notice that redo_pending is set and 
will execute modify_code_redo() from its NMI handler _before_ calling 
all the notifiers and other 'wide' code paths.

the only item that needs to be marked 'notrace' is only the highlevel 
do_nmi() handler itself. (as that executes before we have a chance to 
execute modify_code_redo())

So we trade a large, fragile, and unmapped set of NMI-implicated 
codepaths for a very tight and well controlled an easy to maintain 
codepath.

	Ingo
