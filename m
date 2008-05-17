Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbYEQUe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbYEQUe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbYEQUeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:34:19 -0400
Received: from nuova-ex1.nuovasystems.com ([67.91.200.196]:6459 "EHLO
	nuova-ex1.nuovasystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbYEQUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:34:18 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 16:34:18 EDT
Message-ID: <482F3DF6.7080403@nuovasystems.com>
Date: Sat, 17 May 2008 13:20:06 -0700
From: Joe Eykholt <jre@nuovasystems.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Nicolas 2P <nicolas.2p.debian@free.fr>
CC: Jay Vosburgh <fubar@us.ibm.com>, David Miller <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch]  bondig - arp_interval with low value => Oops.
References: <482C9E73.2040202@free.fr>
In-Reply-To: <482C9E73.2040202@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 May 2008 20:20:09.0380 (UTC) FILETIME=[673F5E40:01C8B85B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas 2P wrote:
> When setting arp_interval parameter to a very low value, delta_in_ticks 
> for next arp might become 0, causing an infinite loop.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=10680
> 
> Same problem for miimon parameter already fixed, but fix might be 
> enhanced, by using msecs_to_jiffies() function.
> 
> Signed-off-by: Nicolas de Pesloüan <nicolas.2p.debian@free.fr>
> 
> --- /usr/src/linux/drivers/net/bonding/bond_main_orig.c 2008-05-13 
> 02:00:01.000000000 +0200
> +++ /usr/src/linux/drivers/net/bonding/bond_main.c      2008-05-14 
> 14:55:53.000000000 +0200
> @@ -2391,7 +2391,7 @@
>                 read_lock(&bond->lock);
>         }
> 
> -       delay = ((bond->params.miimon * HZ) / 1000) ? : 1;
> +       delay = msecs_to_jiffies(bond->params.miimon);
>         read_unlock(&bond->lock);
>         queue_delayed_work(bond->wq, &bond->mii_work, delay);
>  }
> @@ -2704,7 +2704,7 @@
> 
>         read_lock(&bond->lock);
> 
> -       delta_in_ticks = (bond->params.arp_interval * HZ) / 1000;
> +       delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval);
> 
>         if (bond->kill_timers) {
>                 goto out;
> @@ -2837,7 +2837,7 @@
> 
>         read_lock(&bond->lock);
> 
> -       delta_in_ticks = (bond->params.arp_interval * HZ) / 1000;
> +       delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval * HZ);

This seems like it should be just:

	delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval);

Assuming the interval is in milliseconds, based on the previous usage.
Since it's multiplying by HZ (ticks per second) and dividing by 1000 
(milliseconds per second), it was converting from milliseconds to ticks.

Same for the other changes?

	Joe
