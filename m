Return-Path: <linux-kernel-owner+w=401wt.eu-S936700AbYEURZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936700AbYEURZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936387AbYEURXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:23:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934432AbYEURXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:23:46 -0400
Date: Wed, 21 May 2008 13:20:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and
	control (v5)
Message-ID: <20080521172032.GD16367@redhat.com>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521153012.15001.96490.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521153012.15001.96490.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 09:00:12PM +0530, Balbir Singh wrote:

[..]
> +static void memrlimit_cgroup_move_task(struct cgroup_subsys *ss,
> +					struct cgroup *cgrp,
> +					struct cgroup *old_cgrp,
> +					struct task_struct *p)
> +{
> +	struct mm_struct *mm;
> +	struct memrlimit_cgroup *memrcg, *old_memrcg;
> +
> +	mm = get_task_mm(p);
> +	if (mm == NULL)
> +		return;
> +
> +	/*
> +	 * Hold mmap_sem, so that total_vm does not change underneath us
> +	 */
> +	down_read(&mm->mmap_sem);
> +
> +	rcu_read_lock();
> +	if (p != rcu_dereference(mm->owner))
> +		goto out;
> +

Hi Balbir,

How does rcu help here? We are not dereferencing mm->owner. So even if
task_struct it was pointing to goes away, should not be a problem.

OTOH, while updating the mm->owner in mmm_update_next_owner(), we
are not using rcu_assing_pointer() and synchronize_rcu()/call_rcu(). Is
this the right usage if mm->owner is rcu protected?

Thanks
Vivek
