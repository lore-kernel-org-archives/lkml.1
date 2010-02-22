Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0BVRgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:36:50 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50783 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0BVRgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:36:48 -0500
Date: Mon, 22 Feb 2010 23:06:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] memcg: per cgroup dirty limit
Message-ID: <20100222173640.GG3063@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <20100222142744.GB13823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100222142744.GB13823@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2010-02-22 09:27:45]:

> On Sun, Feb 21, 2010 at 04:18:43PM +0100, Andrea Righi wrote:
> > Control the maximum amount of dirty pages a cgroup can have at any given time.
> > 
> > Per cgroup dirty limit is like fixing the max amount of dirty (hard to reclaim)
> > page cache used by any cgroup. So, in case of multiple cgroup writers, they
> > will not be able to consume more than their designated share of dirty pages and
> > will be forced to perform write-out if they cross that limit.
> > 
> > The overall design is the following:
> > 
> >  - account dirty pages per cgroup
> >  - limit the number of dirty pages via memory.dirty_bytes in cgroupfs
> >  - start to write-out in balance_dirty_pages() when the cgroup or global limit
> >    is exceeded
> > 
> > This feature is supposed to be strictly connected to any underlying IO
> > controller implementation, so we can stop increasing dirty pages in VM layer
> > and enforce a write-out before any cgroup will consume the global amount of
> > dirty pages defined by the /proc/sys/vm/dirty_ratio|dirty_bytes limit.
> > 
> 
> Thanks Andrea. I had been thinking about looking into it from IO
> controller perspective so that we can control async IO (buffered writes
> also).
> 
> Before I dive into patches, two quick things.
> 
> - IIRC, last time you had implemented per memory cgroup "dirty_ratio" and
>   not "dirty_bytes". Why this change? To begin with either per memcg
>   configurable dirty ratio also makes sense? By default it can be the
>   global dirty ratio for each cgroup.
> 
> - Looks like we will start writeout from memory cgroup once we cross the
>   dirty ratio, but still there is no gurantee that we be writting pages
>   belonging to cgroup which crossed the dirty ratio and triggered the
>   writeout.
> 
>   This behavior is not very good at least from IO controller perspective
>   where if two dd threads are dirtying memory in two cgroups, then if
>   one crosses it dirty ratio, it should perform writeouts of its own pages
>   and not other cgroups pages. Otherwise we probably will again introduce
>   serialization among two writers and will not see service differentation.

I thought that the I/O controller would eventually provide hooks to do
this.. no?

> 
>   May be we can modify writeback_inodes_wbc() to check first dirty page
>   of the inode. And if it does not belong to same memcg as the task who
>   is performing balance_dirty_pages(), then skip that inode.

Do you expect all pages of an inode to be paged in by the same cgroup?


-- 
	Three Cheers,
	Balbir
