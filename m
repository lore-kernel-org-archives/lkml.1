Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbXKNX2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbXKNX2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762146AbXKNX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:28:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50677 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761563AbXKNX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:28:14 -0500
Date: Thu, 15 Nov 2007 00:25:31 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Freezer: Make freezing failures less verbose by default
Message-ID: <20071115002531.GA2343@ucw.cz>
References: <200711150038.07538.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711150038.07538.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Currently freezing failures are extremely verbose which sometimes is
> unnecessary and prevents the user from seeing which task could not be frozen.
> 
> Make them less verbose by default (ie. if CONFIG_PM_VERBOSE is unset).
> 

I don't think compile time option is right thing to do.

Dump just the stacks of the non-frozen tasks?

acpi_sleep=verbose?

Reorder dmesg so that you get backtraces, and _then_ list of the
tasks?

							Pavel

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/process.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/power/process.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/process.c
> +++ linux-2.6/kernel/power/process.c
> @@ -163,6 +163,15 @@ static void cancel_freezing(struct task_
>  	}
>  }
>  
> +#ifdef CONFIG_PM_VERBOSE
> +static inline void freezer_show_state(void)
> +{
> +	show_state();
> +}
> +#else /* !CONFIG_PM_VERBOSE */
> +static inline void freezer_show_state(void) {}
> +#endif /* !CONFIG_PM_VERBOSE */
> +
>  static int try_to_freeze_tasks(int freeze_user_space)
>  {
>  	struct task_struct *g, *p;
> @@ -214,7 +223,7 @@ static int try_to_freeze_tasks(int freez
>  		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
>  				"(%d tasks refusing to freeze):\n",
>  				elapsed_csecs / 100, elapsed_csecs % 100, todo);
> -		show_state();
> +		freezer_show_state();
>  		read_lock(&tasklist_lock);
>  		do_each_thread(g, p) {
>  			task_lock(p);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
