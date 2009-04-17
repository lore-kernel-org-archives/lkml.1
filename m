Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbZDQOcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbZDQOcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbZDQOcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:32:31 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63858 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbZDQOca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gt8RLDiVzMsVdWPYuXAyHZyG2CUle7nJfAdlLMEF2hTZiYG0zcBGyivKEpG+J3vUMq
         mPyUtqrJd5FmkcYjqFRxtnQjLqNj7n3C/t6BZVERzZHs5V1qM8j5atj+1P3hKNyTDRpe
         1+s4RNdaLhy+PbiVFyltmlr8LP9EgLXV3Lil4=
From: Florian Fainelli <florian@openwrt.org>
To: "Peter Holik" <peter@holik.at>
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
Date: Fri, 17 Apr 2009 16:32:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
In-Reply-To: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904171632.26091.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Nice to see such a driver coming up!

Le Friday 17 April 2009 16:10:24 Peter Holik, vous avez écrit :
> Signed-off-by: Peter Holik <peter@holik.at>
> ---
>  drivers/net/usb/Kconfig    |    7 +
>  drivers/net/usb/Makefile   |    2 +-
>  drivers/net/usb/intellon.c |  273
> ++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 281
> insertions(+), 1 deletions(-)
>  create mode 100644 drivers/net/usb/intellon.c
>
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 8ee2103..068faa5 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -345,4 +345,11 @@ config USB_HSO
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called hso.
>
> +config USB_NET_INTELLON
> +	tristate "Intellon PLC based usb adapter"
> +	depends on USB_USBNET
> +	help
> +	  Choose this option if you're using a PLC (Powerline Communications)
> +	  solution with an Intellon chip, like the "devolo dLan duo".
> +

Please be more specific, i.e: using a USB-based PLC (...) solution. There 
might be support for PLC PHYs connected to a MII-bus in a near future, even 
though they will not reside in drivers/net/usb/.

>  endmenu
> diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
> index 88a87ee..0fccfe9 100644
> --- a/drivers/net/usb/Makefile
> +++ b/drivers/net/usb/Makefile
> @@ -19,4 +19,4 @@ obj-$(CONFIG_USB_NET_CDC_SUBSET)	+= cdc_subset.o
>  obj-$(CONFIG_USB_NET_ZAURUS)	+= zaurus.o
>  obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
>  obj-$(CONFIG_USB_USBNET)	+= usbnet.o
> -
> +obj-$(CONFIG_USB_NET_INTELLON)	+= intellon.o

I would not name this intellon for the same reasons as explained below, but 
rather int51x1.c since this driver will for instance not work with HomePlug 
AV designs which use different Intellon integrated chips like the 6000 and 
6300 series.

> diff --git a/drivers/net/usb/intellon.c b/drivers/net/usb/intellon.c
> new file mode 100644
> index 0000000..c9fcc38
> --- /dev/null
> +++ b/drivers/net/usb/intellon.c
> @@ -0,0 +1,273 @@
> +/*
> + * Copyright (c) 2009 Peter Holik
> + *
> + * Intellon PLC (Powerline Communications) usb net driver

Intellon INT51x1 PLC ...
[snip]

> +
> +static u8 nibble(unsigned char c)
> +{
> +	if (likely(isdigit(c)))
> +		return c - '0';
> +	c = toupper(c);
> +	if (likely(isxdigit(c)))
> +		return 10 + c - 'A';
> +	return 0;
> +}

Please prefix this with intellon_ (or int51x1_) for instance to avoid any 
possible namespace clash.

> +
> +static inline int get_ethernet_addr(struct usbnet *dev)
> +{
> +	int             tmp, i;
> +	unsigned char   buf [13];
> +
> +	tmp = usb_string(dev->udev, 3, buf, sizeof buf);
> +	if (tmp != 12) {
> +		devdbg(dev, "bad MAC string fetch, %d\n", tmp);
> +		if (tmp >= 0)
> +			tmp = -EINVAL;
> +		return tmp;
> +	}
> +	for (i = tmp = 0; i < 6; i++, tmp += 2)
> +		dev->net->dev_addr [i] =
> +			(nibble(buf [tmp]) << 4) + nibble(buf [tmp + 1]);
> +	return 0;
> +}

Same here.

Please fix the intellon prefixing with something more specific to the driver 
like int51x1_ and I am ok with that driver.

Acked-by: Florian Fainelli <florian@openwrt.org>
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
