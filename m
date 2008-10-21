Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYJUVpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYJUVpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYJUVp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:45:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55035 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYJUVpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:45:25 -0400
Subject: Re: [PATCH 3/4] freezer_cg: use thaw_process() in unfreeze_cgroup()
From: Matt Helsley <matthltc@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <48FD2784.30906@cn.fujitsu.com>
References: <48FD26F5.1070809@cn.fujitsu.com>
	 <48FD273F.3040505@cn.fujitsu.com>  <48FD2784.30906@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 14:44:41 -0700
Message-Id: <1224625481.2991.91.camel@enoch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 08:51 +0800, Li Zefan wrote:
> Don't duplicate the implementation of thaw_process().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Matt Helsley <matthltc@us.ibm.com>

> ---
>  kernel/cgroup_freezer.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 6fadafe..3ea57e4 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -275,25 +275,18 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
>  	return num_cant_freeze_now ? -EBUSY : 0;
>  }
> 
> -static int unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
> +static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
>  {
>  	struct cgroup_iter it;
>  	struct task_struct *task;
> 
>  	cgroup_iter_start(cgroup, &it);
>  	while ((task = cgroup_iter_next(cgroup, &it))) {
> -		int do_wake;
> -
> -		task_lock(task);
> -		do_wake = __thaw_process(task);
> -		task_unlock(task);
> -		if (do_wake)
> -			wake_up_process(task);
> +		thaw_process(task);
>  	}
>  	cgroup_iter_end(cgroup, &it);
> -	freezer->state = CGROUP_THAWED;
> 
> -	return 0;
> +	freezer->state = CGROUP_THAWED;
>  }
> 
>  static int freezer_change_state(struct cgroup *cgroup,
> @@ -320,7 +313,7 @@ static int freezer_change_state(struct cgroup *cgroup,
>  		}
>  		/* state == FREEZING and goal_state == THAWED, so unfreeze */
>  	case CGROUP_FROZEN:
> -		retval = unfreeze_cgroup(cgroup, freezer);
> +		unfreeze_cgroup(cgroup, freezer);
>  		break;
>  	default:
>  		break;

