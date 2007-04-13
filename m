Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbXDMQhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbXDMQhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXDMQhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:37:40 -0400
Received: from waste.org ([66.93.16.53]:43427 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbXDMQhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:37:39 -0400
Date: Fri, 13 Apr 2007 11:24:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413162436.GO11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412174201.065068b2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 05:42:01PM -0700, Andrew Morton wrote:
> On Fri, 13 Apr 2007 10:15:24 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > >>+                       ((char *)page)[1] = PAGE_SHIFT;
> > > 
> > > 
> > > OK.
> > 
> > Shouldn't we just expose page size and endianness by other means? (another file or
> > syscall).
> 
> I don't think so - this file exposes fairly deep kernel internals and
> that's unavoidable, really - it's *supposed* to do that.  It is explicitly
> designed for monitoring kernel behaviour.
> 
> So it needs special handling by userspace.  Keeping the number of files
> which need such special handling to a minimum will keep the number of
> applications which are exposed to kernel changes to a minimum.
> 
> > >>+               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
> > >>+                       ppage = pfn_to_page(pfn);
> > >>+                       if (!ppage) {
> > >>+                               page[i] = 0;
> > >>+                               page[i + 1] = 0;
> > >>+                       } else {
> > >>+                               page[i] = ppage->flags;
> > >>+                               page[i + 1] = atomic_read(&ppage->_count);
> > >>+                       }
> > >>+               }
> > > 
> > > 
> > > Not a good idea to expose raw flags in this manner - it changes at the drop
> > > of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
> > > mapping to make this viable.
> > 
> > I don't think it is viable because that makes the flags part of the
> > userspace ABI.
> 
> It *will* be viable.  If the application wants to know if a page is dirty,
> it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
> numerical offset when inspecting fields in /proc/kpagemap.  If correctly
> designed, such a monitoring application will be able to report upon page
> flags which we haven't even thought up yet.

We can probably fit this in the existing (variable-sized) header.
 
> > I wonder what they are needed for.
> 
> Poking deeply into the kernel to provide information about kernel state. 
> 
> There are real-world needs for this, and the people who develop tools to
> process this information will have decent kernel understanding and will
> know that the file's contents may alter across kernel versions.  It sure
> beats poking around in /dev/kmem.
> 
> I doubt if there's a sensible way in which we can prettify this interface
> without losing information.  But we should aim to make it as robust as
> possible agaisnt future kenrel changes, of course.
> 
> And we should satisfy ourselves that all the required information has been
> made available.  The fact that it will satisfy the Oracle requirement is
> encouraging.
> 
> Matt, these changes make the new field in /proc/pid/smaps redundant, don't
> they?

Which new field? From /proc/kpagemap + /proc/*/pagemap, you can
basically synthesize any statistic you want, including all the
existing ones. For some data, /proc/pid/smaps (or /proc/meminfo) will
be considerably more efficient.

But in general, most of the statistics in smaps are basically useless
for shared mappings, just like RSS. Problem is, we really don't know
what statistics we want yet, or even if it can be distilled down to
simple numbers anyway.

-- 
Mathematics is the supreme nostalgia of our time.
