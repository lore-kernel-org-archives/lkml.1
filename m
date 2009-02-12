Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZBLAaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZBLAaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:30:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbZBLA3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:29:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253AbZBLA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:29:48 -0500
Date: Wed, 11 Feb 2009 16:29:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, karaluh@karaluh.pl, ecashin@coraid.com
Subject: Re: [PATCH 1/1] aoe: ignore vendor extension AoE responses
Message-Id: <20090211162944.c1cdf8fb.akpm@linux-foundation.org>
In-Reply-To: <1234397804-9034-1-git-send-email-ecashin@coraid.com>
References: <1234397804-9034-1-git-send-email-ecashin@coraid.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 19:16:44 -0500
Ed Cashin <ecashin@coraid.com> wrote:

> The Welland ME-747K-SI AoE target generates unsolicited AoE
> responses that are marked as vendor extensions.  Instead of
> ignoring these packets, the aoe driver was generating kernel
> messages for each unrecognized response received.  This patch
> corrects the behavior.
> 
> Signed-off-by: Ed Cashin <ecashin@coraid.com>
> Reported-by: karaluh@karaluh.pl
> Tested-by: karaluh@karaluh.pl
> ---
> 
> I will place this patch in the new aoe quilt tree for
> linux-next when this patch has passed LKML review.
> 
>  drivers/block/aoe/aoe.h    |    1 +
>  drivers/block/aoe/aoenet.c |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
> index c237527..5e41e6d 100644
> --- a/drivers/block/aoe/aoe.h
> +++ b/drivers/block/aoe/aoe.h
> @@ -18,6 +18,7 @@
>  enum {
>  	AOECMD_ATA,
>  	AOECMD_CFG,
> +	AOECMD_VEND_MIN = 0xf0,
>  
>  	AOEFL_RSP = (1<<3),
>  	AOEFL_ERR = (1<<2),
> diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
> index 30de5b1..c6099ba 100644
> --- a/drivers/block/aoe/aoenet.c
> +++ b/drivers/block/aoe/aoenet.c
> @@ -142,6 +142,8 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
>  		aoecmd_cfg_rsp(skb);
>  		break;
>  	default:
> +		if (h->cmd >= AOECMD_VEND_MIN)
> +			break;	/* don't complain about vendor commands */
>  		printk(KERN_INFO "aoe: unknown cmd %d\n", h->cmd);
>  	}
>  exit:

Do you believe that this fix should be backported into earlier kernel
versions?  (2.6.28.x, 2.6.27.x, etc)

