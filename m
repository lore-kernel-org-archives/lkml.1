Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZLRBBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZLRBBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZLRBB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:01:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:37676 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZLRBB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:01:28 -0500
Date: Fri, 18 Dec 2009 10:00:21 +0900
To: James.Bottomley@suse.de
Cc: jens.axboe@oracle.com, torvalds@linux-foundation.org, tytso@mit.edu,
       kyle@mcmartin.ca, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-arch@vger.kernel.org
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1261094220.2752.27.camel@mulgrave.site>
References: <alpine.LFD.2.00.0912170950330.15740@localhost.localdomain>
	<20091217193648.GI4489@kernel.dk>
	<1261094220.2752.27.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091218095944G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 18 Dec 2009 10:00:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 00:57:00 +0100
James Bottomley <James.Bottomley@suse.de> wrote:

> On Thu, 2009-12-17 at 20:36 +0100, Jens Axboe wrote:
> > On Thu, Dec 17 2009, Linus Torvalds wrote:
> > > 
> > > 
> > > On Thu, 17 Dec 2009, tytso@mit.edu wrote:
> > > > 
> > > > Sure, but there's some rumors/oral traditions going around that some
> > > > block devices want bio address which are page aligned, because they
> > > > want to play some kind of refcounting game,
> > > 
> > > Yeah, you might be right at that.
> > > 
> > > > And it's Weird Shit(tm) (aka iSCSI, AoE) type drivers, that most of us 
> > > > don't have access to, so just because it works Just Fine on SATA doesn't 
> > > > mean anything.
> > > > 
> > > > And none of this is documented anywhere, which is frustrating as hell.
> > > > Just rumors that "if you do this, AoE/iSCSI will corrupt your file
> > > > systems".
> > > 
> > > ACK. Jens? 
> > 
> > I've heard those rumours too, and I don't even know if they are true.
> > Who has a pointer to such a bug report and/or issue? The block layer
> > itself doesn't not have any such requirements, and the only places where
> > we play page games is for bio's that were explicitly mapped with pages
> > by itself (like mapping user data).o
> 
> OK, so what happened is that prior to the map single fix
> 
> commit df46b9a44ceb5af2ea2351ce8e28ae7bd840b00f
> Author: Mike Christie  <michaelc@cs.wisc.edu>
> Date:   Mon Jun 20 14:04:44 2005 +0200
> 
>     [PATCH] Add blk_rq_map_kern()
> 
> 
> bio could only accept user space buffers, so we had a special path for
> kernel allocated buffers.  That commit unified the path (with a separate
> block API) so we could now submit kmalloc'd buffers via block APIs.
> 
> So the rule now is we can accept any user mapped area via
> blk_rq_map_user and any kmalloc'd area via blk_rq_map_kern().  We might
> not be able to do a stack area (depending on how the arch maps the
> stack) and we definitely cannot do a vmalloc'd area.
> 
> So it sounds like we only need a blk_rq_map_vmalloc() using the same
> techniques as the patch set and we're good to go.

I'm not sure about it.

As I said before (when I was against this 'adding vmalloc support to
the block layer' stuff), are there potential users of this except for
XFS? Are there anyone who does such a thing now?

This API might be useful for only journaling file systems using log
formats that need large contiguous buffer. Sound like only XFS?

Even if we have some potential users, I'm not sure that supporting
vmalloc in the block layer officially is a good idea. IMO, it needs
too many tricks for generic code.
