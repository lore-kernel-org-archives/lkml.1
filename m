Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbXKENpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbXKENpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 08:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXKENph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 08:45:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:2808 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbXKENpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 08:45:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bPQGLb9iUyyBTlCNBhf3PxRqwDf3QKLZgF4hPkFqAa0KmqkIGa/rRhGXujaXMO5JlCtaRGKfvaaGzEmgDvXPRZqmuNPVMXX4Lsb+QJ1IzQEBgPff+JvkauCozW7D7o3dukonBWylOx/TV5ZQuB0qSLsVZQhkrnG0m/L5uW/tFDU=
Message-ID: <472F1E7B.8060304@gmail.com>
Date: Mon, 05 Nov 2007 14:45:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS v10 serial driver rewrite take two
References: <20071105131148.GK7621@axis.com>
In-Reply-To: <20071105131148.GK7621@axis.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2007 02:11 PM, Jesper Nilsson wrote:
> New and improved serial driver for CRISv10, take two, with improvements
> suggested by Jiri Slaby.
> 
> - Call wait_event_interruptible with a sensible condition.
> - Moved common code for deregistering DMA and IRQ to deinit_port function.
> - Use setup_timer when initializing flush_timer.
> - Convert bitfield for uses_dma_in and uses_dma_out to regular bytes.
> - Removed CVS tags.
> - Removed defines and comments for CRIS_BUF_SIZE and TTY_THRESHOLD_THROTTLE
>   (no longer used).
> - Cleaned up code to pass checkpatch.
> - Add crisv10.h header file.
> - Merge of CRISv10 from Axis internal CVS.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  drivers/serial/crisv10.c         | 1291 ++++++++++++-------------------------
>  drivers/serial/crisv10.h         |  146 ++++
>  2 files changed, 580 insertions(+), 857 deletions(-)
> 
> diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
> index f523cdf..ff9634d 100644
> --- a/drivers/serial/crisv10.c
> +++ b/drivers/serial/crisv10.c
[...]
> @@ -4434,7 +3939,8 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
>  	if (tty_hung_up_p(filp) ||
>  	    (info->flags & ASYNC_CLOSING)) {
>  		if (info->flags & ASYNC_CLOSING)

You can remove this (__^) line now, the test itself is inside
wait_event_interruptible macro yet.

> -			interruptible_sleep_on(&info->close_wait);
> +			wait_event_interruptible(info->close_wait,
> +				!info->flags & ASYNC_CLOSING);

This is still buggy, I intentionally put the parenthesis around "info->flags &
ASYNC_CLOSING" in my previous mail. This way it will ever evaluate to 0 (since
it is as same as (!info->flags) & ASYNC_CLOSING now).

>  #ifdef SERIAL_DO_RESTART
>  		if (info->flags & ASYNC_HUP_NOTIFY)
>  			return -EAGAIN;

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
