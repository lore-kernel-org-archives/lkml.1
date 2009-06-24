Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbZFXSa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbZFXSa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZFXSaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:30:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbZFXSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:30:51 -0400
Date: Wed, 24 Jun 2009 11:30:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090624113037.7d72ed59.akpm@linux-foundation.org>
In-Reply-To: <4A426825.80905@cs.helsinki.fi>
References: <20090624080753.4f677847@infradead.org>
	<20090624094622.d0b0fd82.akpm@linux-foundation.org>
	<84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	<20090624105517.904f93da.akpm@linux-foundation.org>
	<4A426825.80905@cs.helsinki.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 20:53:41 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> Andrew Morton wrote:
> > On Wed, 24 Jun 2009 19:55:24 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> >> On Wed, Jun 24, 2009 at 7:46 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> >>> Well yes. __Using GFP_NOFAIL on a higher-order allocation is bad. __This
> >>> patch is there to find, name, shame, blame and hopefully fix callers.
> >>>
> >>> A fix for cxgb3 is in the works. __slub's design is a big problem.
> >>>
> >>> But we'll probably have to revert it for 2.6.31 :(
> >> How is SLUB's design a problem here? Can't we just clear GFP_NOFAIL
> >> from the higher order allocation and thus force GFP_NOFAIL allocations
> >> to use the minimum required order?
> > 
> > That could then lead to the __GFP_NOFAIL allocation attempt returning
> > NULL.  But the callers cannot handle that and probably don't even test
> > for it - this is why they used __GFP_NOFAIL.
> 
> No, the fallback allocation would still use __GFP_NOFAIL so the 
> semantics are preserved.
> 

<looks>

hm, I didn't know that slub could fall back to lower-order allocations
like that.  Neat.

Yes, it looks like that change would improve things.  We have had
reports before of machines which oomed over an order-1 attempt when
there were order-0 pages available.  If that were to happen in
allocate_slab(__GFP_NOFAIL), things would get ugly and the patch would
help.

What's the expected value of s->min in allocate_slab()?  In what
situations would it be >0?


btw, gcc has in the past made a mess of handling small copy-by-value
structs like 'struct kmem_cache_order_objects'.  Probably it's improved
in recent years, but it'd be worth checking to see if
s/struct kmem_cache_order_objects/unsigned long/ generates better code.
