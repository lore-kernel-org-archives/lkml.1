Return-Path: <linux-kernel-owner+w=401wt.eu-S1763809AbZLQB0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763809AbZLQB0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763706AbZLQBVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:11987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763686AbZLQBUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,409,1257148800"; 
   d="scan'208";a="476885617"
Subject: Re: [PATCH] iwmc3200wifi: Fix test of unsigned in
 iwm_ntf_stop_resume_tx()
From: Zhu Yi <yi.zhu@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, "Ortiz, Samuel" <samuel.ortiz@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B290462.7070401@gmail.com>
References: <4B28DBB6.5030304@gmail.com> <1260975195.2965.3.camel@ct>
	 <4B290462.7070401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 09:20:51 +0800
Message-ID: <1261012851.12157.551.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 00:01 +0800, Roel Kluin wrote:
> `queue' was unsigned so the test did not work.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
> >> -			if (queue < 0)
> >> +			if (queue == -EINVAL)
> > 
> > I think it's ugly.  iwm_tid_to_queue() should return int if it's allowed
> > to return error codes.
> 
> Ok, how about:
> 
>  drivers/net/wireless/iwmc3200wifi/iwm.h    |    2 +-
>  drivers/net/wireless/iwmc3200wifi/netdev.c |    2 +-
>  drivers/net/wireless/iwmc3200wifi/rx.c     |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
> index 5a26bb0..79ffa3b 100644
> --- a/drivers/net/wireless/iwmc3200wifi/iwm.h
> +++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
> @@ -349,7 +349,7 @@ int iwm_up(struct iwm_priv *iwm);
>  int iwm_down(struct iwm_priv *iwm);
>  
>  /* TX API */
> -u16 iwm_tid_to_queue(u16 tid);
> +int iwm_tid_to_queue(u16 tid);
>  void iwm_tx_credit_inc(struct iwm_priv *iwm, int id, int total_freed_pages);
>  void iwm_tx_worker(struct work_struct *work);
>  int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
> diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
> index e4f0f87..c4c0d23 100644
> --- a/drivers/net/wireless/iwmc3200wifi/netdev.c
> +++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
> @@ -76,7 +76,7 @@ static int iwm_stop(struct net_device *ndev)
>   */
>  static const u16 iwm_1d_to_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  
> -u16 iwm_tid_to_queue(u16 tid)
> +int iwm_tid_to_queue(u16 tid)
>  {
>  	if (tid > IWM_UMAC_TID_NR - 2)
>  		return -EINVAL;
> diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
> index 1c57c1f..6d6ed74 100644
> --- a/drivers/net/wireless/iwmc3200wifi/rx.c
> +++ b/drivers/net/wireless/iwmc3200wifi/rx.c
> @@ -1126,7 +1126,7 @@ static int iwm_ntf_stop_resume_tx(struct iwm_priv *iwm, u8 *buf,
>  
>  		if (!stop) {
>  			struct iwm_tx_queue *txq;
> -			u16 queue = iwm_tid_to_queue(bit);
> +			int queue = iwm_tid_to_queue(bit);
>  
>  			if (queue < 0)
>  				continue;

Good catch. Thanks both for the fix.

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

