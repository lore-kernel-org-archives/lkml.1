Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYIJVbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYIJVbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIJVbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:31:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbYIJVbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:31:44 -0400
Date: Wed, 10 Sep 2008 14:31:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adam Tkac <vonsch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc5] Allow set RLIMIT_NOFILE to RLIM_INFINITY
Message-Id: <20080910143141.a3bc8258.akpm@linux-foundation.org>
In-Reply-To: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com>
References: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 09:14:07 +0200
Adam Tkac <vonsch@gmail.com> wrote:

> when process wants set limit of open files to RLIM_INFINITY it gets
> EPERM even if it has CAP_SYS_RESOURCE capability. Attached patch
> should fix the problem. Please add me to CC of your responses because
> I'm not member of list.
> 
> Regards, Adam
> 
> -- 
> Adam Tkac
> 
> 
> [linux26-openfiles.patch  text/plain (634B)]
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1458,8 +1458,14 @@ asmlinkage long sys_setrlimit(unsigned i
>  	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
>  	    !capable(CAP_SYS_RESOURCE))
>  		return -EPERM;
> -	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
> -		return -EPERM;
> +	if (resource == RLIMIT_NOFILE) {
> +		if (new_rlim.rlim_max == RLIM_INFINITY)
> +			new_rlim.rlim_max = sysctl_nr_open;
> +		if (new_rlim.rlim_cur == RLIM_INFINITY)
> +			new_rlim.rlim_cur = sysctl_nr_open;
> +		if (new_rlim.rlim_max > sysctl_nr_open)
> +			return -EPERM;
> +	}

The kernel has had this behaviour for a long time.  2.6.13 had:

	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
	    !capable(CAP_SYS_RESOURCE))
		return -EPERM;
	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > NR_OPEN)
			return -EPERM;

I don't immediately see a problem with your change, but what makes you
believe that it is needed?  Is there some standard which we're
violating?  Is there some operational situation in which the current
behaviour is causing a problem?

Thanks.
