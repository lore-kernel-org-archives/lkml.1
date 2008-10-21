Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYJUVkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYJUVkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYJUVk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:40:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39423 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYJUVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:40:27 -0400
Subject: Re: [PATCH 2/4] freezer_cg: remove redundant check in
	freezer_can_attach()
From: Matt Helsley <matthltc@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <48FD273F.3040505@cn.fujitsu.com>
References: <48FD26F5.1070809@cn.fujitsu.com>
	 <48FD273F.3040505@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 14:40:33 -0700
Message-Id: <1224625233.2991.87.camel@enoch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 08:50 +0800, Li Zefan wrote:
> It is sufficient to check if @task is frozen, and no need to check if
> the original freezer is frozen.

Looks great! Thanks!

Acked-by: Matt Helsley <matthltc@us.ibm.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup_freezer.c |   16 +++++++---------
>  1 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 7f54d1c..6fadafe 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -162,9 +162,13 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
>  			      struct task_struct *task)
>  {
>  	struct freezer *freezer;
> -	int retval;
> 
> -	/* Anything frozen can't move or be moved to/from */
> +	/*
> +	 * Anything frozen can't move or be moved to/from.
> +	 *
> +	 * Since orig_freezer->state == FROZEN means that @task has been
> +	 * frozen, so it's sufficient to check the latter condition.
> +	 */
> 
>  	if (is_task_frozen_enough(task))
>  		return -EBUSY;
> @@ -173,13 +177,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
>  	if (freezer->state == CGROUP_FROZEN)
>  		return -EBUSY;
> 
> -	retval = 0;
> -	task_lock(task);
> -	freezer = task_freezer(task);
> -	if (freezer->state == CGROUP_FROZEN)
> -		retval = -EBUSY;
> -	task_unlock(task);
> -	return retval;
> +	return 0;
>  }
> 
>  static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)

