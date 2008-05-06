Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbYEFRum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbYEFRum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYEFRuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:50:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYEFRuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:50:09 -0400
Date: Tue, 6 May 2008 19:49:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506174954.GB9014@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080506173128.GM19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506173128.GM19219@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> > down(), down_interruptible() and down_try() should use 
> > spin_lock_irq(), not irqsave.
> 
> We talked about this ... the BKL actually requires that you be able to 
> acquire it with interrupts disabled. [...]

hm, where does it require it, besides the early bootup code? (which 
should just be fixed)

down_trylock() is OK as irqsave/irqrestore for legacy reasons, but that 
is fundamentally atomic anyway.

> > up() seems to be doing wake-one, FIFO which is nice.  Did the 
> > implementation which we just removed also do that?  Was it perhaps 
> > accidentally doing LIFO or something like that?
> 
> That's a question for someone who knows x86 assembler, I think.

the assembly is mostly just for the fastpath - and a 40% regression 
cannot be about fastpath differences. In the old code the scheduling 
happens in lib/semaphore-sleeper.c, and from the looks of it it appears 
to be a proper FIFO as well. (plus this small wakeup weirdness it has)

i reviewed the new code in kernel/semaphore.c as well and can see 
nothing bad in it - it does proper wake-up, FIFO queueing, like the 
mutex code.

	Ingo
