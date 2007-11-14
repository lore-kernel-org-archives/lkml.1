Return-Path: <linux-kernel-owner+w=401wt.eu-S1762377AbXKNXhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377AbXKNXhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXKNXhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:37:46 -0500
Received: from waste.org ([66.93.16.53]:57373 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbXKNXhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:37:46 -0500
Date: Wed, 14 Nov 2007 17:37:13 -0600
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071114233713.GW19691@waste.org>
References: <20071114190501.GA5768@elte.hu> <20071114.143938.23516450.davem@davemloft.net> <20071114225335.GV19691@waste.org> <20071114.151013.05582536.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114.151013.05582536.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 03:10:13PM -0800, David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Wed, 14 Nov 2007 16:53:36 -0600
> 
> > He hit the bug using SLOB and there are no kmem (or any other) caches
> > in SLOB.
> 
> That's unfortunate, is there any user tracking facility at
> all?

No, the usual strategy for debugging problems -outside- SLOB is to
switch to another allocator with more extensive debugging facilities.

It is of course possible to add redzoning, last user, etc., but there
aren't many advantages to implementing these in SLOB compared to
switching allocators, unless the bug disappears in those other
allocators. In the case of random pointer fandango, such bugs are
likely to disappear when you turn on debugging anyway.

The most likely thing you'll hit in SLOB vs SLUB/SLAB is that SLOB
doesn't hand back power-of-two allocations for kmalloc. Instead, it
has 2-byte granularity on most machines. So small pointer overruns on
kmalloced objects will be somewhat more visible in SLOB than
SLAB/SLUB. I don't think SLAB/SLUB debugging can detect overruns
inside the not-requested-but-still-allocated region of objects.

I've implemented redzoning and various other debugging checks for
earlier versions of SLOB to find problems -in- the allocator, but
those won't apply to current SLOB (which can be considered v2).

-- 
Mathematics is the supreme nostalgia of our time.
