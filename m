Return-Path: <linux-kernel-owner+w=401wt.eu-S1764494AbYJJVfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764494AbYJJVfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760626AbYJJVf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:35:29 -0400
Received: from ppp-111-109.adsl.restena.lu ([158.64.111.109]:40273 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763468AbYJJVf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:35:28 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 17:35:27 EDT
Date: Fri, 10 Oct 2008 23:27:24 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Alex Bennee" <kernel-hacker@bennee.com>
Cc: linux-kernel@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: rtl8169_get_stats seems to be adding random crap to
 rx_missed_errors count
Message-ID: <20081010232724.1447f915@neptune.home>
In-Reply-To: <b2cdc9f30810100953i680c2d02s8352bb109d494bf1@mail.gmail.com>
References: <b2cdc9f30810100947s699dbc76ia72023b08e064816@mail.gmail.com>
	<b2cdc9f30810100953i680c2d02s8352bb109d494bf1@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

This issue has already been reported in
  http://lkml.org/lkml/2008/10/9/235
and a patch exists.

Could you verify that patch #0009 at URL below fixes the issue for you:
  http://userweb.kernel.org/~romieu/r8169/2.6.27-rc9/20081007/


Bruno


On Fri, 10 October 2008 "Alex Bennee" <kernel-hacker@bennee.com> wrote:
> Hi,
> 
> I've been seeing odd behaviour in the ifconfig output for my rtl8169
> based network device. The ifconfig output had a very high number of
> dropped packets in the display which changed massively every time I
> checked. I tracked it down to /proc/net/dev and the a few test patches
> it seems the rc_missed field is the culprit. I did a test patch of the
> form:
> 
> +++ b/drivers/net/r8169.c
> @@ -3062,10 +3062,16 @@ static struct net_device_stats
> *rtl8169_get_stats(struct net_device *dev)
>        unsigned long flags;
> 
>        if (netif_running(dev)) {
> +               u32 missed;
>                spin_lock_irqsave(&tp->lock, flags);
> -               dev->stats.rx_missed_errors += RTL_R32(RxMissed);
> +               missed = RTL_R32(RxMissed);
>                RTL_W32(RxMissed, 0);
>                spin_unlock_irqrestore(&tp->lock, flags);
> +
> +               dev->stats.rx_missed_errors += missed;
> +               if (missed)
> +                       printk(KERN_INFO "rtl8169_get_stats added %d
> to missed count\n", missed);
> +
>        }
> 
>        return &dev->stats;
> 
> And low and behold I see this behaviour:
> 
> [  946.160188] rtl8169_get_stats added 250834943 to missed count
> [  946.160354] rtl8169_get_stats added 20768 to missed count
> [  946.160411] rtl8169_get_stats added 7032 to missed count
> [  946.160425] rtl8169_get_stats added 1677 to missed count
> [  946.160439] rtl8169_get_stats added 1577 to missed count
> [  946.160452] rtl8169_get_stats added 1543 to missed count
> [  946.160465] rtl8169_get_stats added 1517 to missed count
> [  946.160479] rtl8169_get_stats added 1572 to missed count
> [  946.160492] rtl8169_get_stats added 1586 to missed count
> [  946.160504] rtl8169_get_stats added 1284 to missed count
> [  948.164206] rtl8169_get_stats added 250864594 to missed count
> [  948.164374] rtl8169_get_stats added 21004 to missed count
> [  948.164434] rtl8169_get_stats added 7385 to missed count
> [  948.164447] rtl8169_get_stats added 1631 to missed count
> [  948.164461] rtl8169_get_stats added 1574 to missed count
> [  948.164475] rtl8169_get_stats added 1645 to missed count
> [  948.164489] rtl8169_get_stats added 1583 to missed count
> [  948.164503] rtl8169_get_stats added 1561 to missed count
> [  948.164523] rtl8169_get_stats added 2314 to missed count
> [  948.164534] rtl8169_get_stats added 1300 to missed count
> [  950.168182] rtl8169_get_stats added 250857857 to missed count
> [  950.168345] rtl8169_get_stats added 20465 to missed count
> [  950.168401] rtl8169_get_stats added 6903 to missed count
> [  950.168416] rtl8169_get_stats added 1711 to missed count
> [  950.168430] rtl8169_get_stats added 1585 to missed count
> [  950.168443] rtl8169_get_stats added 1532 to missed count
> [  950.168456] rtl8169_get_stats added 1520 to missed count
> [  950.168469] rtl8169_get_stats added 1539 to missed count
> [  950.168483] rtl8169_get_stats added 1588 to missed count
> [  950.168494] rtl8169_get_stats added 1282 to missed count
> 
> It looks very much like the number being read is a decreasing counter
> rather than anything else.
> 
> Has anyone got a copy of the data sheet and can confirm that:
> 
>        RxMissed        = 0x4c,
> 
> is the correct offset for the register and it doesn't need any special
> handling to be read?
> 
> 
> 
> 
> --
> Alex, homepage: http://www.bennee.com/~alex/
