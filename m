Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbXDMBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbXDMBWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXDMBWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:22:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbXDMBWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:22:19 -0400
Date: Thu, 12 Apr 2007 18:22:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-Id: <20070412182213.a18cc4a7.akpm@linux-foundation.org>
In-Reply-To: <461ED96C.5030606@yahoo.com.au>
References: <1.486631555@selenic.com>
	<20070412231050.GN2986@holomorphy.com>
	<20070412163235.dd030637.akpm@linux-foundation.org>
	<461ECB9C.8060000@yahoo.com.au>
	<20070412174201.065068b2.akpm@linux-foundation.org>
	<461ED96C.5030606@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 11:14:20 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Andrew Morton wrote:
> > On Fri, 13 Apr 2007 10:15:24 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> >>>>+               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
> >>>>+                       ppage = pfn_to_page(pfn);
> >>>>+                       if (!ppage) {
> >>>>+                               page[i] = 0;
> >>>>+                               page[i + 1] = 0;
> >>>>+                       } else {
> >>>>+                               page[i] = ppage->flags;
> >>>>+                               page[i + 1] = atomic_read(&ppage->_count);
> >>>>+                       }
> >>>>+               }
> >>>
> >>>
> >>>Not a good idea to expose raw flags in this manner - it changes at the drop
> >>>of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
> >>>mapping to make this viable.
> >>
> >>I don't think it is viable because that makes the flags part of the
> >>userspace ABI.
> > 
> > 
> > It *will* be viable.  If the application wants to know if a page is dirty,
> > it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
> > numerical offset when inspecting fields in /proc/kpagemap.  If correctly
> > designed, such a monitoring application will be able to report upon page
> > flags which we haven't even thought up yet.
> 
> Ooh, you wanted a _runtime_ mapping of flags, yeah then I guess that works.
> Still seems like a basically hit and miss affair to just use flags. What if
> you want to know the process mapping a page? With systemtap or something you
> could walk the rmap structures. What if you want to look at pages along the
> LRU list rather than per-pfn? What about connecting pages to inodes?

Well hang on.  This isn't a tool for understanding kernel behaviour.  It's
a tool for understanding applciation behaviour.

So one doesn't ask "who is mapping that page" - that's a kernel developer
thing.

Instead, one says "what pages are being used by my application", then, for
each of those pages "what is that page's state".  So the first step is to
collect all the pfns from /proc/$(pidof my-application)/pagemap and then to
use those pfns to look the individual pages up in /proc/kpagemap.

If you really want to know "who is using page 123435" then you'd need to
search /proc/*/pagemap.  There are possibly legitimate reasons why an
application developer would want to at least pertially perform such an
operation ("who am I sharing with"), but I doubt if it's the common case.

> 
> But I was going to say
> that satisfying an Oracle requirement is a good reason _not_ to merge it ;)
>

hm, yes, there's plenty of precedent for that.

> (I joke!)

I akpm!
