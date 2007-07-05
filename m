Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbXGER1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbXGER1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbXGER0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:26:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756299AbXGER0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:26:53 -0400
Date: Thu, 5 Jul 2007 10:26:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
In-Reply-To: <20070705170918.GO21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0707051014380.9434@woody.linux-foundation.org>
References: <20070705093528.GK21478@ftp.linux.org.uk>
 <alpine.LFD.0.98.0707050930330.9434@woody.linux-foundation.org>
 <20070705170918.GO21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Al Viro wrote:
> > 
> > So what I'd suggest is to just have *both* cases trigger on __attribute__, 
> > but in the qualifier case we'd use NS_QUALIFIER to look up the attribute 
> > function, and in the non-qualifier case we'd use NS_ATTRIBUTE (right now 
> > we always use NS_KEYWORD, and that's probably bogus: we should put the 
> > attribute names in another namespace _anyway_).
> 
> But that's the problem - we have places where *both* qualifiers and
> attributes are allowed and they apply to different parts of declaration.

So?

If they are allowed int he same place, they have to be parsed in the same 
place.

And if that place allows both attributes and qualifiers, then that place 
*has* to have the parsing for both "__attibute__" and "__qualifier__".

And I'm just saying that:
 (a) having two different magic keywords is silly and stupid, since:
 (b) We already have *one* magic keyword that can (and has to) look at its 
     subwords, and those sub-words have the capability to tell which of 
     the two cases we have (by just using name-space lookups)

> So I'm afraid that we need to change __attribute__ parsing anyway...

YES. That's what I said in my original email. I said:

  "... what you suggest would involve having a new place for parsing
   __attributes__, and making the *current* qualifier-like attribute 
   parsing trigger on "__qualifier__" instead.

   So what I'd suggest is to just have *both* cases trigger on 
   __attribute__, but in the qualifier case we'd use NS_QUALIFIER to look 
   up the attribute function, and in the non-qualifier case we'd use 
   NS_ATTRIBUTE (right now we always use NS_KEYWORD, and that's probably 
   bogus: we should put the attribute names in another namespace 
   _anyway_)"

IOW, nobody disputes that to get the new semantics, we have to have new 
code.  That's obvious.

But what I dispute is that you need to make a whole new keyword. We 
already *have* the keywords. They are the sub-keywords inside the 
"__attribute__()" list.

In other words, the way we really should parse __attribute__ stuff (and 
this is largely how we *do* parse them) is that we end up doing

	__attribute__((x(n),y(m)))

and we turn that into

	__attribute_x__(n) __attribute_y__(m)

where that "__attrubute_x__" really comes from the lookup of "x" in the 
"attribute" namespace (well, right now it's actually NS_KEYWORD, but 
that's a small detail). 

That's literally how we do it now.

And yes, we can do a new top-level name, and have

	__qualifier__((x(n))

turn into

	__qualifier_x__(n)

instead, but I just don't see any advantage. You can already do lookups 
from multiple address spaces at the same time, so I would instead suggest 
that we just *continue* to use

	__attribute__((x(n)))

and in a place where we could accept both qualifiers and gcc attributes, 
we'd look it up with

	struct symbol *sym = lookup_symbol(x, NS_ATTR | NS_QUAL);

and in places where we can just parse one or the other, we'd use just one 
or the other.

See? THAT is what I'm saying. There's no reason to change existing syntax, 
and in fact it is just _bad_ to change existing syntax, because it doesn't 
actually buy us anything, because we already have the capability to parse 
things in different contexts, and in fact allowing things to be parsed at 
the same _time_ in the different contexts.

			Linus
