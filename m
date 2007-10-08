Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbXJHPcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbXJHPcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXJHPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:32:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56636 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbXJHPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:32:08 -0400
Subject: Re: [PATCH 1/1 try 2] V4L: rocket, switch sleep_on to completion
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <1516924190387627638@pripojeni.net>
References: <1516924190387627638@pripojeni.net>
Content-Type: text/plain; charset=utf-8
Date: Mon, 08 Oct 2007 12:31:49 -0300
Message-Id: <1191857509.5564.55.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

The patch might be right, however, AFAIK, this has nothing to do with
V4L. Better to change the subject ;)

Cheers,
Mauro.

Em Seg, 2007-10-08 às 08:45 -0400, Jiri Slaby escreveu:
> rocket, switch sleep_on to completion
> 
> - sleep_on is deprecated and racy, use completion instead
> - also check retval of interruptible function and return ERESTARTSYS
>   eventually
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> commit db2ca3cf492a6a8a4578e6adb869e1a20558b84e
> tree 4f732e546579c3482db61cc6e5e34087d4815a4b
> parent 9936225b4a065eec6eccd9700a680cc840280fdb
> author Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:44:04 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:44:04 +0200
> 
>  drivers/char/rocket.c     |   12 ++++++++----
>  drivers/char/rocket_int.h |    7 +------
>  2 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
> index 56cbba7..d790b08 100644
> --- a/drivers/char/rocket.c
> +++ b/drivers/char/rocket.c
> @@ -84,6 +84,7 @@
>  #include <linux/mutex.h>
>  #include <linux/ioport.h>
>  #include <linux/delay.h>
> +#include <linux/completion.h>
>  #include <linux/wait.h>
>  #include <linux/pci.h>
>  #include <asm/uaccess.h>
> @@ -650,7 +651,7 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
>  	info->closing_wait = 3000;
>  	info->close_delay = 50;
>  	init_waitqueue_head(&info->open_wait);
> -	init_waitqueue_head(&info->close_wait);
> +	init_completion(&info->close_wait);
>  	info->flags &= ~ROCKET_MODE_MASK;
>  	switch (pc104[board][line]) {
>  	case 422:
> @@ -878,7 +879,8 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
>  	if (tty_hung_up_p(filp))
>  		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
>  	if (info->flags & ROCKET_CLOSING) {
> -		interruptible_sleep_on(&info->close_wait);
> +		if (wait_for_completion_interruptible(&info->close_wait))
> +			return -ERESTARTSYS;
>  		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
>  	}
>  
> @@ -983,8 +985,10 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
>  		return -ENOMEM;
>  
>  	if (info->flags & ROCKET_CLOSING) {
> -		interruptible_sleep_on(&info->close_wait);
> +		retval = wait_for_completion_interruptible(&info->close_wait);
>  		free_page(page);
> +		if (retval)
> +			return retval;
>  		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
>  	}
>  
> @@ -1176,7 +1180,7 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
>  	}
>  	info->flags &= ~(ROCKET_INITIALIZED | ROCKET_CLOSING | ROCKET_NORMAL_ACTIVE);
>  	tty->closing = 0;
> -	wake_up_interruptible(&info->close_wait);
> +	complete_all(&info->close_wait);
>  	atomic_dec(&rp_num_ports_open);
>  
>  #ifdef ROCKET_DEBUG_OPEN
> diff --git a/drivers/char/rocket_int.h b/drivers/char/rocket_int.h
> index b4c53df..55b8f2d 100644
> --- a/drivers/char/rocket_int.h
> +++ b/drivers/char/rocket_int.h
> @@ -1163,13 +1163,8 @@ struct r_port {
>  	int read_status_mask;
>  	int cps;
>  
> -#ifdef DECLARE_WAITQUEUE
>  	wait_queue_head_t open_wait;
> -	wait_queue_head_t close_wait;
> -#else
> -	struct wait_queue *open_wait;
> -	struct wait_queue *close_wait;
> -#endif
> +	struct completion close_wait;
>  	spinlock_t slock;
>  	struct mutex write_mtx;
>  };
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Cheers,
Mauro

