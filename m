Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbXIHM2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbXIHM2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 08:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXIHM15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 08:27:57 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:57799 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXIHM14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 08:27:56 -0400
Date: Sat, 8 Sep 2007 05:27:55 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Petr Vandrovec <vandrove@vc.cvut.cz>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, ak@suse.de,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
In-Reply-To: <46E290D3.10304@vc.cvut.cz>
Message-ID: <Pine.LNX.4.64.0709080512040.27088@twinlark.arctic.org>
References: <200709071526.51169.jesse.barnes@intel.com>
 <alpine.LFD.0.999.0709080020040.9047@evo.linux-foundation.org>
 <200709090334.27677.nickpiggin@yahoo.com.au> <200709090348.28076.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709080429420.27088@twinlark.arctic.org> <46E290D3.10304@vc.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007, Petr Vandrovec wrote:

> dean gaudet wrote:
> > On Sun, 9 Sep 2007, Nick Piggin wrote:
> > 
> > > I've also heard that string operations do not follow the normal ordering,
> > > but
> > > that's just with respect to individual loads/stores in the one operation,
> > > I
> > > hope? And they will still follow ordering rules WRT surrounding loads and
> > > stores?
> > 
> > see section 7.2.3 of intel volume 3A...
> > 
> > "Code dependent upon sequential store ordering should not use the string
> > operations for the entire data structure to be stored. Data and semaphores
> > should be separated. Order dependent code should use a discrete semaphore
> > uniquely stored to after any string operations to allow correctly ordered
> > data to be seen by all processors."
> > 
> > i think we need sfence after things like copy_page, clear_page, and possibly
> > copy_user... at least on intel processors with fast strings option enabled.
> 
> I do not think.  I believe that authors are trying to say that
> 
> struct { uint8 lock; uint8 data; } x;
> 
> lea (x.data),%edi
> mov $2,%ecx
> std
> rep movsb
> 
> to set both data and lock does not guarantee that x.lock will be set after
> x.data and that you should do
> 
> lea (x.data),%edi
> std
> movsb
> movsb  # or mov (%esi),%al; mov %al,(%edi), but movsb looks discrete enough to
> me
> 
> instead (and yes, I know that my example is silly).

no it's worse than that -- intel fast string stores can become globally 
visible in any order at all w.r.t. normal loads or stores... so take all 
those great examples in their recent whitepaper and throw out all the 
ordering guarantees for addresses on different cachelines if any of the 
stores are rep string.

for example transitive store ordering for locations on multiple cachelines 
is not guaranteed at all.  the kernel could return a zero page and one 
core could see the zeroes out of order with another core performing some 
sort of lockless data structure operation.

fast strings don't break ordering from the point of view of the core 
performing the rep string operation, but externally there are no 
guarantees (it's right there in the docs).

-dean
