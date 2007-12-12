Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbXLLWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbXLLWj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXLLWjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:39:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63507 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbXLLWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:39:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vpwt9cFOhzaiKkwYzw3IPEPsExROvq7EpY2rL6W7PQZkK16Fhk0JNkDMAvve9nVhgOWDlujXpLuf22oKvIgDm3FGmcWAenK6PlAGe01D1o7kXVdyfo5xrZCQluXt3qMog251Z86mkNbffZ5A3VY/aTzbWXm8XMqpLw2orWZkZaI=
Message-ID: <9a8748490712121439u34863df9r6ff8d4eadb39705f@mail.gmail.com>
Date: Wed, 12 Dec 2007 23:39:15 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: yield API
Cc: "David Schwartz" <davids@webmaster.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071002064620.GA26638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001173159.GB2492@elte.hu>
	 <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
	 <20071002064620.GA26638@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2007, Ingo Molnar <mingo@elte.hu> wrote:
>
> * David Schwartz <davids@webmaster.com> wrote:
>
> > > These are generic statements, but i'm _really_ interested in the
> > > specifics. Real, specific code that i can look at. The typical Linux
> > > distro consists of in execess of 500 millions of lines of code, in
> > > tens of thousands of apps, so there really must be some good, valid
> > > and "right" use of sched_yield() somewhere in there, in some
> > > mainstream app, right? (because, as you might have guessed it, in
> > > the past decade of sched_yield() existence i _have_ seen my share of
> > > sched_yield() utilizing user-space code, and at the moment i'm not
> > > really impressed by those examples.)
> >
> > Maybe, maybe not. Even if so, it would be very difficult to find.
> > Simply grepping for sched_yield is not going to help because
> > determining whether a given use of sched_yield is smart is not going
> > to be easy.
>
> sched_yield() has been around for a decade (about three times longer
> than futexes were around), so if it's useful, it sure should have grown
> some 'crown jewel' app that uses it and shows off its advantages,
> compared to other locking approaches, right?
>

I have one example of sched_yield() use in a real app. Unfortunately
it's proprietary so I can't show you the source, but I can tell you
how it's used.

The case is this:  Process A forks process B. Process B does some work
that takes aproximately between 50 and 1000ms to complete (varies),
then it creates a file and continues to do other work.  Process A
needs to wait for the file B creates before it can continue.
Process A *could* immediately go into some kind of "check for file;
sleep n ms" loop, but instead it starts off by calling sched_yield()
to give process B a chance to run and hopefully get to the point where
it has created the file before process A is again scheduled and starts
to look for it - after the single sched yield call, process A does
indeed go into a "check for file; sleep 250ms;" loop, but most of the
time the initial sched_yield() call actually results in the file being
present without having to loop like that.

Now is this the best way to handle this situation? No.
Does it work better than just doing the wait loop from the start? Yes.
Is this a good way to use sched_yield()? Maybe, maybe not.  But it
*is* an actual use of the API in a real app.

> For example, if you asked me whether pipes are the best thing for
> certain apps, i could immediately show you tons of examples where they
> are. Same for sockets. Or RT priorities. Or nice levels. Or futexes. Or
> just about any other core kernel concept or API.

True. But in the app I'm talking about above, rewriting the code to
communicate over a pipe, socket or anything else would have been too
large a change to make (released product, can't risk introducing (new)
bugs).

>Your notion that
> showing a good example of an API would be "difficult" because it's hard
> to determine "smart" use is not tenable i believe and does not
> adequately refute my pretty plain-meaning "it does not exist" assertion.
>

I agree that sched_yield() is not a very good API. I also agree that
our use of it is not the best solution to the problem we wanted to
solve, but it actually works pretty well most of the time.

> If then this is one more supporting proof for the fundamental weakness
> of the sched_yield() API. Rarely are we able to so universally condemn
> an API: real-life is usually more varied and even for theoretically
> poorly defined APIs _some_ sort of legitimate use does grow up.
>
> APIs that are not in any real, meaningful use, despite a decade of
> presence are not really interesting to me personally. (especially in
> this case where we know exactly _why_ the API is used so rarely.) Sure
> we'll continue to support it in the best possible way, with the usual
> kernel maintainance policy: without hurting other, more commonly used
> APIs. That was the principle we followed in previous schedulers too. And
> if anyone has a patch to make sched_yield() better than it is today, i'm
> of course interested in it.
>
Just for the record; for our use, sched_yield() seems to work just
fine both with older and newer kernels, so from my point of view the
new scheduler is doing fine in this regard.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
