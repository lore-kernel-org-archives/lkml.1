Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYLENwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYLENwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbYLENwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:52:24 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:32936 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbYLENwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:52:23 -0500
Date: Fri, 5 Dec 2008 19:22:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH -mmotm 3/4] memcg: avoid dead lock caused by race
	between oom and cpuset_attach
Message-ID: <20081205135232.GB10004@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
	Paul Menage <menage@google.com>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp> <20081205212450.574f498c.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081205212450.574f498c.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2008-12-05 21:24:50]:

> mpol_rebind_mm(), which can be called from cpuset_attach(), does down_write(mm->mmap_sem).
> This means down_write(mm->mmap_sem) can be called under cgroup_mutex.
> 
> OTOH, page fault path does down_read(mm->mmap_sem) and calls mem_cgroup_try_charge_xxx(), 
> which may eventually calls mem_cgroup_out_of_memory(). And mem_cgroup_out_of_memory()
> calls cgroup_lock().
> This means cgroup_lock() can be called under down_read(mm->mmap_sem).
> 
> If those two paths race, dead lock can happen.
> 
> This patch avoid this dead lock by:
>   - remove cgroup_lock() from mem_cgroup_out_of_memory().
>   - define new mutex (memcg_tasklist) and serialize mem_cgroup_move_task()
>     (->attach handler of memory cgroup) and mem_cgroup_out_of_memory. 

A similar race has been reported for cpuset_migrate_mm(), which is
called holding the cgroup_mutex and further calls do_migrate_pages,
which can call reclaim and thus try to acquire cgroup_lock. If we
avoid reclaiming pages with cpuset_migrate_mm(), as the first patch
did, it also solves the reported race.

> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
