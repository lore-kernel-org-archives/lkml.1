Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZGUPWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZGUPWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZGUPWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:22:54 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:52811 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbZGUPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:22:53 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 11:22:53 EDT
Date: Wed, 22 Jul 2009 01:14:36 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move macsonic's probe function to .devinit.text
In-Reply-To: <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.OSX.2.00.0907220032230.796@silk.local>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-11-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-12-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-13-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-14-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-15-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-16-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-17-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Jul 2009, Uwe Kleine-K?nig wrote:

> A pointer to mac_sonic_probe is passed to the core via 
> platform_driver_register and so the function must not disappear when the 
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y) 
> unbinding and binding a device to the driver via sysfs will result in an 
> oops as does a device being registered late.

This patch works for me (tested on a Quadra 630). I still get an oops on 
rmmod, but that's a separate issue. I'll send a patch for that.

Finn

>
> Various other functions that are called by mac_sonic_probe need to move 
> to .devinit.text, too.
>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>
> Signed-off-by: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> drivers/net/macsonic.c |   14 +++++++-------
> 1 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/macsonic.c b/drivers/net/macsonic.c
> index acd143d..8f492c7 100644
> --- a/drivers/net/macsonic.c
> +++ b/drivers/net/macsonic.c
> @@ -179,7 +179,7 @@ static const struct net_device_ops macsonic_netdev_ops = {
> 	.ndo_set_mac_address	= eth_mac_addr,
> };
>
> -static int __init macsonic_init(struct net_device *dev)
> +static int __devinit macsonic_init(struct net_device *dev)
> {
> 	struct sonic_local* lp = netdev_priv(dev);
>
> @@ -223,7 +223,7 @@ static int __init macsonic_init(struct net_device *dev)
> 	return 0;
> }
>
> -static int __init mac_onboard_sonic_ethernet_addr(struct net_device *dev)
> +static int __devinit mac_onboard_sonic_ethernet_addr(struct net_device *dev)
> {
> 	struct sonic_local *lp = netdev_priv(dev);
> 	const int prom_addr = ONBOARD_SONIC_PROM_BASE;
> @@ -288,7 +288,7 @@ static int __init mac_onboard_sonic_ethernet_addr(struct net_device *dev)
> 	} else return 0;
> }
>
> -static int __init mac_onboard_sonic_probe(struct net_device *dev)
> +static int __devinit mac_onboard_sonic_probe(struct net_device *dev)
> {
> 	/* Bwahahaha */
> 	static int once_is_more_than_enough;
> @@ -409,7 +409,7 @@ static int __init mac_onboard_sonic_probe(struct net_device *dev)
> 	return macsonic_init(dev);
> }
>
> -static int __init mac_nubus_sonic_ethernet_addr(struct net_device *dev,
> +static int __devinit mac_nubus_sonic_ethernet_addr(struct net_device *dev,
> 						unsigned long prom_addr,
> 						int id)
> {
> @@ -424,7 +424,7 @@ static int __init mac_nubus_sonic_ethernet_addr(struct net_device *dev,
> 	return 0;
> }
>
> -static int __init macsonic_ident(struct nubus_dev *ndev)
> +static int __devinit macsonic_ident(struct nubus_dev *ndev)
> {
> 	if (ndev->dr_hw == NUBUS_DRHW_ASANTE_LC &&
> 	    ndev->dr_sw == NUBUS_DRSW_SONIC_LC)
> @@ -449,7 +449,7 @@ static int __init macsonic_ident(struct nubus_dev *ndev)
> 	return -1;
> }
>
> -static int __init mac_nubus_sonic_probe(struct net_device *dev)
> +static int __devinit mac_nubus_sonic_probe(struct net_device *dev)
> {
> 	static int slots;
> 	struct nubus_dev* ndev = NULL;
> @@ -562,7 +562,7 @@ static int __init mac_nubus_sonic_probe(struct net_device *dev)
> 	return macsonic_init(dev);
> }
>
> -static int __init mac_sonic_probe(struct platform_device *pdev)
> +static int __devinit mac_sonic_probe(struct platform_device *pdev)
> {
> 	struct net_device *dev;
> 	struct sonic_local *lp;
>
