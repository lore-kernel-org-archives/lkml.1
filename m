Return-Path: <linux-kernel-owner+w=401wt.eu-S1763164AbXHWMRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763164AbXHWMRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbXHWMQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:16:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:56058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbXHWMQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:16:52 -0400
Date: Thu, 23 Aug 2007 14:16:48 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, riel <riel@redhat.com>
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water
	marks
Message-ID: <20070823121643.GP13915@v2.random>
References: <20070820215040.937296148@sgi.com> <1187692586.6114.211.camel@twins> <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com> <1187730812.5463.12.camel@lappy> <Pine.LNX.4.64.0708211418120.3267@schroedinger.engr.sgi.com> <1187734144.5463.35.camel@lappy> <Pine.LNX.4.64.0708211532560.5728@schroedinger.engr.sgi.com> <1187766156.6114.280.camel@twins> <Pine.LNX.4.64.0708221157180.13813@schroedinger.engr.sgi.com> <1187813025.5463.85.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187813025.5463.85.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:03:45PM +0200, Peter Zijlstra wrote:
> Its not extreme, not even rare, and its handled now. Its what
> PF_MEMALLOC is for.

Agreed. This is the whole point, either you limit the max amount of
anon memory, slab, alloc_pages a driver can do or you reserve a
pool. Guess what? In practice limiting the max ram a driver can eat in
alloc_pages, at the same time while limting the max amount of pages
that can be anon ram, etc..etc.. is called "reserving a pool of
freepages for PF_MEMALLOC".

Now in theory we could try a may_writepage=0 second reclaim pass
before using the PF_MEMALLOC pool but would that make any difference
other than being slower? We can argue what should be done first but
the PF_MEMALLOC pool isn't likely to go away with this patch... only
way to make it go away is to have every subsystem including tcp
incoming to have mempools for everything which is too complicated to
implement so we've to live the imperfect world that just works good
enough.

This logic of falling back in a may_writepage=0 pass will make things
a bit more reliable but certainly not perfect and it doesn't obsolete
the need of the current code IMHO.
