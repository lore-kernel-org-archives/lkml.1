Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbZJMTNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbZJMTNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZJMTNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:13:22 -0400
Received: from mga12.intel.com ([143.182.124.36]:2385 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbZJMTNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:13:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,552,1249282800"; 
   d="scan'208";a="198506506"
Date: Tue, 13 Oct 2009 12:12:18 -0700
From: mgross <mgross@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/28] pm_qos: remove BKL
Message-ID: <20091013191218.GA5197@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20091010153314.827301943@linutronix.de> <20091010153349.071381158@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010153349.071381158@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought we made this change a month or 3 ago.

Signed-off-by: Mark Gross <mgross@linux.intel.com>

--mgross


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
