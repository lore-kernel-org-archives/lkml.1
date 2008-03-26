Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYCZDVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYCZDVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYCZDUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:20:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43440 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbYCZDUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:20:44 -0400
Message-ID: <47E9C10A.9020007@pobox.com>
Date: Tue, 25 Mar 2008 23:20:42 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Marin Mitov <mitov@issp.bas.bg>
CC: linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH]skge napi->poll() locking bug
References: <200803231020.10030.mitov@issp.bas.bg>
In-Reply-To: <200803231020.10030.mitov@issp.bas.bg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marin Mitov wrote:
> Hi all,
> 
> According to: Documentation/networking/netdevices.txt:
> 
> <cite>
> napi->poll:
> ..........
> 	Context: softirq
> 	         will be called with interrupts disabled by netconsole.
> </cite>
> 
> napi->poll() could be called either with interrupts enabled 
> (in softirq context) or disabled (by netconsole), so the irq flag
> should be preserved.
> 
> Inspired by Ingo's resent forcedeth patch :-)
> 
> Regards
> 
> Marin Mitov
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> ===============================
> --- a/drivers/net/skge.c	2008-03-23 09:06:13.000000000 +0200
> +++ b/drivers/net/skge.c	2008-03-23 09:24:47.000000000 +0200
> @@ -3199,12 +3199,14 @@ static int skge_poll(struct napi_struct 
>  	skge_write8(hw, Q_ADDR(rxqaddr[skge->port], Q_CSR), CSR_START);
>  
>  	if (work_done < to_do) {
> -		spin_lock_irq(&hw->hw_lock);
> +		unsigned long flags;
> +		
> +		spin_lock_irqsave(&hw->hw_lock, flags);
>  		__netif_rx_complete(dev, napi);
>  		hw->intr_mask |= napimask[skge->port];
>  		skge_write32(hw, B0_IMSK, hw->intr_mask);
>  		skge_read32(hw, B0_IMSK);
> -		spin_unlock_irq(&hw->hw_lock);
> +		spin_unlock_irqrestore(&hw->hw_lock, flags);
>  	}
>  
>  	return work_done;
> 
> 
> --

applied


