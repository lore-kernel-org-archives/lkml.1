Return-Path: <linux-kernel-owner+w=401wt.eu-S1750909AbXCTBcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbXCTBcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXCTBcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:32:22 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39000 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXCTBcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:32:21 -0400
Date: Mon, 19 Mar 2007 17:32:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
Message-Id: <20070319173218.24219a4a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703191756060.389@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
	<20070319165329.b5830789.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703191655190.13879@schroedinger.engr.sgi.com>
	<20070319170741.5a24af4c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703191718220.13927@schroedinger.engr.sgi.com>
	<20070319175524.812b2f5d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703191756060.389@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 18:03:54 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 19 Mar 2007, Andrew Morton wrote:
> 
> > > See the patch. We are only touching 2 cachelines instead of 32. So even 
> > > without considering the page allocator overhead and the slab allocator 
> > > overhead (which will make the situation even better) its superior.
> > 
> > That's not proof, it is handwaving.  I could wave right back at you and
> > claim that the benefit from returning a cache-hot pte page back to the page
> > allocator for reuse exceeds the benefit which you waved at me above.
> 
> No you cannot make that claim. That would mean that you have to touch 
> 32 pages which is inferior.

For pte pages (which are far more common), more than a single cacheline
will be in cache.

Yes, a common quicklist implementation is good.  But no quicklist
implementation at all is better.  You say that will be slower, and you may
well be right, but I say let's demonstrate that (please) rather than
speculating.

Then we can look at the difference and decide whether it is worth the
additional complexity of this special-purpose private allocator.

> > You may well be right, but nothing is proven, afaict.
> 
> Nothing can be proven except within a rigorously defined mathematical 
> system but even there we are limited by such things as Russel's paradox.
> 
> Its obvious that this is right. And there has been significant work 
> invested into retaining page table pages on i386, sparc64 and ia64 for 
> exactly the specified.

I believe that work predated per-cpu-pages.

> This patch does not change that at all for these 3 
> arches. There is no doubt about the correctness of the approach here.
> 
> > > You do not think that our current way of handling ptes is okay? If we do 
> > > not zero the ptes then we need to separate munmap from process shutdown.
> > 
> > Yep.  It's possible that process shutdown is a sufficiently common and
> > costly special-case for it to be worth special-casing.
> 
> Ok great idea but what does this have to do with this patch? This patch 
> simply generalizes something that has been there for ages.

It has a lot to do with this patch.

If we decide that it is useful to optimise the full-mm teardown case then
we will need to zero these pages when we start to use them so we might as
well get them straight from the page allocator.  Hence this patch goes into
the bitbucket.

> > > The advantage of the quicklists is that it does not require a rework of 
> > > the pte serialization.
> > 
> > No, these are unrelated.  We can get pte pages from the page allocator and
> > zero them without touching the munmap handling.
> > 
> > But it's possible that if we _were_ to optimise the munmap handling as
> > suggested, the end result would be superior.
> 
> Andrew, this is utter crap and unrelated to this work. The main thing here 
> is to generalize something that various arches already do and to avoid the 
> page struct handling collisions. You use pie-in-the-sky to argue against 
> consolidating code and fixing up usage conflicts of the slab with arch 
> code?

It is not pie-in-the-sky to ask "is this code still useful?".

