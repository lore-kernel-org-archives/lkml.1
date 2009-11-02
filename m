Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZKBM6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZKBM6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZKBM6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:58:09 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:57135 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZKBM6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:58:08 -0500
Date: Mon, 2 Nov 2009 18:27:30 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, stable@kernel.org
Subject: Re: [PATCH] uids: Prevent tear down race
Message-ID: <20091102125730.GB5495@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20091102120206.134563297@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102120206.134563297@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 12:09:40PM -0000, Thomas Gleixner wrote:
> Ingo triggered the following warning:
> 
> WARNING: at lib/debugobjects.c:255 debug_print_object+0x42/0x50()
> Hardware name: System Product Name
> ODEBUG: init active object type: timer_list
> Modules linked in:
> Pid: 2619, comm: dmesg Tainted: G        W  2.6.32-rc5-tip+ #5298
> Call Trace:
>  [<81035443>] warn_slowpath_common+0x6a/0x81
>  [<8120e483>] ? debug_print_object+0x42/0x50
>  [<81035498>] warn_slowpath_fmt+0x29/0x2c
>  [<8120e483>] debug_print_object+0x42/0x50
>  [<8120ec2a>] __debug_object_init+0x279/0x2d7
>  [<8120ecb3>] debug_object_init+0x13/0x18
>  [<810409d2>] init_timer_key+0x17/0x6f
>  [<81041526>] free_uid+0x50/0x6c
>  [<8104ed2d>] put_cred_rcu+0x61/0x72
>  [<81067fac>] rcu_do_batch+0x70/0x121
> 
> debugobjects warns about an enqueued timer being initialized. If
> CONFIG_USER_SCHED=y the user management code uses delayed work to
> remove the user from the hash table and tear down the sysfs objects.
> 
> free_uid is called from RCU and initializes/schedules delayed work if
> the usage count of the user_struct is 0. The init/schedule happens
> outside of the uidhash_lock protected region which allows a concurrent
> caller of find_user() to reference the about to be destroyed
> user_struct w/o preventing the work from being scheduled. If the next
> free_uid call happens before the work timer expired then the active
> timer is initialized and the work scheduled again.
> 
> The race was introduced in commit 5cb350ba (sched: group scheduling,
> sysfs tunables) and made more prominent by commit 3959214f (sched:
> delayed cleanup of user_struct)
> 
> Move the init/schedule_delayed_work inside of the uidhash_lock
> protected region to prevent the race.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul E. McKenney <paulmck@us.ibm.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

> ---
>  kernel/user.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/user.c
> ===================================================================
> --- linux-2.6.orig/kernel/user.c
> +++ linux-2.6/kernel/user.c
> @@ -330,9 +330,9 @@ done:
>   */
>  static void free_user(struct user_struct *up, unsigned long flags)
>  {
> -	spin_unlock_irqrestore(&uidhash_lock, flags);
>  	INIT_DELAYED_WORK(&up->work, cleanup_user_struct);
>  	schedule_delayed_work(&up->work, msecs_to_jiffies(1000));
> +	spin_unlock_irqrestore(&uidhash_lock, flags);
>  }
> 
>  #else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */
> 

-- 
regards,
Dhaval
