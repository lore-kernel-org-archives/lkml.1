Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZHaGcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZHaGcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 02:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZHaGcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 02:32:06 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:41475 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZHaGcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 02:32:06 -0400
Message-ID: <4A9B6E57.7090703@gmail.com>
Date: Mon, 31 Aug 2009 08:31:51 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] drop_monitor: fix trace_napi_poll_hit()
References: <4A9B6963.5090207@cn.fujitsu.com>
In-Reply-To: <4A9B6963.5090207@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 31 Aug 2009 08:31:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong a écrit :
> The net_dev of backlog napi is NULL, like below:
> 
> __get_cpu_var(softnet_data).backlog.dev == NULL
> 
> So, we should check it in napi tracepoint's probe function
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  net/core/drop_monitor.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 9d66fa9..d311202 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -182,7 +182,8 @@ static void trace_napi_poll_hit(struct napi_struct *napi)
>  	/*
>  	 * Ratelimit our check time to dm_hw_check_delta jiffies
>  	 */
> -	if (!time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
> +	if (!napi->dev ||
> +	    !time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
>  		return;
>  
>  	rcu_read_lock();


This reminds me dev->last_rx is not anymore updated, unless special conditions
are met.

Test done in trace_napi_poll_hit() is probably not good, even with a non null napi->dev
