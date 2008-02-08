Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbYBHIKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbYBHIKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbYBHIJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:09:40 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:39753 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758967AbYBHIJd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:09:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E0pPAdoHWin8+KCE2beIM6lq847+D9NGUnuZia8hMJ8qAHADelffqkqjnXd1CvqUoERclo4nOCKVSzPs8bmHFXsswrfOJaxa66K8cnfPW3LM48I+ZiclsHJoZeISGLDUmpGSO57m/wDG5arm4A4FOeeK7/BI2ky+8mTHIaojxkg=  ;
X-YMail-OSG: 5A3ma6sVM1lrbZnlKLQU6CBFTnOAt7_ni1toYiT5VGtXyZwHjdJR_IvO6ePqooSRfLnIU2CD4CTXroeDHspo6AClEzOWV8hydpVP
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [git pull] more SLUB updates for 2.6.25
Date: Fri, 8 Feb 2008 19:08:55 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com> <200802081812.22513.nickpiggin@yahoo.com.au> <47AC04CD.9090407@cosmosbay.com>
In-Reply-To: <47AC04CD.9090407@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802081908.55512.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 18:29, Eric Dumazet wrote:
> Nick Piggin a écrit :
> > On Friday 08 February 2008 13:13, Christoph Lameter wrote:
> >> are available in the git repository at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git
> >> slub-linus
> >>
> >> (includes the cmpxchg_local fastpath since the cmpxchg_local work
> >> by Matheiu is in now, and the non atomic unlock by Nick. Verified that
> >> this is not doing any harm after some other patches had been removed.
> >
> > Ah, good. I think it is always a good thing to be able to remove atomics.
> > They place quite a bit of burden on the CPU, especially x86 where it also
> > has implicit memory ordering semantics (although x86 can speculatively
> > get around much of the problem, it's obviously worse than no restriction)
> >
> > Even if perhaps some cache coherency or timing quirk makes the non-atomic
> > version slower (all else being equal), then I'd still say that the non
> > atomic version should be preferred.
>
> What about IRQ masking then ?

I really did mean all else being equal. eg. "clear_bit" vs "__clear_bit".


> Many CPU pay high cost for cli/sti pair...

True, and many UP architectures have to implement atomic operations
with cli/sti pairs... so those are more reasons to use non-atomics.


> And SLAB/SLUB allocators, even if only used from process context, want to
> disable/re-enable interrupts...
>
> I understand kmalloc() want generic pools, but dedicated pools could avoid
> this cli/sti

Sure, I guess that would be possible. I've kind of toyed with doing
some cli/sti mitigation in the page allocator, but in that case I
found that it wasn't a win outside microbenchmarks: the cache
characteristics of the returned pages are just as important if not
more so than cli/sti costs (although that balance would change
depending on the CPU and workload I guess).

For slub yes you could do it with fewer downsides with process context
pools.

Is it possible instead for architectures where cli/sti is so expensive
to change their lowest level of irq handling to do this by setting and
clearing a soft flag somewhere? That's what I'd rather see, if possible.
