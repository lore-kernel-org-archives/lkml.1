Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZDWUMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZDWUMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZDWUM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:12:28 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49836 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZDWUM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:12:27 -0400
Date: Thu, 23 Apr 2009 16:11:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: David Daney <ddaney@caviumnetworks.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
In-Reply-To: <49F0C817.8050407@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.0904231601120.5514@localhost.localdomain>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain> <49F0C817.8050407@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, David Daney wrote:

> Robert P. J. Day wrote:
> > A boolean single_bit_set() routine would simplify the numerous
> > constructs of the form (((n & (n - 1)) == 0)) when testing for
> > single-bitness.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >
> > This is similar to the current is_power_of_2() routine defined in
> > include/linux/log2.h, which is mathematically identical but,
> > semantically, should be defined independently just so the code is more
> > readable.
> >
> > I'm open to an alternative function name.
> >
> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> > index 6182913..1c0c840 100644
> > --- a/include/linux/bitops.h
> > +++ b/include/linux/bitops.h
> > @@ -45,6 +45,13 @@ static inline unsigned long hweight_long(unsigned long w)
> >  	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
> >  }
> >
> > +static inline __attribute__((const))
> > +bool single_bit_set(unsigned long n)
> > +{
> > +        return (n != 0 && ((n & (n - 1)) == 0));
> > +}
> > +
> > +
>
>
> It would be nice to be able to override this per architecture.

  sure, that makes sense.  but in the meantime, there's nothing to
keep from starting the process and, arch by arch, overriding it down
the road as it becomes convenient.

> Also, are we still putting 'inline' everywhere?

  beats me.  are we?  and, just to be definitively pedantic about
this, for maximum readability, i think it would be nice to define
*both* the function and its converse:

  if (exactly_one_bit_set())
  if (more_than_one_bit_set())

or something to that effect.  i'll leave the final naming decisions up
to others higher up the food chain.

rday

p.s.  you can see the potential simplification by running, at the top
of the kernel tree:

  $ grep -Ern "([^\(\)]+) ?\& ?\(\1 ?- ?1\)" .

some of those represent power of 2 semantics, while others are the
single bit thingy.  and others are just weird.

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
