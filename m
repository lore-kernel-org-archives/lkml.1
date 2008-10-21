Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJUJxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJUJxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYJUJxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:53:30 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:35815 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYJUJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:53:29 -0400
Message-ID: <48FDA692.1060509@fr.ibm.com>
Date: Tue, 21 Oct 2008 11:53:22 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] freezer_cg: simplify freezer_change_state()
References: <48FD26F5.1070809@cn.fujitsu.com> <48FD273F.3040505@cn.fujitsu.com> <48FD2784.30906@cn.fujitsu.com> <48FD27E1.5070903@cn.fujitsu.com>
In-Reply-To: <48FD27E1.5070903@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Just call unfreeze_cgroup() if goal_state == THAWED, and call
> try_to_freeze_cgroup() if goal_state == FROZEN.
> 
> No behavior has been changed.

Looks good.

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

thanks,

C.

> 
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

