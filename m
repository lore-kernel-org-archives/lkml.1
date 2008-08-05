Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbYHED6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbYHED6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYHED60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:58:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbYHED6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:58:25 -0400
Date: Mon, 4 Aug 2008 20:57:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
Message-Id: <20080804205754.b05c8aa9.akpm@linux-foundation.org>
In-Reply-To: <200808051341.53282.nickpiggin@yahoo.com.au>
References: <200807311726.51816.nickpiggin@yahoo.com.au>
	<200808051314.33791.nickpiggin@yahoo.com.au>
	<alpine.LFD.1.10.0808042024480.3299@nehalem.linux-foundation.org>
	<200808051341.53282.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 13:41:53 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 05 August 2008 13:28, Linus Torvalds wrote:
> > On Tue, 5 Aug 2008, Nick Piggin wrote:
> > > On Thursday 31 July 2008 17:26, Nick Piggin wrote:
> > > > Hi,
> > > >
> > > > I'm wondering if I could get a patch merged which changes all
> > > > TestSetPageLocked and replaces them with trylock_page?
> > >
> > > Yes? No?
> > >
> > > The alternative is try to merge it via -mm or -next, but that just
> > > wastes everybodies time with conflicts of having these differences
> > > between -mm and mainline.
> >
> > Heh. I had just been _assuming_ this would go through -mm, since it's
> > exactly the kind of thing that usually does go through there.
> >
> > So I hadn't even really considered it.
> 
> OK... it just causes Andrew headaches I suspect. But if he prefers
> to hold onto it for an entire release cycle... Andrew?
> 

Yup.  A mechanical rename-foo-to-bar can be prepared and merged late -
there's little payback for the pain of maintaining it for a couple of
months.

Would prefer either that we hold off until after 2.6.27 is released or
just do it now.

> 
> > I don't mind the patch per se, but can you give some background on what
> > the pending optimization is that makes such a big difference?
> 
> Using the lock semantics bitops is the first one. While it is true
> that we could just hack them into TestSetPageLocked, I really prefer
> callers to require at least a cursory glance to convert them, and
> understand that this is a lock lock, and not a test_and_set bitop
> with full barrier semantics.

This patch wouldn't do anything to ensure that callers get the review
which you describe, would it?

(and we don't need to patch the code to just read it!)

> lock semantics bitops obviously doesn't help x86 a bit. It really
> helps powerpc though.
> 
> The part that helps x86 is another patch further down my stack, which
> can avoid looking at the hashed page waitqueue at unlock_page-time.
> Basically this eliminates the entire page waitqueue from the cache
> footprint of fastpath workloads where the lock is uncontended (often:
> page faulting, write(2), writeout etc).
> 
> I'll send all that stuff off to -mm for 2.6.28 if this gets upstream
> (or into -mm).

I'm OK with that.
