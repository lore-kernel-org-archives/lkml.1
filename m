Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbYBVTXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbYBVTXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765768AbYBVTVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:21:24 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2983 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761984AbYBVTVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:21:22 -0500
Date: Fri, 22 Feb 2008 20:18:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 11/14] optimize the !printk fastpath through the lock acquisition
Message-ID: <20080222191837.GE6060@ucw.cz>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152722.4804.77478.stgit@novell1.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221152722.4804.77478.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Decorate the printk path with an "unlikely()"
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/rtmutex.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 122f143..ebdaa17 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -660,12 +660,12 @@ rt_spin_lock_fastlock(struct rt_mutex *lock,
>  		void fastcall (*slowfn)(struct rt_mutex *lock))
>  {
>  	/* Temporary HACK! */
> -	if (!current->in_printk)
> -		might_sleep();
> -	else if (in_atomic() || irqs_disabled())
> +	if (unlikely(current->in_printk) && (in_atomic() || irqs_disabled()))
>  		/* don't grab locks for printk in atomic */
>  		return;
>  
> +	might_sleep();

I think you changed the code here... you call might_sleep() in
different cases afaict.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
