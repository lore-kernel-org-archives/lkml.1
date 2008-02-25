Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYBYVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYBYVxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYBYVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:53:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53319 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754202AbYBYVxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:53:10 -0500
Date: Mon, 25 Feb 2008 22:53:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, acme@redhat.com,
       gregkh@suse.de, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com
Subject: Re: [(RT RFC) PATCH v2 2/9] sysctl for runtime-control of lateral
	mutex stealing
Message-ID: <20080225215335.GE2659@elf.ucw.cz>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net> <20080225160048.11268.55059.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225160048.11268.55059.stgit@novell1.haskins.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Sven-Thorsten Dietrich <sdietrich@suse.de>
> 
> Add /proc/sys/kernel/lateral_steal, to allow switching on and off
> equal-priority mutex stealing between threads.
> 
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> ---
> 
>  kernel/rtmutex.c |    7 ++++++-
>  kernel/sysctl.c  |   14 ++++++++++++++
>  2 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 6624c66..cd39c26 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -18,6 +18,10 @@
>  
>  #include "rtmutex_common.h"
>  
> +#ifdef CONFIG_RTLOCK_LATERAL_STEAL
> +int rtmutex_lateral_steal __read_mostly = 1;
> +#endif
> +

Ugly..


>  /*
>   * lock->owner state tracking:
>   *
> @@ -321,7 +325,8 @@ static inline int lock_is_stealable(struct task_struct *pendowner, int unfair)
>  	if (current->prio > pendowner->prio)
>  		return 0;
>  
> -	if (!unfair && (current->prio == pendowner->prio))
> +	if (unlikely(current->prio == pendowner->prio) &&
> +	   !(unfair && rtmutex_lateral_steal))
>  #endif

But this is even worse, you are creating #ifdef maze here. Can you
simply #define rtmutex_lateral_steal 0 in !CONFIG_RTLOCK_LATERAL_STEAL
and let the optimizer fix this?


> index c913d48..c24c53d 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -175,6 +175,10 @@ extern struct ctl_table inotify_table[];
>  int sysctl_legacy_va_layout;
>  #endif
>  
> +#ifdef CONFIG_RTLOCK_LATERAL_STEAL
> +extern int rtmutex_lateral_steal;
> +#endif
> +

Try checkpatch.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
