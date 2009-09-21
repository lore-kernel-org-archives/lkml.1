Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZIUNHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZIUNHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZIUNHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:07:18 -0400
Received: from poutre.nerim.net ([62.4.16.124]:56487 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbZIUNHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:07:13 -0400
Date: Mon, 21 Sep 2009 15:07:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [origin tree build fix] [PATCH] Driver-Core: extend devnode
 callbacks to provide permissions, fix
Message-ID: <20090921150713.2c5d64d2@hyperion.delvare>
In-Reply-To: <20090921070055.GA14698@elte.hu>
References: <20090919213332.GA7668@kroah.com>
	<20090921070055.GA14698@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 09:00:55 +0200, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > Here is one driver core patch
> > 
> > It fixes the problem that Ingo found with devtmpfs and makes it so
> > that a user can boot a kernel using devtmpfs and no version of udev
> > on the system, making this option a much more useful thing.
> > 
> > Thanks to Ingo for reporting and testing this, and for Eric's review
> > comments, which Kay has made in this patch as well.
> > 
> > Please pull from:
> > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/
> [...]
> >
> > Kay Sievers (1):
> >       Driver-Core: extend devnode callbacks to provide permissions
> 
> Looks good here - except that you missed a driver which broke the 
> upstream build - fix patch attached below.
> 
> Thanks,
> 
> 	Ingo
> 
> ------------------>
> From 7a9906a8f51df1bf30789aa7c74609928ddb8d0e Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 21 Sep 2009 08:56:58 +0200
> Subject: [PATCH] Driver-Core: extend devnode callbacks to provide permissions, fix
> 
> The build of the dabusb driver broke:
> 
>   drivers/media/video/dabusb.c:758: error: unknown field 'nodename' specified in initializer
>   drivers/media/video/dabusb.c:758: warning: initialization from incompatible pointer type
>   make[3]: *** wait: No child processes.  Stop.
> 
> Due to this commit:
> 
>   e454cea: Driver-Core: extend devnode callbacks to provide permissions
> 
> Missing the dabusb driver's dabusb_nodename() callback.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/video/dabusb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
> index 0664d11..ee43876 100644
> --- a/drivers/media/video/dabusb.c
> +++ b/drivers/media/video/dabusb.c
> @@ -748,14 +748,14 @@ static const struct file_operations dabusb_fops =
>  	.release =	dabusb_release,
>  };
>  
> -static char *dabusb_nodename(struct device *dev)
> +static char *dabusb_devnode(struct device *dev, mode_t *mode)
>  {
>  	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
>  }
>  
>  static struct usb_class_driver dabusb_class = {
>  	.name =		"dabusb%d",
> -	.nodename =	dabusb_nodename,
> +	.devnode =	dabusb_devnode,
>  	.fops =		&dabusb_fops,
>  	.minor_base =	DABUSB_MINOR,
>  };

Fixed half of the build breakage for me. There's a similar problem in
drivers/staging/iio/industrialio-core.c:

--- linux-2.6.32-pre.orig/drivers/staging/iio/industrialio-core.c	2009-09-21 13:24:11.000000000 +0200
+++ linux-2.6.32-pre/drivers/staging/iio/industrialio-core.c	2009-09-21 14:28:35.000000000 +0200
@@ -39,14 +39,14 @@ dev_t iio_devt;
 EXPORT_SYMBOL(iio_devt);
 
 #define IIO_DEV_MAX 256
-static char *iio_nodename(struct device *dev)
+static char *iio_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "iio/%s", dev_name(dev));
 }
 
 struct class iio_class = {
 	.name = "iio",
-	.nodename = iio_nodename,
+	.devnode = iio_devnode,
 };
 EXPORT_SYMBOL(iio_class);
 


-- 
Jean Delvare
