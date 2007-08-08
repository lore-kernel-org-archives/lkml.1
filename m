Return-Path: <linux-kernel-owner+w=401wt.eu-S935465AbXHHXvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935465AbXHHXvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbXHHXvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:51:32 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:38242 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXHHXva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BBCfiAtlLEA1sF5+fuRZdDBkes8NelnNkPnRyYbRe9+bCeVticEWt3/Rew8kA9ieWkYNZFO4ZWYwVEAbLzllYtoVxFVWihQDx2zX7tEPoloFlte0XSTcKkjLqtP0GxcZOqSdgTSyWaR4isLUUlIKM59tu4TPG8gkQJQb1fR5ry4=
Message-ID: <9a8748490708081651o9ba7f7v8d350c155c5a2b18@mail.gmail.com>
Date: Thu, 9 Aug 2007 01:51:29 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: [PATCH] make atomic_t volatile on all architectures
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
In-Reply-To: <46BA524F.2070803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070808230733.GA17270@shell.boston.redhat.com>
	 <9a8748490708081618p43cdcdfdn5de6f292247def5b@mail.gmail.com>
	 <46BA524F.2070803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2007, Chris Snook <csnook@redhat.com> wrote:
> Jesper Juhl wrote:
> > On 09/08/2007, Chris Snook <csnook@redhat.com> wrote:
> >> From: Chris Snook <csnook@redhat.com>
> >>
> >> Some architectures currently do not declare the contents of an atomic_t to be
> >> volatile.  This causes confusion since atomic_read() might not actually read
> >> anything if an optimizing compiler re-uses a value stored in a register, which
> >> can break code that loops until something external changes the value of an
> >> atomic_t.  Avoiding such bugs requires using barrier(), which causes re-loads
> >> of all registers used in the loop, thus hurting performance instead of helping
> >> it, particularly on architectures where it's unnecessary.  Since we generally
> >> want to re-read the contents of an atomic variable on every access anyway,
> >> let's standardize the behavior across all architectures and avoid the
> >> performance and correctness problems of requiring the use of barrier() in
> >> loops that expect atomic_t variables to change externally.  This is relevant
> >> even on non-smp architectures, since drivers may use atomic operations in
> >> interrupt handlers.
> >>
> >> Signed-off-by: Chris Snook <csnook@redhat.com>
> >>
> >
> > Hmm, I thought we were trying to move away from volatile since it is
> > very weakly defined and towards explicit barriers and locks...
> > Points to --> Documentation/volatile-considered-harmful.txt
>
> This is a special case.

I had a feeling it might be.

> Usually, the use of volatile is just lazy.  In
> this case, it's probably necessary on at least some architectures, so we
> can't remove it everywhere unless we want to rewrite atomic.h completely
> in inline assembler for several architectures, and painstakingly verify
> all that work.

Sounds quite unpleasant and actively harmful - keeping stuff in plain
readable C makes it easier to handle by most people.

> I would hope it's obvious that having consistent
> behavior on all architectures, or even at all compiler optimization
> levels within an architecture, can be agreed to be good.

Agreed, consistency is good.

>  Additionally,
> atomic_t variables are a rare exception, in that we pretty much always
> want to work with the latest value in RAM on every access.  Making this
> atomic will allow us to remove a bunch of barriers which do nothing but
> slow things down on most architectures.
>
I believe you meant to say "volatile" and not "atomic" above.  But
yes, if volatile is sufficiently defined to ensure it does what we
want in this case and using it means we can actually speed up the
kernel, then it does indeed sound reasonable. Especially since it's
confined to the implementation of atomic_t which most people shouldn't
be looking at anyway (but simply use) and when using an atomic_t it's
pretty reasonable to expect that it doesn't need any additional
locking or barriers since it's supposed to be *atomic*.

> I agree that the use of atomic_t in .c files is generally bad, but in
> certain special cases, hiding it inside defined data types may be worth
> the slight impurity, just as we sometimes tolerate lines longer than 80
> columns when "fixing" it makes things unreadable.
>
Can't argue with that.

It seems you've thought it through.  I just wanted to be sure that
this approach was actually the one that makes the most sense, and
you've convinced me of that :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
