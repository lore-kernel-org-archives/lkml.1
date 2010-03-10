Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0CJBhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 20:37:09 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52104 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0CJBhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 20:37:05 -0500
Date: Wed, 10 Mar 2010 07:06:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-ID: <20100310013657.GO3073@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1268175636-4673-1-git-send-email-arighi@develer.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <arighi@develer.com> [2010-03-10 00:00:31]:

> Control the maximum amount of dirty pages a cgroup can have at any given time.
> 
> Per cgroup dirty limit is like fixing the max amount of dirty (hard to reclaim)
> page cache used by any cgroup. So, in case of multiple cgroup writers, they
> will not be able to consume more than their designated share of dirty pages and
> will be forced to perform write-out if they cross that limit.
> 
> The overall design is the following:
> 
>  - account dirty pages per cgroup
>  - limit the number of dirty pages via memory.dirty_ratio / memory.dirty_bytes
>    and memory.dirty_background_ratio / memory.dirty_background_bytes in
>    cgroupfs
>  - start to write-out (background or actively) when the cgroup limits are
>    exceeded
> 
> This feature is supposed to be strictly connected to any underlying IO
> controller implementation, so we can stop increasing dirty pages in VM layer
> and enforce a write-out before any cgroup will consume the global amount of
> dirty pages defined by the /proc/sys/vm/dirty_ratio|dirty_bytes and
> /proc/sys/vm/dirty_background_ratio|dirty_background_bytes limits.
> 
> Changelog (v5 -> v6)
> ~~~~~~~~~~~~~~~~~~~~~~
>  * always disable/enable IRQs at lock/unlock_page_cgroup(): this allows to drop
>    the previous complicated locking scheme in favor of a simpler locking, even
>    if this obviously adds some overhead (see results below)
>  * drop FUSE and NILFS2 dirty pages accounting for now (this depends on
>    charging bounce pages per cgroup)
> 
> Results
> ~~~~~~~
> I ran some tests using a kernel build (2.6.33 x86_64_defconfig) on a
> Intel Core 2 @ 1.2GHz as testcase using different kernels:
>  - mmotm "vanilla"
>  - mmotm with cgroup-dirty-memory using the previous "complex" locking scheme
>    (my previous patchset + the fixes reported by Kame-san and Daisuke-san)
>  - mmotm with cgroup-dirty-memory using the simple locking scheme
>    (lock_page_cgroup() with IRQs disabled)
> 
> Following the results:
> <before>
>  - mmotm "vanilla", root  cgroup:			11m51.983s
>  - mmotm "vanilla", child cgroup:			11m56.596s
> 
> <after>
>  - mmotm, "complex" locking scheme, root  cgroup:	11m53.037s
>  - mmotm, "complex" locking scheme, child cgroup:	11m57.896s
> 
>  - mmotm, lock_page_cgroup+irq_disabled, root  cgroup:	12m5.499s
>  - mmotm, lock_page_cgroup+irq_disabled, child cgroup:	12m9.920s
>

This is a cause for big concern, any chance you could test this on a
large system. I am concerned about root overhead the most.
 

-- 
	Three Cheers,
	Balbir
