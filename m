Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZK3PWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZK3PWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZK3PWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:22:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbZK3PWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:22:19 -0500
Date: Mon, 30 Nov 2009 07:22:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul McKenney <paulmck@us.ibm.com>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <20091130075557.GI17484@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, Nick Piggin wrote:
> 
> We do have quite a large number of rwlocks really.

Dynamically they tend to be unimportant, except for the tasklist_lock. 
Many of them are in drivers and/or finegrained, or get called only by 
fairly unusual things (registering filesystems etc).

> If they are so important as to be rwlocks,

Stop making total red-herring arguments.

It's not about "so important as to be rwlocks". Quite the reverse. I'm 
saying that most rwlocks are totally _unimportant_. Being a rwlock does 
_not_ make anything more important or less important in itself, so your 
argument is bogus. You have to base importantness on other issues than 
whether they are rwlocks or not.

As far as I can tell there is _one_ single important rwlock, and that's 
tasklist_lock. Everything else could probably trivially and individually 
be turned into a spinlock if fairness matters for them. But tasklist_lock 
fundamentally depends on the semantics of rwlocks.

And that one rwlock requires unfair behavior, and is not going to be happy 
with some more complicated thing (because it is also called from some 
pretty critical pathways).

So my argument is purely:

 - there is absolutely NOBODY who cares about "fair" rwlocks, because no 
   other user will ever hit its lock enough for it to matter. And if they
   really do, most of them tend to be fairly simple and localized and 
   might be turned into spinlocks.

 - the _one_ major exception to this - somebody who does hit the lock 
   enough for fairness to matter - is not likely amenable to any kind of 
   trivial fairness.

Now, I'd love to come up with some solution to tasklist_lock, but I just 
don't see it. At least nothing easy that doesn't have tons of downsides 
(like turning it into a spinlock, using the irq-safe versions, and having 
irq's potentially disabled for much longer than I think is good).

			Linus
