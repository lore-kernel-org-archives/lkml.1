Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbZGICT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbZGICT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZGICTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:19:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42061 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbZGICTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:19:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0907071248560.5124@gentwo.org>
References: <20090707101855.0C63.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907071248560.5124@gentwo.org>
Message-Id: <20090709111458.238C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 11:19:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 7 Jul 2009, KOSAKI Motohiro wrote:
> 
> > +++ b/include/linux/mmzone.h
> > @@ -100,6 +100,8 @@ enum zone_stat_item {
> >  	NR_BOUNCE,
> >  	NR_VMSCAN_WRITE,
> >  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
> > +	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
> > +	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
> 
> LRU counters are rarer in use then the counters used for dirty pages etc.
> 
> Could you move the counters for reclaim into a separate cacheline?
> 

Current definition is here.

dirty pages and other frequently used counter stay in first cache line.
NR_ISOLATED_(ANON|FILE) and other unfrequently used counter stay in second
cache line.

Do you mean we shouldn't use zone_stat_item for it?


---------------------------------------------------------
enum zone_stat_item {
        /* First 128 byte cacheline (assuming 64 bit words) */
        NR_FREE_PAGES,
        NR_LRU_BASE,
        NR_INACTIVE_ANON = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
        NR_ACTIVE_ANON,         /*  "     "     "   "       "         */
        NR_INACTIVE_FILE,       /*  "     "     "   "       "         */
        NR_ACTIVE_FILE,         /*  "     "     "   "       "         */
        NR_UNEVICTABLE,         /*  "     "     "   "       "         */
        NR_MLOCK,               /* mlock()ed pages found and moved off LRU */
        NR_ANON_PAGES,  /* Mapped anonymous pages */
        NR_FILE_MAPPED, /* pagecache pages mapped into pagetables.
                           only modified from process context */
        NR_FILE_PAGES,
        NR_FILE_DIRTY,
        NR_WRITEBACK,
        NR_SLAB_RECLAIMABLE,
        NR_SLAB_UNRECLAIMABLE,
        NR_PAGETABLE,           /* used for pagetables */
        NR_KERNEL_STACK,
        /* Second 128 byte cacheline */
        NR_UNSTABLE_NFS,        /* NFS unstable pages */
        NR_BOUNCE,
        NR_VMSCAN_WRITE,
        NR_WRITEBACK_TEMP,      /* Writeback using temporary buffers */
        NR_ISOLATED_ANON,       /* Temporary isolated pages from anon lru */
        NR_ISOLATED_FILE,       /* Temporary isolated pages from file lru */
        NR_SHMEM,               /* shmem pages (included tmpfs/GEM pages) */
#ifdef CONFIG_NUMA
        NUMA_HIT,               /* allocated in intended node */
        NUMA_MISS,              /* allocated in non intended node */
        NUMA_FOREIGN,           /* was intended here, hit elsewhere */
        NUMA_INTERLEAVE_HIT,    /* interleaver preferred this zone */
        NUMA_LOCAL,             /* allocation from local node */
        NUMA_OTHER,             /* allocation from other node */
#endif
        NR_VM_ZONE_STAT_ITEMS };





