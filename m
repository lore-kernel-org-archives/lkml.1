Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbXJYJvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbXJYJvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbXJYJvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:51:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:38466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbXJYJvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:51:14 -0400
Date: Thu, 25 Oct 2007 11:51:11 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ISDN/capidrv: fix casting warning
Message-ID: <20071025095111.GA22353@pingi.kke.suse.de>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <42205df7291ce7109866f9dbb5d06e481337e776.1193299380.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42205df7291ce7109866f9dbb5d06e481337e776.1193299380.git.jeff@garzik.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:06:16AM -0400, Jeff Garzik wrote:
> drivers/isdn/capi/capidrv.c: In function 'if_sendbuf':
> drivers/isdn/capi/capidrv.c:1865: warning: cast from pointer to integer
> of different size
> 
> We are passing a kernel pointer, skb->data, but the interface itself is
> limited to 32 bits.  A future changeset may want to mark this code
> 32-bit only, if it turns out cmsg->Data value truncation on 64-bit
> platforms is problematic in practice.
> 

I think I should really add somewhere a comment for this issue.
This field is not used in practice in linux kernel (neither in 32 or
64 bit), but should have some value, since a CAPI message trace will
display it.
The correct value in the 32 bit case is the address of the
data, in 64 bit it makes no sense, maybe we should use 0 here.

> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/isdn/capi/capidrv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
> index 44f954d..a4814e1 100644
> --- a/drivers/isdn/capi/capidrv.c
> +++ b/drivers/isdn/capi/capidrv.c
> @@ -1862,7 +1862,7 @@ static int if_sendbuf(int id, int channel, int doack, struct sk_buff *skb)
>  	datahandle = nccip->datahandle;
>  	capi_fill_DATA_B3_REQ(&sendcmsg, global.ap.applid, card->msgid++,
>  			      nccip->ncci,	/* adr */
> -			      (u32) skb->data,	/* Data */
> +			      (unsigned long) skb->data, /* Data */
>  			      skb->len,		/* DataLength */
>  			      datahandle,	/* DataHandle */
>  			      0	/* Flags */
> -- 
> 1.5.2.4

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
