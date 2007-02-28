Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXB1VIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXB1VIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXB1VIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:08:13 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48437 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXB1VIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:08:12 -0500
X-AuditID: d80ac287-a2c32bb000002978-4f-45e5ef3b8bbd 
Date: Wed, 28 Feb 2007 21:08:16 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jan Beulich <jbeulich@novell.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: struct page field arrangement
In-Reply-To: <45E5A05F.76E4.0078.0@novell.com>
Message-ID: <Pine.LNX.4.64.0702282044340.15399@blonde.wat.veritas.com>
References: <45E5A05F.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 28 Feb 2007 21:08:11.0269 (UTC) FILETIME=[8D93BB50:01C75B7C]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Jan Beulich wrote:

> A change early last year reordered struct page so that ptl overlaps not only
> private, but also mapping. Since spinlock_t can be much larger, I'm wondering
> whether there's a reason to not also overlay the space index and lru take -
> are these used for anything on page table pages?

Overlaying lru is a problem for for those architectures which use
kmem_cache_alloc for their pagetables: arm26, powerpc, sparc64 and
perhaps others (I just grepped quickly through include/asm*, didn't
follow up those who have extern functions): since slab reuses the
lru fields for its own purposes.  Could perhaps be stacked somehow.

Overlaying index is fairly straightforward: the index field is fair
game.  In my original patches I did overlay index, but Andrew was
strongly averse to the way I was doing it, and scaled things back,
to private alone if I remember rightly, then relaxed a little to
include mapping too.  Way back then I made up a patch to overlay
index too (when I saw Fedora going out with CONFIG_DEBUG_SPINLOCK),
but I could never get it into a form where I felt it would satisfy
Andrew; and grew increasingly dissatisfied with that approach myself.

I don't think further overlaying is the right answer really.
But I do think it's a scandal that the size of struct page (in a
DEBUG_SPINLOCK system) is governed by such a minority use of the
struct page.  Lacking a satisfying answer, I've just let it drift
on until someone notices and complains.

kmalloc a separate spinlock structure when it's too big to fit in?
Not such a good idea, since then there will tend to be false sharing
of cachelines between them: simpler just to disable SPLIT_PTLOCK in
that case.

I'm not happy with the status quo, but I don't know the right answer:
perhaps allow pagetable pages to use an undebugged spinlock variant?

Hugh
