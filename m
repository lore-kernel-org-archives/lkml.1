Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXHRCsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXHRCsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 22:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXHRCsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 22:48:37 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:58130 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751677AbXHRCsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 22:48:36 -0400
Message-ID: <387405312.22079@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 18 Aug 2007 10:48:31 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in
	granularity of pages
Message-ID: <20070818024831.GA7856@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817064727.GA6723@mail.ustc.edu.cn> <20070817165808.GM30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817165808.GM30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Fri, Aug 17, 2007 at 11:58:08AM -0500, Matt Mackall wrote:
> On Fri, Aug 17, 2007 at 02:47:27PM +0800, Fengguang Wu wrote:
> > It's not easy to do direct performance comparisons between pmaps and
> > pagemap/kpagemap. However some close analyzes are still possible :)
> > 
> > 1) code size
> > pmaps                   ~200 LOC
> > pagemap/kpagemap        ~300 LOC
> > 
> > 2) dataset size
> > take for example my running firefox on Intel Core 2:
> > VSZ             400 MB
> > RSS              64 MB, or 16k pages
> > pmaps            64 KB, wc shows 2k lines, or so much page ranges
> > pagemap         800 KB, could be heavily optimized by returning partial data
> 
> I take it you're in 64-bit mode?

Yes. That will be the common case.

> You're right, this data compresses well in many circumstances. I
> suspect it will suffer under memory pressure though. That will
> fragment the ranges in-memory and also fragment the active bits. The
> worst case here is huge, of course, but realistically I'd expect
> something like 2x-4x.

Not likely to degrade even under memory pressure ;)

The compress_ratio = (VSZ:RSS) * (RSS:page_ranges).
- On fresh startup and no memory pressure,
  - the VSZ:RSS ratio of ALL processes are 4516796KB:457048KB ~= 10:1.
  - the firefox case shows a (RSS:page_ranges) of 16k:2k ~= 8:1.
- On memory pressure,
  - as VSZ goes up, RSS will be bounded by physical memory.
    So VSZ:RSS ratio actually goes up with memory pressure.
  - page range is a good unit of locality. They are more likely to be
    reclaimed as a whole. So (RSS:page_ranges) wouldn't degrade as much.

> But there are still the downsides I have mentioned:
> 
> - you don't get page frame numbers

True. I guess PFNs are meaningless to a normal user?

> - you can't do random access

Not for now.

It would be trivial to support seek-by-address semantic: the seqfile
operations already iterate by addresses. Only that we cannot do it via
the regular read/pread/seek interfaces. They have different semantic
on fpos. However, tricks like ioctl(begin_addr, end_addr) can be
employed if necessary.

> And how long does it take to pull the data out? My benchmarks show
> greater than 50MB/s (and that's with the version in -mm that's doing
> double buffering), so that 800K would take < .016s. 

You are right :)

> > kpagemap        256 KB
> > 
> > 3) runtime overheads
> > pmaps            2k lines of string processing(encode/decode)
> > kpagemap        16k seek()/read()s, and context switches (could be
> >                     optimized somehow by doing a PFN sort first, but
> >                     that's also non-trivial overheads)
> 
> You can do anywhere between 16k small reads or 1 large read. Depends

No way to avoid the seeks if PFNs are discontinuous. Too bad the
memory get fragmented with uptime, at least for the current kernel.

But sure, sequential reads are viable when doing whole system memory
analysis, or for memory hog processes.

> what data you're trying to get. Right now, kpagemap is fast enough
> that I can do realtime displays of the whole of memory in my desktop
> in a GUI written in Python. And Python is fairly horrible for drawing
> bitmaps and such.
> 
> http://www.selenic.com/Screenshot-kpagemap.png
> 
> > So pmaps seems to be a clear winner :)
> 
> Except that it's only providing a subset of the data.

Yes, and it's a nice graph :)

