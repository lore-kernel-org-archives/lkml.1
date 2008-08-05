Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYHEDmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYHEDmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYHEDmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:42:01 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:43474 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753287AbYHEDmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:42:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ze7oIfxc4Wvl3GWdZ5I8VSA6TXgo4t9r2mM6qmGG0utobMcQG6DdyO7pFbZ3Cs/NSRb71va0ROtXi6OX0cN7xpxP8faWeBG3iejuDbjRyjJ6xEoU1axs7VLzO7oEDHD0xyGA531EMfgfsF5gYDyM52rCgHMMVwnOeuH2yk8Sso0=  ;
X-YMail-OSG: 2UxhJ6YVM1mTd6nYqVVi2N6gWTT2Qs.cG0vKRdFba9XniRWtZm3aSwvT8tg6M0vLZPufNBJlTgQPTMsAP6UqvrW4cyPa1tTE_5HY1XnZHw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
Date: Tue, 5 Aug 2008 13:41:53 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <200808051314.33791.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808042024480.3299@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808042024480.3299@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051341.53282.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 13:28, Linus Torvalds wrote:
> On Tue, 5 Aug 2008, Nick Piggin wrote:
> > On Thursday 31 July 2008 17:26, Nick Piggin wrote:
> > > Hi,
> > >
> > > I'm wondering if I could get a patch merged which changes all
> > > TestSetPageLocked and replaces them with trylock_page?
> >
> > Yes? No?
> >
> > The alternative is try to merge it via -mm or -next, but that just
> > wastes everybodies time with conflicts of having these differences
> > between -mm and mainline.
>
> Heh. I had just been _assuming_ this would go through -mm, since it's
> exactly the kind of thing that usually does go through there.
>
> So I hadn't even really considered it.

OK... it just causes Andrew headaches I suspect. But if he prefers
to hold onto it for an entire release cycle... Andrew?


> I don't mind the patch per se, but can you give some background on what
> the pending optimization is that makes such a big difference?

Using the lock semantics bitops is the first one. While it is true
that we could just hack them into TestSetPageLocked, I really prefer
callers to require at least a cursory glance to convert them, and
understand that this is a lock lock, and not a test_and_set bitop
with full barrier semantics.

lock semantics bitops obviously doesn't help x86 a bit. It really
helps powerpc though.

The part that helps x86 is another patch further down my stack, which
can avoid looking at the hashed page waitqueue at unlock_page-time.
Basically this eliminates the entire page waitqueue from the cache
footprint of fastpath workloads where the lock is uncontended (often:
page faulting, write(2), writeout etc).

I'll send all that stuff off to -mm for 2.6.28 if this gets upstream
(or into -mm).
