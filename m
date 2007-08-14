Return-Path: <linux-kernel-owner+w=401wt.eu-S1765295AbXHNQ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765295AbXHNQ0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbXHNQZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:25:52 -0400
Received: from waste.org ([66.93.16.53]:44943 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbXHNQZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:25:51 -0400
Date: Tue, 14 Aug 2007 11:26:18 -0500
From: Matt Mackall <mpm@selenic.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] /proc/<pid>/pmaps - memory maps in granularity of pages
Message-ID: <20070814162618.GV30556@waste.org>
References: <20070814085204.GA10884@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814085204.GA10884@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 04:52:04PM +0800, Fengguang Wu wrote:
> Hello,
> 
> Matt Mackall brings us many memory-footprint-optimization
> opportunities with his pagemap/kpagemap patches. However I wonder if
> the binary interface can be improved.
> 
> This seq_file based implementation iterates in the unit of vmas.  So
> super large vmas can be a problem. The next step is to to do address
> based iteration. That should not be hard.
> 
> Andrew, please stop me early if it is at all a wrong interface :)
> 
> Thank you,
> Fengguang
> ===
> 
> Show a process's memory maps page-by-page in /proc/<pid>/pmaps.
> It helps to analyze application's memory footprint in a comprehensive way.
> 
> Pages share the same states are grouped into a page range.
> For each page range, the following fields are exported:
> 	- first page index
> 	- number of pages in the range
> 	- well known page/pte flags
> 	- number of mmap users
> 
> Only page flags not expected to disappear in the near future are exported:
> 
> 	Y:young R:referenced A:active U:uptodate P:ptedirty D:dirty W:writeback
> 
> Here is a sample output:
> 
> # cat /proc/$$/pmaps
> 08048000-080c9000 r-xp 08048000 00:00 0
> 32840   129     Y_A_P__ 1
> 080c9000-080f6000 rwxp 080c9000 00:00 0                                  [heap]
> 32969   45      Y_A_P__ 1
> f7dba000-f7dc3000 r-xp 00000000 03:00 176633                             /lib/libnss_files-2.3.6.so
> 0       1       Y_AU___ 1
> 1       1       YR_U___ 1
> 5       1       YR_U___ 1
> 8       1       Y_AU___ 1
> f7dc3000-f7dc5000 rwxp 00008000 03:00 176633                             /lib/libnss_files-2.3.6.so
> 8       2       Y_A_P__ 1
> f7dc5000-f7dcd000 r-xp 00000000 03:00 176635                             /lib/libnss_nis-2.3.6.so
> 0       1       Y_AU___ 1
> 1       1       YR_U___ 1
> 4       1       YR_U___ 1
> 7       1       Y_AU___ 1
> f7dcd000-f7dcf000 rwxp 00007000 03:00 176635                             /lib/libnss_nis-2.3.6.so
> 7       2       Y_A_P__ 1
> f7dcf000-f7de1000 r-xp 00000000 03:00 176630                             /lib/libnsl-2.3.6.so
> 0       1       Y_AU___ 1
> 1       3       YR_U___ 1
> 16      1       YR_U___ 1
> f7de1000-f7de3000 rwxp 00011000 03:00 176630                             /lib/libnsl-2.3.6.so
> 17      2       Y_A_P__ 1
> [...]

That's a _lot_ of data to generate and parse. I doubt we can watch a
larger app in realtime with this interface. And it doesn't give us
physical page numbers either.

-- 
Mathematics is the supreme nostalgia of our time.
