Return-Path: <linux-kernel-owner+w=401wt.eu-S1762617AbXE1WfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762617AbXE1WfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXE1WfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:35:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48864 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXE1WfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:35:09 -0400
Message-ID: <465B591B.1010507@garzik.org>
Date: Mon, 28 May 2007 18:35:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/7] cxgb3 - fix netpoll hanlder
References: <20070526225952.12115.30971.stgit@localhost.localdomain>
In-Reply-To: <20070526225952.12115.30971.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Fix netpoll handler to work with line interrupt, msi and msi-x.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_main.c |   12 +++++++++---
>  drivers/net/cxgb3/sge.c        |    1 -
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
> index 67b4b21..e0ef724 100644
> --- a/drivers/net/cxgb3/cxgb3_main.c
> +++ b/drivers/net/cxgb3/cxgb3_main.c
> @@ -2076,10 +2076,16 @@ static void vlan_rx_kill_vid(struct net_
>  static void cxgb_netpoll(struct net_device *dev)
>  {
>  	struct adapter *adapter = dev->priv;
> -	struct sge_qset *qs = dev2qset(dev);
> +	struct port_info *pi = netdev_priv(dev);
> +	int qidx;
>  
> -	t3_intr_handler(adapter, qs->rspq.polling) (adapter->pdev->irq,
> -						    adapter);
> +	for (qidx = pi->first_qset; qidx < pi->first_qset + pi->nqsets; qidx++) {
> +		struct sge_qset *qs = &adapter->sge.qs[qidx];
> +		
> +		t3_intr_handler(adapter, qs->rspq.polling) (0, 
> +					(adapter->flags & USING_MSIX) ?
> +					(void *)qs : (void *)adapter);

Remove needless casts to void*


