Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZFWGU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZFWGU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZFWGTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:19:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494AbZFWGTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:19:47 -0400
Date: Mon, 22 Jun 2009 23:19:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt fix transmit race and timeout
Message-Id: <20090622231937.2d32898e.akpm@linux-foundation.org>
In-Reply-To: <1245181451.3727.5.camel@x2.microgate.com>
References: <1245181451.3727.5.camel@x2.microgate.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 14:44:11 -0500 Paul Fulghum <paulkf@microgate.com> wrote:

> Fix race condition when adding transmit data to active DMA buffer ring
> that can cause transmit stall.
> Update transmit timeout when adding data to active DMA buffer ring.
> Base transmit timeout on amount of buffered data instead of
> using fixed value.
> 

It's not a terribly good changelog, sorry.

It fails to describe the race condition?

It fails to explain the user-visible effects of the bug which was
fixed.  Those who need to make should-we-backport-this-to-stable
decisions need to know this.  Often we are told, often we can guess. 
Sometimes neither.


> 
> --- a/drivers/char/synclink_gt.c	2009-06-09 22:05:27.000000000 -0500
> +++ b/drivers/char/synclink_gt.c	2009-06-16 13:58:14.000000000 -0500
> @@ -463,7 +463,6 @@ static unsigned int free_tbuf_count(stru
>  static unsigned int tbuf_bytes(struct slgt_info *info);
>  static void reset_tbufs(struct slgt_info *info);
>  static void tdma_reset(struct slgt_info *info);
> -static void tdma_start(struct slgt_info *info);
>  static void tx_load(struct slgt_info *info, const char *buf, unsigned int count);
>  
>  static void get_signals(struct slgt_info *info);
> @@ -791,6 +790,18 @@ static void set_termios(struct tty_struc
>  	}
>  }
>  
> +static void update_tx_timer(struct slgt_info *info)
> +{
> +	/*
> +	 * use worst case speed of 1200bps to calculate transmit timeout
> +	 * based on data in buffers (tbuf_bytes) and FIFO (128 bytes)
> +	 */
> +	if (info->params.mode == MGSL_MODE_HDLC) {
> +		int timeout  = (tbuf_bytes(info) * 7) + 1000;
> +		mod_timer(&info->tx_timer, jiffies + msecs_to_jiffies(timeout));
> +	}
> +}

Where did the "7" come from?

>  static int write(struct tty_struct *tty,
>  		 const unsigned char *buf, int count)
>  {
> @@ -834,8 +845,18 @@ start:
>  		spin_lock_irqsave(&info->lock,flags);
>  		if (!info->tx_active)
>  		 	tx_start(info);
> -		else
> -			tdma_start(info);
> +		else if (!(rd_reg32(info, TDCSR) & BIT0)) {
> +			/* transmit still active but transmit DMA stopped */
> +			unsigned int i = info->tbuf_current;
> +			if (!i)
> +				i = info->tbuf_count;
> +			i--;
> +			/* if DMA buf unsent must try later after tx idle */
> +			if (desc_count(info->tbufs[i]))
> +				ret = 0;
> +		}
> +		if (ret > 0)
> +			update_tx_timer(info);
>  		spin_unlock_irqrestore(&info->lock,flags);
>   	}
>  
> @@ -1498,10 +1519,9 @@ static int hdlcdev_xmit(struct sk_buff *
>  	/* save start time for transmit timeout detection */
>  	dev->trans_start = jiffies;
>  
> -	/* start hardware transmitter if necessary */
>  	spin_lock_irqsave(&info->lock,flags);
> -	if (!info->tx_active)
> -	 	tx_start(info);
> +	tx_start(info);
> +	update_tx_timer(info);
>  	spin_unlock_irqrestore(&info->lock,flags);
>  
>  	return 0;
> @@ -3886,50 +3906,19 @@ static void tx_start(struct slgt_info *i
>  			slgt_irq_on(info, IRQ_TXUNDER + IRQ_TXIDLE);
>  			/* clear tx idle and underrun status bits */
>  			wr_reg16(info, SSR, (unsigned short)(IRQ_TXIDLE + IRQ_TXUNDER));
> -			if (info->params.mode == MGSL_MODE_HDLC)
> -				mod_timer(&info->tx_timer, jiffies +
> -						msecs_to_jiffies(5000));
>  		} else {
>  			slgt_irq_off(info, IRQ_TXDATA);
>  			slgt_irq_on(info, IRQ_TXIDLE);
>  			/* clear tx idle status bit */
>  			wr_reg16(info, SSR, IRQ_TXIDLE);
>  		}
> -		tdma_start(info);
> +		/* set 1st descriptor address and start DMA */
> +		wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
> +		wr_reg32(info, TDCSR, BIT2 + BIT0);
>  		info->tx_active = true;
>  	}
>  }
>  
> ...
>
> @@ -4942,8 +4931,7 @@ static void tx_timeout(unsigned long con
>  		info->icount.txtimeout++;
>  	}
>  	spin_lock_irqsave(&info->lock,flags);
> -	info->tx_active = false;
> -	info->tx_count = 0;
> +	tx_stop(info);

I have a suspicion that tx_stop() should use del_timer_sync(), not
del_timer().  What happens if the timer handler is concurrently
running?
