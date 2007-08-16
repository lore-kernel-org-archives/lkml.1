Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbXHPBhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbXHPBhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXHPBhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:37:08 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:57404 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753212AbXHPBhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:37:05 -0400
Message-ID: <387228221.02620@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 16 Aug 2007 09:37:01 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] /proc/<pid>/pmaps - memory maps in granularity of
	pages
Message-ID: <20070816013701.GA5209@mail.ustc.edu.cn>
References: <20070814085204.GA10884@mail.ustc.edu.cn> <20070814162618.GV30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814162618.GV30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 11:26:18AM -0500, Matt Mackall wrote:
> On Tue, Aug 14, 2007 at 04:52:04PM +0800, Fengguang Wu wrote:
> > Hello,
> > 
> > Matt Mackall brings us many memory-footprint-optimization
> > opportunities with his pagemap/kpagemap patches. However I wonder if
> > the binary interface can be improved.
> > 
> > This seq_file based implementation iterates in the unit of vmas.  So
> > super large vmas can be a problem. The next step is to to do address
> > based iteration. That should not be hard.
> > 
> > Andrew, please stop me early if it is at all a wrong interface :)
> > 
> > Thank you,
> > Fengguang
> > ===
> > 
> > Show a process's memory maps page-by-page in /proc/<pid>/pmaps.
> > It helps to analyze application's memory footprint in a comprehensive way.
> > 
> > Pages share the same states are grouped into a page range.
> > For each page range, the following fields are exported:
> > 	- first page index
> > 	- number of pages in the range
> > 	- well known page/pte flags
> > 	- number of mmap users
> > 
> > Only page flags not expected to disappear in the near future are exported:
> > 
> > 	Y:young R:referenced A:active U:uptodate P:ptedirty D:dirty W:writeback
> > 
> > Here is a sample output:
> > 
> > # cat /proc/$$/pmaps
> > 08048000-080c9000 r-xp 08048000 00:00 0
> > 32840   129     Y_A_P__ 1
> > 080c9000-080f6000 rwxp 080c9000 00:00 0                                  [heap]
> > 32969   45      Y_A_P__ 1
> > f7dba000-f7dc3000 r-xp 00000000 03:00 176633                             /lib/libnss_files-2.3.6.so
> > 0       1       Y_AU___ 1
> > 1       1       YR_U___ 1
> > 5       1       YR_U___ 1
> > 8       1       Y_AU___ 1
> > f7dc3000-f7dc5000 rwxp 00008000 03:00 176633                             /lib/libnss_files-2.3.6.so
> > 8       2       Y_A_P__ 1
> > f7dc5000-f7dcd000 r-xp 00000000 03:00 176635                             /lib/libnss_nis-2.3.6.so
> > 0       1       Y_AU___ 1
> > 1       1       YR_U___ 1
> > 4       1       YR_U___ 1
> > 7       1       Y_AU___ 1
> > f7dcd000-f7dcf000 rwxp 00007000 03:00 176635                             /lib/libnss_nis-2.3.6.so
> > 7       2       Y_A_P__ 1
> > f7dcf000-f7de1000 r-xp 00000000 03:00 176630                             /lib/libnsl-2.3.6.so
> > 0       1       Y_AU___ 1
> > 1       3       YR_U___ 1
> > 16      1       YR_U___ 1
> > f7de1000-f7de3000 rwxp 00011000 03:00 176630                             /lib/libnsl-2.3.6.so
> > 17      2       Y_A_P__ 1
> > [...]
> 
> That's a _lot_ of data to generate and parse. I doubt we can watch a

Yes, but won't be too bad because it works in a sparse way.

1) It will only generate output for resident pages, that normally is
much smaller than the mapped size. Take my shell for example, the
(size:rss) ratio is (7:1)!

wfg ~% cat /proc/$$/smaps |grep Size|sum
sum      50552.000 
avg        777.723 

wfg ~% cat /proc/$$/smaps |grep Rss|sum 
sum       7604.000 
avg        116.985 

2) The page range trick suppresses more output. Look at these lines:

> > 08048000-080c9000 r-xp 08048000 00:00 0
> > 32840   129     Y_A_P__ 1
> > 080c9000-080f6000 rwxp 080c9000 00:00 0 [heap]
> > 32969   45      Y_A_P__ 1

It's interesting to see that the seq_file interface demands some
more programming efforts, and provides this flexibility as well.

3) A 64bit number can be encoded in hex in 8 bytes, no more than its
binary presentation. And often the text string will be much shorter
because of the common small values.

4) String formatting is cheap. Much cheaper than pte/struct page
walkings, and context switches. Not to mention its user friendliness.

> larger app in realtime with this interface. And it doesn't give us
> physical page numbers either.

This could be a problem. Binary interface is discouraging, which is
good and bad. The good thing about it is that we can safely export
the raw PFN/page flag numbers without upsetting upset normal users. In
this way a possible useful kernel debugging interface can be shipped
everywhere.

If kpagemap is a reasonable kernel debug interface, I do not see the
reason why kpagemap and pmaps cannot coexist :)

