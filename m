Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXE3AIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXE3AIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXE3AIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:08:11 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbXE3AIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:08:10 -0400
Date: Tue, 29 May 2007 17:08:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] Char: vt_ioctl, use wait_event_interruptible
Message-Id: <20070529170806.c4791255.akpm@linux-foundation.org>
In-Reply-To: <3026996181117418@wsc.cz>
References: <12191294601255228079@wsc.cz>
	<3026996181117418@wsc.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 15:31:12 +0200 (CEST)
Jiri Slaby <jirislaby@gmail.com> wrote:

> vt_ioctl, use wait_event_interruptible
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> commit fbe1931e02f11b2fef771ff1698f1598b3567520
> tree fcfcd72a5619f6e26598ac2ee3132aed4b070987
> parent c025c4b3eca99f50b05bc24c445b861e91226539
> author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 22:58:17 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 22:58:17 +0200
> 
>  drivers/char/vt_ioctl.c |   22 ++++------------------
>  1 files changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
> index c6f6f42..2056367 100644
> --- a/drivers/char/vt_ioctl.c
> +++ b/drivers/char/vt_ioctl.c
> @@ -1035,12 +1035,8 @@ static DECLARE_WAIT_QUEUE_HEAD(vt_activate_queue);
>  int vt_waitactive(int vt)
>  {
>  	int retval;
> -	DECLARE_WAITQUEUE(wait, current);
> -
> -	add_wait_queue(&vt_activate_queue, &wait);
> -	for (;;) {
> -		retval = 0;
>  
> +	return wait_event_interruptible(vt_activate_queue, ({
>  		/*
>  		 * Synchronize with redraw_screen(). By acquiring the console
>  		 * semaphore we make sure that the console switch is completed
> @@ -1049,20 +1045,10 @@ int vt_waitactive(int vt)
>  		 * updated, but the console switch hasn't been completed.
>  		 */
>  		acquire_console_sem();
> -		set_current_state(TASK_INTERRUPTIBLE);
> -		if (vt == fg_console) {
> -			release_console_sem();
> -			break;
> -		}
> +		retval = vt == fg_console;
>  		release_console_sem();
> -		retval = -EINTR;
> -		if (signal_pending(current))
> -			break;
> -		schedule();
> -	}
> -	remove_wait_queue(&vt_activate_queue, &wait);
> -	__set_current_state(TASK_RUNNING);
> -	return retval;
> +		retval;
> +	}));
>  }
>  

So we end up with

int vt_waitactive(int vt)
{
	int retval;

	return wait_event_interruptible(vt_activate_queue, ({
		/*
		 * Synchronize with redraw_screen(). By acquiring the console
		 * semaphore we make sure that the console switch is completed
		 * before we return. If we didn't wait for the semaphore, we
		 * could return at a point where fg_console has already been
		 * updated, but the console switch hasn't been completed.
		 */
		acquire_console_sem();
		retval = vt == fg_console;
		release_console_sem();
		retval;
	}));
}

Again, I do think this needs a helper function.  Or something.  The handling
of `retval' in there is pretty perverse.  We're modifying a local variable
within the macro and then returning it by value?  Perhaps a bit cleaner
would be to move `retval' inside the macro body.

But a helper function would be better.  Again, remember that the macro
evaluates that expression twice - you may find that the helper function
even generates less code.

