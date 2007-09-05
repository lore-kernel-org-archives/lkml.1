Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbXIED7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbXIED7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 23:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXIED7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 23:59:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39987 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752442AbXIED7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 23:59:33 -0400
Date: Tue, 4 Sep 2007 20:59:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <1188953218.26438.34.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0709042053320.7231@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Zhang, Yanmin wrote:

> 8) kmalloc-4096 order is 1 which means one slab consists of 2 objects. So a

You can change that by booting with slub_max_order=0. Then we can also use 
the per cpu queues to get these order 0 objects which may speed up the 
allocations because we do not have to take zone locks on slab allocation.

Note also that Andrew's tree has a page allocator pass through for SLUB 
for 4k kmallocs bypassing slab completely. That may also address the 
issue.

If you want SLUB to handle more objects in the 4k kmalloc cache 
without going to the page allocator then you can boot f.e. with

slub_max_order=3 slub_min_objects=8

which will result in a kmalloc-4096 that caches 8 objects.

> 	b) Change SLUB per-cpu slab cache, to cache more slabs instead of only one
> slab. This way could use page->lru to creates a list linked in kmem_cache->cpu_slab[]
> whose members need to be changed to as list_head. As for how many slabs could be in
> a per-cpu slab cache, it might be implemented as a sysfs parameter under /sys/slab/XXX/.
> Default could be 1 to satisfy big machines.

Try the ways to address the issue that I mentioned above.

