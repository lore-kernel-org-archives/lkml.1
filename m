Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYKNJnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYKNJnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYKNJne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:43:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35540 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbYKNJne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:43:34 -0500
Date: Fri, 14 Nov 2008 10:41:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] relay: fix cpu offline problem
Message-ID: <20081114094154.GT26778@kernel.dk>
References: <491D45EB.5050307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D45EB.5050307@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14 2008, Lai Jiangshan wrote:
> relay_open() will close allocated buffers when failed.
> but if cpu offlined, some buffer will not be closed.
> this patch fixed it.
> 
> and did cleanup for relay_reset() too.

Good catch, that definitely looks like a bug. Applied.

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 8d13a78..32b0bef 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -400,7 +400,7 @@ void relay_reset(struct rchan *chan)
>  	}
>  
>  	mutex_lock(&relay_channels_mutex);
> -	for_each_online_cpu(i)
> +	for_each_possible_cpu(i)
>  		if (chan->buf[i])
>  			__relay_reset(chan->buf[i], 0);
>  	mutex_unlock(&relay_channels_mutex);
> @@ -611,10 +611,9 @@ struct rchan *relay_open(const char *base_filename,
>  	return chan;
>  
>  free_bufs:
> -	for_each_online_cpu(i) {
> -		if (!chan->buf[i])
> -			break;
> -		relay_close_buf(chan->buf[i]);
> +	for_each_possible_cpu(i) {
> +		if (chan->buf[i])
> +			relay_close_buf(chan->buf[i]);
>  	}
>  
>  	kref_put(&chan->kref, relay_destroy_channel);
> 

-- 
Jens Axboe

