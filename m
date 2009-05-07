Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZEGRAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZEGRAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZEGQ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:59:54 -0400
Received: from waste.org ([66.93.16.53]:38254 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZEGQ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:59:53 -0400
Date: Thu, 7 May 2009 11:55:45 -0500
From: Matt Mackall <mpm@selenic.com>
To: Florian Weimer <fweimer@bfk.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090507165545.GK31071@waste.org>
References: <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <82prel54fo.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82prel54fo.fsf@mid.bfk.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:16:27PM +0200, Florian Weimer wrote:
> * Matt Mackall:
> 
> > On Wed, May 06, 2009 at 09:48:20AM -0700, Linus Torvalds wrote:
> >> 
> >> Matt, are you willing to ack my suggested patch which adds history to the 
> >> mix? Did somebody test that? I have this memory of there being an 
> >> "exploit" program to show the non-randomness of the values, but I can't 
> >> recall details, and would really want to get a second opinion from 
> >> somebody who cares about PRNG's.
> >
> > I still don't like it. I bounced it off some folks on the adversarial
> > side of things and they didn't think it looked strong enough either.
> > Full MD5 collisions can be generated about as fast as they can be
> > checked, which makes _reduced strength_ MD4 not much better than an
> > LFSR in terms of attack potential.
> 
> Well, with periodic reseeding, even that shouldn't be a problem.  You
> don't need collision resistance at all, so those MD5 attacks don't
> tell you anything about the difficulty of state recovery/prediction
> attacks on your variant.

It's *not* MD5. It's a reduced-round MD4. And MD4 is already many
orders of magnitude weaker than MD5. It's so weak in fact that
collisions can be generated in O(1)[1]. Hard to get much weaker than
that, except by, say, using something like our reduced-round variant.

It's not much of a stretch of the imagination to think that such an
amazingly weak hash might reveal our hidden state quite rapidly,
especially when used in a feedback mode.

[1] http://eprint.iacr.org/2005/151.pdf

We have a better hash function handy, and it's only takes twice as long.

> On the other hand, most people who need a quick, unpredictable source
> of randomness seem to use RC4 with a random key initialized from a
> more costly source.

Using a stream cipher is a fine idea. Ted and I have recently
discussed adding this as a layer to the stock RNG. We haven't used it
historically because of a) export restrictions and b) unsuitability of
the cryptoapi interface.

> Oh, and you should really, really ditch that Tausworthe generator (in
> lib/random32.c).

I'm not responsible for that particular bad idea.

-- 
Mathematics is the supreme nostalgia of our time.
