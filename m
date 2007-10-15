Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbXJOXfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbXJOXfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXJOXf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:35:26 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44181 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbXJOXfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:35:25 -0400
Subject: Re: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags
	interfaces
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <20071015231106.GX19691@waste.org>
References: <11.290135367@selenic.com> <1192488513.6118.98.camel@localhost>
	 <20071015231106.GX19691@waste.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 16:34:57 -0700
Message-Id: <1192491297.6118.129.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 18:11 -0500, Matt Mackall wrote:
> > Could we just have /proc/kpagereferenced?  Is there a legitimate need
> > for other flags to be visible?
> 
> Referenced, dirty, uptodate, lru, active, slab, writeback, reclaim,
> and buddy all look like they might be interesting to me from the point
> of view of watching what's happening in the VM graphically in
> real-time.

This is true, but it forces a lot of logic from the kernel to be run in
userspace to figure out what is going on.  Looking at mainline today:

#define PG_reclaim              17      /* To be reclaimed asap */
...
#define PG_readahead            PG_reclaim /* Reminder to do async read-ahead */

All of a sudden, to figure out which flag it actually is, we need to
have all of the logic that the kernel does.  

Does this establish a fixed user<->kernel ABI that will keep us from
doing this in the future:

-#define PG_slab                  7      /* slab debug (Suparna wants this) */
+#define PG_slab                  14      /* slab debug (Suparna wants this) */

Or, even something like this:

-#define PageSlab(page)          test_bit(PG_slab, &(page)->flags)
+#define PageSlab(page)          (!PageLRU(page) && !PageHighmem(page))

If we actually had several (or even still one file) that exposed this
state, independent of the actual content of page->flags, I think we'd be
better off.  I think that's the difference between a fun, super-useful
debugging feature and one that can stay in mainline and have
applications stay using it (without breaking) for a long time.

The flags you listed are things that I would imagine will always exist,
logically.  But, we might not always have a specific page flag for pages
under writeback or in the buddy list for that matter.  PG_buddy isn't
that old.  Perhaps that would be better abstracted to something like
page_in_main_allocator().

-- Dave

