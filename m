Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXCTGkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXCTGkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 02:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXCTGkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 02:40:42 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbXCTGkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 02:40:42 -0400
Date: Mon, 19 Mar 2007 22:40:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: fix a potential race in the VT_WAITACTIVE handler
Message-Id: <20070319224039.d99f8275.akpm@linux-foundation.org>
In-Reply-To: <20070315141023.GA9757@spock.one.pl>
References: <20070315141023.GA9757@spock.one.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 15:10:23 +0100 Michal Januszewski <spock@gentoo.org> wrote:

> On a multiprocessor machine the VT_WAITACTIVE ioctl call may return 0
> if fg_console has already been updated in redraw_screen(), but the 
> console switch itself hasn't been completed. Fix this by checking
> fg_console in vt_waitactive() with the console sem held.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> 
> ---
> diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
> index 3a5d301..00b5b34 100644
> --- a/drivers/char/vt_ioctl.c
> +++ b/drivers/char/vt_ioctl.c
> @@ -1041,8 +1041,12 @@ int vt_waitactive(int vt)
>  	for (;;) {
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		retval = 0;
> -		if (vt == fg_console)
> +		acquire_console_sem();
> +		if (vt == fg_console) {
> +			release_console_sem();
>  			break;
> +		}
> +		release_console_sem();
>  		retval = -EINTR;
>  		if (signal_pending(current))
>  			break;
> 

OK.  I think.  It's hard to tell.  I assume that the acquire_console_sem()
in here is to synchronise against some other function which also takes
acquire_console_sem(), but it is not clear which.

So could you please redo this with a comment which tells the reader exactly
what's being protected against what, and why?

Also, I always feel a bit worried by:

	set_current_state(TASK_INTERRUPTIBLE);
	down(...);

because if it hits contention, the down() will undo the
set_curremt_state().  Now that's normally OK because we loop, and because
the semaphore won't normally be 100% contended all the time.  Unless
someone reimplements down() so it happens to return in state TASK_RUNNING
all the time, which they could legitimately do (although this would
probably break stuff such as the above).


But still, it is nicer to do

	down(...);
	set_current_state(TASK_INTERRUPTIBLE);

if possible, and I think it is possible here.

Thanks.
