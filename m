Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYEGJlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYEGJlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYEGJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:41:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYEGJlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:41:19 -0400
Date: Wed, 7 May 2008 11:41:50 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Liam Howlett <howlett@gmail.com>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH 2/2] Freezer: Try to handle killable tasks
Message-ID: <20080507094150.GG13858@elf.ucw.cz>
References: <200805070003.56387.rjw@sisk.pl> <200805070007.56998.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805070007.56998.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-05-07 00:07:55, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The introduction of TASK_KILLABLE allows the freezer to work in some situation
> that it could not handle before.
> 
> Make the freezer handle killable tasks and add try_to_freeze() in some places
> where it is safe to freeze a (killable) task.  Introduce the
> wait_event_killable_freezable() macro to be used wherever the freezing of
> a waiting killable task is desirable.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  fs/nfs/inode.c          |    2 ++
>  fs/nfs/nfs3proc.c       |    2 ++
>  fs/nfs/nfs4proc.c       |    4 ++++
>  fs/nfs/pagelist.c       |    8 ++++++--
>  fs/smbfs/request.c      |    2 ++
>  include/linux/freezer.h |   20 +++++++++++++++++---
>  kernel/mutex.c          |    3 +++
>  kernel/power/process.c  |    6 ++++--
>  kernel/sched.c          |    2 ++
>  net/sunrpc/sched.c      |    2 ++
>  10 files changed, 44 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/fs/nfs/nfs3proc.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/nfs3proc.c
> +++ linux-2.6/fs/nfs/nfs3proc.c
> @@ -17,6 +17,7 @@
>  #include <linux/nfs_page.h>
>  #include <linux/lockd/bind.h>
>  #include <linux/nfs_mount.h>
> +#include <linux/freezer.h>
>  
>  #include "iostat.h"
>  #include "internal.h"
> @@ -33,6 +34,7 @@ nfs3_rpc_wrapper(struct rpc_clnt *clnt, 
>  		if (res != -EJUKEBOX)
>  			break;
>  		schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
> +		try_to_freeze();
>  		res = -ERESTARTSYS;
>  	} while (!fatal_signal_pending(current));
>  	return res;
> Index: linux-2.6/fs/nfs/nfs4proc.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/nfs4proc.c
> +++ linux-2.6/fs/nfs/nfs4proc.c
> @@ -48,6 +48,7 @@
>  #include <linux/smp_lock.h>
>  #include <linux/namei.h>
>  #include <linux/mount.h>
> +#include <linux/freezer.h>
>  
>  #include "nfs4_fs.h"
>  #include "delegation.h"
> @@ -2788,6 +2789,7 @@ static int nfs4_wait_bit_killable(void *
>  	if (fatal_signal_pending(current))
>  		return -ERESTARTSYS;
>  	schedule();
> +	try_to_freeze();
>  	return 0;
>  }

I'd say try_to_freeze() belongs close to the other signal check,
i.e. before schedule?

> @@ -180,10 +182,12 @@ static int nfs_wait_bit_killable(void *w
>  {
>  	int ret = 0;
>  
> -	if (fatal_signal_pending(current))
> +	if (fatal_signal_pending(current)) {
>  		ret = -ERESTARTSYS;
> -	else
> +	} else {
>  		schedule();
> +		try_to_freeze();
> +	}

Same here?

> @@ -109,6 +110,7 @@ struct smb_request *smb_alloc_request(st
>  			return ERR_PTR(-ERESTARTSYS);
>  		current->policy = SCHED_YIELD;
>  		schedule();
> +		try_to_freeze();

And here?

> @@ -182,6 +183,8 @@ __mutex_lock_common(struct mutex *lock, 
>  		/* didnt get the lock, go to sleep: */
>  		spin_unlock_mutex(&lock->wait_lock, flags);
>  		schedule();
> +		if (state == TASK_KILLABLE)
> +			try_to_freeze();
>  		spin_lock_mutex(&lock->wait_lock, flags);
>  	}
>  

I'm not comfortable with this one. Can the task be killable, but still
hold some _other_ mutex? (and then release it only if it actually gets
the signal?)


> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -4769,6 +4769,8 @@ do_wait_for_common(struct completion *x,
>  			__set_current_state(state);
>  			spin_unlock_irq(&x->wait.lock);
>  			timeout = schedule_timeout(timeout);
> +			if (state == TASK_KILLABLE)
> +				try_to_freeze();
>  			spin_lock_irq(&x->wait.lock);
>  			if (!timeout) {
>  				__remove_wait_queue(&x->wait, &wait);

Same here. I can't see why we could not be holding mutexes.

> @@ -227,6 +228,7 @@ static int rpc_wait_bit_killable(void *w
>  	if (fatal_signal_pending(current))
>  		return -ERESTARTSYS;
>  	schedule();
> +	try_to_freeze();
>  	return 0;
>  }

Swap?

> @@ -426,6 +427,7 @@ static int nfs_wait_schedule(void *word)
>  	if (signal_pending(current))
>  		return -ERESTARTSYS;
>  	schedule();
> +	try_to_freeze();
>  	return 0;
>  }
>  

Swap?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
