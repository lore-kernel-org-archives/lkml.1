Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbZGZAwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbZGZAwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 20:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZGZAwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 20:52:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:59629 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZGZAwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 20:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=cpKIzPRMuQjff/7dREoNyV8FmFQ/8OtUC7CSd6DPVdpxFQ3ak+FUzctxmxMc9BrQ3z
         RNtnVZR1g95COKZE17Fqw9ySmLvi5vtXWfzwCJcd5sj9oAHXZRlx/BYp/6vNCdhg4CAi
         GUSMffbtsB/lB2viAGuEr9oDXewczgiD9dnIE=
References: <20090701083737.41f28c7d.erik@kryo.se> <20090708144337.7006fa0a@t61.ukuu.org.uk> <200907251612.34140.elendil@planet.nl> <200907252218.46364.rjw@sisk.pl> <20090725225937.dfbd4805.erik@kryo.se>
Message-Id: <A64E62CE-DD3A-495F-A745-77588B25E495@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Erik Ekman <erik@kryo.se>
In-Reply-To: <20090725225937.dfbd4805.erik@kryo.se>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [PATCH v2 -tip][RFC] serial8250: update to dev_pm_ops
Date: Sat, 25 Jul 2009 17:52:46 -0700
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Alan Cox <alan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 25, 2009, at 1:59 PM, Erik Ekman <erik@kryo.se> wrote:

> serial8250: update to dev_pm_ops
>
> From dmesg:
> Platform driver 'serial8250' needs updating - please use dev_pm_ops
>
> Signed-off-by: Erik Ekman <erik@kryo.se>
> --
> Updated to handle hibernation as understood based on info from  
> Rafael J. Wysocki.
> Please let me know if any special handling is needed.
>
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index fb867a9..e93222c 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -2982,42 +2982,50 @@ static int __devexit serial8250_remove 
> (struct platform_device *dev)
>    return 0;
> }
>
> -static int serial8250_suspend(struct platform_device *dev,  
> pm_message_t state)
> +static int serial8250_suspend(struct device *dev)
> {
>    int i;
>
>    for (i = 0; i < UART_NR; i++) {
>        struct uart_8250_port *up = &serial8250_ports[i];
>
> -        if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev- 
> >dev)
> +        if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
>            uart_suspend_port(&serial8250_reg, &up->port);
>    }
>
>    return 0;
> }
>
> -static int serial8250_resume(struct platform_device *dev)
> +static int serial8250_resume(struct device *dev)
> {
>    int i;
>
>    for (i = 0; i < UART_NR; i++) {
>        struct uart_8250_port *up = &serial8250_ports[i];
>
> -        if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev- 
> >dev)
> +        if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
>            serial8250_resume_port(i);
>    }
>
>    return 0;
> }
>
> +static struct dev_pm_ops serial8250_pm_ops = {
> +    .resume   = serial8250_resume,
> +    .suspend  = serial8250_suspend,
> +    .freeze   = serial8250_resume,
> +    .thaw     = serial8250_suspend,
> +    .restore  = serial8250_resume,
> +    .poweroff = serial8250_suspend,
> +};


Do we really both freeze and poweroff for serial port? I am getting  
wary of these mechanical conversions...

-- 
Dmitry

