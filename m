Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbXDMA2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbXDMA2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXDMA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:28:30 -0400
Received: from waste.org ([66.93.16.53]:44773 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbXDMA23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:28:29 -0400
Date: Thu, 12 Apr 2007 19:15:58 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: William Lee Irwin III <wli@holomorphy.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413001558.GI11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412163235.dd030637.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 04:32:35PM -0700, Andrew Morton wrote:
> On Thu, 12 Apr 2007 16:10:50 -0700
> William Lee Irwin III <wli@holomorphy.com> wrote:
> 
> > On Tue, Apr 03, 2007 at 09:43:30PM -0500, Matt Mackall wrote:
> > > This patch series introduces /proc/pid/pagemap and /proc/kpagemap,
> > > which allow detailed run-time examination of process memory usage at a
> > > page granularity.
> > > The first several patches whip the page-walking code introduced for
> > > /proc/pid/smaps and clear_refs into a more generic form, the next
> > > couple make those interfaces optional, and the last two introduce the
> > > new interfaces, also optional.
> > 
> > This solves a real-life problem for Oracle system monitoring software
> > (specifically EM). Among the tasks it must carry out is determining
> > per-process memory footprint of a set of cooperating tasks (i.e. Oracle
> > processes). RSS is inadequate for this due to page sharing; this work
> > provides sufficient information to determine what EM needs.
> 
> I'm still dying to see what the human-readable output from this
> thing looks like.

Still a work-in-progress. It's a monstrous amount of data and it
basically requires a GUI to really get a handle on. Here's a couple
apps I've been tinkering with (aka My First GTK Apps):

http://selenic.com/Screenshot-pagemap.png

That's a snapshot of a live-updating image of memory usage for a
running process (Galeon). Each pixel is a page. Each 32x32 block is
4MB. Mappings are dark red. Pages that are actually faulted in are
bright red. You can poke around in the memory map with the mouse and
highlight mappings (blue). And pages that get faulted in flash green
(hard to capture in a screenshot).

http://selenic.com/Screenshot-kpagemap.png

And that's a live-updating image of system-wide memory usage. Bright
red are pages with a count of 1, dark red are pages with higher
counts. Next is to visualize slab/page cache/buddy/active/lru data as
well as highlight changing pages.

This isn't terribly interesting yet. It can tell you things about page
cache usage and fragmentation and readahead and so on.

But correlating across the two sources, we'll be able to show
information like "what pages in a process are actually
shared/active/lru/etc." You can take it even further by correlating
the above data with symbol info from nm, /proc/pid/clear_refs, etc.

Also, something I immediately noticed on looking at the raw data
(cat /proc/`pidof`/pagemap | hexdump -C | less):

002c8fd0  ff ff ff ff ff ff ff ff  ff ff ff ff 6d f8 03 00 |............m...|
002c8fe0  6c f8 03 00 b9 f8 03 00  6b f8 03 00 6a f8 03 00 |l.......k...j...|
002c8ff0  b8 f8 03 00 69 f8 03 00  68 f8 03 00 b7 f8 03 00 |....i...h.......|
002c9000  67 f8 03 00 66 f8 03 00  b6 f8 03 00 65 f8 03 00 |g...f.......e...|
002c9010  64 f8 03 00 b5 f8 03 00  63 f8 03 00 62 f8 03 00 |d.......c...b...|
002c9020  b4 f8 03 00 61 f8 03 00  60 f8 03 00 b3 f8 03 00 |....a...`.......|
002c9030  7f f8 03 00 7e f8 03 00  b2 f8 03 00 7d f8 03 00 |....~.......}...|
002c9040  7c f8 03 00 b1 f8 03 00  5f f8 03 00 5e f8 03 00 ||......._...^...|
002c9050  b0 f8 03 00 5d f8 03 00  5c f8 03 00 af f8 03 00 |....]...\.......|

Most of the consecutive page frames are allocated in descending order
(6d 6c 6b 6a ...). That's pessimal for physical merging of block I/O.
Given that we theoretically fixed this long-standing problem in 2.6
but it's obviously still happening, it's clear that a little more
visibility into the VM would be useful.

-- 
Mathematics is the supreme nostalgia of our time.
