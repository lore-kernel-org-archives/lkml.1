Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZKTMRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZKTMRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZKTMRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:17:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63854 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZKTMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:17:03 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 07:17:02 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=IQtPM0MtHVt6C/3ZvZKc6SN+lx36h/tGaezEvG7Pfy54xKN1ZR5Z7yUOKXFkZ+JxlX
         jGAa8lnD28sMZBJNceWt838Y4Fvgm6ZRU2HopFCCAezvIpP6jkWBh6BXhxCC5mfUxGua
         FTi10xI64+mg6AABmeI+7yqgtB87FuP5Ev+XQ=
Date: Fri, 20 Nov 2009 14:08:55 +0200
From: Dan Carpenter <error27@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] mxser: Use the new locking rules to fix
	setserial properly
Message-ID: <20091120120855.GA28630@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alan Cox <alan@linux.intel.com>, greg@kroah.com,
	linux-kernel@vger.kernel.org
References: <20091118141354.3346.16910.stgit@localhost.localdomain> <20091118141516.3346.1769.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118141516.3346.1769.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 02:15:23PM +0000, Alan Cox wrote:
> Propogate the init/shutdown mutex through the setserial logic. Use the proper
> locks for the various bits still using the BKL. Kill the BKL in this driver.
> 

>  drivers/char/mxser.c |  145 +++++++++++++++++++++++++++-----------------------

> @@ -1951,6 +1959,7 @@ static void mxser_wait_until_sent(struct tty_struct *tty, int timeout)

> +	spin_lock_irqsave(&info->slock, flags);
>  	while (!((lsr = inb(info->ioaddr + UART_LSR)) & UART_LSR_TEMT)) {
>  #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
>  		printk("lsr = %d (jiff=%lu)...", lsr, jiffies);
>  #endif
> +		spin_unlock_irqrestore(&info->slock, flags);
>  		schedule_timeout_interruptible(char_time);
>  		if (signal_pending(current))
>  			break;
>  		if (timeout && time_after(jiffies, orig_jiffies + timeout))
>  			break;

If we break out of this while loop we get a double unlock.

> +		spin_lock_irqsave(&info->slock, flags);
>  	}
> +	spin_unlock_irqrestore(&info->slock, flags);
>  	set_current_state(TASK_RUNNING);
> -	unlock_kernel();

regards,
dan carpenter
