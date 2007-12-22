Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbXLVGqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbXLVGqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 01:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXLVGqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 01:46:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbXLVGqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 01:46:30 -0500
Date: Fri, 21 Dec 2007 22:45:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Cory T. Tusar" <ctusar@videon-central.com>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH] tty: Fix logic change introduced by
 wait_event_interruptible_timeout()
Message-Id: <20071221224547.34066a6a.akpm@linux-foundation.org>
In-Reply-To: <476AE109.5070005@videon-central.com>
References: <476AE109.5070005@videon-central.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 16:39:21 -0500 "Cory T. Tusar" <ctusar@videon-central.com> wrote:

> tty: Fix logic change introduced by wait_event_interruptible_timeout()
> 
> Commit 5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8 introduced a subtle logic
> change in tty_wait_until_sent().  The original version would only error
> out of the 'do { ... } while (timeout)' loop if signal_pending() evaluated
> to true; a timeout or break due to an empty buffer would fall out of the
> loop and into the tty->driver->wait_until_sent handling.  The current
> implementation will error out on either a pending signal or an empty
> buffer, falling through to the tty->driver->wait_until_sent handling
> only on a timeout.
> 
> This change reverts the logic flow in tty_wait_until_sent() to match that
> prior to the aforementioned commit.
> 
> Signed-off-by: Cory T. Tusar <ctusar@videon-central.com>
> 
> ---
> Please CC me on any replies; I'm not subscribed to lkml.  Thanks.
> 
>  drivers/char/tty_ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
> index 1bdd2bf..e02d592 100644
> --- a/drivers/char/tty_ioctl.c
> +++ b/drivers/char/tty_ioctl.c
> @@ -62,7 +62,7 @@ void tty_wait_until_sent(struct tty_struct * tty, long timeout)
>  	if (!timeout)
>  		timeout = MAX_SCHEDULE_TIMEOUT;
>  	if (wait_event_interruptible_timeout(tty->write_wait,
> -			!tty->driver->chars_in_buffer(tty), timeout))
> +			!tty->driver->chars_in_buffer(tty), timeout) < 0)
>  		return;
>  	if (tty->driver->wait_until_sent)
>  		tty->driver->wait_until_sent(tty, timeout);
> 
> 

OK...  So what are the user-visible effects of this regression?  The caller
will run ->wait_until_sent() even after being signalled?  So the signal is
not promptly responded to?

