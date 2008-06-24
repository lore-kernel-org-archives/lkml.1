Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbYFXAOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYFXAOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYFXAN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:13:59 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:38846 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756015AbYFXAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:13:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EpyyR7lNYoq2PBZ9Xg/Ko0fbKvni//td6jRrhw8BObr4XpoYVzECCZVZgQirexyXywXFEys9L32JQ8lwuGhuP6yMBoiR7njjidb/0Z0Kn7ZeehnPh4NgFiCNXWJGVeVdz12nDq7ovZYjPj3iRZWVWn/i6QjHTPoQ2TvBliZuctk=  ;
X-YMail-OSG: yNKZ9j0VM1lPYozXR2AAruFnBJ30T7_7yFGKRuc5wAJJZJt1b7kP23hY.HRicy_FxIMNC1gvvTwU7wKtU01FBvVN4skuPnbaPfUJmkcgCchSxQp3tWTyykKvgPJF0jnLJSg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Date: Tue, 24 Jun 2008 10:13:45 +1000
User-Agent: KMail/1.9.5
Cc: Ryan Hope <rmh3093@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com> <200806232154.52820.nickpiggin@yahoo.com.au> <20080623130536.GA10595@linux.vnet.ibm.com>
In-Reply-To: <20080623130536.GA10595@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241013.45908.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 23:05, Paul E. McKenney wrote:
> On Mon, Jun 23, 2008 at 09:54:52PM +1000, Nick Piggin wrote:
> > On Monday 23 June 2008 13:51, Ryan Hope wrote:
> > > well i get the hardlock on -mm with out using reiser4, i am pretty
> > > sure is swap related
> >
> > The guys seeing hangs don't use PREEMPT_RCU, do they?
> >
> > In my swapping tests, I found -mm3 to be stable with classic RCU, but
> > on a hunch, I tried PREEMPT_RCU and it crashed a couple of times rather
> > quickly. First crash was in find_get_pages so I suspected lockless
> > pagecache doing something subtly wrong with the RCU API, but I just got
> > another crash in __d_lookup:
>
> Could you please send me a repeat-by?  (At least Alexey is no longer
> alone!)

OK, I had DEBUG_PAGEALLOC in the .config, which I think is probably
important to reproduce it (but the fact that I'm reproducing oopses
with << PAGE_SIZE objects like dentries and radix tree nodes indicates
that there is even more free-before-grace activity going undetected --
if you construct a test case using full pages, it might become even
easier to detect with DEBUG_PAGEALLOC).

2 socket, 8 core x86 system.

I mounted two tmpfs filesystems, one contains a single large file
which is formatted as 1K block size ext3 and mounted loopback, the
other is used directly. Linux kernel source is unpacked on each mount
and concurrent make -j128 on each. This pushes it pretty hard into
swap. Classic RCU survived another 5 hours of this last night.

But that's a fairly convoluted test for an RCU problem. I expect it
should be easier to trigger with something more targetted...
