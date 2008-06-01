Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYFATi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYFATi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 15:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYFATir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 15:38:47 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56825 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYFATiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 15:38:46 -0400
Message-ID: <4842FB89.6040802@keyaccess.nl>
Date: Sun, 01 Jun 2008 21:42:01 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 01/15] serial: when guessing, check only active resources,
 not options
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224931.549456692@ldl.fc.hp.com>
In-Reply-To: <20080530224931.549456692@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:48, Bjorn Helgaas wrote:

> Given a completely unknown PNP device, if it happens to have
> a modem-like string in its name and it matches a COM port
> address, we assume it's a modem.
> 
> We used to check the address against all the possible resource
> options for the device.  But the device is already configured
> and enabled, so we only need to check the resources it is
> actually using.  If we matched an address that wasn't currently
> enabled, we would fail anyway as soon as we attempted to touch
> the device at that address.
> 
> This removes a reference to the struct pnp_dev.{independent,dependent}
> fields, which I will soon make private to the PNP subsystem.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

This isn't quite right it seems. Or changes behaviour at least:

> Index: work10/drivers/serial/8250_pnp.c
> ===================================================================
> --- work10.orig/drivers/serial/8250_pnp.c	2008-05-13 11:28:48.000000000 -0600
> +++ work10/drivers/serial/8250_pnp.c	2008-05-13 11:29:16.000000000 -0600
> @@ -383,22 +383,19 @@ static int __devinit check_name(char *na
>  	return 0;
>  }
>  
> -static int __devinit check_resources(struct pnp_option *option)
> +static int __devinit check_resources(struct pnp_dev *dev)
>  {
> -	struct pnp_option *tmp;
> -	if (!option)
> +	resource_size_t port, size;
> +
> +	if (!pnp_port_valid(dev, 0))
>  		return 0;
>  
> -	for (tmp = option; tmp; tmp = tmp->next) {
> -		struct pnp_port *port;
> -		for (port = tmp->port; port; port = port->next)
> -			if ((port->size == 8) &&
> -			    ((port->min == 0x2f8) ||
> -			     (port->min == 0x3f8) ||
> -			     (port->min == 0x2e8) ||
> -			     (port->min == 0x3e8)))
> -				return 1;
> -	}
> +	port = pnp_port_start(dev, 0);
> +	size = pnp_port_len(dev, 0);
> +
> +	if (size == 8 &&
> +	    (port == 0x2f8 || port == 0x3f8 || port == 0x2e8 || port == 0x3e8))
> +		return 1;
>  
>  	return 0;
>  }
> @@ -420,10 +417,7 @@ static int __devinit serial_pnp_guess_bo
>  		(dev->card && check_name(dev->card->name))))
>  			return -ENODEV;
>  
> -	if (check_resources(dev->independent))
> -		return 0;
> -
> -	if (check_resources(dev->dependent))
> +	if (check_resources(dev))
>  		return 0;
>  
>  	return -ENODEV;

We used to cry "modem" if the device _could_ be configured using a COM 
address while after this change we'd only do so if it _was_ configured 
using one.

My old analog modem for example had 5 dependent sets -- the first with 
the regular COM port addresses (0x3f8, 0x2f8, 0x3e8, 0x2e8) and a 5th 
one listing a port range of (IIRC, something like that at least) 0x100 
to 0xff8.

So say I'd have a PC with the regular two onboard COM ports at COM1 and 
COM2 (0x3f8 and 0x2f8) and an additional serial controller providing 
COM3 and COM4 (0x3e8 and 0x2e8). My modem would then be configured to 
use 0x100 and this code would no longer trigger while it did use to.

Not that I care deeply or anything but whomever wrote this did no doubt 
intend it to work this way...

Rene.
