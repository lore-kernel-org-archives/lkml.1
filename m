Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZFHO17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZFHO17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZFHO1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:27:49 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:41138 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZFHO1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:27:48 -0400
Message-ID: <4A2D1FE4.5030100@gmail.com>
Date: Mon, 08 Jun 2009 16:27:48 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [Security, resend] Instant crash with rtl8169 and large packets
References: <4A2D1147.8020101@msgid.tls.msk.ru>
In-Reply-To: <4A2D1147.8020101@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 08 Jun 2009 16:27:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev a écrit :
> [Please excuse me for the resend, --
>  picked the wrong address for netdev again]
> 
> Hello.
> 
> This is a resend (sort of) of several months old email.
> Previous email about this issue has been mostly ignored.
> 
> The situation is very simple: with an RTL8169 (probably
> onboard) GigE card which, by default, is configured to
> have MTU (maximal transmission unit) to be 1500 bytes,
> it's *trivial* to instantly crash the machine by sending
> it a *single* packet of size >1500 bytes (provided the
> network switch can handle jumbo frames).
> 
> I verified with on several different machines - all I were
> able to find with this card - and all behaves exactly the
> same.
> 
> When sending a packet of size, say, 3000 bytes (ping -s 3000)
> from another machine to a machine running rtl8169 with no
> MTU configured, kernel OOPSes.
> 
> I captured one such OOPS (unfortunately without the first
> line few lines) here:
> 
>  http://www.corpit.ru/mjt/r8169-mtu-oops.jpg
> 
> (since the network goes boom at that time, no network console
> is working).
> 
> But for anyone familiar with the driver's internals it
> should be easy to figure the issue out.
> 
> This is, in my opinion, quite a serious issue.  And I've no
> idea why it is being ignored for several months.

I suppose you use a recent kernel ?

Could you please try following patch ?

Thank you

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index e94316b..c08b97a 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3468,7 +3468,7 @@ static int rtl8169_rx_interrupt(struct net_device *dev,
 
 		if (status & DescOwn)
 			break;
-		if (unlikely(status & RxRES)) {
+		if (unlikely(status & (RxRES | RxRWT | RxRUNT | RxCRC | RxFOVF))) {
 			if (netif_msg_rx_err(tp)) {
 				printk(KERN_INFO
 				       "%s: Rx ERROR. status = %08x\n",

