Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYJORLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYJORLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYJORK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:10:58 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:31432 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752118AbYJORK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:10:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YctAVYjD2oxo/2iioBjjMJsotq+iZ92K0Cb+zk0leEXi3Ymw05um7Fg3Tsu0wv6AKTlaw/FJC2PGKrKXcNlhEAzJgX/n2jggGNjnoPBhlRR98/1eh6MkxeX+2WxVKqqyCdYFgWJfcwEXOFoKyww/fjOl9bHLWhAerQADfXUvhe8=  ;
X-YMail-OSG: XAS_MAMVM1nqcemdeeDn1I0N.MKjSfSB6KjEYzNmkKOnxByPPXtVSD2fCNhSZ89ULDbc86lDBGDXI_1sYuKr0rEyJAGeXaYQACJzNO7w5VNl2o.hyncmCtJ6c65bt3YDb.rpDkKPOjHRAojvILk5CenL7zm287s2GQBwMSve
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 04:10:49 +1100
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au> <1224089658.3316.218.camel@calx>
In-Reply-To: <1224089658.3316.218.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160410.49894.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 03:54, Matt Mackall wrote:
> On Thu, 2008-10-16 at 03:34 +1100, Nick Piggin wrote:
> > I think I see a possible memory ordering problem with SLOB:
> > In slab caches with constructors, the constructor is run
> > before returning the object to caller, with no memory barrier
> > afterwards.
> >
> > Now there is nothing that indicates the _exact_ behaviour
> > required here. Is it at all reasonable to expect ->ctor() to
> > be visible to all CPUs and not just the allocating CPU?
>
> Do you have a failure scenario in mind?
>
> First, it's a categorical mistake for another CPU to be looking at the
> contents of an object unless it knows that it's in an allocated state.
>
> For another CPU to receive that knowledge (by reading a causally-valid
> pointer to it in memory), a memory barrier has to occur, no?

No.

For (slightly bad) example. Some architectures have a ctor for their
page table page slabs. Not a bad thing to do.

Now they allocate these guys, take a lock, then insert them into the
page tables. The lock is only an acquire barrier, so it can leak past
stores.

The read side is all lockless and in some cases even done by hardware.

Now in _practice_, this is not a problem because some architectures
don't have ctors, and I spotted the issue and put proper barriers in
there. But it was a known fact that ctors were always used, and if I
had assumed ctors were barriers so didn't need the wmb, then there
would be a bug.

Especially the fact that a lock doesn't order the stores makes me
worried that a lockless read-side algorithm might have a bug here.
Fortunately, most of them use RCU and probably use rcu_assign_pointer
even if they do have ctors. But I can't be sure...
