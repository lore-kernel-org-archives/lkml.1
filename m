Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYCXHe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYCXHe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 03:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYCXHet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 03:34:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41180 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbYCXHes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 03:34:48 -0400
Date: Mon, 24 Mar 2008 10:39:41 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pids: sys_getsid: make sure we don't return 0 instead of -ESRCH
Message-ID: <20080324073941.GA88@tv-sign.ru>
References: <20080323175136.GA3353@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323175136.GA3353@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry! please ignore this patch and
"[PATCH] pids: sys_getpgid: use rcu_read_lock() instead of tasklist_lock",

I'll send the updated version.

It turns out that sys_getsid/sys_getpgid have other problems which should
be fixed.

On 03/23, Oleg Nesterov wrote:
>
> The task can exit between find_task_by_vpid() and task_session_vnr(), in
> that unlikely case sys_getsid() returns 0 instead of -ESRCH.
> 
> The bug was introduced by me in ac9a8e3f0f43d20fc316162e8e5f9186d295ff49.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- 25/kernel/sys.c~1_GETSID	2008-03-20 18:21:17.000000000 +0300
> +++ 25/kernel/sys.c	2008-03-23 19:25:36.000000000 +0300
> @@ -1019,19 +1019,19 @@ asmlinkage long sys_getsid(pid_t pid)
>  	if (!pid)
>  		return task_session_vnr(current);
>  	else {
> -		int retval;
> +		int retval = 0;
>  		struct task_struct *p;
>  
>  		rcu_read_lock();
>  		p = find_task_by_vpid(pid);
> -		retval = -ESRCH;
>  		if (p) {
>  			retval = security_task_getsid(p);
>  			if (!retval)
>  				retval = task_session_vnr(p);
>  		}
>  		rcu_read_unlock();
> -		return retval;
> +
> +		return retval ?: -ESRCH;
>  	}
>  }
>  

