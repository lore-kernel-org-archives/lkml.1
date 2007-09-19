Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXISVgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXISVgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXISVgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:36:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55220 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755276AbXISVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:36:04 -0400
Date: Wed, 19 Sep 2007 14:36:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten
 (sysfs?)
In-Reply-To: <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0709191432200.3111@schroedinger.engr.sgi.com>
References: <20070919123907.GA15591@localhost.sw.ru> <20070919125918.GA6760@localhost.sw.ru>
 <20070919123954.fb552e80.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Christoph Lameter wrote:

> Hmmm... This works fine here. Doing the cat may trigger slab validation 
> and show objects corruptions that were heretofore unnoticed.

Not exactly true since reading a file cannot trigger slab validation. The 
catting of all files will touch the following:

clameter@schroedinger:/sys/slab/kmalloc-64$ ls -l
total 0
-r--r--r-- 1 root root 4096 Sep 19 14:28 aliases
-r--r--r-- 1 root root 4096 Sep 19 14:28 align
-r--r--r-- 1 root root 4096 Sep 19 14:28 alloc_calls
-r--r--r-- 1 root root 4096 Sep 19 14:28 cache_dma
-r--r--r-- 1 root root 4096 Sep 19 14:28 cpu_slabs
-r--r--r-- 1 root root 4096 Sep 19 14:28 ctor
-r--r--r-- 1 root root 4096 Sep 19 14:28 destroy_by_rcu
-r--r--r-- 1 root root 4096 Sep 19 14:28 free_calls
-r--r--r-- 1 root root 4096 Sep 19 14:28 hwcache_align
-r--r--r-- 1 root root 4096 Sep 19 14:28 object_size
-r--r--r-- 1 root root 4096 Sep 19 14:28 objects
-r--r--r-- 1 root root 4096 Sep 19 14:28 objs_per_slab
-r--r--r-- 1 root root 4096 Sep 19 14:28 order
-r--r--r-- 1 root root 4096 Sep 19 14:28 partial
-rw-r--r-- 1 root root 4096 Sep 19 14:28 poison
-rw-r--r-- 1 root root 4096 Sep 19 14:28 reclaim_account
-rw-r--r-- 1 root root 4096 Sep 19 14:28 red_zone
-rw-r--r-- 1 root root 4096 Sep 19 14:28 sanity_checks
-rw-r--r-- 1 root root 4096 Sep 19 14:28 shrink
-r--r--r-- 1 root root 4096 Sep 19 14:28 slab_size
-r--r--r-- 1 root root 4096 Sep 19 14:28 slabs
-rw-r--r-- 1 root root 4096 Sep 19 14:28 store_user
-rw-r--r-- 1 root root 4096 Sep 19 14:28 trace
-rw-r--r-- 1 root root    0 Sep 19 14:28 validate

catting

	alloc_calls

and
	free_calls

will perform a global scan over all objects to determine the callers. 
Before we do that we have to flush the per cpu slabs. The trace shows that 
one of the errors was detected in there and the other one probably later.

So I would think that this is an actual memory corruption issue on your 
system and the /sys/slab stuff works fine. slabinfo -v will perform a more 
details scan to help you located the problem.

