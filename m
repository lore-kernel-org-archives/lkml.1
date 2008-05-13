Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYEMEH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYEMEH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYEMEHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:07:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:37736 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYEMEHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:07:48 -0400
X-IronPort-AV: E=Sophos;i="4.27,477,1204520400"; 
   d="scan'208";a="68185554"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/1] [net/irda]: Fix a misalign access issue.
Date: Tue, 13 May 2008 12:07:35 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA0164BC89@chinexm1.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] [net/irda]: Fix a misalign access issue.
Thread-Index: Aci0MjEKG2Z7oS1nTAGe47GvCk2oRQAdUpnY
References: <1210588521-11508-1-git-send-email-cooloney@kernel.org> <1210598108.16390.47.camel@violet.holtmann.net>
From: "Yang, Graf" <Graf.Yang@analog.com>
To: "Marcel Holtmann" <marcel@holtmann.org>, "Bryan Wu" <cooloney@kernel.org>
Cc: <samuel@sortiz.org>, <irda-users@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, "Graf Yang" <graf.yang@analog.com>
X-OriginalArrivalTime: 13 May 2008 04:07:38.0697 (UTC) FILETIME=[E1E0BB90:01C8B4AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

The root cause is __u8 hints[2] are unaligned because of __u8 charset defined in file include/linux/irda.h:132
struct irda_device_info {
        __u32       saddr;    /* Address of local interface */
        __u32       daddr;    /* Address of remote device */
        char        info[22]; /* Description */
        __u8        charset;  /* Charset used for description */
        __u8        hints[2]; /* Hint bits */
};
And code may access hints[2] as u16. 

As put_unaligned/get_unaligned would set/get value through several instructions which decreases the performance. So I'd like to modify the irda_device_info instead of using put_unaligned/get_unaligned in irlmp.c/discovery.c.

I have tried
struct irda_device_info {
        __u32       saddr;    /* Address of local interface */
        __u32       daddr;    /* Address of remote device */
        char        info[22]; /* Description */
        __u8        charset;  /* Charset used for description */
        __u8        reserve;  /* For align data */ 
        __u8        hints[2]; /* Hint bits */
};

It works with my irda driver. Can I modify it like this?
There are many methods to modify this structure, which method are better?


It seems u16ho is useless, I would remove them from net/irda.

I can't enable irnet, so didn't touch net/irda/irnet/irnet_irda.c.
Would you give some information about how to enable irnet?

BRs,
Graf

-----Original Message-----
From: Marcel Holtmann [mailto:marcel@holtmann.org]
Sent: Mon 5/12/2008 9:15 PM
To: Bryan Wu
Cc: samuel@sortiz.org; irda-users@lists.sourceforge.net; linux-kernel@vger.kernel.org; Graf Yang
Subject: Re: [PATCH 1/1] [net/irda]: Fix a misalign access issue.
 
Hi Bryan,

> From: Graf Yang <graf.yang@analog.com>
> 
> Signed-off-by: Graf Yang <graf.yang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  net/irda/discovery.c |    8 +++++---
>  net/irda/irlmp.c     |    2 +-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/irda/discovery.c b/net/irda/discovery.c
> index bfacef8..a6f99b5 100644
> --- a/net/irda/discovery.c
> +++ b/net/irda/discovery.c
> @@ -40,6 +40,8 @@
>  
>  #include <net/irda/discovery.h>
>  
> +#include <asm/unaligned.h>
> +
>  /*
>   * Function irlmp_add_discovery (cachelog, discovery)
>   *
> @@ -87,7 +89,7 @@ void irlmp_add_discovery(hashbin_t *cachelog, discovery_t *new)
>  			 */
>  			hashbin_remove_this(cachelog, (irda_queue_t *) node);
>  			/* Check if hints bits are unchanged */
> -			if(u16ho(node->data.hints) == u16ho(new->data.hints))
> +			if (get_unaligned((__u16 *)node->data.hints) == get_unaligned((__u16 *)new->data.hints))
>  				/* Set time of first discovery for this node */
>  				new->firststamp = node->firststamp;
>  			kfree(node);
> @@ -281,9 +283,9 @@ struct irda_device_info *irlmp_copy_discoveries(hashbin_t *log, int *pn,
>  		/* Mask out the ones we don't want :
>  		 * We want to match the discovery mask, and to get only
>  		 * the most recent one (unless we want old ones) */
> -		if ((u16ho(discovery->data.hints) & mask) &&
> +		if ((get_unaligned((__u16 *)discovery->data.hints) & mask) &&
>  		    ((old_entries) ||
> -		     ((jiffies - discovery->firststamp) < j_timeout)) ) {
> +		     ((jiffies - discovery->firststamp) < j_timeout))) {
>  			/* Create buffer as needed.
>  			 * As this function get called a lot and most time
>  			 * we don't have anything to put in the log (we are
> diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
> index 1f81f8e..7b95cd6 100644
> --- a/net/irda/irlmp.c
> +++ b/net/irda/irlmp.c
> @@ -1086,7 +1086,7 @@ discovery_t *irlmp_get_discovery_response(void)
>  
>  	IRDA_ASSERT(irlmp != NULL, return NULL;);
>  
> -	u16ho(irlmp->discovery_rsp.data.hints) = irlmp->hints.word;
> +	put_unaligned(irlmp->hints.word, (__u16 *)irlmp->discovery_rsp.data.hints);
>  
>  	/*
>  	 *  Set character set for device name (we use ASCII), and

what about net/irda/irnet/irnet_irda.c and why not also kill the u16ho
macro at the same time.

Regards

Marcel

