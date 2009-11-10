Return-Path: <linux-kernel-owner+w=401wt.eu-S1750830AbZKJP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750830AbZKJP6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZKJP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:58:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735AbZKJP6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:58:17 -0500
Date: Tue, 10 Nov 2009 07:57:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pci_find_parent_resource patch
In-Reply-To: <86802c440911100205i14dcf69i99cb0ef6f76406d1@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0911100745580.31845@localhost.localdomain>
References: <4AF875D0.10602@kernel.org> <20091110082340.319f1ad3@jbarnes-x200> <86802c440911100205i14dcf69i99cb0ef6f76406d1@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Nov 2009, Yinghai Lu wrote:

> On Tue, Nov 10, 2009 at 12:23 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > I don't remember seeing it, is it for 2.6.32?
> 
> http://lkml.org/lkml/2009/8/7/352

I'm not entirely sure it needs to go into 32, but it's probably the right 
thing to do. Another way of explaining the patch is:

 - we currently pick the _first_ exactly matching bus resource entry, but 
   the _last_ inexactly matching one. Normally first/last shouldn't 
   matter, but bus resource entries aren't actually all created equal: in 
   a transparent bus, the last resources will be the parent resources, 
   which we should generally try to avoid unless we have no choice. So 
   "first matching" is the thing we should always aim for.

 - the patch is a bit bigger than it needs to be, because I simplified the 
   logic at the same time. It used to be a fairly incomprehensible

	if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags & IORESOURCE_PREFETCH))
		best = r;       /* Approximating prefetchable by non-prefetchable */

   and technically, all the patch did was to make that complex choice be 
   even more complex (it basically added a "&& !best" to say that if we 
   already gound a non-prefetchable window for the prefetchable resource, 
   then we won't override an earlier one with that later one: remember 
   "first matching").

 - So instead of that complex one with three separate conditionals in one, 
   I split it up a bit, and am taking advantage of the fact that we 
   already handled the exact case, so if 'res->flags' has the PREFETCH 
   bit, then we already know that 'r->flags' will _not_ have it. So the 
   simplified code drops the redundant test, and does the new '!best' test 
   separately. It also uses 'continue' as a way to ignore the bus 
   resource we know doesn't work (ie a prefetchable bus resource is _not_ 
   acceptable for anything but an exact match), so it turns into:


	/* We can't insert a non-prefetch resource inside a prefetchable parent .. */
	if (r->flags & IORESOURCE_PREFETCH)
		continue;
	/* .. but we can put a prefetchable resource inside a non-prefetchable one */
	if (!best)
		best = r;

   instead. With the comments, it's now six lines instead of two, but it's 
   conceptually simpler, and I _could_ have written it as two lines:

	if ((res->flags & IORESOURCE_PREFETCH) && !best)
		best = r;	/* Approximating prefetchable by non-prefetchable */

   but I thought that was too damn subtle.

Feel free to use this long explanation as a commit message if you want,

			Linus
