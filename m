Return-Path: <linux-kernel-owner+w=401wt.eu-S1765449AbXJPAgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765449AbXJPAgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbXJPAgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:36:24 -0400
Received: from waste.org ([66.93.16.53]:49525 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbXJPAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:36:23 -0400
Date: Mon, 15 Oct 2007 19:35:39 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags interfaces
Message-ID: <20071016003538.GC19691@waste.org>
References: <11.290135367@selenic.com> <1192488513.6118.98.camel@localhost> <20071015231106.GX19691@waste.org> <1192491297.6118.129.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192491297.6118.129.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 04:34:57PM -0700, Dave Hansen wrote:
> On Mon, 2007-10-15 at 18:11 -0500, Matt Mackall wrote:
> > > Could we just have /proc/kpagereferenced?  Is there a legitimate need
> > > for other flags to be visible?
> > 
> > Referenced, dirty, uptodate, lru, active, slab, writeback, reclaim,
> > and buddy all look like they might be interesting to me from the point
> > of view of watching what's happening in the VM graphically in
> > real-time.
> 
> This is true, but it forces a lot of logic from the kernel to be run in
> userspace to figure out what is going on.  Looking at mainline today:
> 
> #define PG_reclaim              17      /* To be reclaimed asap */
> ...
> #define PG_readahead            PG_reclaim /* Reminder to do async read-ahead */
> 
> All of a sudden, to figure out which flag it actually is, we need to
> have all of the logic that the kernel does.  
> 
> Does this establish a fixed user<->kernel ABI that will keep us from
> doing this in the future:
> 
> -#define PG_slab                  7      /* slab debug (Suparna wants this) */
> +#define PG_slab                  14      /* slab debug (Suparna wants this) */
> 
> Or, even something like this:
> 
> -#define PageSlab(page)          test_bit(PG_slab, &(page)->flags)
> +#define PageSlab(page)          (!PageLRU(page) && !PageHighmem(page))

Yeah, there are a bunch of flags that aren't mutually exclusive and we
could probably recover a few.

> If we actually had several (or even still one file) that exposed this
> state, independent of the actual content of page->flags, I think we'd be
> better off.  I think that's the difference between a fun, super-useful
> debugging feature and one that can stay in mainline and have
> applications stay using it (without breaking) for a long time.
> 
> The flags you listed are things that I would imagine will always exist,
> logically.  But, we might not always have a specific page flag for pages
> under writeback or in the buddy list for that matter.  PG_buddy isn't
> that old.  Perhaps that would be better abstracted to something like
> page_in_main_allocator().

Perhaps we need something like:

flags = page->flags;
userflags = 
	  FLAG_BIT(USER_REFERENCED, flags & PG_referenced) |
	  ...

etc. for the flags we want to export. This will let us change to

	 FLAG_BIT(USER_SLAB, PageSlab(page)) |

if we make a virtual slab bit.

And it shows up in grep.

Unfortunately, i386 test_bit is an asm inline and not a macro so we
can't hope for the compiler to fold up a bunch of identity bit
mappings for us.


-- 
Mathematics is the supreme nostalgia of our time.
