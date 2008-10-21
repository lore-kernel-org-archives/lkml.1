Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYJUHdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYJUHdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYJUHc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:32:57 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:56940 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYJUHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:32:56 -0400
Message-ID: <48FD85A2.8090605@fr.ibm.com>
Date: Tue, 21 Oct 2008 09:32:50 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] freezer_cg: remove redundant check in freezer_can_attach()
References: <48FD26F5.1070809@cn.fujitsu.com> <48FD273F.3040505@cn.fujitsu.com>
In-Reply-To: <48FD273F.3040505@cn.fujitsu.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> It is sufficient to check if @task is frozen, and no need to check if
> the original freezer is frozen.

hmm, a task being frozen does not mean that its freezer cgroup is 
frozen. So the extra check seems valid but looking at the comment :

	/*
	 * The call to cgroup_lock() in the freezer.state write method prevents
	 * a write to that file racing against an attach, and hence the
	 * can_attach() result will remain valid until the attach completes.
	 */
	static int freezer_can_attach(struct cgroup_subsys *ss,

how do we know that the task_freezer(task), which is not protected by
the cgroup_lock(), is not going to change its state to CGROUP_FROZEN 
it looks racy.

C.

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

