Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbZJJQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbZJJQJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 12:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761794AbZJJQJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 12:09:22 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46031 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761699AbZJJQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 12:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RTK6wC2fszY0ZJ21ZdqAv3jiyvw5wZvRq14IF3M49LswVuWxJTRKqJoIXjGbEVF5UT
         ATsZOVwhuSwBvjgjycLIdwbqjh0d4FHtR0z8phG5IJVEzVEtwFwJBxWpKh0uV08kspQL
         f8MksSmEGzGEV0uR1qycLvQ9e75mvVDJ/dMAA=
Date: Sat, 10 Oct 2009 18:08:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [patch 01/28] pm_qos: remove BKL
Message-ID: <20091010160839.GE5150@nowhere>
References: <20091010153314.827301943@linutronix.de> <20091010153349.071381158@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010153349.071381158@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 03:35:24PM -0000, Thomas Gleixner wrote:
> pm_qos_power_open got its lock_kernel() calls from the open() pushdown.  A
> look at the code shows that the only global resources accessed are
> pm_qos_array and "name".  pm_qos_array doesn't change (things pointed to
> therein do change, but they are atomics and/or are protected by
> pm_qos_lock).  Accesses to "name" are totally unprotected with or without
> the BKL; that will be fixed shortly.  The BKL is not helpful here; take it
> out.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> Cc: Mark Gross <mgross@linux.intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>


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
>  	if (pm_qos_class >= 0) {
>  		filp->private_data = (void *)pm_qos_class;
>  		sprintf(name, "process_%d", current->pid);
>  		ret = pm_qos_add_requirement(pm_qos_class, name,
>  					PM_QOS_DEFAULT_VALUE);
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
> 
> 

