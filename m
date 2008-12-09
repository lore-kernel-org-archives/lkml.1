Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYLIIbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYLIIbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYLIIbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:31:15 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:36768 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYLIIbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:31:14 -0500
Date: Tue, 9 Dec 2008 09:31:11 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Bombe <aeb@debian.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiflop: get rid of sleep_on calls
In-Reply-To: <1228755578-26069-1-git-send-email-aeb@debian.org>
Message-ID: <Pine.LNX.4.64.0812090927580.29640@anakin>
References: <1228755578-26069-1-git-send-email-aeb@debian.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008, Andreas Bombe wrote:
> Apart from sleep_on() calls that could be easily converted to
> wait_event() and completion calls amiflop also used a flag in ms_delay()
> and ms_isr() as a custom mutex for ms_delay() without a need for
> explicit unlocking.  I converted that to a standard mutex semaphore.
> 
> The replacement for the unconditional sleep_on() in fd_motor_on() is a
> complete_all() together with a INIT_COMPLETION() before the mod_timer()
> call.  It appears to me that fd_motor_on() might be called concurrently
> and fd_select() does not guarantee mutual exclusivity in the case the
> same drive gets selected again.
> 
> Signed-off-by: Andreas Bombe <aeb@debian.org>
> ---
> 
> Note: I haven't tested these changes beyond correct compilation.
> 
> The complete_all() with INIT_COMPLETION() was because I'm not sure about
> whether fd_motor_on() might run concurrently.  Better safe than sorry.

I'm afraid my Amiga floppy drive doesn't work anymore...
Any other testers available?

> --- a/drivers/block/amiflop.c
> +++ b/drivers/block/amiflop.c
> @@ -220,19 +218,17 @@ static irqreturn_t ms_isr(int irq, void *dummy)
>     A more generic routine would do a schedule a la timer.device */
>  static void ms_delay(int ms)
>  {
> -	unsigned long flags;
>  	int ticks;
> +	static DECLARE_MUTEX(mutex);
               ^^^^^^^^^^^^^
Shouldn't this be a real mutex (declared using DEFINE_MUTEX(mutex)) instead of
a semaphore used as a mutex?

> +
>  	if (ms > 0) {
> -		local_irq_save(flags);
> -		while (ms_busy == 0)
> -			sleep_on(&ms_wait);
> -		ms_busy = 0;
> -		local_irq_restore(flags);
> +		down(&mutex);
                ^^^^
		mutex_lock

>  		ticks = MS_TICKS*ms-1;
>  		ciaa.tblo=ticks%256;
>  		ciaa.tbhi=ticks/256;
>  		ciaa.crb=0x19; /*count eclock, force load, one-shoot, start */
> -		sleep_on(&ms_wait);
> +		wait_for_completion(&ms_wait_completion);
> +		up(&mutex);
		mutex_unlock

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
