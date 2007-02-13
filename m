Return-Path: <linux-kernel-owner+w=401wt.eu-S1751359AbXBMW1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbXBMW1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXBMW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:27:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXBMW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:27:37 -0500
Date: Tue, 13 Feb 2007 23:24:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070213222443.GH22104@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142035.GF638@elte.hu> <p73bqjxhcnl.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73bqjxhcnl.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4616]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > +
> > +static struct async_thread *
> > +pick_ready_cachemiss_thread(struct async_head *ah)
> 
> The cachemiss names are confusing. I assume that's just a left over 
> from Tux?

yeah. Although 'stuff goes async' is quite similar to a cachemiss. We 
didnt have some resource available right now so the syscall has to block 
== i.e. some cache was not available.

> > +
> > +	memset(atom->args, 0, sizeof(atom->args));
> > +
> > +	ret |= __get_user(arg_ptr, &uatom->arg_ptr[0]);
> > +	if (!arg_ptr)
> > +		return ret;
> > +	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
> > +		return -EFAULT;
> 
> It's a little unclear why you do that many individual access_ok()s. 
> And why is the target constant sized anyways?

each indirect pointer has to be checked separately, before dereferencing 
it. (Andrew pointed out that they should be VERIFY_READ, i fixed that in 
my tree)

it looks a bit scary in C but the assembly code is very fast and quite 
straightforward.

> +	/*
> +	 * Lock down the ring. Note: user-space should not munlock() this,
> +	 * because if the ring pages get swapped out then the async
> +	 * completion code might return a -EFAULT instead of the expected
> +	 * completion. (the kernel safely handles that case too, so this
> +	 * isnt a security problem.)
> +	 *
> +	 * mlock() is better here because it gets resource-accounted
> +	 * properly, and even unprivileged userspace has a few pages
> +	 * of mlock-able memory available. (which is more than enough
> +	 * for the completion-pointers ringbuffer)
> +	 */
> 
> If it's only a few pages you don't need any resource accounting. If 
> it's more then it's nasty to steal the users quota. I think plain 
> gup() would be better.

get_user_pages() would have to be limited in some way - and i didnt want 
to add yet another wacky limit thing - so i just used the already 
existing mlock() infrastructure for this. If Oracle wants to set up a 10 
MB ringbuffer, they can set the PAM resource limits to 11 MB and still 
have enough stuff left. And i dont really expect GPG to start using 
syslets - just yet ;-)

a single page is enough for 1024 completion pointers - that's more than 
enough for most purposes - and the default mlock limit is 40K.

	Ingo
