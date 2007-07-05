Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXGEQmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXGEQmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbXGEQmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:42:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909AbXGEQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:42:10 -0400
Date: Thu, 5 Jul 2007 09:41:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
In-Reply-To: <20070705093528.GK21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0707050930330.9434@woody.linux-foundation.org>
References: <20070705093528.GK21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Al Viro wrote:
> 
> Now, that idiocy would be none of our concern, if not for the fact
> that noderef and address_space() are definitely supposed to imitate
> qualifiers.

Absolutely.

> Note that gcc rules for __attribute__() (and that's the only source
> of rules we _have_ for the damn thing) clearly say that
> 	int __user *p;
> is the same thing as
> 	int *__user p;

Quick question: is there some reason why we have to honor the crazy gcc 
rules, and cannot try to convince gcc people that they are insane?

That said:

> Frankly, I would rather add a new primitive (__qualifier__) mirroring the
> __attribute__, but acting like real qualifiers do.

I'd be ok with that, but I would in many ways just prefer to keep the 
existing syntax, and just make the qualifiers be a separate _namespace_ 
within the attribute setup.

We already really should be able to handle that perfectly well, since we 
look up the attribute names using the normal name lookup functions, which 
already has the notion of different namespaces. 

IOW, as far as I can tell, there's really no reason to add a 
"__qualifier__" handler, because it's not going to help us. Anything we 
can do with __qualifier__, we can already do with our __attribute__ 
parsing: what you suggest would involve having a new place for parsing 
__attributes__, and making the *current* qualifier-like attribute parsing 
trigger on "__qualifier__" instead.

So what I'd suggest is to just have *both* cases trigger on __attribute__, 
but in the qualifier case we'd use NS_QUALIFIER to look up the attribute 
function, and in the non-qualifier case we'd use NS_ATTRIBUTE (right now 
we always use NS_KEYWORD, and that's probably bogus: we should put the 
attribute names in another namespace _anyway_).

That would effectively mean that "__attribute__()" is just a way to escape 
into another set of namespaces. The advantage of that is that we could 
possibly support attributes in other places more naturally (ie we could 
have another namespace for attributes on statements or inline assembly, 
and we wouldn't ever introduce yet another keyword - the *name* in the 
attribute is the real keyword)

		Linus
