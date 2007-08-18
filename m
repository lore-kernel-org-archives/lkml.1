Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbXHRGju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbXHRGju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 02:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXHRGjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 02:39:43 -0400
Received: from waste.org ([66.93.16.53]:58559 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbXHRGjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 02:39:42 -0400
Date: Sat, 18 Aug 2007 01:40:42 -0500
From: Matt Mackall <mpm@selenic.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages
Message-ID: <20070818064042.GQ30556@waste.org>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817064727.GA6723@mail.ustc.edu.cn> <20070817165808.GM30556@waste.org> <20070818024831.GA7856@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818024831.GA7856@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 10:48:31AM +0800, Fengguang Wu wrote:
> Matt,
> 
> On Fri, Aug 17, 2007 at 11:58:08AM -0500, Matt Mackall wrote:
> > On Fri, Aug 17, 2007 at 02:47:27PM +0800, Fengguang Wu wrote:
> > > It's not easy to do direct performance comparisons between pmaps and
> > > pagemap/kpagemap. However some close analyzes are still possible :)
> > > 
> > > 1) code size
> > > pmaps                   ~200 LOC
> > > pagemap/kpagemap        ~300 LOC
> > > 
> > > 2) dataset size
> > > take for example my running firefox on Intel Core 2:
> > > VSZ             400 MB
> > > RSS              64 MB, or 16k pages
> > > pmaps            64 KB, wc shows 2k lines, or so much page ranges
> > > pagemap         800 KB, could be heavily optimized by returning partial data
> > 
> > I take it you're in 64-bit mode?
> 
> Yes. That will be the common case.
> 
> > You're right, this data compresses well in many circumstances. I
> > suspect it will suffer under memory pressure though. That will
> > fragment the ranges in-memory and also fragment the active bits. The
> > worst case here is huge, of course, but realistically I'd expect
> > something like 2x-4x.
> 
> Not likely to degrade even under memory pressure ;)
> 
> The compress_ratio = (VSZ:RSS) * (RSS:page_ranges).
> - On fresh startup and no memory pressure,
>   - the VSZ:RSS ratio of ALL processes are 4516796KB:457048KB ~= 10:1.
>   - the firefox case shows a (RSS:page_ranges) of 16k:2k ~= 8:1.

Yes.

> - On memory pressure,
>   - as VSZ goes up, RSS will be bounded by physical memory.
>     So VSZ:RSS ratio actually goes up with memory pressure.

And yes.

But that's not what I'm talking about. You're likely to have more
holes in your ranges with memory pressure as things that aren't active
get paged or swapped out and back in. And because we're walking the
LRU more rapidly, we'll flip over a lot of the active bits more often
which will mean more output.

>   - page range is a good unit of locality. They are more likely to be
>     reclaimed as a whole. So (RSS:page_ranges) wouldn't degrade as much.

There is that. The relative magnitude of the different effects is
unclear. But it is clear that the worst case for pmap is much worse
than pagemap (two lines per page of RSS?). 

> > But there are still the downsides I have mentioned:
> > 
> > - you don't get page frame numbers
> 
> True. I guess PFNs are meaningless to a normal user?

They're useful for anyone who's trying to look at the system as a
whole.
 
> > - you can't do random access
> 
> Not for now.
> 
> It would be trivial to support seek-by-address semantic: the seqfile
> operations already iterate by addresses. Only that we cannot do it via
> the regular read/pread/seek interfaces. They have different semantic
> on fpos. However, tricks like ioctl(begin_addr, end_addr) can be
> employed if necessary.

I suppose. But if you're willing to stomach that sort of thing, you
might as well use a simple binary interface.
 
-- 
Mathematics is the supreme nostalgia of our time.
