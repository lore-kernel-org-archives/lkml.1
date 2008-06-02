Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbYFBGxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbYFBGxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYFBGxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:53:16 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:49144 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752048AbYFBGxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:53:15 -0400
Date: Mon, 2 Jun 2008 15:50:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080602065055.GA27293@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	akpm@linux-foundation.org, mpm@selenic.com
References: <484256AA.3000709@cs.helsinki.fi> <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI> <20080601082427.GC25429@linux-sh.org> <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI> <20080601102401.GD25429@linux-sh.org> <48427A13.7050704@cs.helsinki.fi> <20080601112137.GE25429@linux-sh.org> <Pine.LNX.4.64.0806011426150.17742@sbz-30.cs.Helsinki.FI> <20080602055922.GA24626@linux-sh.org> <84144f020806012332n47ba7a7eg37a6892dbb059d09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020806012332n47ba7a7eg37a6892dbb059d09@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 09:32:48AM +0300, Pekka Enberg wrote:
> On Mon, Jun 2, 2008 at 8:59 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> > In the kmem_cache_alloc() case calling ksize() there is bogus, the
> > previous semantics for kobjsize() just defaulted to returning PAGE_SIZE
> > for these, since page->index was typically 0. Presently if we ksize()
> > those objects, we get bogus size results that are smaller than the
> > minimum alignment size. So we still need a way to handle that, even if
> > it's not frightfully accurate.
> >
> > If we go back and apply your PG_slab patch for SLUB + SLOB, then
> > kobjsize() can just become:
> 
> What call-sites are using kmem_cache_alloc()? Can we convert them to
> kmalloc() or page_alloc()? IIRC both Christoph and Matt opposed my
> PG_slab patches.

Well, with that modified version of your patch I posted, even if your
previous PG_slab patches aren't applied, kobjsize() doesn't behave any
worse than it presently does in terms of object size accuracy.

In short: PG_slab doesn't get set and ksize() is never called, so we get
the same degree of accuracy as the existing implementation, and the
oopses get fixed (and the comments are still accurate, too!). So I think
it's worth applying. Verified on all of SLUB/SLOB/SLAB.

As for the call-site question, perhaps I'm misunderstanding your
question. alloc_vfsmnt() is the first to call kmem_cache_zalloc() during
boot-up on my system, but I'm not sure what relevance this has to
anything? Accurately measuring kmem_cache_alloc() and static allocations
is going to need quite a bit more of a re-think, but that's out of scope
for 2.6.26. Presently I'd rather have my system booting first :-)
