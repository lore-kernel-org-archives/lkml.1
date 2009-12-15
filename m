Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZLOJnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZLOJnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZLOJnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:43:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50255
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbZLOJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:43:10 -0500
Date: Tue, 15 Dec 2009 01:43:08 -0800 (PST)
Message-Id: <20091215.014308.77044043.davem@davemloft.net>
To: daniel@caiaq.de
Cc: linux-kernel@vger.kernel.org, dcbw@redhat.com, m.hirsch@raumfeld.com,
       netdev@vger.kernel.org, libertas-dev@lists.infradead.org,
       stable@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: wext: allocate space for NULL-termination
 for 32byte SSIDs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1260650850-16163-1-git-send-email-daniel@caiaq.de>
References: <1260650850-16163-1-git-send-email-daniel@caiaq.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@caiaq.de>
Date: Sun, 13 Dec 2009 04:47:30 +0800

> We've experienced a long standing bug when quickly switching from
> ad-hoc to managed mode on a hardware using a Libertas chipset.

Can you please CC: linux-wireless for wireless patches?

Thanks.

> The effect is that after a number of mode transistions (sometimes as few
> as two sufficed), the kernel will oops at very strange locations, mostly
> in something like __kmem_alloc().
> 
> While the root cause turned out to be an issue with the wpa-supplicant
> which feeds the kernel driver with garbage, this occasion pointed out a
> bug in the wireless wext core when SSIDs with 32 byte lengths are passed
> from userspace. In this case, the string is not properly NULL-terminated
> which causes some other part to corrupt memory.
> 
> (In the particular case I observed, an SIOCSIWESSID was issued with
>  bogus data in iwp->pointer but iwp->length=32).
> 
> I admitedly couldn't find where the actual corruption itself happens,
> but with this trivial fix, I can't reproduce the bug anymore.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Michael Hirsch <m.hirsch@raumfeld.com>
> Cc: netdev@vger.kernel.org
> Cc: libertas-dev@lists.infradead.org
> Cc: stable@kernel.org
> ---
>  net/wireless/wext.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> ---
>  net/wireless/wext-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
> index 5e1656b..3d8f4b0 100644
> --- a/net/wireless/wext-core.c
> +++ b/net/wireless/wext-core.c
> @@ -759,8 +759,8 @@ static int ioctl_standard_iw_point(struct iw_point *iwp, unsigned int cmd,
>  		}
>  	}
>  
> -	/* kzalloc() ensures NULL-termination for essid_compat. */
> -	extra = kzalloc(extra_size, GFP_KERNEL);
> +	/* kzalloc() +1 ensures NULL-termination for essid_compat. */
> +	extra = kzalloc(extra_size + 1, GFP_KERNEL);
>  	if (!extra)
>  		return -ENOMEM;
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
