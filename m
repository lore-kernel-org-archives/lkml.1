Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYKNWhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYKNWhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYKNWhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:37:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYKNWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:37:04 -0500
Date: Fri, 14 Nov 2008 14:36:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hao <kexin.hao@windriver.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@redhat.com,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] add device function for usb serial console
Message-Id: <20081114143643.c79cfc0c.akpm@linux-foundation.org>
In-Reply-To: <2fdffab7c5a36049b81ec63f2ee1fbdd4dd25a8a.1226366228.git.kexin.hao@windriver.com>
References: <1226541217-32673-1-git-send-email-kexin.hao@windriver.com>
	<23d0e3c26b7580b20c76900e16a53e42950ffaab.1226366228.git.kexin.hao@windriver.com>
	<2fdffab7c5a36049b81ec63f2ee1fbdd4dd25a8a.1226366228.git.kexin.hao@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 09:53:37 +0800
Kevin Hao <kexin.hao@windriver.com> wrote:

> Add device funtion for usb serial console, so we can open /dev/console
> when we use a usb serial device as console.
> 
> Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
> ---
>  drivers/usb/serial/console.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
> index 5b95009..1dbb203 100644
> --- a/drivers/usb/serial/console.c
> +++ b/drivers/usb/serial/console.c
> @@ -241,12 +241,25 @@ static void usb_console_write(struct console *co,
>  	}
>  }
>  
> +static struct tty_driver *usb_console_device(struct console *co, int *index)
> +{
> +	struct tty_driver **p = (struct tty_driver **)co->data;

co->data is already void*, hence this cast is unneeded.  It is also
undesirable because it defeats typechecking.

> +
> +	if (!*p)
> +		return NULL;
> +
> +	*index = co->index;
> +	return (struct tty_driver *)(*p);

And *p already has type `struct tty_driver *'.

> +}
> +
>  static struct console usbcons = {
>  	.name =		"ttyUSB",
>  	.write =	usb_console_write,
> +	.device =	usb_console_device,
>  	.setup =	usb_console_setup,
>  	.flags =	CON_PRINTBUFFER,
>  	.index =	-1,
> +	.data = 	&usb_serial_tty_driver,
>  };
>  


--- a/drivers/usb/serial/console.c~usb-serial-console-add-device-function-fix
+++ a/drivers/usb/serial/console.c
@@ -243,13 +243,13 @@ static void usb_console_write(struct con
 
 static struct tty_driver *usb_console_device(struct console *co, int *index)
 {
-	struct tty_driver **p = (struct tty_driver **)co->data;
+	struct tty_driver **p = co->data;
 
 	if (!*p)
 		return NULL;
 
 	*index = co->index;
-	return (struct tty_driver *)(*p);
+	return *p;
 }
 
 static struct console usbcons = {
_

