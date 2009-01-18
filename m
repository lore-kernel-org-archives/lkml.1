Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbZARJHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbZARJHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 04:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758356AbZARJGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 04:06:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbZARJGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 04:06:51 -0500
Date: Sun, 18 Jan 2009 10:06:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       miaox@cn.fujitsu.com, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpuset: fix possible deadlock in
	async_rebuild_sched_domains
Message-ID: <20090118090635.GB27144@elte.hu>
References: <496FEFCA.9050908@cn.fujitsu.com> <4970000E.7040902@cn.fujitsu.com> <20090116125738.22c21bf2.akpm@linux-foundation.org> <4972E311.5010603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4972E311.5010603@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Lockdep reported some possible circular locking info when we tested cpuset on
> NUMA/fake NUMA box.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-rc1-00224-ga652504 #111
> -------------------------------------------------------
> bash/2968 is trying to acquire lock:
>  (events){--..}, at: [<ffffffff8024c8cd>] flush_work+0x24/0xd8
> 
> but task is already holding lock:
>  (cgroup_mutex){--..}, at: [<ffffffff8026ad1e>] cgroup_lock_live_group+0x12/0x29
> 
> which lock already depends on the new lock.
> ......
> -------------------------------------------------------
> 
> Steps to reproduce:
> # mkdir /dev/cpuset
> # mount -t cpuset xxx /dev/cpuset
> # mkdir /dev/cpuset/0
> # echo 0 > /dev/cpuset/0/cpus
> # echo 0 > /dev/cpuset/0/mems
> # echo 1 > /dev/cpuset/0/memory_migrate
> # cat /dev/zero > /dev/null &
> # echo $! > /dev/cpuset/0/tasks
> 
> This is because async_rebuild_sched_domains has the following lock sequence:
> run_workqueue(async_rebuild_sched_domains)
> 	-> do_rebuild_sched_domains -> cgroup_lock
> 
> But, attaching tasks when memory_migrate is set has following:
> cgroup_lock_live_group(cgroup_tasks_write)
> 	-> do_migrate_pages -> flush_work
> 
> This can be fixed by using a separate workqueue thread.
> 
> But queuing a work to an other thread is adding some overhead for cpuset.

Can you measure any overhead from that? In any case, this is triggered on 
admin activities (when reconfiguring cpusets), so it's a slowpath and thus 
using existing infrastructure is preferred in the 99.9% of the cases. 

Thanks,

	Ingo
