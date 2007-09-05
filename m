Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbXIEFcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbXIEFcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 01:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXIEFcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 01:32:35 -0400
Received: from mga10.intel.com ([192.55.52.92]:62142 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751897AbXIEFcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 01:32:35 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 01:32:34 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,209,1186383600"; 
   d="scan'208";a="293520297"
Subject: Re: tbench regression - Why process scheduler has impact on tbench
	and why small per-cpu slab (SLUB) cache creates the scenario?
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0709042053320.7231@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang>
	 <Pine.LNX.4.64.0709042053320.7231@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 05 Sep 2007 13:22:05 +0800
Message-Id: <1188969725.26438.46.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 20:59 -0700, Christoph Lameter wrote:
> On Wed, 5 Sep 2007, Zhang, Yanmin wrote:
> 
> > 8) kmalloc-4096 order is 1 which means one slab consists of 2 objects. So a
> 
> You can change that by booting with slub_max_order=0. Then we can also use 
> the per cpu queues to get these order 0 objects which may speed up the 
> allocations because we do not have to take zone locks on slab allocation.
> 
> Note also that Andrew's tree has a page allocator pass through for SLUB 
> for 4k kmallocs bypassing slab completely. That may also address the 
> issue.
> 
> If you want SLUB to handle more objects in the 4k kmalloc cache 
> without going to the page allocator then you can boot f.e. with
> 
> slub_max_order=3 slub_min_objects=8
I tried this approach. The testing result showed 2.6.23-rc4 is about
2.5% better than 2.6.22. It really resovles the issue.

However, the approach treats the slabs in the same policy. Could we
implement a per-slab specific approach like direct b)?

> 
> which will result in a kmalloc-4096 that caches 8 objects.
> 
> > 	b) Change SLUB per-cpu slab cache, to cache more slabs instead of only one
> > slab. This way could use page->lru to creates a list linked in kmem_cache->cpu_slab[]
> > whose members need to be changed to as list_head. As for how many slabs could be in
> > a per-cpu slab cache, it might be implemented as a sysfs parameter under /sys/slab/XXX/.
> > Default could be 1 to satisfy big machines.
Above direction b) looks more flexible.

In addition, could process scheduler also have an enhancement to schedule waken
processes firstly or do some favor for waken processes? From cache-hot point of view,
this enhancement might help performance, because mostly, waken process and waker share
some data.

> Try the ways to address the issue that I mentioned above.
I really appreciate your kind comments!

-yanmin
