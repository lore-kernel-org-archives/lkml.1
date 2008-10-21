Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYJUVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYJUVps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJUVp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:45:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52655 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYJUVp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:45:27 -0400
Subject: Re: [PATCH 4/4] freezer_cg: simplify freezer_change_state()
From: Matt Helsley <matthltc@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <48FD27E1.5070903@cn.fujitsu.com>
References: <48FD26F5.1070809@cn.fujitsu.com>
	 <48FD273F.3040505@cn.fujitsu.com> <48FD2784.30906@cn.fujitsu.com>
	 <48FD27E1.5070903@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 14:45:39 -0700
Message-Id: <1224625539.2991.93.camel@enoch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 08:52 +0800, Li Zefan wrote:
> Just call unfreeze_cgroup() if goal_state == THAWED, and call
> try_to_freeze_cgroup() if goal_state == FROZEN.
> 
> No behavior has been changed.

Another good one. Thanks!

Acked-by: Matt Helsley <matthltc@us.ibm.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup_freezer.c |   19 +++++++------------
>  1 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 3ea57e4..cdef2d8 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -296,27 +296,22 @@ static int freezer_change_state(struct cgroup *cgroup,
>  	int retval = 0;
> 
>  	freezer = cgroup_freezer(cgroup);
> +
>  	spin_lock_irq(&freezer->lock);
> +
>  	update_freezer_state(cgroup, freezer);
>  	if (goal_state == freezer->state)
>  		goto out;
> -	switch (freezer->state) {
> +
> +	switch (goal_state) {
>  	case CGROUP_THAWED:
> -		retval = try_to_freeze_cgroup(cgroup, freezer);
> +		unfreeze_cgroup(cgroup, freezer);
>  		break;
> -	case CGROUP_FREEZING:
> -		if (goal_state == CGROUP_FROZEN) {
> -			/* Userspace is retrying after
> -			 * "/bin/echo FROZEN > freezer.state" returned -EBUSY */
> -			retval = try_to_freeze_cgroup(cgroup, freezer);
> -			break;
> -		}
> -		/* state == FREEZING and goal_state == THAWED, so unfreeze */
>  	case CGROUP_FROZEN:
> -		unfreeze_cgroup(cgroup, freezer);
> +		retval = try_to_freeze_cgroup(cgroup, freezer);
>  		break;
>  	default:
> -		break;
> +		BUG();
>  	}
>  out:
>  	spin_unlock_irq(&freezer->lock);

