Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbZEKWkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbZEKWkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZEKWkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:40:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbZEKWkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:40:39 -0400
Date: Tue, 12 May 2009 00:40:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -rc] [BUGFIX] x86: fix kernel_trap_sp()
Message-ID: <20090511224001.GA8198@elte.hu>
References: <20090511210300.17332.67549.stgit@localhost.localdomain> <alpine.LFD.2.01.0905111512240.3586@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905111512240.3586@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 11 May 2009, Masami Hiramatsu wrote:
> >
> > Use &regs->sp instead of regs for getting the top of stack in kernel mode.
> > (on x86-64, regs->sp always points the top of stack)
> 
> Ack. 
> 
> That said, we have only _one_ use of this "kernel_trap_sp()" in 
> the whole kernel, and that use is actually fairly odd too, in that 
> it does it _before_ checking that it's in kernel mode.
> 
> Admittedly it will then only _use_ the value after it has checked 
> that things are in kernel mode, but it all boils down to "ok, 
> that's pretty odd".
> 
> So how about fixing that, and also fixing the naming of the 
> function. Call it "kernel_stack_pointer()" to match its more 
> widely used sibling function "user_stack_pointer()".
> 
> IOW, something like this?

yeah, this is cleaner and probably a tad faster. I've applied it to 
x86/urgent with your acked-by - or would you like to apply this 
straight away?

The use of the backtracing feature on the oprofile side is not very 
common (and the bug is ancient) so i wanted to wait a few days with 
this.

One small detail:

> +	return (unsigned long)(&regs->sp);

the original commit had:

> +	return (unsigned long)&regs->sp;

and this latter is correct as well due to operator priorities. No 
strong preference from my side so i took your version as-is. I kept 
Masami as the author and a comment for your changes.

( Not sure how to express this in a changelog properly - i didnt 
  want two commits but it was authored by two people in essence. So 
  i went for the version that will show up in the commit 
  notification email in a few minutes - also attached below. )

	Ingo
