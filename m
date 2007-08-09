Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXHISlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXHISlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbXHISll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:41:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:20972 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbXHISlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fqPbXkqRgg64gdfkXyQEsmKV3iF5bDmxWG/OTbV1DXaIB5Cv0SumddK2EupjsY4bGN+ONbuuBy62c+E95CX3c0AjOh7jNAp52tc0XudR99N4oXTP1J+pMUMSnC6KtonhkbdfyVoJd0sMLLjPtmR/zx1MptxvZd+nK09yat1PBiY=
Message-ID: <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com>
Date: Thu, 9 Aug 2007 14:41:39 -0400
From: "Daniel Phillips" <daniel.raymond.phillips@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Cc: "Daniel Phillips" <phillips@phunq.net>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Phillips" <phillips@google.com>
In-Reply-To: <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806102922.907530000@chello.nl>
	 <200708061559.41680.phillips@phunq.net>
	 <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com>
	 <200708061649.56487.phillips@phunq.net>
	 <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com>
	 <4a5909270708080037n32be2a73k5c28d33bb02f770b@mail.gmail.com>
	 <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Wed, 8 Aug 2007, Daniel Phillips wrote:
> Maybe we need to kill PF_MEMALLOC....

Shrink_caches needs to be able to recurse into filesystems at least,
and for the duration of the recursion the filesystem must have
privileged access to reserves.  Consider the difficulty of handling
that with anything other than a process flag.

> > > Try NUMA constraints and zone limitations.
> >
> > Are you worried about a correctness issue that would prevent the
> > machine from operating, or are you just worried about allocating
> > reserve pages to the local node for performance reasons?
>
> I am worried that allocation constraints will make the approach incorrect.
> Because logically you must have distinct pools for each set of allocations
> constraints. Otherwise something will drain the precious reserve slab.

To be precise, each user of the reserve must have bounded reserve
requirements, and a shared reserve must be at least as large as the
total of the bounds.

Peter's contribution here was to modify the slab slightly so that
multiple slabs can share the global memalloc reserve.  Not necessary
pre-allocating pages into the reserve reduces complexity.  The total
size of the reserve can also be reduced by this pool sharing strategy
in theory, but the patch set does not attempt this.

Anyway, you are right that if allocation constraints are not
calculated and enforced on the user side then the global reserve may
drain and get the system into a very bad state.  That is why each user
on the block writeout path must be audited for reserve requirements
and throttled to a requirement no greater than its share of the global
pool.  This patch set does not provide an example of such block IO
throttling, but you can see one in ddsnap at the link I provided
earlier (throttle_sem).

> > > No I mean all 1024 processors of our system running into this fail/succeed
> > > thingy that was added.
> >
> > If an allocation now fails that would have succeeded in the past, the
> > patch set is buggy.  I can't say for sure one way or another at this
> > time of night.  If you see something, could you please mention a
> > file/line number?
>
> It seems that allocations fail that the reclaim logic should have taken
> care of letting succeed. Not good.

I do not see a case like that, if you can see one then we would like
to know.  We make a guarantee to each reserve user that the memory it
has reserved will be available immediately from the global memalloc
pool.  Bugs can break this, and we do not automatically monitor each
user just now to detect violations, but both are also the case with
the traditional memalloc paths.

In theory, we could reduce the size of the global memalloc pool by
including "easily freeable" memory in it.  This is just an
optimization and does not belong in this patch set, which fixes a
system integrity issue.

Regards,

Daniel
