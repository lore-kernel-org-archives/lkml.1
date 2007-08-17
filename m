Return-Path: <linux-kernel-owner+w=401wt.eu-S1765369AbXHQQ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765369AbXHQQ5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXHQQ5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:57:39 -0400
Received: from waste.org ([66.93.16.53]:42424 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbXHQQ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:57:38 -0400
Date: Fri, 17 Aug 2007 11:58:08 -0500
From: Matt Mackall <mpm@selenic.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages
Message-ID: <20070817165808.GM30556@waste.org>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817064727.GA6723@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817064727.GA6723@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 02:47:27PM +0800, Fengguang Wu wrote:
> Matt,
> 
> It's not easy to do direct performance comparisons between pmaps and
> pagemap/kpagemap. However some close analyzes are still possible :)
> 
> 1) code size
> pmaps                   ~200 LOC
> pagemap/kpagemap        ~300 LOC
> 
> 2) dataset size
> take for example my running firefox on Intel Core 2:
> VSZ             400 MB
> RSS              64 MB, or 16k pages
> pmaps            64 KB, wc shows 2k lines, or so much page ranges
> pagemap         800 KB, could be heavily optimized by returning partial data

I take it you're in 64-bit mode?

You're right, this data compresses well in many circumstances. I
suspect it will suffer under memory pressure though. That will
fragment the ranges in-memory and also fragment the active bits. The
worst case here is huge, of course, but realistically I'd expect
something like 2x-4x.

But there are still the downsides I have mentioned:

- you don't get page frame numbers
- you can't do random access

And how long does it take to pull the data out? My benchmarks show
greater than 50MB/s (and that's with the version in -mm that's doing
double buffering), so that 800K would take < .016s. 

> kpagemap        256 KB
> 
> 3) runtime overheads
> pmaps            2k lines of string processing(encode/decode)
> kpagemap        16k seek()/read()s, and context switches (could be
>                     optimized somehow by doing a PFN sort first, but
>                     that's also non-trivial overheads)

You can do anywhere between 16k small reads or 1 large read. Depends
what data you're trying to get. Right now, kpagemap is fast enough
that I can do realtime displays of the whole of memory in my desktop
in a GUI written in Python. And Python is fairly horrible for drawing
bitmaps and such.

http://www.selenic.com/Screenshot-kpagemap.png

> So pmaps seems to be a clear winner :)

Except that it's only providing a subset of the data.

-- 
Mathematics is the supreme nostalgia of our time.
