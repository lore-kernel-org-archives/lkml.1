Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbZD2X4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbZD2X4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZD2X40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:56:26 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:64513 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbZD2X40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:56:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYFAHCG+ElMQW1W/2dsb2JhbACBUL0hCJBhgiUWCIEyBQ
Date: Wed, 29 Apr 2009 19:56:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090429235623.GA17191@Krystal>
References: <20090429232546.GB15782@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090429232546.GB15782@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:42:28 up 60 days, 20:08,  1 user,  load average: 0.51, 0.71,
	0.62
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Basically, the following execution :
> 
> dd if=/dev/zero of=/tmp/testfile
> 
> will slowly fill _all_ ram available without taking into account memory
> pressure.
> 
> This is because the dirty page accounting is incorrect in
> redirty_page_for_writepage.
> 
> This patch adds missing dirty page accounting in redirty_page_for_writepage().
> This should fix a _lot_ of issues involving machines becoming slow under heavy
> write I/O. No surprise : eventually the system starts swapping.
> 
> Linux kernel 2.6.30-rc2
> 
> The /proc/meminfo picture I had before applying this patch after filling my
> memory with the dd execution was :
> 
> MemTotal:       16433732 kB
> MemFree:        10919700 kB

Darn, I have not taken this meminfo snapshot at the appropriate moment.

I actually have to double-check if 2.6.30-rc still shows the bogus
behavior I identified in the 2.6.28-2.6.29 days. Then I'll check with
earlier 2.6.29.x. I know there has been some improvement on the ext3
side since then. I'll come back when I have those informations.

Sorry.

Mathieu

> Buffers:           12492 kB
> Cached:          5262508 kB
> SwapCached:            0 kB
> Active:            37096 kB
> Inactive:        5254384 kB
> Active(anon):      16716 kB
> Inactive(anon):        0 kB
> Active(file):      20380 kB
> Inactive(file):  5254384 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:      19535024 kB
> SwapFree:       19535024 kB
> Dirty:           2125956 kB
> Writeback:         50476 kB
> AnonPages:         16660 kB
> Mapped:             9560 kB
> Slab:             189692 kB
> SReclaimable:     166688 kB
> SUnreclaim:        23004 kB
> PageTables:         3396 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    27751888 kB
> Committed_AS:      53904 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:       10764 kB
> VmallocChunk:   34359726963 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:        3456 kB
> DirectMap2M:    16773120 kB
> 
> After applying my patch, the same test case steadily leaves between 8
> and 500MB ram free in the steady-state (when pressure is reached).
> 
> MemTotal:       16433732 kB
> MemFree:           85144 kB
> Buffers:           23148 kB
> Cached:         15766280 kB
> SwapCached:            0 kB
> Active:            51500 kB
> Inactive:       15755140 kB
> Active(anon):      15540 kB
> Inactive(anon):     1824 kB
> Active(file):      35960 kB
> Inactive(file): 15753316 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:      19535024 kB
> SwapFree:       19535024 kB
> Dirty:           2501644 kB
> Writeback:         33280 kB
> AnonPages:         17280 kB
> Mapped:             9272 kB
> Slab:             505524 kB
> SReclaimable:     485596 kB
> SUnreclaim:        19928 kB
> PageTables:         3396 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    27751888 kB
> Committed_AS:      54508 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:       10764 kB
> VmallocChunk:   34359726715 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:        3456 kB
> DirectMap2M:    16773120 kB
> 
> The pressure pattern I see with the patch applied is :
> (16GB ram total)
> 
> - Inactive(file) fills up to 15.7GB.
> - Dirty fills up to 1.7GB.
> - Writeback vary between 0 and 600MB
> 
> sync() behavior :
> 
> - Dirty down to ~6MB.
> - Writeback increases to 1.6GB, then shrinks down to ~0MB.
> 
> References :
> This insanely huge
> http://bugzilla.kernel.org/show_bug.cgi?id=12309
> [Bug 12309] Large I/O operations result in slow performance and high iowait times
> (yes, I've been in CC all along)
> 
> Special thanks to Linus Torvalds and Nick Piggin and Thomas Pi for their
> suggestions on previous patch iterations.
> 
> Special thanks to the LTTng community, which helped me getting LTTng up to its
> current usability level. It's been tremendously useful in understanding those
> problematic I/O workloads and generating fio test cases.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: akpm@linux-foundation.org
> CC: Nick Piggin <nickpiggin@yahoo.com.au>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: thomas.pi@arcor.dea
> CC: Yuriy Lalym <ylalym@gmail.com>
> ---
>  mm/page-writeback.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6-lttng/mm/page-writeback.c
> ===================================================================
> --- linux-2.6-lttng.orig/mm/page-writeback.c	2009-04-29 18:14:48.000000000 -0400
> +++ linux-2.6-lttng/mm/page-writeback.c	2009-04-29 18:23:59.000000000 -0400
> @@ -1237,6 +1237,12 @@ int __set_page_dirty_nobuffers(struct pa
>  		if (!mapping)
>  			return 1;
>  
> +		/*
> +		 * Take care of setting back page accounting correctly.
> +		 */
> +		inc_zone_page_state(page, NR_FILE_DIRTY);
> +		inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
> +
>  		spin_lock_irq(&mapping->tree_lock);
>  		mapping2 = page_mapping(page);
>  		if (mapping2) { /* Race with truncate? */
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
