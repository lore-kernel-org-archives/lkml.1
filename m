Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZEMLhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZEMLhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZEMLhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:37:21 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59775 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZEMLhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:37:20 -0400
X-Auth-Info: 8aNApHGJ5rncRXupRpgix3ByKR0YKiL9Yy4k9E0Apd4=
Message-ID: <4A0AB0EC.5010902@grandegger.com>
Date: Wed, 13 May 2009 13:37:16 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Subject: Re: [PATCH v2 3/7] [PATCH 3/8] can: CAN Network device driver and
 Netlink interface
References: <20090512092757.048938233@denx.de>	<20090512092757.574693100@denx.de>	<20090512233052.ecd600f1.akpm@linux-foundation.org> <20090512235323.e3de5e5d.akpm@linux-foundation.org>
In-Reply-To: <20090512235323.e3de5e5d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 12 May 2009 23:30:52 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Tue, 12 May 2009 11:28:00 +0200 Wolfgang Grandegger <wg@grandegger.com> wrote:
>>
>>> +int can_restart_now(struct net_device *dev)
>>> +{
>>> +	struct can_priv *priv = netdev_priv(dev);
>>> +	struct net_device_stats *stats = &dev->stats;
>>> +	struct sk_buff *skb;
>>> +	struct can_frame *cf;
>>> +	int err;
>>> +
>>> +	/* Synchronize with dev->hard_start_xmit() */
>>> +	netif_tx_lock(dev);
>>> +
>>> +	/* Ensure that no more messages can go out */
>>> +	if (netif_carrier_ok(dev))
>>> +		netif_carrier_off(dev);
>>> +
>>> +	/* Ensure that no more messages can come in */
>>> +	err = priv->do_set_mode(dev, CAN_MODE_STOP);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	/*  Now it's save to clean up */
>>> +	del_timer_sync(&priv->restart_timer);
>> This is deadlockable.
>>
>> It calls del_timer_sync() while holding netif_tx_lock().  But the timer
>> handler (can_restart_now()) also takes netif_tx_lock().  So if the
>> timer handler is presently running, it's sitting there spinning in
>> netif_tx_lock().  And del_timer_sync() is sitting there waiting for the
>> timer handler to complete.

Oops, I have obviously overlook that.

> Also, I wonder if it's safe to take netif_tx_lock() from a timer
> handler when other parts of the code might be taking it from process
> context (I didn't check).
> 
> lockdep should be able to detect this, and I trust this code has been
> fully runtime tested with lockdep enabled?

Well, CONFIG_PROVE_LOCKING would be cool, but I'm unable to enabled it
for my MPC5200 test system. Only 64bit PowerPC's seem to support
TRACE_IRQFLAGS_SUPPORT. I'm going to test the code on a PC as well.

Thanks,

Wolfgang.
