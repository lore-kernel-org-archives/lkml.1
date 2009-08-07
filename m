Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZHGFyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZHGFyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 01:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHGFyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 01:54:16 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35392 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZHGFyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 01:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JwAVHAOij9jnon1EbOC5RM5Epm6bC9+tKCZiYkvyTY02feg9QJGjLdNIXtpQyqHGk9
         IA7TmImfaGB369zZWwAa/vkDTuZQXV4pwGgRVesM/zHl4uB/8GvCDACnlQtqGoZebTdO
         SU1HB/I6A8E/XlBJYjKkpQ1DnAZrn7iDZUFxQ=
Date: Fri, 7 Aug 2009 07:54:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [PATCH 1/2] pm_qos: remove BKL
Message-ID: <20090807055412.GB9182@nowhere>
References: <20090806135841.46682114@bike.lwn.net> <20090806135953.7706e57d@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806135953.7706e57d@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 01:59:53PM -0600, Jonathan Corbet wrote:
> pm_qos_power_open got its lock_kernel() calls from the open() pushdown.  A
> look at the code shows that the only global resources accessed are
> pm_qos_array and "name".  pm_qos_array doesn't change (things pointed to
> therein do change, but they are atomics and/or are protected by
> pm_qos_lock).  Accesses to "name" are totally unprotected with or without
> the BKL; that will be fixed shortly.  The BKL is not helpful here; take it
> out.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  kernel/pm_qos_params.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index dfdec52..d96b83e 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -29,7 +29,6 @@
>  
>  #include <linux/pm_qos_params.h>
>  #include <linux/sched.h>
> -#include <linux/smp_lock.h>
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/time.h>
> @@ -352,20 +351,15 @@ static int pm_qos_power_open(struct inode *inode, struct file *filp)
>  	int ret;
>  	long pm_qos_class;
>  
> -	lock_kernel();
>  	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));



Yeah, AFAICS, the pm_qos_array reading doesn't need to be protected.
It is statically defined and the array itself is never changed. And
as you said, its content are atomically changed.

And the field we are reading here is pm_qos_power_miscdev.minor.
It doesn't seem to be changed anywhere.

Well these field are changed but only on init time, through
register_pm_qos_misc(). But the I guess it's not racy against this
open call.



>  	if (pm_qos_class >= 0) {
>  		filp->private_data = (void *)pm_qos_class;
>  		sprintf(name, "process_%d", current->pid);
>  		ret = pm_qos_add_requirement(pm_qos_class, name,
>  					PM_QOS_DEFAULT_VALUE);


The only thing that doesn't seem protected inside
pm_qos_add_requirement is the read of pm_qos_array[pm_qos_class]->default_value

But again, this field seems statically defined and never changed later.

The rest of pm_qos_add_requirement() and update_target() is protected
by pm_qos_lock.

May be the last doubt could be the blocking_notifier_call_chain() call from
update_target(). Not sure if these notifier handlers can expect to be called
concurrently?

Thanks,
Frederic.



> -		if (ret >= 0) {
> -			unlock_kernel();
> +		if (ret >= 0)
>  			return 0;
> -		}
>  	}
> -	unlock_kernel();
> -
>  	return -EPERM;
>  }
>  
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

