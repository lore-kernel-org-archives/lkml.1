Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZLMW37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZLMW37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZLMW36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:29:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbZLMW34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:29:56 -0500
Date: Sun, 13 Dec 2009 14:29:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] kfifo: fix warn_unused_result
Message-Id: <20091213142907.d0ac63da.akpm@linux-foundation.org>
In-Reply-To: <1260523108.27010.7.camel@wall-e>
References: <1260523108.27010.7.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 10:18:28 +0100 Stefani Seibold <stefani@seibold.net> wrote:

> As requested by Andrew Morton:
> 
> This patch fix the "ignoring return value of '...', declared with
> attribute warn_unused_result" compiler warning in several users of the
> new kfifo API.
> 
> The patch-set is against current mm tree from 11-Dec-2009
> 
> ...
>
> --- mmotm/drivers/char/nozomi.c	2009-12-11 08:31:46.670736197 +0100
> +++ linux-2.6.32/drivers/char/nozomi.c	2009-12-11 09:25:46.941436203 +0100
> @@ -685,8 +685,9 @@ static int nozomi_read_config_table(stru
>  		dump_table(dc);
>  
>  		for (i = PORT_MDM; i < MAX_PORT; i++) {
> -			kfifo_alloc(&dc->port[i].fifo_ul,
> -				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC);
> +			if (kfifo_alloc(&dc->port[i].fifo_ul,
> +				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC))
> +					BUG();

No, we can't do this.  GFP_ATOMIC allocations are unreliable and can
fail.  The calling code *has* to detect the failure and then take some
recovery action.

It would be better to leave the warning in place, rather than to add
this runtime landmine.

>  		input_sync(kp.dev);
> -		kfifo_in_locked(&sonypi_device.input_fifo,
> +		if (kfifo_in_locked(&sonypi_device.input_fifo,
>  			(unsigned char *)&kp, sizeof(kp),
> -			&sonypi_device.input_fifo_lock);
> +			&sonypi_device.input_fifo_lock) != sizeof(kp))
> +				BUG();

The rest of the patch seems to be adding BUG()s if kfifo_in() fails. 
All over the place.

If that's the appropriate way to handle failure for these callsites
then it would be neater to do this in the callee.  ie, add a new

unsigned int kfifo_in_nonpartial(struct kfifo *fifo,
                        const unsigned char *from, unsigned int len)
{
	unsigned int ret = kfifo_in(fifo, from, len);

	BUG_ON(ret != len);
	return ret;
}

