Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab0CKAnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:43:07 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48440 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab0CKAnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:43:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Mar 2010 09:39:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
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
Message-Id: <20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1268175636-4673-1-git-send-email-arighi@develer.com>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 00:00:31 +0100
Andrea Righi <arighi@develer.com> wrote:

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
> With the "complex" locking solution, the overhead introduced by the
> cgroup dirty memory accounting is minimal (0.14%), compared with the overhead
> introduced by the lock_page_cgroup+irq_disabled solution (1.90%).
> 
Hmm....isn't this bigger than expected ?


> The performance overhead is not so huge in both solutions, but the impact on
> performance is even more reduced using a complicated solution...
> 
> Maybe we can go ahead with the simplest implementation for now and start to
> think to an alternative implementation of the page_cgroup locking and
> charge/uncharge of pages.
> 

maybe. But in this 2 years, one of our biggest concerns was the performance.
So, we do something complex in memcg. But complex-locking is , yes, complex.
Hmm..I don't want to bet we can fix locking scheme without something complex.

Thanks,
-Kame

