Return-Path: <linux-kernel-owner+w=401wt.eu-S1763165AbYEEWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763165AbYEEWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbYEEWQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:16:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759450AbYEEWQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:16:15 -0400
Date: Mon, 5 May 2008 15:15:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Enhance cgroup mm_owner_changed callback to
 add task information
Message-Id: <20080505151504.98c28f7c.akpm@linux-foundation.org>
In-Reply-To: <20080503213804.3140.26503.sendpatchset@localhost.localdomain>
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
	<20080503213804.3140.26503.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 May 2008 03:08:04 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> This patch adds an additional field to the mm_owner callbacks. This field
> is required to get to the mm that changed.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  include/linux/cgroup.h |    3 ++-
>  kernel/cgroup.c        |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff -puN kernel/cgroup.c~cgroup-add-task-to-mm--owner-callbacks kernel/cgroup.c
> --- linux-2.6.25/kernel/cgroup.c~cgroup-add-task-to-mm--owner-callbacks	2008-05-04 02:53:05.000000000 +0530
> +++ linux-2.6.25-balbir/kernel/cgroup.c	2008-05-04 02:53:05.000000000 +0530
> @@ -2772,7 +2772,7 @@ void cgroup_mm_owner_callbacks(struct ta
>  			if (oldcgrp == newcgrp)
>  				continue;
>  			if (ss->mm_owner_changed)
> -				ss->mm_owner_changed(ss, oldcgrp, newcgrp);
> +				ss->mm_owner_changed(ss, oldcgrp, newcgrp, new);
>  		}
>  	}
>  }
> diff -puN include/linux/cgroup.h~cgroup-add-task-to-mm--owner-callbacks include/linux/cgroup.h
> --- linux-2.6.25/include/linux/cgroup.h~cgroup-add-task-to-mm--owner-callbacks	2008-05-04 02:53:05.000000000 +0530
> +++ linux-2.6.25-balbir/include/linux/cgroup.h	2008-05-04 02:53:05.000000000 +0530
> @@ -310,7 +310,8 @@ struct cgroup_subsys {
>  	 */
>  	void (*mm_owner_changed)(struct cgroup_subsys *ss,
>  					struct cgroup *old,
> -					struct cgroup *new);
> +					struct cgroup *new,
> +					struct task_struct *p);

If mm_owner_changed() had any documentation I'd suggest that it be updated.
Sneaky.

The existing comment:

	/*
	 * This routine is called with the task_lock of mm->owner held
	 */
	void (*mm_owner_changed)(struct cgroup_subsys *ss,
					struct cgroup *old,
					struct cgroup *new);

Is rather mysterious.  To what mm does it refer?
