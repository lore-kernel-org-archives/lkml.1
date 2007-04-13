Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXDMAmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXDMAmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXDMAmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:42:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39263 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXDMAmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:42:09 -0400
Date: Thu, 12 Apr 2007 17:42:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-Id: <20070412174201.065068b2.akpm@linux-foundation.org>
In-Reply-To: <461ECB9C.8060000@yahoo.com.au>
References: <1.486631555@selenic.com>
	<20070412231050.GN2986@holomorphy.com>
	<20070412163235.dd030637.akpm@linux-foundation.org>
	<461ECB9C.8060000@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 10:15:24 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> >>+                       ((char *)page)[1] = PAGE_SHIFT;
> > 
> > 
> > OK.
> 
> Shouldn't we just expose page size and endianness by other means? (another file or
> syscall).

I don't think so - this file exposes fairly deep kernel internals and
that's unavoidable, really - it's *supposed* to do that.  It is explicitly
designed for monitoring kernel behaviour.

So it needs special handling by userspace.  Keeping the number of files
which need such special handling to a minimum will keep the number of
applications which are exposed to kernel changes to a minimum.

> >>+               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
> >>+                       ppage = pfn_to_page(pfn);
> >>+                       if (!ppage) {
> >>+                               page[i] = 0;
> >>+                               page[i + 1] = 0;
> >>+                       } else {
> >>+                               page[i] = ppage->flags;
> >>+                               page[i + 1] = atomic_read(&ppage->_count);
> >>+                       }
> >>+               }
> > 
> > 
> > Not a good idea to expose raw flags in this manner - it changes at the drop
> > of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
> > mapping to make this viable.
> 
> I don't think it is viable because that makes the flags part of the
> userspace ABI.

It *will* be viable.  If the application wants to know if a page is dirty,
it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
numerical offset when inspecting fields in /proc/kpagemap.  If correctly
designed, such a monitoring application will be able to report upon page
flags which we haven't even thought up yet.

> I wonder what they are needed for.

Poking deeply into the kernel to provide information about kernel state. 

There are real-world needs for this, and the people who develop tools to
process this information will have decent kernel understanding and will
know that the file's contents may alter across kernel versions.  It sure
beats poking around in /dev/kmem.

I doubt if there's a sensible way in which we can prettify this interface
without losing information.  But we should aim to make it as robust as
possible agaisnt future kenrel changes, of course.

And we should satisfy ourselves that all the required information has been
made available.  The fact that it will satisfy the Oracle requirement is
encouraging.

Matt, these changes make the new field in /proc/pid/smaps redundant, don't
they?

