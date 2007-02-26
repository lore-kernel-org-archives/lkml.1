Return-Path: <linux-kernel-owner+w=401wt.eu-S1751262AbXBZLwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbXBZLwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 06:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXBZLwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 06:52:15 -0500
Received: from mail.screens.ru ([213.234.233.54]:51055 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbXBZLwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 06:52:14 -0500
Date: Mon, 26 Feb 2007 14:52:16 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 3/3] Freezer: Prevent ___call_usermodehelper from missing freezing requests
Message-ID: <20070226115216.GA234@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <200702261152.18379.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702261152.18379.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Rafael J. Wysocki wrote:
>
> NOTE: Alternatively, we can just drop flush_signals() from there, but I'm not
> sure that's the right thing to do.

We should drop it, I believe. I forgot to send a patch.

Oleg.

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Since ____call_usermodehelper() calls flush_signals(current), the task that
> enters it may miss a freezing request.  However, if ____call_usermodehelper()
> clears TIF_FREEZE for the current task after flush_signals(current) returns, the
> freezer will generate one more freezing request for this task.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/kmod.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.20-mm2/kernel/kmod.c
> ===================================================================
> --- linux-2.6.20-mm2.orig/kernel/kmod.c	2007-02-25 12:07:15.000000000 +0100
> +++ linux-2.6.20-mm2/kernel/kmod.c	2007-02-25 12:49:16.000000000 +0100
> @@ -34,6 +34,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/resource.h>
> +#include <linux/freezer.h>
>  #include <asm/uaccess.h>
>  
>  extern int delete_module(const char *name, unsigned int flags);
> @@ -258,6 +259,7 @@ static int ____call_usermodehelper(void 
>  	new_session = key_get(sub_info->ring);
>  	flush_signals(current);
>  	spin_lock_irq(&current->sighand->siglock);
> +	do_not_freeze(current);
>  	old_session = __install_session_keyring(current, new_session);
>  	flush_signal_handlers(current, 1);
>  	sigemptyset(&current->blocked);

