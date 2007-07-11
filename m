Return-Path: <linux-kernel-owner+w=401wt.eu-S1765739AbXGKSEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765739AbXGKSEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXGKSEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:04:23 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52388 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbXGKSEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:04:21 -0400
Date: Wed, 11 Jul 2007 19:03:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Hellwig <hch@infradead.org>
cc: Jes Sorensen <jes@sgi.com>, Dmitry Monakhov <dmonakhov@sw.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
In-Reply-To: <20070711101437.GA21735@infradead.org>
Message-ID: <Pine.LNX.4.64.0707111826530.22786@blonde.wat.veritas.com>
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
 <20070711093253.GA19061@infradead.org> <20070711101245.GA18770@dnb.sw.ru>
 <20070711101437.GA21735@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZG1vbmFraG92QHN3LnJ1AGplc0BzZ2kuY29tAGhjaEBpbmZyYWRlYWQub3JnAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Christoph Hellwig wrote:
> On Wed, Jul 11, 2007 at 02:12:45PM +0400, Dmitry Monakhov wrote:
> > > > Or would this simpler patch be the right one?  I suspect the
> > > > mspec driver only says VM_LOCKED because of a deep-seated but
> > > > irrational fear that its pages might fall into reclaim.

I was perhaps too unkind: that fear was not irrational in 2.4,
when reclaim scanned vmas; but in 2.6, pages have to be on one
of reclaim's LRUs to fall vulnerable to it.

> > > 
> > > Looks good.  We probably should add a debug check to do_mmap_pgoff
> > > so that ->mmap methods don't change flags that are not for drivers.

We could indeed, though I'd rather not jump into that: something
to do when we tidy up those driver mmaps (something I promised to
do 18 months ago?), there's a lot of pointless flag setting.

> > As result fglrx totally goes crazy, because it change vm_flags
> > even from  ->nopage() calback :)

That must be an exciting new State of the Art version of fglrx.

Looking at what I downloaded for inspection a year ago, I can't
see any sign of that.  But I do see lots of random stabs at setting
different vm_flags in different mmap cases (VM_IO, VM_SHM, VM_RESERVED,
VM_LOCKED): of which the VM_IO serves some point, VM_SHM is defunct,
VM_RESERVED will be defunct, and VM_LOCKED can confuse us.

But interestingly, where they set VM_LOCKED, they did increment
vm_locked: so there shouldn't be that issue of wrapping negative
on munmap, which had worried me.  And now I look at Dmitry's
patch again, I see that he was indeed assuming that the driver
had done that incrementation.

> Well, everyone with half a brain knows that fglrx is not just legally
> problematic but an utter piece of junk.  We should add more debug checks
> to stop it from doing such stupid things.  And yes, chaning flags from
> ->nopage() does not just deserve a warning but a panic.

Well, they'll get what they deserve.  I'm not convinced Dmitry's right
about their nopage; and I'm not going to waste any more time working
out ways to protect ourselves from them.  Let's stick with the mspec.

Hugh
