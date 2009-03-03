Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZCCApP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZCCApP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZCCApB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:45:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZCCApA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:45:00 -0500
Date: Tue, 3 Mar 2009 01:44:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303004427.GA8638@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021542.25153.david-b@pacbell.net> <20090302235327.GB19084@elte.hu> <200903021633.08736.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903021633.08736.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> On Monday 02 March 2009, Ingo Molnar wrote:
> > > 
> > > The significant omission is lack of support for chaining
> > > such threads.  Example, an I2C device that exposes
> > > several dozen IRQs with mask/ack/... operations that
> > > require I2C access.
> > 
> > Well, those are rarely used, embedded-only constructs - the main 
> > focus of IRQ threading patches are the more common patterns.
> 
> Yes, mostly for embedded, where "system bus" more likely
> means I2C than PCI.
> 
> 
> > Since you care about them - could you please send patches on top 
> > of the IRQ threading patches to add support for them?
> 
> I'll look at that, and try to prepare something on top
> of the version of the threading patches that gets into
> the -next tree.  I got the impression there was going
> to be a v3 of those patches soonish...

Great! We'll sort out any conflicts so dont worry about that - 
you can pick up v2 just fine and post patches.

> I expect there will be two basic parts of that work:
> 
>  - One to cope with the upcoming change to handle_irq(),
>    insisting that it live in hardirq context instead of
>    just an irqs-off context (and thereby preventing use
>    of standard chaining calls in irq threads, sigh).
> 
>  - Another to set up a chaining thread, since chain
>    setup bypasses setup_irq() and friends.

If you mean to push the chaining bits into the IRQ thread too, i 
think the chaining bits actually should never be threaded. Is 
there a good reason to do that? It's not like they will really 
be preemptible (preempting a chaining thread would mean the 
whole demuxing chain is held up => bad).

> That latter might touch what the v2 patches added,
> since I'd want it to share code.

Sure.

> 
> - Dave
> 
> p.s. Note that those changes would still leave the
>      lockdep bug around ... it will still be breaking
>      various drivers that use normal IRQs, by forcibly
>      enabling IRQF_DISABLED.

it's not a bug - and i think Peter explained that already. It's 
not really breaking things either - we've had this for more than 
2 years.

	Ingo
