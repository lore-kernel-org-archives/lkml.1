Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbZHRX15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbZHRX15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZHRX14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:27:56 -0400
Received: from mga05.intel.com ([192.55.52.89]:65228 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751788AbZHRX14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:27:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,404,1246863600"; 
   d="scan'208";a="718258213"
Date: Tue, 18 Aug 2009 16:27:57 -0700
From: mgross <mgross@linux.intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] pm_qos: remove the BKL
Message-ID: <20090818232757.GB16014@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20090813140554.014ce1e0@bike.lwn.net> <20090813140716.4490ab37@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813140716.4490ab37@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 02:07:16PM -0600, Jonathan Corbet wrote:
> pm_qos_power_open got its lock_kernel() calls from the open() pushdown.  A
> look at the code shows that the only global resources accessed are
> pm_qos_array and "name".  pm_qos_array doesn't change (things pointed to
> therein do change, but they are atomics and/or are protected by
> pm_qos_lock).  Accesses to "name" are totally unprotected with or without
> the BKL; that will be fixed shortly.  The BKL is not helpful here; take it
> out.



Signed-off-by: Mark Gross <mgross@linux.intel.com>

--mgross

> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> Cc: Mark Gross <mgross@linux.intel.com>
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
