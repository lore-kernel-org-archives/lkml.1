Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXKGWbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXKGWbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXKGWbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:31:21 -0500
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:32570 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758193AbXKGWbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:31:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TeXCgEEVPYIZNCZaPVOrrRVXlusRnZzksca1LqKLuLWzaX1CKQLD/maSbZhCqZaAtMlEWSMv2BCZnZEbt7c3h0sU0LNNqIiQI0TV+2UWuaakcSbiJzU4YNDGd3ku6W45tOA5IYLAEcGJz14M+wOGIGZBGu8RQnnvtcq37CqrtG0=  ;
X-YMail-OSG: 1AeXmU0VM1lKsj2Y_Y6rcLFAlYT5Ev9soZu499RmVHejm8szFoXZaA5NNbuQ2IGm0GBUSujZXbgcg5c51Z6R44pS9KrttJt.LeMSkXNf0M5k5rosBxk-
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [2.6 patch] usbnet.c: check for the right MII variable
Date: Wed, 7 Nov 2007 14:31:15 -0800
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@kernel.org>,
       Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200711012024.57412.toralf.foerster@gmx.de> <200711011652.39601.david-b@pacbell.net> <20071102154615.GS30287@stusta.de>
In-Reply-To: <20071102154615.GS30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711071431.15525.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 November 2007, Adrian Bunk wrote:
> <--  snip  -->
> 
> 
> This patch fixes the following compile error with CONFIG_MII=m, 
> CONFIG_USB_USBNET=y, CONFIG_USB_USBNET_MII=n:

This is the patch I liked better, if there was going to be
one going upstream without additional test from me ... sorry,
the patch you appear to have accepted was the worst of the
three patches in flight.

> 
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `usbnet_set_settings':
> (.text+0xf1876): undefined reference to `mii_ethtool_sset'
> drivers/built-in.o: In function `usbnet_get_settings':
> (.text+0xf1836): undefined reference to `mii_ethtool_gset'
> drivers/built-in.o: In function `usbnet_get_link':
> (.text+0xf18d6): undefined reference to `mii_link_ok'
> drivers/built-in.o: In function `usbnet_nway_reset':
> (.text+0xf18f6): undefined reference to `mii_nway_restart'
> make: *** [.tmp_vmlinux1] Error 1
> 
> <--  snip  -->
> 
> This bug was introduced by commit 18ee91fa9815fa3bb4e51cdcb8229bd0a0f11a70
> and reported by Toralf Förster.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> BTW:
> The Kconfig part of this patch is not really required, but testing for
>   #if defined(CONFIG_USB_USBNET_MII) || defined(CONFIG_USB_USBNET_MII_MODULE)
> would look needlessly ugly.
> 
>  drivers/net/usb/Kconfig  |    5 ++---
>  drivers/net/usb/usbnet.c |    7 +++----
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> a421e4910eb30b140a315e274632e87c7a218df6 
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 5a96d74..9261371 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -94,12 +94,11 @@ config USB_RTL8150
>  	  module will be called rtl8150.
>  
>  config USB_USBNET_MII
> -	tristate
> -	default n
> +	bool
>  
>  config USB_USBNET
>  	tristate "Multi-purpose USB Networking Framework"
> -	select MII if USB_USBNET_MII != n
> +	select MII if USB_USBNET_MII
>  	---help---
>  	  This driver supports several kinds of network links over USB,
>  	  with "minidrivers" built around a common network driver core
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index acd5f1c..7393ab0 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -683,8 +683,7 @@ done_nopm:
>   * they'll probably want to use this base set.
>   */
>  
> -#if defined(CONFIG_MII) || defined(CONFIG_MII_MODULE)
> -#define HAVE_MII
> +#ifdef CONFIG_USB_USBNET_MII
>  
>  int usbnet_get_settings (struct net_device *net, struct ethtool_cmd *cmd)
>  {
> @@ -744,7 +743,7 @@ int usbnet_nway_reset(struct net_device *net)
>  }
>  EXPORT_SYMBOL_GPL(usbnet_nway_reset);
>  
> -#endif	/* HAVE_MII */
> +#endif	/*  CONFIG_USB_USBNET_MII  */
>  
>  void usbnet_get_drvinfo (struct net_device *net, struct ethtool_drvinfo *info)
>  {
> @@ -776,7 +775,7 @@ EXPORT_SYMBOL_GPL(usbnet_set_msglevel);
>  
>  /* drivers may override default ethtool_ops in their bind() routine */
>  static struct ethtool_ops usbnet_ethtool_ops = {
> -#ifdef	HAVE_MII
> +#ifdef CONFIG_USB_USBNET_MII
>  	.get_settings		= usbnet_get_settings,
>  	.set_settings		= usbnet_set_settings,
>  	.get_link		= usbnet_get_link,
> 


