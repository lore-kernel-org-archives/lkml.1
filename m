Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab0BPSLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:11:15 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49469 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab0BPSLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:11:13 -0500
Date: Tue, 16 Feb 2010 10:11:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: akpm@linux-foundation.org, andi@firstfloor.org, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de, kay.sievers@suse.de
Subject: Re: [PATCH] Fix up a few missed minor rcu errors in uevent_helper
Message-ID: <20100216181101.GD6797@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100216155243.GA6155@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216155243.GA6155@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 10:52:43AM -0500, Neil Horman wrote:
> Fix up a few remaining nits in uevent_helper
> 
> Fixes the remaining missed lock points in uevent_helper, as reported by Paul
> McKenney in his review.  Specifically adds a spin lock to guard the write side
> of usevent_helper from concurrent writes, and fixes two remaining missed read
> side points that failed to use rcu_read_lock properly.  Also fixe up a minor
> string parsing issue in uvent_helper_set (was terminating the string on the
> wrong buffer).
> 
> I've done minimal testing on this (as the things this fixes were reported by
> code audit, not any actual oops or other failure).  I did run this for a few
> hours though, with several processes reading/writing different values to
> /sys/kernel/uevent_helper, while issued a few module loads that required issuing
> udev events (which, when overlapping with a proper write to /sys/kernel/uevent),
> triggered a fork in the appropriate binary.  Nothing has fallen over in that
> time, so I'm satisfied with this.  Applies as an incremental on top of the
> latest -mm
> Neil

>From and RCU perspective:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Tested-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  kernel/ksysfs.c      |   17 ++++++++++++-----
>  lib/kobject_uevent.c |    3 ++-
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index 66d1e5b..401d1f0 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -16,6 +16,7 @@
>  #include <linux/kexec.h>
>  #include <linux/profile.h>
>  #include <linux/sched.h>
> +#include <linux/spinlock.h>
> 
>  #define KERNEL_ATTR_RO(_name) \
>  static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
> @@ -37,13 +38,18 @@ KERNEL_ATTR_RO(uevent_seqnum);
>  static ssize_t uevent_helper_show(struct kobject *kobj,
>  				  struct kobj_attribute *attr, char *buf)
>  {
> -	return sprintf(buf, "%s\n", rcu_dereference(uevent_helper));
> +	ssize_t count;
> +	rcu_read_lock();
> +	count = sprintf(buf, "%s\n", rcu_dereference(uevent_helper));
> +	rcu_read_unlock();
> +	return count;
>  }
> 
>  struct uevent_helper_rcu {
>  	char *oldptr;
>  	struct rcu_head rcu;
>  };
> +static DEFINE_SPINLOCK(uevent_helper_lock);
> 
>  static void free_old_uevent_ptr(struct rcu_head *list)
>  {
> @@ -68,15 +74,16 @@ static ssize_t uevent_helper_store(struct kobject *kobj,
>  	kbuf = kstrndup(buf, UEVENT_HELPER_PATH_LEN, GFP_KERNEL);
>  	if (!kbuf)
>  		return -ENOMEM;
> -	uevent_helper[count] = '\0';
> -	if (count && uevent_helper[count-1] == '\n')
> -		uevent_helper[count-1] = '\0';
> +	kbuf[count] = '\0';
> +	if (count && kbuf[count-1] == '\n')
> +		kbuf[count-1] = '\0';
>  	old = kmalloc(sizeof(struct uevent_helper_rcu), GFP_KERNEL);
>  	if (!old)
>  		goto out_free;
> -
> +	spin_lock(&uevent_helper_lock);
>  	old->oldptr = rcu_dereference(uevent_helper);
>  	rcu_assign_pointer(uevent_helper, kbuf);
> +	spin_unlock(&uevent_helper_lock);
>  	call_rcu(&old->rcu, free_old_uevent_ptr);
> 
>  	return count;
> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
> index 211f846..a7520d0 100644
> --- a/lib/kobject_uevent.c
> +++ b/lib/kobject_uevent.c
> @@ -273,10 +273,11 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
>  #endif
> 
>  	/* call uevent_helper, usually only enabled during early boot */
> +	rcu_read_lock();
>  	helper = rcu_dereference(uevent_helper);
>  	if (helper[0])
>  		retval = uevent_call_helper(subsystem, env);
> -
> +	rcu_read_unlock();
>  exit:
>  	kfree(devpath);
>  	kfree(env);
