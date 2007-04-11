Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXDKTpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXDKTpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030259AbXDKTpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:45:21 -0400
Received: from kanga.kvack.org ([66.96.29.28]:46000 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250AbXDKTpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:45:19 -0400
Date: Wed, 11 Apr 2007 15:45:04 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Ken Chen <kenchen@google.com>
Cc: Zach Brown <zach.brown@oracle.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070411194504.GM13621@kvack.org>
References: <20070410235353.325A7346F64@localhost> <20070411180038.GN28322@mami.zabbo.net> <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 12:28:26PM -0700, Ken Chen wrote:
> >I have mixed feelings.  I think the userspace getevents support was
> >poorly designed and the simple fact that we've gone this long without it
> >says just how desperately the feature isn't needed.
> 
> I kept on getting requests from application developers who want that
> feature.  My initial patch was dated back May 2004.

The right way to do it involves synchronization between the kernel side 
io_getevents() and the userspace code pulling events out of the ring.  
Alan Cox suggested embedding a futex in the shared memory region, but I 
don't think anyone ever implemented that.

> I noticed that while writing the patch.  We have the same bug right
> now that nr_events is enlarged to consume the entire mmap'ed ring
> buffer pages.  But yet, we don't account those in aio_max_nr.  I
> didn't fix that up in this patch because I was going to do a separate
> patch on that.

It's not accounted because it is irrelevant -- the memory used by the 
events is already accounted against the user's address space.  The actual 
number of aios in flight is clamped to the maximum number of requests 
that was specified and accounted against the global reservation.  The 
number of events in the ringbuffer can be larger, and that doesn't hurt 
anything.

> >The ring page, which is mmaped to userspace at some weird address, was
> >just written through a kmap.  Do we need a flush_dcache_page()?  This
> >isn't this patch's problem, but it'd need to be addressed if we're using
> >the ring from userspace.
> 
> I will look into this aside from this patch.

That's probably the case.  Also, any changes in this area *must* correctly 
update the compat/incompat feature flags in the ring buffer header.  That 
has been missed in the past...

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
