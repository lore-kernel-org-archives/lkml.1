Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZGRXdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZGRXdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 19:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZGRXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 19:33:11 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37070 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753898AbZGRXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 19:33:10 -0400
Date: Sat, 18 Jul 2009 18:33:08 -0500
From: Robin Holt <holt@sgi.com>
To: Julia Lawall <julia@diku.dk>
Cc: holt@sgi.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers/misc/sgi-xp: convert nested
	spin_lock_irqsave to spin_lock
Message-ID: <20090718233308.GC7426@sgi.com>
References: <Pine.LNX.4.64.0907181723360.26792@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907181723360.26792@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You reason description confused me at first.  After looking closer at
the code, I understand and agree.

Acked-by: Robin Holt <holt@sgi.com>

On Sat, Jul 18, 2009 at 05:23:57PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> If spin_lock_irqsave is called twice in a row with the same second
> argument, the interrupt state at the point of the second call overwrites
> the value saved by the first call.  Indeed, the second call does not need
> to save the interrupt state, so it is changed to a simple spin_lock.
> 
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression lock1,lock2;
> expression flags;
> @@
> 
> *spin_lock_irqsave(lock1,flags)
> ... when != flags
> *spin_lock_irqsave(lock2,flags)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/misc/sgi-xp/xpc_uv.c        |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
> index c76677a..d0052ad 100644
> --- a/drivers/misc/sgi-xp/xpc_uv.c
> +++ b/drivers/misc/sgi-xp/xpc_uv.c
> @@ -443,9 +443,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
>  
>  		if (msg->activate_gru_mq_desc_gpa !=
>  		    part_uv->activate_gru_mq_desc_gpa) {
> -			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
> +			spin_lock(&part_uv->flags_lock);
>  			part_uv->flags &= ~XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV;
> -			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
> +			spin_unlock(&part_uv->flags_lock);
>  			part_uv->activate_gru_mq_desc_gpa =
>  			    msg->activate_gru_mq_desc_gpa;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
