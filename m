Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYDGUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYDGUr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYDGUrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:47:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41323 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYDGUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:47:51 -0400
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804072121320.28744@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
	 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0804072000410.18591@blonde.site>
	 <1207598115.29991.23.camel@lappy>
	 <Pine.LNX.4.64.0804072121320.28744@blonde.site>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 22:47:13 +0200
Message-Id: <1207601233.29991.32.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 21:31 +0100, Hugh Dickins wrote:
> On Mon, 7 Apr 2008, Peter Zijlstra wrote:
> > On Mon, 2008-04-07 at 20:40 +0100, Hugh Dickins wrote:
> > > 
> > > My supposition is that once a page has been allocated from __GFP_HIGH
> > > reserves to a scsi sense_slab, swap_writepages are liable to gobble up
> > > the rest of the page with bio allocations which they wouldn't have had
> > > access to traditionally (i.e. under SLAB).
> > > 
> > > So an unexpected behaviour emerges from SLUB's slab merging.
> > 
> > Somewhere along the line of my swap over network patches I made
> > 'robustified' SLAB to ensure these sorts of things could not happen - it
> > came at a cost though.
> > 
> > It would basically fail[*] allocations that had a higher low watermark
> > than what was used to allocate the current slab.
> > 
> > [*] - well, it would attempt to allocate a new slab to raise the current
> > watermark, but failing that it would fail the allocation.
> 
> Thanks, Peter: that sounds just right to me; but a larger change than
> we'd want to jump into for this one particular issue - it might have
> its own unexpected consequences.

Right, but I doubt we'd ever get something like that merged though -
esp. as it will basically destroy the SLUB fast-path.

SLAB allocation fairness:
  http://lkml.org/lkml/2007/1/16/61

I abandoned this approach because it was too expensive; it was reduced
to the ALLOC_NO_WATERMARKS state transition. Which is much more unlikely
to happen and it's generally accepted we're in a slow path once we
really dive so low into the reserves.

The latest posting:
  http://lkml.org/lkml/2008/3/20/214


