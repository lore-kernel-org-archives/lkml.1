Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZLIVyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZLIVyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZLIVyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:54:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757080AbZLIVyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:54:00 -0500
Date: Wed, 9 Dec 2009 13:52:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912091356200.4120-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912091317330.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091356200.4120-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Alan Stern wrote:
> 
> That could be attributed to reordering on CPU2, so let's take CPU2's
> peculiarities out of the picture (initially everything is set to 0):
> 
> 	CPU1			CPU2
> 	----			----
> 	if (x == 1)		z = y;
> 		y = 5;		mb();
> 				x = 1;
> 
> This gets at the heart of the question: Can a write move up past a
> control dependency?
>  [ .. ]
> Can z end up equal to 5 in any of these examples?

In any _practical_ microarchitecture I know of, the above will never 
result in 'z' being 5, even though CPU1 doesn't really have a memory 
barrier. But if I read the alpha memory ordering guarantees rigth, then at 
least in theory you really can end up with z=5.

Let me write that as five events (with the things in brackets being what 
the alpha memory ordering manual calls them):

 - A is "read of x returns 1" on CPU1   [ P1:R(x,1) ]
 - B is "write of value 5 to y" on CPU1 [ P1:W(y,5) ]
 - C is "read of y returns 5" on CPU2   [ P2:R(y,5) ]
 - D is "write of value 1 to x" on CPU2 [ P2:W(x,1) ]
 - 'MB' is the mb() on CPU2             [ P2:MB ]

(The write of 'z' is irrelevant, we can think of it as a register, the end 
result is the same).

And yes, if I read the alpha memory ordering rules correctly, you really 
can end up with z=5, although I don't think you will ever find an alpha 
_implementation_ that does it.

Why?

The alpha memory ordering literally defines ordering in two ways:

 - "location access order". But that is _only_ defined per actual 
   location, so while 'x' can have a location access order specified by 
   seeing certain values, there is no "location access order" for two 
   different memory locations (x and y).

   The alpha architecture manual uses "A << B" to say "event A" is before 
   "event B" when there is a defined ordering.

   So in the example above, there is a location access ordering between 

	P2:W(x,1) << P1:R(x, 1)

   and

	P2:R(y,5) << P1:W(y,5)

   ie you have D << A and B << C.

   Good so far, but that doesn't define anything else: there's only 
   ordering between the pairs (D,A) and (B,C), nothing between them.

 - "Processor issue order" for two instruction is _only_ defined by either 
   (a) memory barriers or (b) accesses to the _same_ locations. The alpha 
   architecture manual uses "A < B" to say that "event A" is before "event 
   B" in processor issue order.

   So there is a "Processor issue order" on CPU2 due to the memory 
   barrier: P2:R(y,5) < P2:MB < P2:W(x,1), or put another way C < MB < D: 
   C < D.

Now, the question is, can we actually get the behaviour of reading 5 on 
CPU2 (ie P2:R(y,5)), and that is only possible if we can find an ordering 
that satisfies all the constraints. We have

	D << A
	B << C
	C < D

and it seems to be that it is a possible situation: "B C D A" 
really does satisfy all the constraints afaik.

So yes, according to the actual alpha architecture memory ordering rules, 
you can see '5' from that first read of 'y'. DESPITE having a mb() on 
CPU2.

In order to not see 5, you need to also specify "A < B", and the _only_ 
way to do that processor issue order specification is with a memory 
barrier (or if the locations are the same, which they aren't).

"Causality" simply is nowhere in the officially defined alpha memory 
ordering. The fact that we test 'x == 1' and conditionally do the write 
simply doesn't enter the picture. I suspect you'd have a really hard time 
not having causality in practice, but there _are_ things that can break 
causality (value prediction etc), so it's not like you'd have to actually 
violate physics of reality to do it.

IOW, you could at least in theory implement a CPU that does every 
instruction speculatively in parallel, and then validates the end result 
afterwards according to the architecture rules. And that CPU would require 
the memory barrier on alpha.

(On x86, 'causality' is defined to be part of the memory ordering rules, 
so on x86, you _do_ have a 'A < B' relationship. But not on alpha).

				Linus
