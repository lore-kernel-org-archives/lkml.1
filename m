Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYGBQjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYGBQjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYGBQi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:38:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42920 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYGBQi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:38:58 -0400
Date: Wed, 2 Jul 2008 20:40:38 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: make get_online_cpus() useable for work->func()
Message-ID: <20080702164038.GB565@tv-sign.ru>
References: <20080629165131.GA11215@tv-sign.ru> <20080702013147.126feb34.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702013147.126feb34.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Andrew Morton wrote:
>
> I know that Document/SubmitChecklist has a lot of stuff.  But a basic
> allnoconfig only takes seconds and it's often the thing which breaks.
> 
>  include/linux/cpu.h |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff -puN include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func-fix include/linux/cpu.h
> --- a/include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func-fix
> +++ a/include/linux/cpu.h
> @@ -69,10 +69,11 @@ static inline void unregister_cpu_notifi
>  #endif
>  
>  int cpu_up(unsigned int cpu);
> -
>  extern void cpu_hotplug_init(void);
> +extern void cpu_maps_update_begin(void);
> +extern void cpu_maps_update_done(void);
>  
> -#else
> +#else	/* CONFIG_SMP */
>  
>  static inline int register_cpu_notifier(struct notifier_block *nb)
>  {
> @@ -87,10 +88,16 @@ static inline void cpu_hotplug_init(void
>  {
>  }
>  
> +static inline void cpu_maps_update_begin(void)
> +{
> +}
> +
> +static inline void cpu_maps_update_done(void)
> +{
> +}

Oh thanks...

This also means that we can't kill workqueue_lock (as I was going to do),
we still need it for !CONFIG_HOTPLUG_CPU case.

Oleg.

