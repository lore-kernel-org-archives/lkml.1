Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZIOAY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZIOAY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbZIOAY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:24:26 -0400
Received: from plane.gmane.org ([80.91.229.3]:57261 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbZIOAYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:24:25 -0400
X-Greylist: delayed 4015 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 20:24:25 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Fb/L+Fbcfncb1o/ODDTNVn02FpJHrCOt14WuGT+/sb8vaESVtjkW7qkzP3hTmI4LVq
         PUZ4Gbx4qzTQ6RGClbX0XI+XeN6XOZ3lqUNpMXKN+pQ9a/LnC4dp6RwNj1+XhQAxbUoh
         C7964n5UyE3B/BSNEF75fT1sXrepOKglUzVzw=
Message-ID: <4AAECEF4.9070200@gmail.com>
Date: Mon, 14 Sep 2009 17:17:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Frysinger 
	<public-vapier-aBrp7R+bbdUdnm+yROfE0A@plane.gmane.org>
CC: Marcel Holtmann 
	<public-marcel-kz+m5ild9QBg9hUCZPvPmw@plane.gmane.org>,
       public-linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
       Michael Hennerich 
	<public-michael.hennerich-OyLXuOCK7orQT0dZR+AlfA@plane.gmane.org>
Subject: Re: [PATCH] Revert "[Bluetooth] Eliminate checks for impossible conditions
 in IRQ handler"
References: <1252905504-26666-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1252905504-26666-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/13/2009 11:18 PM, Mike Frysinger wrote:
> Commit ac019360fe3 changed the irq handler logic to BUG_ON rather than
> returning IRQ_NONE when the incoming argument is invalid.  While this
> works in most cases, it doesn't work when the IRQ is shared with other
> devices (or when DEBUG_SHIRQ is enabled).

Something doesn't add up here. It shouldn't be possible for the incoming 
argument to be invalid. I'd think that if it is it means that the IRQ 
handler is being registered too soon, before the data structures it 
requires are set up fully. If that's the case, reverting the change just 
partially papers over the bug.

>
> So revert the previous change and replace the warning message with a
> comment.
>
> Signed-off-by: Michael Hennerich<michael.hennerich-OyLXuOCK7orQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mike Frysinger<vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
> ---
>   drivers/bluetooth/bluecard_cs.c |    4 +++-
>   drivers/bluetooth/bt3c_cs.c     |    4 +++-
>   drivers/bluetooth/btuart_cs.c   |    4 +++-
>   drivers/bluetooth/dtl1_cs.c     |    4 +++-
>   4 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
> index b0e569b..a3a8f4d 100644
> --- a/drivers/bluetooth/bluecard_cs.c
> +++ b/drivers/bluetooth/bluecard_cs.c
> @@ -503,7 +503,9 @@ static irqreturn_t bluecard_interrupt(int irq, void *dev_inst)
>   	unsigned int iobase;
>   	unsigned char reg;
>
> -	BUG_ON(!info->hdev);
> +	if (!info || !info->hdev)
> +		/* our irq handler is shared */
> +		return IRQ_NONE;
>
>   	if (!test_bit(CARD_READY,&(info->hw_state)))
>   		return IRQ_HANDLED;
> diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
> index d58e22b..9a7578e 100644
> --- a/drivers/bluetooth/bt3c_cs.c
> +++ b/drivers/bluetooth/bt3c_cs.c
> @@ -345,7 +345,9 @@ static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
>   	int iir;
>   	irqreturn_t r = IRQ_NONE;
>
> -	BUG_ON(!info->hdev);
> +	if (!info || !info->hdev)
> +		/* our irq handler is shared */
> +		return IRQ_NONE;
>
>   	iobase = info->p_dev->io.BasePort1;
>
> diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
> index efd689a..cd9cb6c 100644
> --- a/drivers/bluetooth/btuart_cs.c
> +++ b/drivers/bluetooth/btuart_cs.c
> @@ -295,7 +295,9 @@ static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
>   	int iir, lsr;
>   	irqreturn_t r = IRQ_NONE;
>
> -	BUG_ON(!info->hdev);
> +	if (!info || !info->hdev)
> +		/* our irq handler is shared */
> +		return IRQ_NONE;
>
>   	iobase = info->p_dev->io.BasePort1;
>
> diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
> index 2cc7b32..588678a 100644
> --- a/drivers/bluetooth/dtl1_cs.c
> +++ b/drivers/bluetooth/dtl1_cs.c
> @@ -299,7 +299,9 @@ static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
>   	int iir, lsr;
>   	irqreturn_t r = IRQ_NONE;
>
> -	BUG_ON(!info->hdev);
> +	if (!info || !info->hdev)
> +		/* our irq handler is shared */
> +		return IRQ_NONE;
>
>   	iobase = info->p_dev->io.BasePort1;
>


