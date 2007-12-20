Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXLTH7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXLTH7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXLTH7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:59:23 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:45652 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754777AbXLTH7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:59:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YlWRj1FCi55RiZ5lOIzzyYeKvgpPnz5FZkMhYxMlKNyVE03C6lFqbUr25H7LXjAQx96UY4ukXYakpAXkblIfRGquo6f5HP6i+1JUFyXzj1yqZmIUmYM4Pul9fRzQhx1w1Mg6g8gGZFRXG3vGtTBEhiG6R1UvH+Zm8iIks0C3EGI=  ;
X-YMail-OSG: K9keBtsVM1kIovzk6l3zsXb7_e8OdxEvWui8Jg7IgyyN63tYJkcLBDQLkgkfV2_ilmkwF4Z_xA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Date: Thu, 20 Dec 2007 18:59:12 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20071218211539.250334036@redhat.com> <200712201040.29040.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0712192301120.13118@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0712192301120.13118@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201859.12934.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 18:04, Christoph Lameter wrote:
> > The only reason the x86 ticket locks have the 256 CPu limit is that
> > if they go any bigger, we can't use the partial registers so would
> > have to have a few more instructions.
>
> x86_64 is going up to 4k or 16k cpus soon for our new hardware.
>
> > A 32 bit spinlock would allow 64K cpus (ticket lock has 2 counters,
> > each would be 16 bits). And it would actually shrink the spinlock in
> > the case of preempt kernels too (because it would no longer have the
> > lockbreak field).
> >
> > And yes, I'll go out on a limb and say that 64k CPUs ought to be
> > enough for anyone ;)
>
> I think those things need a timeframe applied to it. Thats likely
> going to be true for the next 3 years (optimistic assessment ;-)).

Yeah, that was tongue in cheek ;)


> Could you go to 32bit spinlock by default?

On x86, the size of the ticket locks is 32 bit, simply because I didn't
want to risk possible alignment bugs (a subsequent patch cuts it down to
16 bits, but this is a much smaller win than 64->32 in general because
of natural alignment of types).

Note that the ticket locks still support twice the number as the old
spinlocks, so I'm not causing a regression here... but yes, increasing
the size further will require an extra instruction or two.

> How about NUMA awareness for the spinlocks? Larger backoff periods for
> off node lock contentions please.

ticket locks can naturally tell you how many waiters there are, and how
many waiters are in front of you, so it is really nice for doing backoff
(eg. you can adapt the backoff *very* nicely depending on how many are in
front of you, and how quickly you are moving toward the front).

Also, since I got rid of the ->break_lock field, you could use that space
perhaps to add a cpu # of the lock holder for even more backoff context
(if you find that helps).

Anyway, I didn't do any of that because it obviously needs someone with
real hardware in order to tune it properly.
