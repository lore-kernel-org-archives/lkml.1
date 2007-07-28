Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXG1Fzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXG1Fzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 01:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbXG1Fzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 01:55:39 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54370 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXG1Fzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 01:55:38 -0400
Date: Sat, 28 Jul 2007 06:54:37 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
In-Reply-To: <1185586601.5495.299.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707280627110.26545@blonde.wat.veritas.com>
References: <20070724083855.GA858@elte.hu>  <20070724015441.8604d85d.akpm@linux-foundation.org>
  <1185270045.5439.249.camel@localhost.localdomain>  <p73abtmt2y7.fsf@bingen.suse.de>
  <1185312559.5439.276.camel@localhost.localdomain>  <1185345850.8197.64.camel@twins>
 <1185586601.5495.299.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmcAcGV0ZXJ6QGluZnJhZGVhZC5vcmcAYW5kaUBmaXJzdGZsb29yLm9yZwBtaW5nb0BlbHRlLmh1AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007, Benjamin Herrenschmidt wrote:
> 
> As I'm sweeping through arch code etc... preparing the ground for the
> proper mmu_gather surgery, I've been thinking about the way to deal with
> that per-cpu page list and finally came up with the idea that the best
> we can do is around the lines of trying to allocate the list via gfp,
> and if that fails, fallback to a (smaller than now) per-cpu. I'm
> reworking the interfaces such that the higher level code doesn't have to
> care whether preemption is enabled or disabled at a given point.

That doesn't sound like the best way to me at all.  Using two means
of buffering, one with preemption enabled and the other not, seems
complex and prone to error (perhaps not while you're working on it,
but later on).  We do already have that problem (the i_mmap_lock case
versus the others), but it's not a complication I'd want to extend.

The onstack array seems fine to me, even if you do end up deciding on
an array of one.  Is there any evidence that it's a problem getting a
page for the freeing (other than in circumstances that are already
badly slowed down)?  It's obvious that we need a fallback route,
but optimizing throughput on that route seems premature.

Hugh
