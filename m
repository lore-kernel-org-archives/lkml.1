Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbYBVTYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbYBVTYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759758AbYBVTVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:21:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:18874 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765807AbYBVTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oAVpf7tmfGEoqJw5W7s7egNO5fORJfZcKp1XTb+g1iu4wDP2UC5OSwcxGizg+vAyAsT82kXhJ10Syx8WAZ/vp0Y8TKp3qVPZ65neDqWy+e2zHRUbkN6Ybylu2Q+y7HUb79fStBSt1Y/dQHl7+tNHy8mvEoe5HY1O49GB4ySKygQ=
Message-ID: <47BF20B0.6090203@gmail.com>
Date: Fri, 22 Feb 2008 20:21:20 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] char: fix possible double-unlock in esp.c
References: <1203701667.5962.4.camel@brick>
In-Reply-To: <1203701667.5962.4.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2008 06:34 PM, Harvey Harrison wrote:
> Hitting either of the break statements in the while loop would cause
> a double-unlock of info->lock.  Add an out label and goto instead of
> break to skip the unlock in those cases.
> 
> Noticed by sparse:
> drivers/char/esp.c:2042:2: warning: context imbalance in 'rs_wait_until_sent' - unexpected unlock
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/char/esp.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/esp.c b/drivers/char/esp.c
> index 01fbddd..2b14814 100644
> --- a/drivers/char/esp.c
> +++ b/drivers/char/esp.c
> @@ -2030,16 +2030,17 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
>  		msleep_interruptible(jiffies_to_msecs(char_time));

guarantees current state be running after it returns either interrupted or not.

>  
>  		if (signal_pending(current))
> -			break;
> +			goto out;

just return;

>  		if (timeout && time_after(jiffies, orig_jiffies + timeout))
> -			break;
> +			goto out;

detto

>  		spin_lock_irqsave(&info->lock, flags);
>  		serial_out(info, UART_ESI_CMD1, ESI_NO_COMMAND);
>  		serial_out(info, UART_ESI_CMD1, ESI_GET_TX_AVAIL);
>  	}
>  	spin_unlock_irqrestore(&info->lock, flags);
> +out:
>  	set_current_state(TASK_RUNNING);

no need for this.

>  }
>  
