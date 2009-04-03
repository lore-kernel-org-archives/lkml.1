Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZDCItd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZDCItd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZDCItV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:49:21 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:38951 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZDCItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:49:19 -0400
Date: Fri, 3 Apr 2009 10:49:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rik van Riel <riel@redhat.com>, akpm@osdl.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, frankeh@watson.ibm.com,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       hugh@veritas.com, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [patch 0/6] Guest page hinting version 7.
Message-ID: <20090403104913.29c62082@skybase>
In-Reply-To: <49D5215D.6050503@goop.org>
References: <20090327150905.819861420@de.ibm.com>
	<200903281705.29798.rusty@rustcorp.com.au>
	<20090329162336.7c0700e9@skybase>
	<200904022232.02185.nickpiggin@yahoo.com.au>
	<20090402175249.3c4a6d59@skybase>
	<49D50CB7.2050705@redhat.com>
	<49D518E9.1090001@goop.org>
	<49D51CA9.6090601@redhat.com>
	<49D5215D.6050503@goop.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Apr 2009 13:34:37 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Rik van Riel wrote:
> > Jeremy Fitzhardinge wrote:
> >> The more complex host policy decisions of how to balance overall 
> >> memory use system-wide are much in the same for both mechanisms.
> > Not at all.  Page hinting is just an optimization to host swapping, where
> > IO can be avoided on many of the pages that hit the end of the LRU.
> >
> > No decisions have to be made at all about balancing memory use
> > between guests, it just happens through regular host LRU aging.
> 
> When the host pages out a page belonging to guest A, then its making a 
> policy decision on how large guest A should be compared to B.  If the 
> policy is a global LRU on all guest pages, then that's still a policy on 
> guest sizes: the target size is a function of its working set, assuming 
> that the working set is well modelled by LRU.  I imagine that if the 
> guest and host are both managing their pages with an LRU-like algorithm 
> you'll get some nasty interactions, which page hinting tries to alleviate.

This is the basic idea of guest page hinting. Let the host memory
manager make it decision based on the data it has. That includes page
age determined with a global LRU list, page age determined with a
per-guest LRU list, i/o rates of the guests, all kind of policy which
guest should have how much memory. The page hinting comes into play
AFTER the decision has been made which page to evict. Only then the host
should look at the volatile vs. stable page state and decide what has
to be done with the page. If it is volatile the host can throw the page
away because the guest can recreate it with LESS effort. That is the
optimization.

> > Automatic ballooning requires that something on the host figures
> > out how much memory each guest needs and sizes the guests
> > appropriately.  All the proposed policies for that which I have
> > seen have some nasty corner cases or are simply very limited
> > in scope.
> 
> Well, you could apply something equivalent to a global LRU: ask for more 
> pages from guests who have the most unused pages.  (I'm not saying that 
> its necessarily a useful policy.)

But with page hinting you don't have to even ask. Just take the pages
if you need them. The guest already told you that you can have them by
setting the unused state.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

