Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZLRHI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZLRHI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZLRHI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:08:58 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42818 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbZLRHI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:08:57 -0500
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, torvalds@linux-foundation.org, tytso@mit.edu,
       kyle@mcmartin.ca, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20091218095944G.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LFD.2.00.0912170950330.15740@localhost.localdomain>
	 <20091217193648.GI4489@kernel.dk> <1261094220.2752.27.camel@mulgrave.site>
	 <20091218095944G.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 08:08:48 +0100
Message-Id: <1261120128.3013.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 10:00 +0900, FUJITA Tomonori wrote:
> On Fri, 18 Dec 2009 00:57:00 +0100
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > On Thu, 2009-12-17 at 20:36 +0100, Jens Axboe wrote:
> > > On Thu, Dec 17 2009, Linus Torvalds wrote:
> > > > 
> > > > 
> > > > On Thu, 17 Dec 2009, tytso@mit.edu wrote:
> > > > > 
> > > > > Sure, but there's some rumors/oral traditions going around that some
> > > > > block devices want bio address which are page aligned, because they
> > > > > want to play some kind of refcounting game,
> > > > 
> > > > Yeah, you might be right at that.
> > > > 
> > > > > And it's Weird Shit(tm) (aka iSCSI, AoE) type drivers, that most of us 
> > > > > don't have access to, so just because it works Just Fine on SATA doesn't 
> > > > > mean anything.
> > > > > 
> > > > > And none of this is documented anywhere, which is frustrating as hell.
> > > > > Just rumors that "if you do this, AoE/iSCSI will corrupt your file
> > > > > systems".
> > > > 
> > > > ACK. Jens? 
> > > 
> > > I've heard those rumours too, and I don't even know if they are true.
> > > Who has a pointer to such a bug report and/or issue? The block layer
> > > itself doesn't not have any such requirements, and the only places where
> > > we play page games is for bio's that were explicitly mapped with pages
> > > by itself (like mapping user data).o
> > 
> > OK, so what happened is that prior to the map single fix
> > 
> > commit df46b9a44ceb5af2ea2351ce8e28ae7bd840b00f
> > Author: Mike Christie  <michaelc@cs.wisc.edu>
> > Date:   Mon Jun 20 14:04:44 2005 +0200
> > 
> >     [PATCH] Add blk_rq_map_kern()
> > 
> > 
> > bio could only accept user space buffers, so we had a special path for
> > kernel allocated buffers.  That commit unified the path (with a separate
> > block API) so we could now submit kmalloc'd buffers via block APIs.
> > 
> > So the rule now is we can accept any user mapped area via
> > blk_rq_map_user and any kmalloc'd area via blk_rq_map_kern().  We might
> > not be able to do a stack area (depending on how the arch maps the
> > stack) and we definitely cannot do a vmalloc'd area.
> > 
> > So it sounds like we only need a blk_rq_map_vmalloc() using the same
> > techniques as the patch set and we're good to go.
> 
> I'm not sure about it.
> 
> As I said before (when I was against this 'adding vmalloc support to
> the block layer' stuff), are there potential users of this except for
> XFS? Are there anyone who does such a thing now?
> 
> This API might be useful for only journaling file systems using log
> formats that need large contiguous buffer. Sound like only XFS?
> 
> Even if we have some potential users, I'm not sure that supporting
> vmalloc in the block layer officially is a good idea. IMO, it needs
> too many tricks for generic code.

So far, there's only xfs that I know of.

Given the way journalling works, it's not an unusual requirement to use
a large buffer for operations.  It's a bit of a waste of kernel
resources to have this physically contiguous, but it is a waste of
resources (and for buffers over our kmalloc max, it would even have to
be allocated at start of day), so I think large kernel virtual areas
(like vmap/vmalloc) have a part to play in fs operations.

As to the API, the specific problem is that the block and lower arch
layers are specifically programmed to think any kernel address has only
a single alias and that it's offset mapped, which is why we get the
failure.

An alternative proposal to modifying the block layer to do coherency,
might be simply to have the fs layer do a vunmap before doing I/O and
re-vmap when it's completed.  That would ensure the architecturally
correct flushing of the aliases, and would satisfy the expectations of
blk_rq_map_kern().  The down side is that vmap/vmalloc set up and clear
page tables, which isn't necessary and might impact performance (xfs
people?)

If the performance impact of the above is too great, then we might
introduce a vmalloc sync API to do the flush before and the invalidate
after (would have to be called twice, once before I/O and once after).
This is sort of a violation of our architectural knowledge layering,
since the user of a vmap/vmalloc area has to know intrinsically how to
handle I/O instead of having it just work(tm), but since the users are
few and specialised, it's not going to lead to too many coding problems.

Any opinions?

James


