Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbXCCVFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbXCCVFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXCCVFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:05:22 -0500
Received: from email.authentidate.de ([213.61.157.66]:58752 "EHLO
	email.authentidate.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbXCCVFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:05:22 -0500
Subject: Re: usbserial not working/oops on removal
From: Andreas Laumann <al@authentidate.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Kevin Fenzi <kevin@scrye.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200703032143.34664.oliver@neukum.org>
References: <20070302193715.568098a6@ningauble.scrye.com>
	 <200703031138.20582.oliver@neukum.org>
	 <1172928441.3710.8.camel@justine.inexnet.de>
	 <200703032143.34664.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Organization: AuthentiDate International AG
Date: Sat, 03 Mar 2007 22:05:16 +0100
Message-Id: <1172955916.5393.16.camel@justine.inexnet.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 03.03.2007, 21:43 +0100 schrieb Oliver Neukum:
> Am Samstag, 3. März 2007 14:27 schrieb Andreas Laumann:
> > Unfortunately your fix  does not work.  The first one seems registered
> > correctly, but after that it fails again for the next one.  
> 
> Unfortunately the last patch I sent you introduced a race. Could you test
> this alternative patch?
> 
> 	Regards
> 		Oliver
> 
> --- a/drivers/usb/serial/usb-serial.c	2007-03-03 16:28:22.000000000 +0100
> +++ b/drivers/usb/serial/usb-serial.c	2007-03-03 21:37:27.000000000 +0100
> @@ -99,9 +99,12 @@
>  			continue;
>  
>  		*minor = i;
> +		j = 0;
>  		dbg("%s - minor base = %d", __FUNCTION__, *minor);
> -		for (i = *minor; (i < (*minor + num_ports)) && (i < SERIAL_TTY_MINORS); ++i)
> +		for (i = *minor; (i < (*minor + num_ports)) && (i < SERIAL_TTY_MINORS); ++i) {
>  			serial_table[i] = serial;
> +			serial->port[j++]->number = i;
> +		}
>  		spin_unlock(&table_lock);
>  		return serial;
>  	}
> @@ -847,7 +850,6 @@
>  		port = kzalloc(sizeof(struct usb_serial_port), GFP_KERNEL);
>  		if (!port)
>  			goto probe_error;
> -		port->number = i + serial->minor;
>  		port->serial = serial;
>  		spin_lock_init(&port->lock);
>  		mutex_init(&port->mutex);

On top of the first patch ? Sure, I'll try it in a couple of minutes

Btw, I got rejects from the last patch (the racy one) you've sent and
had to apply them manually.  Which version do you use ? 

Regards
	Andreas


