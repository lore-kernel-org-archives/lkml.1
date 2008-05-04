Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYEDJd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYEDJd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYEDJdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:33:15 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:37192 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbYEDJdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:33:14 -0400
Date: Sun, 04 May 2008 11:33:12 +0200
Message-Id: <264300966@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, g4klx@g4klx.demon.co.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 24rc8: unregister_netdevice: waiting for ... to become free
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/8KkEJ6NrxwTGaadnCqK2YkWe1klsF0hn6s8a8kJEa2wQmx
 7sebeCaMenRu1QFAkG8aklUv7QE4q8/1zkV+FFAtaY87N9PYcU=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, does this fix your bug?

Yes! 
With this patch i can unload the nic driver again.
Thank you !



> -----Ursprüngliche Nachricht-----
> Von: "David Miller" <davem@davemloft.net>
> Gesendet: 04.05.08 06:11:32
> An: devzero@web.de
> CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, g4klx@g4klx.demon.co.uk
> Betreff: Re: 24rc8: unregister_netdevice: waiting for ... to become free


> From: David Miller <davem@davemloft.net>
> Date: Fri, 02 May 2008 05:45:36 -0700 (PDT)
> 
> > From: "Roland" <devzero@web.de>
> > Date: Fri, 2 May 2008 14:38:36 +0200
> > 
> > > it seems it`s lapbether driver
> > > 
> > > reproduce:
> > > 
> > > on system with pcnet32 (vmware) do
> > > 
> > > modprobe pcnet32
> > > modprobe lapbether
> > > modprobe -r lapbether
> > > modprobe -r pcnet32 -> hang -> unregister_netdevice: waiting for eth0 to 
> > > become free
> > 
> > lapbeth_cleanup_driver() unregisters the netdevice, but does not
> > release the reference to lapbeth->ethdev in those device instances.
> > 
> > Once this happens, and the lapbeth_dev_notifier is unregistered,
> > these references will leak forever.
> 
> Roland, does this fix your bug?
> 
> lapbeth: Release ->ethdev when unregistering device.
> 
> Otherwise it leaks forever.
> 
> Based upon a report by Roland <devzero@web.de>
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
> index b5860b9..24fd613 100644
> --- a/drivers/net/wan/lapbether.c
> +++ b/drivers/net/wan/lapbether.c
> @@ -459,6 +459,7 @@ static void __exit lapbeth_cleanup_driver(void)
>  	list_for_each_safe(entry, tmp, &lapbeth_devices) {
>  		lapbeth = list_entry(entry, struct lapbethdev, node);
>  
> +		dev_put(lapbeth->ethdev);
>  		unregister_netdevice(lapbeth->axdev);
>  	}
>  	rtnl_unlock();

Acked-by: Roland Kletzing <devzero@web.de>


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

