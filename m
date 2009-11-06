Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZKFNPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZKFNPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZKFNPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:15:40 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54902 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbZKFNPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:15:40 -0500
Date: Fri, 6 Nov 2009 14:15:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to
 unlocked_ioctl
Message-ID: <20091106141542.12404c5c@hyperion.delvare>
In-Reply-To: <20091015202758.400949170@linutronix.de>
References: <20091015202722.372890083@linutronix.de>
	<20091015202758.400949170@linutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Sorry for the late answer.

On Thu, 15 Oct 2009 20:28:31 -0000, Thomas Gleixner wrote:
> The conversion of fschmd watchdog ioctl to unlocked_ioctl needs to
> protect the static watchdog_info variable for the WDIOC_GETSUPPORT
> command.
> 
> All other commands are safe w/o BKL as the called watchdog functions
> are already serialized with watchdog_lock of the sensor.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: lm-sensors@lm-sensors.org
> ---
>  drivers/hwmon/fschmd.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6-tip/drivers/hwmon/fschmd.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/hwmon/fschmd.c
> +++ linux-2.6-tip/drivers/hwmon/fschmd.c
> @@ -844,8 +844,8 @@ static ssize_t watchdog_write(struct fil
>  	return count;
>  }
>  
> -static int watchdog_ioctl(struct inode *inode, struct file *filp,
> -	unsigned int cmd, unsigned long arg)
> +static long watchdog_ioctl(struct file *filp, unsigned int cmd,
> +			   unsigned long arg)
>  {
>  	static struct watchdog_info ident = {
>  		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
> @@ -857,11 +857,13 @@ static int watchdog_ioctl(struct inode *
>  
>  	switch (cmd) {
>  	case WDIOC_GETSUPPORT:
> +		mutex_lock(&watchdog_data_mutex);
>  		ident.firmware_version = data->revision;
>  		if (!nowayout)
>  			ident.options |= WDIOF_MAGICCLOSE;
>  		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
>  			ret = -EFAULT;
> +		mutex_unlock(&watchdog_data_mutex);
>  		break;

I'm not sure why we need to hold the mutex here? My understanding is
that watchdog_data_mutex protects watchdog_data_list and each
watchdog's kref. And the above code doesn't touch either.

What I am more worried about is why ident is declared static. This
looks like a bug to me. Instead of abusing watchdog_data_mutex to
workaround this, I'd rather remove the "static". I guess that the
current code happens to work because neither data->revision nor
nowayout can change over time, but this looks needlessly fragile.

Hans, any comment?

>  
>  	case WDIOC_GETSTATUS:
> @@ -921,7 +923,7 @@ static const struct file_operations watc
>  	.open = watchdog_open,
>  	.release = watchdog_release,
>  	.write = watchdog_write,
> -	.ioctl = watchdog_ioctl,
> +	.unlocked_ioctl = watchdog_ioctl,
>  };

-- 
Jean Delvare
