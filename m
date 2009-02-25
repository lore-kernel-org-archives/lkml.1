Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZBYIad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZBYIad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZBYIaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:30:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58196 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbZBYIaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:30:23 -0500
Date: Wed, 25 Feb 2009 09:29:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090225082958.GA9322@elte.hu>
References: <20090224020304.GA4496@google.com> <200902251423.58861.nickpiggin@yahoo.com.au> <20090225072503.GD21903@elte.hu> <200902251909.42928.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902251909.42928.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 25 February 2009 18:25:03 Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Wednesday 25 February 2009 02:52:34 Linus Torvalds wrote:
> > > > On Tue, 24 Feb 2009, Nick Piggin wrote:
> > > > > > it does make some kind of sense to try to avoid the noncached
> > > > > > versions for small writes - because small writes tend to be for
> > > > > > temp-files.
> > > > >
> > > > > I don't see the significance of a temp file. If the pagecache is
> > > > > truncated, then the cachelines remain dirty and so you can't avoid an
> > > > > eventual store back to RAM?
> > > >
> > > > No, because many small files end up being used as scratch-pads (think
> > > > shell script sequences etc), and get read back immediately again. Doing
> > > > non-temporal stores might just be bad simply because trying to play
> > > > games with caching may simply do the wrong thing.
> > >
> > > OK, for that angle it could make sense. Although as has been
> > > noted earlier, at this point of the copy, we don't have much
> > > idea about the length of the write passed into the vfs (and
> > > obviously will never know the higher level intention of
> > > userspace).
> > >
> > > I don't know if we can say a 1 page write is nontemporal, but
> > > anything smaller is temporal. And having these kinds of
> > > behavioural cutoffs I would worry will create strange
> > > performance boundary conditions in code.
> >
> > I agree in principle.
> >
> > The main artifact would be the unaligned edges around a bigger
> > write. In particular the tail portion of a big write will be
> > cached.
> >
> > For example if we write a 100,000 bytes file, we'll copy the
> > first 24 pages (98304 bytes) uncached, while the final 1696
> > bytes cached. But there is nothing that necessiates this
> > assymetry.
> >
> > For that reason it would be nice to pass down the total size of
> > the write to the assembly code. These are single-usage-site APIs
> > anyway so it should be easy.
> >
> > I.e. something like the patch below (untested). I've extended
> > the copy APIs to also pass down a 'total' size as well, and
> > check for that instead of the chunk 'len'. Note that it's
> > checked in the inlined portion so all the "total == len" special
> > cases will optimize out the new parameter completely.
> 
> This does give more information, not exactly all (it could be 
> a big total write with many smaller writes especially if the 
> source is generated on the fly and will be in cache, or if the 
> source is not in cache, then we would also want to do 
> nontemporal loads from there etc etc).

A big total write with many smaller writes should already be 
handled in this codepath, as long as it's properly iovec-ed.

We can do little about user-space doing stupid things as doing a 
big write as a series of many smaller-than-4K writes.

> > This should express the 'large vs. small' question 
> > adequately, with no artifacts. Agreed?
> 
> Well, no artifacts, but it still has a boundary condition 
> where one might cut from temporal to nontemporal behaviour.
> 
> If it is a *really* important issue, maybe some flags should 
> be incorporated into an extended API? It not, then I wonder if 
> it is important enough to add such complexity for?

the iozone numbers in the old commits certainly are convincing. 
The new numbers from Salman are convincing too - and his fix 
should preserve the iozone [large-write] numbers as well.

I.e. i think this is a reasonable compromise, it should handle 
all the sane cases.

	Ingo
