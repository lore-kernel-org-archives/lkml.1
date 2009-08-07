Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbZHGCDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbZHGCDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbZHGCDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:03:36 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:1104 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbZHGCDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tq0y2Bn8AcD4XI91F+8xonIzEI/VMWm+I3aYhjQ+qlrUY6eWy3UJgiE6D2ZmyC5sqz
         Px+qUqsdjli4zhl2iigEQuklk6Pipp5w0yUfb3WaFWi5bZnlu4dRBZo25Rb6C6g2GlCS
         8Y0J0RosvvIcCE4izCjUtApghfJIA4EdYjp8g=
Date: Fri, 7 Aug 2009 04:03:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [PATCH 1/2] pm_qos: remove BKL
Message-ID: <20090807020330.GA5425@nowhere>
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


Is there a 2/2 missing patch in the series, or may be I missed it.
I guess it fixes the racy "name"...


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
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

