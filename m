Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYDGU2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYDGU2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYDGU2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:28:32 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49574 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYDGU2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:28:31 -0400
Date: Mon, 7 Apr 2008 21:31:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <1207598115.29991.23.camel@lappy>
Message-ID: <Pine.LNX.4.64.0804072121320.28744@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site> 
 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, Peter Zijlstra wrote:
> On Mon, 2008-04-07 at 20:40 +0100, Hugh Dickins wrote:
> > 
> > My supposition is that once a page has been allocated from __GFP_HIGH
> > reserves to a scsi sense_slab, swap_writepages are liable to gobble up
> > the rest of the page with bio allocations which they wouldn't have had
> > access to traditionally (i.e. under SLAB).
> > 
> > So an unexpected behaviour emerges from SLUB's slab merging.
> 
> Somewhere along the line of my swap over network patches I made
> 'robustified' SLAB to ensure these sorts of things could not happen - it
> came at a cost though.
> 
> It would basically fail[*] allocations that had a higher low watermark
> than what was used to allocate the current slab.
> 
> [*] - well, it would attempt to allocate a new slab to raise the current
> watermark, but failing that it would fail the allocation.

Thanks, Peter: that sounds just right to me; but a larger change than
we'd want to jump into for this one particular issue - it might have
its own unexpected consequences.

> > If we had a SLAB_NOMERGE flag, would we want to apply it to the
> > bio cache or to the scsi_sense_cache or to both?  My difficulty
> > in answering that makes me wonder whether such a flag is right.
> 
> If this is critical to avoid memory deadlocks, I would suggest using
> mempools (or my reserve framework).

No, the critical part of it has been dealt with (small fix to scsi
free_list handling: which resembles a mempool, but done its own way).

What remains is about "unsightly" behaviour, the system having a
tendency to collapse briefly into far-from-efficient operation
when out of memory.

Hugh
