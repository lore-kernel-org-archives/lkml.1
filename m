Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXG3E5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXG3E5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXG3E5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:57:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48518 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbXG3E5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:57:24 -0400
Date: Mon, 30 Jul 2007 10:39:38 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070729100007.GB9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707301034240.10861@enigma.security.iitk.ac.in>
References: <1185284942.14697.319.camel@pmac.infradead.org>
 <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org>
 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
 <20070729100007.GB9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,


On Sun, 29 Jul 2007, Rodolfo Giometti wrote:

> On Sat, Jul 28, 2007 at 05:11:17AM +0530, Satyam Sharma wrote:
> 
> > Take the race between the time_pps_setparams() syscall and a concurrent
> > pps_event() from an interrupt for instance. From sys_time_pps_setparams,
> > the parameters for an existing source are not modified / set atomically,
> > which means a pps_event() called on the same source in between will see
> > invalid parameters ... and bad things will happen.
> 
> I think this should be a good solution... :)
> 
> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index 08de71d..f0c42ec 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -29,12 +29,6 @@
>  #include <linux/pps.h>
>  
>  /*
> - * Local variables
> - */
> -
> -static spinlock_t pps_lock = SPIN_LOCK_UNLOCKED;
> -
> -/*
>   * Local functions
>   */
>  
> diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> index 9176c01..91b7e4d 100644
> --- a/drivers/pps/pps.c
> +++ b/drivers/pps/pps.c
> @@ -35,6 +35,7 @@
>  
>  struct pps_s pps_source[PPS_MAX_SOURCES];
>  DEFINE_MUTEX(pps_mutex);
> +spinlock_t pps_lock = SPIN_LOCK_UNLOCKED;
>  
>  /*
>   * Misc functions
> @@ -227,6 +228,8 @@ asmlinkage long sys_time_pps_setparams(int source,
>                 goto sys_time_pps_setparams_exit;
>         }
>  
> +       spin_lock(&pps_lock);
> +
>         /* Save the new parameters */
>         ret = copy_from_user(&pps_source[source].params, params,
>                                                 sizeof(struct pps_kparams));
> @@ -245,6 +248,8 @@ asmlinkage long sys_time_pps_setparams(int source,
>                 pps_source[source].params.mode |= PPS_CANWAIT;
>         pps_source[source].params.api_version = PPS_API_VERS;
>  
> +       spin_unlock(&pps_lock);
> +
>  sys_time_pps_setparams_exit:
>         mutex_unlock(&pps_mutex);


Nopes, this isn't quite correct/safe. I suggest you should read:

http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/


Satyam
