Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbXLWNlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbXLWNlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 08:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXLWNla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 08:41:30 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:62011 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXLWNl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 08:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rdg6Zqxatfv9KQDUSQQs8azQQI1AIBnrxGPJstP65mIYiOj7MHxE2c0u8/JFDxvY6rSkUc9kCx7BolZIyvZy0qWYc28wELO1naOrkadts4hs/mjolZ7aQA4VTCMNsRRk+i6bjBXbUZHhmTDhAzSdcLacQTzlXLigHHwOyFlgHPM=
Message-ID: <476E6584.9030304@gmail.com>
Date: Sun, 23 Dec 2007 14:41:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Cory T. Tusar" <ctusar@videon-central.com>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] tty: Fix logic change introduced by wait_event_interruptible_timeout()
References: <476AE109.5070005@videon-central.com>
In-Reply-To: <476AE109.5070005@videon-central.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2007 10:39 PM, Cory T. Tusar wrote:
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

Acked-by: Jiri Slaby <jirislaby@gmail.com>

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

Thanks for tracking this down.
