Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbXJWVuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbXJWVuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbXJWVuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:50:09 -0400
Received: from tim.rpsys.net ([194.106.48.114]:43072 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbXJWVuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:50:07 -0400
Subject: Re: [PATCH 3/3] leds-clevo-mail: driver for Clevo mail LED
From: Richard Purdie <rpurdie@rpsys.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
In-Reply-To: <471B4C46.9030502@freemail.hu>
References: <4718FD04.3080602@freemail.hu>
	 <20071019133607.3419b00a.randy.dunlap@oracle.com>
	 <471B4BA5.30100@freemail.hu>  <471B4C46.9030502@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 23 Oct 2007 22:48:24 +0100
Message-Id: <1193176104.5709.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-21 at 14:55 +0200, Németh Márton wrote:
> diff -uprN linux-2.6.23.orig/Documentation/leds-class.txt linux-2.6.23/Documentation/leds-class.txt
> --- linux-2.6.23.orig/Documentation/leds-class.txt	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/Documentation/leds-class.txt	2007-10-21 10:45:35.000000000 +0200
> @@ -39,7 +39,9 @@ LED Device Naming
> 
>  Is currently of the form:
> 
> -"devicename:colour"
> +"devicename:colour" or
> +"devicename:colour:type" or
> +"devicename::type"

Adding a the idea of function here was proposed a while back and we
probably should do that but it needs to be a separate patch and some of
the other drivers probably need tweaking for consistency. I will take
care of this for the next merge window.

> diff -uprN linux-2.6.23.orig/drivers/leds/Kconfig linux-2.6.23/drivers/leds/Kconfig
> --- linux-2.6.23.orig/drivers/leds/Kconfig	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/drivers/leds/Kconfig	2007-10-21 12:04:50.000000000 +0200
> @@ -101,6 +101,39 @@ config LEDS_GPIO
>  	  outputs. To be useful the particular board must have LEDs
>  	  and they must be connected to the GPIO lines.
> 
> +config LEDS_CLEVO_MAIL
> +	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
> +	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
> +	help
> +	  This driver makes the mail LED accessible from userspace
> +	  programs through the leds subsystem. This LED have three
> +	  known mode: off, blink at 0.5Hz and blink at 1Hz.
> +
> +	  The driver supports two kinds of interface: using ledtrig-timer
> +	  or through /sys/class/leds/clevo::mail/brightness. As this LED
> +	  cannot change it's brightness it blinks instead. The brightness
> +	  value 0 means off, 1..127 means blink at 0.5Hz and 128..255 means
> +	  blink at 1Hz.

Hmm, there really is no way to just turn the LED on? :(

> +	  Example to start blink at 0.5Hz:
> +	    echo 1 >/sys/class/leds/clevo::mail/brightness
> +	  - or -
> +	    echo timer >/sys/class/leds/clevo::mail/trigger
> +	    echo 1000 >/sys/class/leds/clevo::mail/delay_on
> +	    echo 1000 >/sys/class/leds/clevo::mail/delay_off

The Kconfig option shouldn't need to go into this much detail. If we
need this much detail, we should probably enhance the LED documentation
in Documentation/ instead.

> diff -uprN linux-2.6.23.orig/drivers/leds/leds-clevo-mail.c linux-2.6.23/drivers/leds/leds-clevo-mail.c
> --- linux-2.6.23.orig/drivers/leds/leds-clevo-mail.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.23/drivers/leds/leds-clevo-mail.c	2007-10-21 10:49:32.000000000 +0200
> @@ -0,0 +1,210 @@
> +
> +#include <linux/module.h>
> +
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/leds.h>
> +
> +#include <linux/io.h>
> +#include <linux/dmi.h>
> +
> +#include <linux/i8042.h>
> +
> +#define HANDLED				0

Probably easiest to turn the two references to this into "return 0"

Other than that the driver looks ok and I'm happy to add a version with
the above minor tweaks to the LED tree.

Cheers,

Richard

