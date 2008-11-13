Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYKMQHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYKMQHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYKMQGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:06:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59407 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYKMQGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:06:51 -0500
Date: Thu, 13 Nov 2008 17:06:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081113160633.GA13095@elte.hu>
References: <20081113072821.GB2946@wotan.suse.de> <20081113074109.GB1723@elte.hu> <20081113075022.GC2946@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113075022.GC2946@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > 32-bit should use oops_begin() too. Solves the previous comment as 
> > well.
> > 
> > > +#ifdef CONFIG_X86_32
> > > +	die("Oops", regs, error_code);
> > > +	bust_spinlocks(0);
> > > +	do_exit(SIGKILL);
> > > +#else
> > > +	if (__die("Oops", regs, error_code))
> > > +		regs = NULL;
> > > +	/* Executive summary in case the body of the oops scrolled away */
> > > +	printk(KERN_EMERG "CR2: %016lx\n", address);
> > > +	oops_end(flags, regs, SIGKILL);
> > > +#endif
> > 
> > this difference seems unnecessary too - 32-bit should use oops_end() 
> > too.
> 
> Probably all 3 good comments, but I didn't want to be tempted into 
> changing behaviour (modulo adding bugs). Easy to merge them up in a 
> subsequent patch, however...

please do feel tempted to clean this code up - and if it changes 
behavior, split it up into smaller steps. The patch is already quite 
large with a flux of 430 lines:

 1 file changed, 251 insertions(+), 188 deletions(-)

... your primary goal is faster code, we also want cleaner code. I 
think we can meet in the middle, have faster _and_ cleaner code, and 
it's a done deal ;)

	Ingo
