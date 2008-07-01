Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYGAJsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYGAJsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYGAJsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:48:01 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:44700 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753972AbYGAJsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:48:00 -0400
Date: Tue, 1 Jul 2008 15:17:34 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org
Subject: Re: Attaching PID 0 to a cgroup
Message-ID: <20080701094734.GE3925@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080701094545.GD3925@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701094545.GD3925@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[put in the wrong alias for containers list correcting it.]

On Tue, Jul 01, 2008 at 03:15:45PM +0530, Dhaval Giani wrote:
> Hi Paul,
> 
> Attaching PID 0 to a cgroup caused the current task to be attached to
> the cgroup. Looking at the code,
> 
>         if (pid) {
>                 rcu_read_lock();
>                 tsk = find_task_by_vpid(pid);
>                 if (!tsk || tsk->flags & PF_EXITING) {
>                         rcu_read_unlock();
>                         return -ESRCH;
>                 }
>                 get_task_struct(tsk);
>                 rcu_read_unlock();
> 
>                 if ((current->euid) && (current->euid != tsk->uid)
>                     && (current->euid != tsk->suid)) {
>                         put_task_struct(tsk);
>                         return -EACCES;
>                 }
>         } else {
>                 tsk = current;
>                 get_task_struct(tsk);
>         }
> 
> I was wondering, why this was done. It seems to be unexpected behavior.
> Wouldn't something like the following be a better response? (I've used
> EINVAL, but I can change it to ESRCH if that is better.)
> 
> ---
> cgroups: Don't allow PID 0 to be attached to a group
> 
> Currently when one trys to attach PID 0 to a cgroup, it attaches
> the current task. That is not expected behavior. It should return
> an error instead.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Index: linux-2.6/kernel/cgroup.c
> ===================================================================
> --- linux-2.6.orig/kernel/cgroup.c
> +++ linux-2.6/kernel/cgroup.c
> @@ -1309,8 +1309,7 @@ static int attach_task_by_pid(struct cgr
>  			return -EACCES;
>  		}
>  	} else {
> -		tsk = current;
> -		get_task_struct(tsk);
> +			return -EINVAL;
>  	}
>  
>  	ret = cgroup_attach_task(cgrp, tsk);
> -- 
> regards,
> Dhaval

-- 
regards,
Dhaval
