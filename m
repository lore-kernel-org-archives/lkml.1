Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZCQUJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZCQUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZCQUJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:09:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38864 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbZCQUJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:09:43 -0400
Message-ID: <49C00381.8050207@garzik.org>
Date: Tue, 17 Mar 2009 16:09:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
CC: linux-kernel@vger.kernel.org, NetDev <netdev@vger.kernel.org>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH] r8169: Fix irq masking in rtl8169_interrupt()
References: <200903171937.53401.fzu@wemgehoertderstaat.de>
In-Reply-To: <200903171937.53401.fzu@wemgehoertderstaat.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Wiese wrote:
> Only adjust the NAPI bits of the interruptmask, if netif_rx_schedule_prep()
> returns true.
> Without this, I see interrupt storms here using 2.6.29-rcx and 2.6.27.19 and
> device needed rmmod r8169 + modprobe r8169 to start working.
> 
> Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
> ---
>  drivers/net/r8169.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index b347340..0c943ba 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -3708,12 +3708,11 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>  		rtl8169_check_link_status(dev, tp, ioaddr);
>  
>  	if (status & tp->napi_event) {
> -		RTL_W16(IntrMask, tp->intr_event & ~tp->napi_event);
> -		tp->intr_mask = ~tp->napi_event;
> -
> -		if (likely(netif_rx_schedule_prep(&tp->napi)))
> +		if (likely(netif_rx_schedule_prep(&tp->napi))) {
> +			RTL_W16(IntrMask, tp->intr_event & ~tp->napi_event);
> +			tp->intr_mask = ~tp->napi_event;
>  			__netif_rx_schedule(&tp->napi);
> -		else if (netif_msg_intr(tp)) {
> +		} else if (netif_msg_intr(tp)) {
>  			printk(KERN_INFO "%s: interrupt %04x in poll\n",


FWIW, you should CC net driver patches to netdev@vger.kernel.org, so 
that they get tracked in patchworks and handled by the right people.

	Jeff


