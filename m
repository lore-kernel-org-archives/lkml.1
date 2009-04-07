Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZDGBGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZDGBGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZDGBGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:06:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:40165 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZDGBGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:06:06 -0400
Date: Mon, 6 Apr 2009 18:01:34 -0700
From: Greg KH <gregkh@suse.de>
To: Elina <epasheva@sierrawireless.com>
Cc: rfiler@sierrawireless.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/003] USB: serial: sierra driver performance
	improvements
Message-ID: <20090407010134.GB2839@suse.de>
References: <1239062754.10120.36.camel@Linuxdev3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239062754.10120.36.camel@Linuxdev3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 05:05:54PM -0700, Elina wrote:
> +int sierra_suspend(struct usb_serial *serial, pm_message_t message)
> +{
> +	printk(KERN_ERR "################################%s\n", __func__);
> +
> +	return 0;
> +}
> +
> +int sierra_resume(struct usb_serial *serial)
> +{
> +	printk(KERN_ERR "################################%s\n", __func__);
> +
> +	return 0;
> +}

What are these changes for?  What are they supposed to do becides annoy
any user who happens to want to suspend/resume their system with your
driver and device loaded?

>  static struct usb_driver sierra_driver = {
>  	.name       = "sierra",
>  	.probe      = usb_serial_probe,
>  	.disconnect = usb_serial_disconnect,
> +	.suspend =	usb_serial_suspend,
> +	.resume =	usb_serial_resume,

Please keep the formatting the same wherever possible (hint, like
here...)


>  struct sierra_port_private {
> @@ -360,7 +385,12 @@ static int sierra_write(struct tty_struc
>  	unsigned long flags;
>  	unsigned char *buffer;
>  	struct urb *urb;
> -	int status;
> +	size_t writesize = min((size_t)count, (size_t)MAX_TRANSFER);

There is a min_t() macro if you need to cast the type, like you did
here, please use that instead.

>  static void sierra_indat_callback(struct urb *urb)
> @@ -735,6 +764,8 @@ static struct usb_serial_driver sierra_d
>  	.attach            = sierra_startup,
>  	.shutdown          = sierra_shutdown,
>  	.read_int_callback = sierra_instat_callback,
> +	.suspend =	sierra_suspend,
> +	.resume =	sierra_resume,

Same formatting issue here as above.


> -	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
> -	       DRIVER_DESC "\n");
> -
> +	printk(KERN_ERR "################################%s\n", __func__);
>  	return 0;

This is not an ok change.

>  failed_driver_register:
> @@ -763,6 +792,7 @@ failed_device_register:
>  
>  static void __exit sierra_exit(void)
>  {
> +	printk(KERN_ERR "################################%s\n", __func__);

And neither is this.

It looks like you left your debugging code in here :(

thanks,

greg k-h
