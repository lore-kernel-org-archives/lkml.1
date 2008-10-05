Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYJEObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYJEObT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYJEObK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 10:31:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:2267 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbYJEObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=EVSQ4ODM0HpVEKIVxTeBJf/v6s7vYzF1bViRLYyr548C6vPQzcsUHPGnU2Ht+EdX1j
         PxbL6X0EQnb+5YEJ3L0/uM/LtE1AWP6HTV67YqJn/IkrlVL2AzYj/fTfhTJVvcUMQwEM
         bpm6q6TVJmfaF43h5VFmbTTMOQn478ayNcwXk=
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
Date: Sun, 5 Oct 2008 16:31:03 +0200
User-Agent: KMail/1.9.9
Cc: dmitry.torokhov@gmail.com, hmh@hmh.eng.br, sitsofe@yahoo.com,
       linux-kernel@vger.kernel.org
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org> <20081005110226.GB4087@srcf.ucam.org>
In-Reply-To: <20081005110226.GB4087@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810051631.03844.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008, Matthew Garrett wrote:
> rfkill-input implements debounce as follows:
> 
>         if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> 
> However, task->last is initialised to 0 while jiffies starts at -300*HZ. 
> Any input within 5 minutes of kernel start is therefore ignored. Fix by 
> initialising task->last correctly.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

I am not too happy about the multiple jiffies - HZ/5 statements
regardless of the comment that it should be updated when new tasks are
defined.

But on the other hand I haven't seen any real alternatives yet either,
so I have no objections against this patch either.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
 
> ---
> 
> Document the requirement to initialise the struct.
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index e5b6955..6c7baa0 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -103,6 +103,8 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
>  		.desired_state = RFKILL_STATE_UNBLOCKED,	\
>  	}
>  
> +/* Remember to initialise these in rfkill_handler_init if you add any */
> +
>  static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
>  static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
>  static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
> @@ -255,6 +257,11 @@ static struct input_handler rfkill_handler = {
>  
>  static int __init rfkill_handler_init(void)
>  {
> +	rfkill_wlan.last = jiffies - HZ/5;
> +	rfkill_bt.last = jiffies - HZ/5;
> +	rfkill_uwb.last = jiffies - HZ/5;
> +	rfkill_wimax.last = jiffies - HZ/5;
> +	rfkill_wwan.last = jiffies - HZ/5;
>  	return input_register_handler(&rfkill_handler);
>  }
>  
> 


