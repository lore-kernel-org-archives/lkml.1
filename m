Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYKCVMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYKCVMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYKCVMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:12:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756181AbYKCVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:12:29 -0500
Date: Mon, 3 Nov 2008 13:12:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: trond.myklebust@fys.uio.no, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH] lockd: convert reclaimer thread to kthread interface
Message-Id: <20081103131215.75a83236.akpm@linux-foundation.org>
In-Reply-To: <1225278945-15407-1-git-send-email-jlayton@redhat.com>
References: <1225278945-15407-1-git-send-email-jlayton@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 07:15:45 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> My understanding is that there is a push to turn the kernel_thread
> interface into a non-exported symbol and move all kernel threads to use
> the kthread API. This patch changes lockd to use kthread_run to spawn
> the reclaimer thread.
> 
> I've made the assumption here that the extra module references taken
> when we spawn this thread are unnecessary and removed them. I've also
> added a KERN_ERR printk that pops if the thread can't be spawned to warn
> the admin that the locks won't be reclaimed.
> 
> I consider this patch 2.6.29 material.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/lockd/clntlock.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
> index 8307dd6..fcc2378 100644
> --- a/fs/lockd/clntlock.c
> +++ b/fs/lockd/clntlock.c
> @@ -14,6 +14,7 @@
>  #include <linux/sunrpc/svc.h>
>  #include <linux/lockd/lockd.h>
>  #include <linux/smp_lock.h>
> +#include <linux/kthread.h>
>  
>  #define NLMDBG_FACILITY		NLMDBG_CLIENT
>  
> @@ -191,11 +192,15 @@ __be32 nlmclnt_grant(const struct sockaddr *addr, const struct nlm_lock *lock)
>  void
>  nlmclnt_recovery(struct nlm_host *host)
>  {
> +	struct task_struct *task;
> +
>  	if (!host->h_reclaiming++) {
>  		nlm_get_host(host);
> -		__module_get(THIS_MODULE);
> -		if (kernel_thread(reclaimer, host, CLONE_FS | CLONE_FILES) < 0)
> -			module_put(THIS_MODULE);
> +		task = kthread_run(reclaimer, host, "%s-reclaim", host->h_name);
> +		if (IS_ERR(task))
> +			printk(KERN_ERR "lockd: unable to spawn reclaimer "
> +				"thread. Locks for %s won't be reclaimed! "
> +				"(%ld)\n", host->h_name, PTR_ERR(task));
>  	}
>  }
>  
> @@ -207,7 +212,6 @@ reclaimer(void *ptr)
>  	struct file_lock *fl, *next;
>  	u32 nsmstate;
>  
> -	daemonize("%s-reclaim", host->h_name);
>  	allow_signal(SIGKILL);
>  
>  	down_write(&host->h_rwsem);
> @@ -261,5 +265,5 @@ restart:
>  	nlm_release_host(host);
>  	lockd_down();
>  	unlock_kernel();
> -	module_put_and_exit(0);
> +	return 0;
>  }

Looks OK to me.  I assume the SIGKILL handling has been carefully tested?


Is it correct to emit a warning and keep going if the thread didn't
start?  Or would it be safer&saner to fail the whole mount (or whatever
syscall we're doing here..)



I see this:

	/* Why are we leaking memory here? --okir */
	if (signalled())
		continue;

is that still true?  It seems unlikely that what appears to be a pretty
gross leak has been around for so long.

This code needs some BKL-removal love.
