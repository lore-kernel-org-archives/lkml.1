Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZHFU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZHFU61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbZHFU60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:58:26 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:64667 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbZHFU6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:58:25 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXJ75kzGpLGTzXI=
X-RZG-CLASS-ID: mo00
Message-ID: <4A7B43EE.8050601@hartkopp.net>
Date: Thu, 06 Aug 2009 22:58:22 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: socketcan-users@lists.berlios.de,
       Michael Olbrich <m.olbrich@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [Socketcan-users] [PATCH] CAN: make checking in can_rcv less
 restrictive
References: <1249572295-7801-1-git-send-email-l.fu@pengutronix.de> <4A7B0957.5020808@hartkopp.net> <20090806201740.GA7067@pengutronix.de>
In-Reply-To: <20090806201740.GA7067@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luotao Fu wrote:
> Hi Oliver,
> 

>>> -	BUG_ON(skb->len != sizeof(struct can_frame) || cf->can_dlc > 8);
>>> +	WARN_ON(skb->len != sizeof(struct can_frame) || cf->can_dlc > 8);
>>>  
>>>  	/* update statistics */
>>>  	can_stats.rx_frames++;
>> NAK.
>>
>> The CAN applications can rely on getting proper CAN frames with this check. It
>> was introduced some time ago together with several other sanity checks - even
>> on the TX path.
>>
>> The CAN core *only* consumes skbuffs originated from a CAN netdevice
>> (ARPHRD_CAN).
> 
> I don't quite get it. The problem here is a broken can message sent to
> the device can bring down the kernel.

I assume you mean from the wire via the controller to the Kernel here, right?

> 
>> When this BUG() triggers, someone provided a definitely broken *CAN* network
>> driver, and this needsfp to be fixed on that level. 
> 
> In our case a sender (a FPGA) generates correct can frames carrying
> wrong dlc length.

Which is therefore *NOT* a correct CAN frame.

> This way the can driver on our side runs into the bug
> though the driver itself is allright.

Whatever there is on the bus or whatever your CAN controller provides in it's
dlc value: You need to ensure that the dlc is 0..8 before you push it into the
skbuff and call netif_rx(). Everything else *is* broken and not CAN conform.

> The opposite needed to be fixed,
> not our side.

Sure but it's your turn to be robust against obviously wrongs stuff, that's
provided by your (obviously sloppy) CAN controller.

>  Though we do suffer a system crash only because the
> sender sends trash into the can network. This is imo quite bad.

No. You suffer because you allow the trash to climb up into the system.

Anyway i really wonder that there is a CAN controller that provides you
information in its registers that describe a non conform CAN frame.

This discussion shows that using BUG() was the correct approach :-)

Fix your driver and do not allow to pass broken stuff into the system.

Cheers,
Oliver
