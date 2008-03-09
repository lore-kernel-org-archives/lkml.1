Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbYCIMEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbYCIMEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbYCIMD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:03:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37446 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYCIMD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:03:56 -0400
Date: Sun, 09 Mar 2008 21:03:35 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: quicklists confuse meminfo
Cc: kosaki.motohiro@jp.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20080309111456.GA21690@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu>
Message-Id: <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> hm. I think we should not let this much RAM hang around in a 
> special-purpose allocator like quicklists. Shouldnt the quicklists be 
> temporary in nature, and be trimmed much more agressively?
> 
> in fact, we have a check_pgt_cache() call in cpu_idle(), which does:
> 
>         quicklist_trim(0, pgd_dtor, 25, 16);
> 
> but it appears we dont do quicklist trimming anywhere else! So if a 
> system has no idle time, the quicklist can grow unbounded, and that's a 
> real memory leak IMO.

I test following method.

1. $ hackbench 100 process 1000
2. $ cat /proc/meminfo

quicklist consume 1GB memory of 8GB total memory system.
it seems too large cache ;)

IMHO we need shrink pgtable cache mecanism.


---------------------------------------
MemTotal:      7683328 kB
MemFree:       4940672 kB
Buffers:          2816 kB
Cached:          23232 kB
SwapCached:      72192 kB
Active:          56832 kB
Inactive:        77440 kB
SwapTotal:     2031488 kB
SwapFree:      1907776 kB
Dirty:             704 kB
Writeback:           0 kB
AnonPages:       48384 kB
Mapped:          20864 kB
Slab:          1325824 kB
SReclaimable:    11968 kB
SUnreclaim:    1313856 kB
PageTables:      13632 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   5873152 kB
Committed_AS:   531008 kB
VmallocTotal: 17592177655808 kB
VmallocUsed:     28864 kB
VmallocChunk: 17592177623104 kB
Quicklists:    1194304 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB


