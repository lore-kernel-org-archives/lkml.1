Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZEPKl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZEPKl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 06:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZEPKlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 06:41:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbZEPKlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 06:41:15 -0400
Date: Sat, 16 May 2009 12:39:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
       Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Message-ID: <20090516103909.GB6261@elte.hu>
References: <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar> <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain> <20090515134717.GA16389@elte.hu> <20090516100039.GA24619@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516100039.GA24619@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Willy Tarreau <w@1wt.eu> wrote:

> On Fri, May 15, 2009 at 03:47:17PM +0200, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Thu, 14 May 2009, Jake Edge wrote:
> > > >
> > > > It seems like this should be queued up for stable, yes?  I 
> > > > just saw the 2.6.29.4 review patches go out, but this wasn't 
> > > > part of it ...
> > > 
> > > Well, I was hoping to maybe have actual timing numbers from 
> > > some better hash, in case Matt can make one that is efficient 
> > > enough. So I committed the randomness improvement as a clear 
> > > _improvement_ over what we had, but it may not be the final 
> > > version.
> > 
> > yep, it was just a quick hack really. If someone can do a 
> > stronger hash that also happens to be faster i guess we all will 
> > be happy campers. The performance figures showed room for 
> > improvement - how well are those hashes optimized? Many 
> > thousands of cycles ... is that really justified?
> 
> In fact we must keep in mind that those hashes produce far more 
> data than we need and we're throwing that data to the bin on every 
> call. If we use SHA1, we get 160 bits. We should save them and 
> return them by 5 packets of 32 bits, then only call SHA1 once 
> every 5 calls. That way, we get one slower exec every 5 calls but 
> faster calls on average.

Good idea ...

> And if we can't get a good hash to be fast enough, let's make this 
> configurable. Most of us won't ever care about the strength of the 
> hash. People concerned about security won't care about the slower 
> hash. If we set the slower hash by default and have a tunable for 
> it, everyone will have the solution that fits them.

Bad idea IMHO ...

It is a bad idea because such sort of tunables do not really help 
the user as those who tweak are a distinct minority.

Also, having a two-way hack _hinders_ your good idea from being 
adopted for example. Why bother with a faster hash and with using 
the resulting bits sparingly if we can get an 'easy' tunable in and 
can have two sub-par solutions instead of one (harder to implement) 
good solution?

So tunables are really counter-productive - and this is a pet peeve 
of mine.

Every time we have such a tunable for something fundamental we've 
not improved the kernel, we've documented a _failure_ in kernel 
design and implementation.

Sure, we do use tunables for physical constants, limits and other 
natural parameters - and _sometimes_ we just grudingly admit defeat 
and admit that something is really impossible to implement. IMHO 
here we are not at that point yet, at all.

	Ingo
