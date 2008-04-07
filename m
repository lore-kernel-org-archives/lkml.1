Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYDGF1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYDGF1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYDGF05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:26:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41340 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752297AbYDGF05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:26:57 -0400
Date: Sun, 6 Apr 2008 22:26:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.ziljstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
Message-ID: <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2008, Hugh Dickins wrote:

> __scsi_get_command has a (one item) free_list to protect against
> this, but rc1's [SCSI] use dynamically allocated sense buffer
> de25deb18016f66dcdede165d07654559bb332bc upset that slightly.
> When it fails to allocate from the separate sense_slab, instead
> of giving up, it must fall back to the command free_list, which
> is sure to have a sense_buffer attached.
> 
> Either my earlier -rc testing missed this, or there's some recent
> contributory factor.  One very significant factor is SLUB, which
> merges slab caches when it can, and on 64-bit happens to merge
> both bio cache and sense_slab cache into kmalloc's 128-byte cache:
> so that under this swapping load, bios above are liable to gobble
> up all the slots needed for scsi_cmnd sense_buffers below.

A reliance on free slots that the slab allocator may provide? That is a 
rather bad dependency since it is up to the slab allocator to implement
the storage layout for the objects and thus the availability of slots may
vary depending on the layout for the objects chosen by the allocator.

Looking at mempool_alloc: Mempools may be used to do atomic allocations 
until they fail thereby exhausting reserves and available object in the 
partial lists of slab caches?

In order to make this a significant factor we need to have already 
exhausted reserves right? Thus we are already operating at the boundary of 
what memory there is. Any non atomic alloc will then allocate a new page 
with N elements in order to get one object. The mempool_allocs from the 
atomic context will then gooble up the N-1 remaining objects? So the
nonatomic alloc will then have to hit the page allocator again...

