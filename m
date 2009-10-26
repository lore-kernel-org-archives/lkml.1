Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZJZRSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZJZRSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZJZRSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:18:40 -0400
Received: from kroah.org ([198.145.64.141]:49040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZJZRSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:18:38 -0400
Date: Mon, 26 Oct 2009 10:15:50 -0700
From: Greg KH <greg@kroah.com>
To: Antti =?iso-8859-1?Q?Kaijanm=E4ki?= <antti.kaijanmaki@nomovok.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix hso soft-lockup
Message-ID: <20091026171550.GA24910@kroah.com>
References: <1256200578.3057.113.camel@nomovok.homedomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1256200578.3057.113.camel@nomovok.homedomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 11:36:18AM +0300, Antti Kaijanmäki wrote:
> Fix soft-lockup in hso.c which is triggered on SMP machine when
> modem is removed while file descriptor(s) under /dev are still open:
> 
>   old version called kref_put() too early which resulted in destroying
>   hso_serial and hso_device objects which were still used later on.
> 
> Also fix driver debug routines (not compiled in by default).

Patches need to have a "signed-off-by:" line in order to be applied.

Also, please do not gpg sign your patches, that only causes problems
with our tools.

> ---
>  drivers/net/usb/hso.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index fa4e581..539642a 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -2,6 +2,7 @@
>   *
>   * Driver for Option High Speed Mobile Devices.
>   *
> + *  Copyright (C) 2009 Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>

Adding a copyright for a few lines changed is not really correct.

>   *  Copyright (C) 2008 Option International
>   *                     Filip Aben <f.aben@option.com>
>   *                     Denis Joseph Barrow <d.barow@option.com>
> @@ -378,7 +379,7 @@ static void dbg_dump(int line_count, const char *func_name, unsigned char *buf,
>  }
>  
>  #define DUMP(buf_, len_)	\
> -	dbg_dump(__LINE__, __func__, buf_, len_)
> +	dbg_dump(__LINE__, __func__, (unsigned char*)buf_, len_)

Why did you mane this change?

>  
>  #define DUMP1(buf_, len_)			\
>  	do {					\
> @@ -1363,7 +1364,7 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
>  	/* reset the rts and dtr */
>  	/* do the actual close */
>  	serial->open_count--;
> -	kref_put(&serial->parent->ref, hso_serial_ref_free);
> +
>  	if (serial->open_count <= 0) {
>  		serial->open_count = 0;
>  		spin_lock_irq(&serial->serial_lock);
> @@ -1383,6 +1384,8 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
>  		usb_autopm_put_interface(serial->parent->interface);
>  
>  	mutex_unlock(&serial->parent->mutex);
> +
> +	kref_put(&serial->parent->ref, hso_serial_ref_free);
>  }
>  
>  /* close the requested serial port */
> @@ -1527,7 +1530,7 @@ static void tiocmget_intr_callback(struct urb *urb)
>  		dev_warn(&usb->dev,
>  			 "hso received invalid serial state notification\n");
>  		DUMP(serial_state_notification,
> -		     sizeof(hso_serial_state_notifation))
> +		     sizeof(struct hso_serial_state_notification));

Is this a build fix not related to the bug above?

Also, network patches need to be sent to the network maintainers, they
usually miss them if you only copy the linux-kernel list.

Try using the scripts/get_maintainer.pl script on your patch to figure
out who to send the patch to, and also the scripts/checkpatch.pl script
to verify that you got everything correct before you send it off.

Also, for a bugfix like this, it would be good to send it to the
stable@kernel.org developers when it goes into Linus's tree as others
are reporting problems with this driver in the 2.6.31 kernel.

thanks,

greg k-h
