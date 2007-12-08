Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbXLHSeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbXLHSeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXLHSea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:34:30 -0500
Received: from waste.org ([66.93.16.53]:56954 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbXLHSe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:34:29 -0500
Date: Sat, 8 Dec 2007 12:33:42 -0600
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52, [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071208183341.GM19691@waste.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 09:54:06AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 8 Dec 2007, Linus Torvalds wrote:
> > 
> > But I'll apply it anyway, because it looks "obviously correct" from the 
> > standpoint that the _other_??slob user already clears the end result 
> > explicitly later on, and we simply should never pass down __GFP_ZERO to 
> > the actual page allocator.
> 
> Actually, I take that back. The other slob users are different. They share 
> pages, this codepath does not.
> 
> So I think a more proper solution would be:
>  (a) Something like this patch (which includes my previous mm/slub.c 
>      change)
>  (b) don't warn about atomic GFP_ZERO's - unless they have GFP_HIGHMEM set 
>      *too*.

But what about:

(c) stop passing GFP_ZERO to kmalloc allocators
    stop fiddling with flags inside allocators
    remove ugly if (unlikely(gfp & GFP_ZERO)) from kmalloc allocators
    make kzalloc and kcalloc non-inline functions that do the memset

That should:

- make both kmalloc and kzalloc/kcalloc faster (one less branch)
- reduce kernel size

GFP_ZERO is a bit of an abuse here, given that we don't even intend to
pass it to the underlying "GFP".

-- 
Mathematics is the supreme nostalgia of our time.
