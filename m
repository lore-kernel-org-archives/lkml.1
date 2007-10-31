Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbXJaCYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbXJaCYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXJaCYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:24:15 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:29028 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751616AbXJaCYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:24:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TE3HwlnPWT/8rn6NQQdzRhOAyZdRy6wQkkoZgHYmorGXppy3B3qe69tjPe2kIgct+7FRww/0kCcAyfq27pTd5tsvc8IV5tszGvhRrgTuOlMUJhB7M+JC0JPHghljHg8yGLYm01bz0fn9xNkFhcx9MNiRDyGocp1V201G8h+f7cQ=  ;
X-YMail-OSG: AdHcLY4VM1mRkHR0diaLPdD1mO7QmLiPDX0AAD4F0lWZwIShgu7hpXnO6teUaBM4CbtrypjLnQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 09/10] SLUB: Do our own locking via slab_lock and slab_unlock.
Date: Wed, 31 Oct 2007 12:17:33 +1100
User-Agent: KMail/1.9.5
Cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <20071028033156.022983073@sgi.com> <200710301550.55199.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710301124520.11531@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710301124520.11531@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311217.34162.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 05:32, Christoph Lameter wrote:
> On Tue, 30 Oct 2007, Nick Piggin wrote:
> > Is this actually a speedup on any architecture to roll your own locking
> > rather than using bit spinlock?
>
> It avoids one load from memory when allocating and the release is simply
> writing the page->flags back. Less instructions.

OK, but it probably isn't a measurable speedup, even on microbenchmarks,
right? And many architectures have to have more barriers around cmpxchg
than they do around a test_and_set_bit_lock, so it may even be slower
on some.


> > I am not exactly convinced that smp_wmb() is a good idea to have in your
> > unlock, rather than the normally required smp_mb() that every other open
> > coded lock in the kernel is using today. If you comment every code path
> > where a load leaking out of the critical section would not be a problem,
> > then OK it may be correct, but I still don't think it is worth the
> > maintenance overhead.
>
> I thought you agreed that release semantics only require a write barrier?

Not in general.


> The issue here is that other processors see the updates before the
> updates to page-flags.
>
> A load leaking out of a critical section would require that the result of
> the load is not used to update other information before the slab_unlock
> and that the source of the load is not overwritten in the critical
> section. That does not happen in sluib.

That may be the case, but I don't think there is enough performance
justification to add a hack like this. ia64 for example is going to
do an mf for smp_wmb so I doubt it is a clear win.
