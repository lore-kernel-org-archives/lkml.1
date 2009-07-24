Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZGXQ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZGXQ2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZGXQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:28:50 -0400
Received: from h155.mvista.com ([63.81.120.155]:59694 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751847AbZGXQ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:28:49 -0400
Message-ID: <4A69E164.9040403@ru.mvista.com>
Date: Fri, 24 Jul 2009 20:29:24 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Trevor Pace <tr212206@DAL.CA>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
In-Reply-To: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Trevor Pace wrote:

> Removed useless return value variables.

    Are you sure gcc doesn't optimize them away? :-)

> Signed-off By: Trevor Pace <trevor.pace@dal.ca>

> ================================================================================

> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> index bd7581b..faec1d1 100644
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c

[...]

> @@ -437,11 +432,9 @@ static int serial_ioctl(struct tty_struct *tty, struct file
> *file,
> 
>  	/* pass on to the driver specific version of this function
>  	   if it is available */
> -	if (port->serial->type->ioctl) {
> -		retval = port->serial->type->ioctl(tty, file, cmd, arg);
> -	} else
> -		retval = -ENOIOCTLCMD;
> -	return retval;
> +	if (port->serial->type->ioctl)
> +		return port->serial->type->ioctl(tty, file, cmd, arg);
> +        return -ENOIOCTLCMD;

    Spaces instead of tab here...

> @@ -1185,24 +1178,21 @@ int usb_serial_suspend(struct usb_interface *intf,
> pm_message_t message)
>  	}
> 
>  	if (serial->type->suspend)
> -		r = serial->type->suspend(serial, message);
> +		return serial->type->suspend(serial, message);
> 
> -	return r;
> +	return 0;
>  }
>  EXPORT_SYMBOL(usb_serial_suspend);
> 
>  int usb_serial_resume(struct usb_interface *intf)
>  {
>  	struct usb_serial *serial = usb_get_intfdata(intf);
> -	int rv;
> 
>  	serial->suspending = 0;
> -	if (serial->type->resume)
> -		rv = serial->type->resume(serial);
> -	else
> -		rv = usb_serial_generic_resume(serial);
> 
> -	return rv;
> +	return (serial->type->resume)

    Parens totally not needed here.

> +		? serial->type->resume(serial)
> +		: usb_serial_generic_resume(serial);
>  }
>  EXPORT_SYMBOL(usb_serial_resume);

WBR, Sergei
