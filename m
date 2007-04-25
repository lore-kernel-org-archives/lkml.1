Return-Path: <linux-kernel-owner+w=401wt.eu-S1031026AbXDYNyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031026AbXDYNyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031038AbXDYNyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:54:31 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:41361 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031026AbXDYNya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:54:30 -0400
Message-ID: <462F5D9C.9050706@gmail.com>
Date: Wed, 25 Apr 2007 15:54:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in RocketPort driver v2
References: <20070425130843.GK6798@traven>
In-Reply-To: <20070425130843.GK6798@traven>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 25 Apr 2007 15:54:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke napsal(a):
> the RocketPort driver uses a semaphore as mutex. use the mutex API
> instead of the (binary) semaphore
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> --
> 
> diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
> index 76357c8..7d23790 100644
> --- a/drivers/char/rocket.c
> +++ b/drivers/char/rocket.c
> @@ -702,7 +702,7 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
>  		}
>  	}
>  	spin_lock_init(&info->slock);
> -	sema_init(&info->write_sem, 1);
> +	mutex_init(&info->write_mtx);
>  	rp_table[line] = info;
>  	if (pci_dev)
>  		tty_register_device(rocket_driver, line, &pci_dev->dev);
> @@ -1662,7 +1662,7 @@ static void rp_put_char(struct tty_struct *tty, unsigned char ch)
>  		return;
>  
>  	/*  Grab the port write semaphore, locking out other processes that try to write to this port */
> -	down(&info->write_sem);
> +	mutex_lock(&info->write_mtx);
>  
>  #ifdef ROCKET_DEBUG_WRITE
>  	printk(KERN_INFO "rp_put_char %c...", ch);
> @@ -1684,7 +1684,7 @@ static void rp_put_char(struct tty_struct *tty, unsigned char ch)
>  		info->xmit_fifo_room--;
>  	}
>  	spin_unlock_irqrestore(&info->slock, flags);
> -	up(&info->write_sem);
> +	mutex_unlock(&info->write_mtx);
>  }
>  
>  /*
> @@ -1706,7 +1706,8 @@ static int rp_write(struct tty_struct *tty,
>  	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
>  		return 0;
>  
> -	down_interruptible(&info->write_sem);
> +	if(mutex_lock_interruptible(&info->write_mtx))
> +		return -EINTR;

I think that ERESTARTSYS is appropriate here.

reagrds,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
