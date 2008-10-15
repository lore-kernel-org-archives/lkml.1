Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYJOSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYJOSu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYJOSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:50:14 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:41139 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750902AbYJOSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:50:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Dw0DXErKUwZaknbsu3SbZOwcvkSvK348yeEKGSngtb1pG2LhMFNz3R3gg3G9tHOhRXG9hud6GMsf3Raae3DgTJAVMVB5AH63dGxDFJrPwXm4BSGLQn9uQWGd3qE+hM6sKUxlGoDq2b+IXIlxF0/Hr5pU3wPcvjNz/Fh0OukDWiQ=  ;
X-YMail-OSG: w4iRhysVM1m6W1l2_5MRu0uBgD5v2HQbdxqCH_uEaW3d6d_li2bV6n1xWlzxnr9INJFSGfRtYlR4K_oSoaUAA.rX5fpHAroe2rMd4m5X0j1MVllc_fHgaN6KfU4ujnGHDepA
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 05:50:04 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>, Hugh Dickins <hugh@veritas.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160506.14261.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0810151116430.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810151116430.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160550.04321.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 05:26, Linus Torvalds wrote:
> On Thu, 16 Oct 2008, Nick Piggin wrote:
> > Who was it that said memory ordering was self-evident?
>
> Nobody has _ever_ said that memory ordering is self-evident. Quite the
> reverse.

Heh, no that was a dig at someone who actually did say that the
other day. Not you or Matt.


> What we've said is that it's not a ctor issue. This has nothing
> what-so-ever to do with ctors, and everything to do with the fact that
> lockless is hard.
>
> And the general rule is: to find a page (or any other data structures) on
> another CPU, you need to insert it into the right data structures. And
> that insertion event needs to either be locked, or it needs to be ordered.

Sure. And "ordered" doesn't come by itself, but specifically with preceeding
stores that initialise the object.


> But notice that it's the _insertion_ event. Not the ctor. Not the
> allocator. It's the person _doing_ the allocation that needs to order
> things.
>
> See?

I see it as a joint effort between the code initialising the object, and
the code making it visible. But whatever. Whether or not we agree on the
exact obviousness or whatever, I don't want to argue. I think the solution
is agreed more or less "very unlikely to be bugs, and anyway the only way
to fix them is to document it and read code".


> And no, I didn't look at your exact case. But for pages in page tables,
> we'd need to have the right smp_wmb() at the "set_pte[_at]()" stage,
> either inside that macro or in the caller.

The example was actually talking about _page table pages_ in page tables.


> We used to only care about the page _contents_ (because the only unlocked
> access was the one that was done by hardware), but now that we do unlocked
> lookups in software too, we need to make sure the "struct page" itself is
> also valid.

I added those. Actually we _also_ need them for lockless hardware and
software walks, and not just for struct page, but also page table page
contents (which is what some architectures initialise with ctor).

Because otherwise you can insert your page table page, only to have that
store pass an earlier store to invalidate one of its ptes, and boom!
