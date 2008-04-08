Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYDHUn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYDHUn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYDHUnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:43:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42648 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752607AbYDHUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:43:18 -0400
Date: Tue, 8 Apr 2008 13:43:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <Pine.LNX.4.64.0804072000410.18591@blonde.site>
Message-ID: <Pine.LNX.4.64.0804081333180.30874@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804072000410.18591@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, Hugh Dickins wrote:

> > Looking at mempool_alloc: Mempools may be used to do atomic allocations 
> > until they fail thereby exhausting reserves and available object in the 
> > partial lists of slab caches?
> 
> Mempools may be used for atomic allocations, but I think that's not
> the case here.  swap_writepage's get_swap_bio says GFP_NOIO, which
> allows (indeed is) __GFP_WAIT, and does not give access to __GFP_HIGH
> reserves.

Looks like that one of the issues here is that swap_writepage() 
does not perform enough reclaim? If it would free more pages then 
__scsi_get_command would still have pages to allocate and not drain
the reserves.

> Maybe PF_MEMALLOC and __GFP_NOMEMALLOC complicate the situation:
> I've given little thought to mempool_alloc's fiddling with the
> gfp_mask (beyond repeatedly misreading it).

Mempool_alloc()s use of the gfp_mask here suggests that it can potentially 
drain all reserves and exhaust all available "slots" (partial slabs). Thus 
it may regularly force any other user of the slab to hit the slow path 
and potentially trigger reclaim. Could be a bit unfair.
