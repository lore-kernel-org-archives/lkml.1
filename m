Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXDMB5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXDMB5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXDMB5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:57:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXDMB5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:57:31 -0400
Date: Thu, 12 Apr 2007 18:57:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-Id: <20070412185723.5a5f0443.akpm@linux-foundation.org>
In-Reply-To: <461EE005.6070605@yahoo.com.au>
References: <1.486631555@selenic.com>
	<20070412231050.GN2986@holomorphy.com>
	<20070412163235.dd030637.akpm@linux-foundation.org>
	<461ECB9C.8060000@yahoo.com.au>
	<20070412174201.065068b2.akpm@linux-foundation.org>
	<461ED96C.5030606@yahoo.com.au>
	<20070412182213.a18cc4a7.akpm@linux-foundation.org>
	<461EE005.6070605@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 11:42:29 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Andrew Morton wrote:
> > On Fri, 13 Apr 2007 11:14:20 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > 
> > 
> >>Andrew Morton wrote:
> 
> >>>It *will* be viable.  If the application wants to know if a page is dirty,
> >>>it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
> >>>numerical offset when inspecting fields in /proc/kpagemap.  If correctly
> >>>designed, such a monitoring application will be able to report upon page
> >>>flags which we haven't even thought up yet.
> >>
> >>Ooh, you wanted a _runtime_ mapping of flags, yeah then I guess that works.
> >>Still seems like a basically hit and miss affair to just use flags. What if
> >>you want to know the process mapping a page? With systemtap or something you
> >>could walk the rmap structures. What if you want to look at pages along the
> >>LRU list rather than per-pfn? What about connecting pages to inodes?
> > 
> > 
> > Well hang on.  This isn't a tool for understanding kernel behaviour.  It's
> > a tool for understanding applciation behaviour.
> > 
> > So one doesn't ask "who is mapping that page" - that's a kernel developer
> > thing.
> > 
> > Instead, one says "what pages are being used by my application", then, for
> 
> That includes unmapped pagecache being used by my application, doesn't it?
> Maybe that's too hard to do via /proc so we forget about it...

Yes, harder.  I'm hoping that sampling of /proc/pid/io can be used to
determine pagecache use sufficiently accurately.  I know of one large
hosting company who are using it ("BTW, we are making great use of
taskstats!!  Its GREAT!")

> 
> > each of those pages "what is that page's state".  So the first step is to
> > collect all the pfns from /proc/$(pidof my-application)/pagemap and then to
> > use those pfns to look the individual pages up in /proc/kpagemap.
> 
> OK I realise you could do it that way, but systemtap can definitely be
> used as a tool for understanding application behaviour in the context of
> the kernel, I think? The purpose for it is so that various little bits
> of deep kernel internals do not have to be exposed on a case by case basis.
> 
> If kprobes is simply crappy and doesn't work properly for this, then I
> could accept that. I'm not someone trying to get this info. So why can't
> it be used? (not just for kpagemap, but for clear_refs and all that gunk
> too).
> 
>  > If you really want to know "who is using page 123435" then you'd need to
>  > search /proc/*/pagemap.  There are possibly legitimate reasons why an
>  > application developer would want to at least pertially perform such an
>  > operation ("who am I sharing with"), but I doubt if it's the common case.
> 
> Maybe. How about LRU? Reclaim performance is bad, and you want to work out
> which pages keep going off the end of it, or which pages keep getting
> written out via it, or who's pages are on the active list, forcing mine
> out.

I guess we have static analysis versus dynamic.  The interfaces which Matt
is proposing are suited to answering the question "what is my memory being
used for" (static).  They're unlikely to be useful for answering the question
"what's happening in the VM" (dynamic).  Systemtap is probably better for the
dynamic analysis.

I guess one could generate an answer to the static question with systemtap,
by accumulating running counts across the application lifetime and then
snapshotting them.  Sounds hard though.

