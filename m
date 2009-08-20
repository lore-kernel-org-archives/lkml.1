Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZHTCke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZHTCke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZHTCkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:40:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57600 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZHTCkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:40:33 -0400
Message-ID: <4A8CB750.7040509@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 10:39:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/8] Adds functionality to read/write lock CLONE_THREAD
 fork()ing per-threadgroup
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235843.22531.57310.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235843.22531.57310.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> From: Ben Blum <bblum@google.com>
> 
> 
> Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
> 
> This patch adds an rwsem that lives in a threadgroup's sighand_struct (next to
> the sighand's atomic count, to piggyback on its cacheline), and two functions
> in kernel/cgroup.c (for now) for easily+safely obtaining and releasing it. If
> another part of the kernel later wants to use such a locking mechanism, the
> CONFIG_CGROUPS ifdefs should be changed to a higher-up flag that CGROUPS and
> the other system would both depend on, and the lock/unlock functions could be
> moved to sched.c or so.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Signed-off-by: Paul Menage <menage@google.com>
>

Looks fine to me.

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

... 

> +struct sighand_struct *threadgroup_fork_lock(struct task_struct *tsk)
> +{
> +	struct sighand_struct *sighand;
> +	struct task_struct *p;
> +
> +	/* tasklist lock protects sighand_struct's disappearance in exit(). */
> +	read_lock(&tasklist_lock);
> +	if (likely(tsk->sighand)) {
> +		/* simple case - check the thread we were given first */
> +		sighand = tsk->sighand;
> +	} else {
> +		sighand = NULL;
> +		/*
> +		 * tsk is exiting; try to find another thread in the group
> +		 * whose sighand pointer is still alive.
> +		 */
> +		rcu_read_lock();

since we are holding tasklist_lock, I think we don't need to
take rcu lock?

> +		list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
> +			if (p->sighand) {
> +				sighand = tsk->sighand;

s/tsk->sighand/p->sighand

> +				break;
> +			}
> +		}
> +		rcu_read_unlock();
> +	}
