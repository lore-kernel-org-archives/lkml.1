Return-Path: <linux-kernel-owner+w=401wt.eu-S1945994AbXBVMZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945994AbXBVMZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945985AbXBVMZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:25:24 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:21064 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945979AbXBVMZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:25:23 -0500
Message-ID: <45DD8B83.5040604@chelsio.com>
Date: Thu, 22 Feb 2007 04:24:35 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: shemminger@osdl.org, benh@kernel.crashing.org, netdev@vger.kernel.org,
       ebs@ebshome.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC] split NAPI from network device.
References: <20061213113537.6baf410f@dxpl.pdx.osdl.net>	<1166042552.11914.188.camel@localhost.localdomain>	<20061213154635.1f284bf6@dxpl.pdx.osdl.net> <20070220.213125.74747066.davem@davemloft.net>
In-Reply-To: <20070220.213125.74747066.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2007 12:24:39.0070 (UTC) FILETIME=[6BF80BE0:01C7567C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
>
> @@ -919,10 +920,7 @@ int dev_close(struct net_device *dev)
>  	 * engine, but this requires more changes in devices. */
>  
>  	smp_mb__after_clear_bit(); /* Commit netif_running(). */
> -	while (test_bit(__LINK_STATE_RX_SCHED, &dev->state)) {
> -		/* No hurry. */
> -		msleep(1);
> -	}
> +	netif_poll_disable(dev);
When dev_close() exits, NAPI_STATE_SCHED will be set,
whereas __LINK_STATE_RX_SCHED was previously reset.
The cxgb3 driver assumes that the device is not scheduled after the 
interface was brought up.
It's no longer true if the interface is brought up, brought down, and 
then brought up.
Should cxgb3 explicitly call napi_enable() on the open() path ?

Cheers,
Divy
