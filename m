Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYHNLFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYHNLFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYHNLEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:04:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1267 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753793AbYHNLEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:04:53 -0400
Date: Thu, 14 Aug 2008 07:32:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Rework disabling of user mode helpers during suspend/hibernation
Message-ID: <20080814053235.GG6995@ucw.cz>
References: <200808080019.37057.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808080019.37057.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> PM: Rework disabling of user mode helpers during suspend/hibernation
> 
> We currently use a PM notifier to disable user mode helpers before
> suspend and hibernation and to re-enable them during the resume.
> However, this is not an ideal solution, because if any drivers want
> to upolad firmware into memory before suspend, they have to use a
> PM notifier for this purpose and there is not guarantee that the
> ordering of PM notifiers will be as expected (ie. the notifier that
> disables user mode helpers has to be run after the driver's notifier
> used for uploading the firmware).
> 
> For this reason, it seems better to move the disabling and enabling
> of user mode helpers to separate functions that will be called by the
> PM core as necessary.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

> Index: linux-2.6/include/linux/kmod.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kmod.h
> +++ linux-2.6/include/linux/kmod.h
> @@ -99,4 +99,9 @@ struct file;
>  extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
>  				    struct file **filp);
>  
> +#ifdef CONFIG_PM_SLEEP
> +extern int usermodehelper_disable(void);
> +extern void usermodehelper_enable(void);
> +#endif

No #ifdef needed for prototypes?


>  #endif /* __LINUX_KMOD_H__ */
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -21,6 +21,7 @@
>  #include <linux/freezer.h>
>  #include <linux/vmstat.h>
>  #include <linux/syscalls.h>
> +#include <linux/kmod.h>
>  
>  #include "power.h"
>  
> @@ -236,6 +237,10 @@ static int suspend_prepare(void)
>  	if (error)
>  		goto Finish;
>  
> +	error = usermodehelper_disable();
> +	if (error)
> +		goto Finish;
> +
>  	if (suspend_freeze_processes()) {
>  		error = -EAGAIN;
>  		goto Thaw;

Could this be moved into suspend_freeze_processes? It is related
(usermode helper is disabled when no userland), and you will not have
to call it from 3 places...?

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
