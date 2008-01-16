Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYAPJCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYAPJCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYAPJCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:02:39 -0500
Received: from mail.bigtelecom.ru ([87.255.0.61]:33827 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYAPJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:02:37 -0500
Message-ID: <478DC824.4030600@bigtelecom.ru>
Date: Wed, 16 Jan 2008 12:02:28 +0300
From: Badalian Vyacheslav <slavon@bigtelecom.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071129)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: elendil@planet.nl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
References: <200801150625.10823.elendil@planet.nl> <20080114.215317.38045859.davem@davemloft.net>
In-Reply-To: <20080114.215317.38045859.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to 2.6.24-rc7-git2
Have messages
Also have regression after apply patch.
System may do above 800mbs traffic before patch. After its "exit polling 
mode?" (4 CPU, 1 cpu get 100% si (process ksoftirqd/0), 3 CPU is IDLE)
After patch system was go to "exit polling mode" at above 600mbs.

Thanks.

> From: Frans Pop <elendil@planet.nl>
> Date: Tue, 15 Jan 2008 06:25:10 +0100
>
>   
>> kernel: e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>>     
>
> Does this make the problem go away?
>
> (Note this isn't the final correct patch we should apply.  There
>  is no reason why this revert back to the older ->poll() logic
>  here should have any effect on the TX hang triggering...)
>
> diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> index 13d57b0..cada32c 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -3919,7 +3919,7 @@ e1000_clean(struct napi_struct *napi, int budget)
>  {
>  	struct e1000_adapter *adapter = container_of(napi, struct e1000_adapter, napi);
>  	struct net_device *poll_dev = adapter->netdev;
> -	int work_done = 0;
> +	int tx_work = 0, work_done = 0;
>  
>  	/* Must NOT use netdev_priv macro here. */
>  	adapter = poll_dev->priv;
> @@ -3929,8 +3929,8 @@ e1000_clean(struct napi_struct *napi, int budget)
>  	 * simultaneously.  A failure obtaining the lock means
>  	 * tx_ring[0] is currently being cleaned anyway. */
>  	if (spin_trylock(&adapter->tx_queue_lock)) {
> -		e1000_clean_tx_irq(adapter,
> -				   &adapter->tx_ring[0]);
> +		tx_work = e1000_clean_tx_irq(adapter,
> +					     &adapter->tx_ring[0]);
>  		spin_unlock(&adapter->tx_queue_lock);
>  	}
>  
> @@ -3938,7 +3938,7 @@ e1000_clean(struct napi_struct *napi, int budget)
>  	                  &work_done, budget);
>  
>  	/* If budget not fully consumed, exit the polling mode */
> -	if (work_done < budget) {
> +	if (!tx_work && (work_done < budget)) {
>  		if (likely(adapter->itr_setting & 3))
>  			e1000_set_itr(adapter);
>  		netif_rx_complete(poll_dev, napi);
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

