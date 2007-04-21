Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXDUXLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXDUXLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXDUXLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:11:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:59856 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXDUXLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:11:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/8] Kconfig: unwanted menus for s390.
Date: Sun, 22 Apr 2007 01:10:54 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070420113248.GC3738@skybase>
In-Reply-To: <20070420113248.GC3738@skybase>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704220110.54587.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/f5AOP12eSZlY/LDHQjuGM7SeuE4lxXHAEh19
 pR3JtWxPTpIwO/Ekn8fmyooTL9UFM8D91tpkRiy6LnEOi8KQCV
 gUbT2WgyIJXePeqLI2TwQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007, Martin Schwidefsky wrote:
> diff -urpN linux-2.6/drivers/char/ipmi/Kconfig linux-2.6-patched/drivers/char/ipmi/Kconfig
> --- linux-2.6/drivers/char/ipmi/Kconfig 2007-02-04 19:44:54.000000000 +0100
> +++ linux-2.6-patched/drivers/char/ipmi/Kconfig 2007-04-19 15:49:55.000000000 +0200
> @@ -3,6 +3,8 @@
>  #
>  
>  menu "IPMI"
> +       depends on !S390
> +
>  config IPMI_HANDLER
>         tristate 'IPMI top-level message handler'
>         help

I think I made this comment the last time we discussed this topic, but don't
remember the exact outcome.

I would prefer to not have 'depends on !S390' but rather 'depends on MMIO',
because that is what really drives stuff like IPMI: they expect the device
to be reachable through the use of ioremap or inX/outX instructions, which
don't exist on s390.

While it's unlikely that another architecture has the same restriction,
it expresses much clearer what you mean.

In drivers/Kconfig, you can then simply add a

config MMIO
	def_bool !S390

There are a few exceptions though, that I think should not depend on MMIO:

> --- linux-2.6/drivers/dma/Kconfig	2007-04-19 15:24:33.000000000 +0200
> +++ linux-2.6-patched/drivers/dma/Kconfig	2007-04-19 15:49:55.000000000 +0200
> @@ -3,6 +3,7 @@
>  #
>  
>  menu "DMA Engine support"
> +	depends on !S390
>  
>  config DMA_ENGINE
>  	bool "Support for DMA engines"

I'd leave the menu enabled. If the DMA engine infrastructure becomes more widely
used, you may want to add an implementation for s390 using milicoded instructions
like xor-string or copy-page.

> diff -urpN linux-2.6/drivers/input/Kconfig linux-2.6-patched/drivers/input/Kconfig
> --- linux-2.6/drivers/input/Kconfig	2007-02-04 19:44:54.000000000 +0100
> +++ linux-2.6-patched/drivers/input/Kconfig	2007-04-19 15:49:55.000000000 +0200
> @@ -3,6 +3,7 @@
>  #
>  
>  menu "Input device support"
> +	depends on !S390
>  
>  config INPUT
>  	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EMBEDDED

Probably leave this as !S390. One could imagine channel-attached input devices
or the idea of intepreting a terminal as an input device, but no driver currently
does and probably never will.

> diff -urpN linux-2.6/drivers/isdn/Kconfig linux-2.6-patched/drivers/isdn/Kconfig
> --- linux-2.6/drivers/isdn/Kconfig	2007-02-04 19:44:54.000000000 +0100
> +++ linux-2.6-patched/drivers/isdn/Kconfig	2007-04-19 15:49:55.000000000 +0200
> @@ -3,6 +3,7 @@
>  #
>  
>  menu "ISDN subsystem"
> +	depends on !S390
>  
>  config ISDN
>  	tristate "ISDN support"

Same here, actually there was an IBM 2216 ISDN adapter with channel attachment,
but I don't think anybody wants to add a driver for that one.

> diff -urpN linux-2.6/drivers/misc/Kconfig linux-2.6-patched/drivers/misc/Kconfig
> --- linux-2.6/drivers/misc/Kconfig	2007-04-19 15:24:35.000000000 +0200
> +++ linux-2.6-patched/drivers/misc/Kconfig	2007-04-19 15:49:55.000000000 +0200
> @@ -3,6 +3,7 @@
>  #
>  
>  menu "Misc devices"
> +	depends on !S390
>  
>  config IBM_ASM
>  	tristate "Device driver for IBM RSA service processor"

Maybe just leave the menu open, all drivers in it are already depending on PCI
or similar and someone might add a driver that does work on s390 here.

> diff -urpN linux-2.6/drivers/net/phy/Kconfig linux-2.6-patched/drivers/net/phy/Kconfig
> --- linux-2.6/drivers/net/phy/Kconfig	2007-02-04 19:44:54.000000000 +0100
> +++ linux-2.6-patched/drivers/net/phy/Kconfig	2007-04-19 15:49:55.000000000 +0200
> @@ -3,6 +3,7 @@
>  #
>  
>  menu "PHY device support"
> +	depends on !S390
>  
>  config PHYLIB
>  	tristate "PHY Device support and infrastructure"

Also depends on !S390, not MMIO. A future network adapter might give you access
to the phy device through other means than MMIO.

> diff -urpN linux-2.6/drivers/rtc/Kconfig linux-2.6-patched/drivers/rtc/Kconfig
> --- linux-2.6/drivers/rtc/Kconfig	2007-04-19 15:24:39.000000000 +0200
> +++ linux-2.6-patched/drivers/rtc/Kconfig	2007-04-19 15:49:55.000000000 +0200
> @@ -3,6 +3,7 @@
>  #
>  
>  menu "Real Time Clock"
> +	depends on !S390
>  
>  config RTC_LIB
>  	tristate

Applications might actually want to use the RTC interface to access the system time
or get accurate timers, but the rtc drivers are all very dependant on either MMIO
or I2C. Not sure what would be best here.

	Arnd <><
