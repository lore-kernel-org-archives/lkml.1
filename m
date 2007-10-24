Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbXJXPVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbXJXPVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbXJXPU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:20:58 -0400
Received: from waste.org ([66.93.16.53]:34706 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbXJXPU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:20:58 -0400
Date: Wed, 24 Oct 2007 10:20:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071024152036.GX19691@waste.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx> <20071023221116.GL17536@waste.org> <20071024014920.GU27248@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024014920.GU27248@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:49:20PM -0600, Matthew Wilcox wrote:
> On Tue, Oct 23, 2007 at 05:11:16PM -0500, Matt Mackall wrote:
> > You might want to consider growing the buffer by no less than a small
> > constant factor like 1.3x. This will keep things that do short concats
> > in a loop from degrading to O(n^2) performance due to realloc and
> > memcpy.
> 
> I looked at slab and slub, and would grow the buffer by no less than
> 1.5x each time, thanks to the buckets.  I'd initially implemented 2x,
> but switched to allocating size+1 and calling ksize() as being a more
> efficient implementation.

Fair enough.
 
> I presume slob is different?  Actually, slob doesn't seem to
> provide krealloc, so I think stringbuf won't work on slob.  Will you
> have time to fix this?

http://lxr.linux.no/source/mm/slob.c#L207

Yep, slob is different, it has no kmalloc buckets.

> > Should probably just bite the bullet and pass a flag.
> 
> Hrm.
> 
> extern void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *fmt, ...)
>         __attribute__((format(printf, 3, 4)));
> 
> ?  Any objections?

Fine by me.
 
> > > +#define INITIAL_SIZE 32
> > 
> > Too small. That will guarantee that most users end up doing a realloc.
> > Can we have 128 instead?
> 
> I don't care.  Sure!

Most of these objects will have very short lifetimes, so there's very
little downside.

-- 
Mathematics is the supreme nostalgia of our time.
