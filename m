Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbZLQX5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbZLQX5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZLQX5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:57:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZLQX5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:57:12 -0500
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: James Bottomley <James.Bottomley@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       hch@infradead.org, linux-arch@vger.kernel.org
In-Reply-To: <20091217193648.GI4489@kernel.dk>
References: <20091216043618.GB9104@hera.kernel.org>
	 <20091217132256.GO28962@bombadil.infradead.org>
	 <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain>
	 <20091217163036.GE2123@thunk.org>
	 <alpine.LFD.2.00.0912170839550.15740@localhost.localdomain>
	 <20091217173957.GG2123@thunk.org>
	 <alpine.LFD.2.00.0912170950330.15740@localhost.localdomain>
	 <20091217193648.GI4489@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 00:57:00 +0100
Message-Id: <1261094220.2752.27.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 20:36 +0100, Jens Axboe wrote:
> On Thu, Dec 17 2009, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 17 Dec 2009, tytso@mit.edu wrote:
> > > 
> > > Sure, but there's some rumors/oral traditions going around that some
> > > block devices want bio address which are page aligned, because they
> > > want to play some kind of refcounting game,
> > 
> > Yeah, you might be right at that.
> > 
> > > And it's Weird Shit(tm) (aka iSCSI, AoE) type drivers, that most of us 
> > > don't have access to, so just because it works Just Fine on SATA doesn't 
> > > mean anything.
> > > 
> > > And none of this is documented anywhere, which is frustrating as hell.
> > > Just rumors that "if you do this, AoE/iSCSI will corrupt your file
> > > systems".
> > 
> > ACK. Jens? 
> 
> I've heard those rumours too, and I don't even know if they are true.
> Who has a pointer to such a bug report and/or issue? The block layer
> itself doesn't not have any such requirements, and the only places where
> we play page games is for bio's that were explicitly mapped with pages
> by itself (like mapping user data).o

OK, so what happened is that prior to the map single fix

commit df46b9a44ceb5af2ea2351ce8e28ae7bd840b00f
Author: Mike Christie  <michaelc@cs.wisc.edu>
Date:   Mon Jun 20 14:04:44 2005 +0200

    [PATCH] Add blk_rq_map_kern()


bio could only accept user space buffers, so we had a special path for
kernel allocated buffers.  That commit unified the path (with a separate
block API) so we could now submit kmalloc'd buffers via block APIs.

So the rule now is we can accept any user mapped area via
blk_rq_map_user and any kmalloc'd area via blk_rq_map_kern().  We might
not be able to do a stack area (depending on how the arch maps the
stack) and we definitely cannot do a vmalloc'd area.

So it sounds like we only need a blk_rq_map_vmalloc() using the same
techniques as the patch set and we're good to go.

> We fix driver crap like that, we don't work around it. It's a BUG.

James



