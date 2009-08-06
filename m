Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZHFQs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZHFQs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZHFQs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:48:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:12313 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZHFQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:48:27 -0400
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuYLJjI9PtQ=
X-RZG-CLASS-ID: mo00
Message-ID: <4A7B0957.5020808@hartkopp.net>
Date: Thu, 06 Aug 2009 18:48:23 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: socketcan-users@lists.berlios.de,
       Michael Olbrich <m.olbrich@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [Socketcan-users] [PATCH] CAN: make checking in can_rcv less
 restrictive
References: <1249572295-7801-1-git-send-email-l.fu@pengutronix.de>
In-Reply-To: <1249572295-7801-1-git-send-email-l.fu@pengutronix.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luotao Fu wrote:
> From: Michael Olbrich <m.olbrich@pengutronix.de>
> 
> Checking for can frame format in can_rcv() is too restrictive. BUG_ON is way too
> heavy for the case that the can interface probably received a can frame with
> malicious format. Further it can be used for DDOS attack since BUG_ON can lead
> to kernel panic. Hence we turn this to WARN_ON instead.
> 
> Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> ---
>  net/can/af_can.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index e733725..e6dcf4b 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -656,7 +656,7 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
>  		return 0;
>  	}
>  
> -	BUG_ON(skb->len != sizeof(struct can_frame) || cf->can_dlc > 8);
> +	WARN_ON(skb->len != sizeof(struct can_frame) || cf->can_dlc > 8);
>  
>  	/* update statistics */
>  	can_stats.rx_frames++;

NAK.

The CAN applications can rely on getting proper CAN frames with this check. It
was introduced some time ago together with several other sanity checks - even
on the TX path.

The CAN core *only* consumes skbuffs originated from a CAN netdevice
(ARPHRD_CAN).

When this BUG() triggers, someone provided a definitely broken *CAN* network
driver, and this needs to be fixed on that level. It is really not that
problematic to ensure proper CAN frames on driver level ... this sanity check
should not be needed to be performed by every single application.

Btw. the SocketCAN core ML and probably the netdev ML are the better places to
post CAN specific stuff the first time.

Regards,
Oliver

ps. If you have a use-case to make a DDOS via CAN bus - please let me know.
I'm always interested doing strange things on CAN ;-)
