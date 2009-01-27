Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZA0EEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZA0EEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 23:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZA0EEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 23:04:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbZA0EEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 23:04:41 -0500
Date: Mon, 26 Jan 2009 20:03:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: Paul Menage <menage@google.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RESEND][PATCH] cpuset: fix possible deadlock in
 async_rebuild_sched_domains
Message-Id: <20090126200307.833b087a.akpm@linux-foundation.org>
In-Reply-To: <497540BE.4070408@cn.fujitsu.com>
References: <497540BE.4070408@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 11:10:54 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:

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

Where is this flush_work() call?  lru_add_drain_all()->schedule_on_each_cpu()?

If so, and if that is the only such callsite then we could/should
rework this code to use work_on_cpu(), if we manage to fix that thing.

It would be somewhat inefficient.  It would be better if work_on_cpu()
were to take a cpumask argument, and avoid blocking behind each CPU one
at a time.  But first things first.

> This patch fixes it by using a separate workqueue thread.

<wonders when RESERVED_PIDS became a logarithm>

