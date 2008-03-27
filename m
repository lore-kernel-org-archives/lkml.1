Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbYC0KBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbYC0KBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYC0KBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:01:42 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:52819 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYC0KBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:01:41 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [patch for 2.6.25? 3/3] skge napi->poll() locking bug
Date: Thu, 27 Mar 2008 12:03:17 +0200
User-Agent: KMail/1.9.7
References: <200803270745.m2R7jEUA024166@imap1.linux-foundation.org>
In-Reply-To: <200803270745.m2R7jEUA024166@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271203.17947.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.3.2008, you wrote:
> From: Marin Mitov <mitov@issp.bas.bg>
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
As far as skge driver has not changed since 2.6.24, the
patch could be applied to the stable 2.6.24.5 release too.

Marin Mitov

> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> Acked-by: David S. Miller <davem@davemloft.net>
> Cc: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/skge.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/net/skge.c~skge-napi-poll-locking-bug drivers/net/skge.c
> --- a/drivers/net/skge.c~skge-napi-poll-locking-bug
> +++ a/drivers/net/skge.c
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
> _
> 


