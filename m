Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbYHDClk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbYHDClk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYHDCl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:41:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:54517 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbYHDCl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:41:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,302,1215414000"; 
   d="scan'208";a="29222566"
Subject: Re: [PATCH 4/7] drivers/net/wireless/ipw2100.c: Release mutex in
	error handling code
From: Zhu Yi <yi.zhu@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: jketreno@linux.intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807210957490.24625@ask.diku.dk>
References: <Pine.LNX.4.64.0807210957490.24625@ask.diku.dk>
Content-Type: text/plain
Organization: Intel Corp.
Date: Mon, 04 Aug 2008 10:41:18 +0800
Message-Id: <1217817678.3107.11.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 09:58 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The mutex is released on a successful return, so it would seem that it
> should be released on an error return as well.

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

> The semantic patch finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression l;
> @@
> 
> mutex_lock(l);
> ... when != mutex_unlock(l)
>     when any
>     when strict
> (
> if (...) { ... when != mutex_unlock(l)
> +   mutex_unlock(l);
>     return ...;
> }
> |
> mutex_unlock(l);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> diff -u -p a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
> --- a/drivers/net/wireless/ipw2100.c
> +++ b/drivers/net/wireless/ipw2100.c
> @@ -6442,6 +6442,7 @@ static int ipw2100_resume(struct pci_dev
>  	if (err) {
>  		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
>  		       dev->name);
> +		mutex_unlock(&priv->action_mutex);
>  		return err;
>  	}
>  	pci_restore_state(pci_dev);
> @@ -7146,7 +7147,7 @@ static int ipw2100_wx_get_rate(struct ne
>  	err = ipw2100_get_ordinal(priv, IPW_ORD_CURRENT_TX_RATE, &val, &len);
>  	if (err) {
>  		IPW_DEBUG_WX("failed querying ordinals.\n");
> -		return err;
> +		goto done;
>  	}
>  
>  	switch (val & TX_RATE_MASK) {

