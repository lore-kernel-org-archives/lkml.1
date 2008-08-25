Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYHYO3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYHYO3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYHYO3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:29:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:38223 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYHYO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:29:29 -0400
Date: Mon, 25 Aug 2008 17:28:52 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: ext Bryan Wu <cooloney@kernel.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] usb: musb: fix bug - don't mess up count number
	and CSR0 register value
Message-ID: <20080825142852.GK20450@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1219655621-18510-1-git-send-email-cooloney@kernel.org> <1219655621-18510-2-git-send-email-cooloney@kernel.org> <20080825114928.GG20450@gandalf.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825114928.GG20450@gandalf.research.nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 25 Aug 2008 14:28:51.0812 (UTC) FILETIME=[E558BA40:01C906BE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 02:49:28PM +0300, Felipe Balbi wrote:
> On Mon, Aug 25, 2008 at 05:13:40PM +0800, ext Bryan Wu wrote:
> > Signed-off-by: Bryan Wu <cooloney@kernel.org>
> 
> This patch looks ok, but doesn't apply on top of the previous series.
> 
> Greg, please apply the refreshed version attached.
> 
> thanks,
> -- 
> balbi

> >From efae64b5f222e1b57b354e8207c62975c5a7618b Mon Sep 17 00:00:00 2001
> From: Bryan Wu <cooloney@kernel.org>
> Date: Mon, 25 Aug 2008 14:39:39 +0300
> Subject: [PATCH] usb: musb: do not mess up count number and CSR0 register value
> 
Signed-off-by: Bryan Wy <cooloney@kernel.org>
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---
>  drivers/usb/musb/musb_gadget_ep0.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/musb/musb_gadget_ep0.c b/drivers/usb/musb/musb_gadget_ep0.c
> index b50a30d..9b59824 100644
> --- a/drivers/usb/musb/musb_gadget_ep0.c
> +++ b/drivers/usb/musb/musb_gadget_ep0.c
> @@ -437,7 +437,7 @@ static void ep0_rxstate(struct musb *musb)
>  {
>  	void __iomem		*regs = musb->control_ep->regs;
>  	struct usb_request	*req;
> -	u16			tmp;
> +	u16			count, csr;
>  
>  	req = next_ep0_request(musb);
>  
> @@ -449,34 +449,34 @@ static void ep0_rxstate(struct musb *musb)
>  		unsigned	len = req->length - req->actual;
>  
>  		/* read the buffer */
> -		tmp = musb_readb(regs, MUSB_COUNT0);
> -		if (tmp > len) {
> +		count = musb_readb(regs, MUSB_COUNT0);
> +		if (count > len) {
>  			req->status = -EOVERFLOW;
> -			tmp = len;
> +			count = len;
>  		}
> -		musb_read_fifo(&musb->endpoints[0], tmp, buf);
> -		req->actual += tmp;
> -		tmp = MUSB_CSR0_P_SVDRXPKTRDY;
> -		if (tmp < 64 || req->actual == req->length) {
> +		musb_read_fifo(&musb->endpoints[0], count, buf);
> +		req->actual += count;
> +		csr = MUSB_CSR0_P_SVDRXPKTRDY;
> +		if (count < 64 || req->actual == req->length) {
>  			musb->ep0_state = MUSB_EP0_STAGE_STATUSIN;
> -			tmp |= MUSB_CSR0_P_DATAEND;
> +			csr |= MUSB_CSR0_P_DATAEND;
>  		} else
>  			req = NULL;
>  	} else
> -		tmp = MUSB_CSR0_P_SVDRXPKTRDY | MUSB_CSR0_P_SENDSTALL;
> +		csr = MUSB_CSR0_P_SVDRXPKTRDY | MUSB_CSR0_P_SENDSTALL;
>  
>  
>  	/* Completion handler may choose to stall, e.g. because the
>  	 * message just received holds invalid data.
>  	 */
>  	if (req) {
> -		musb->ackpend = tmp;
> +		musb->ackpend = csr;
>  		musb_g_ep0_giveback(musb, req);
>  		if (!musb->ackpend)
>  			return;
>  		musb->ackpend = 0;
>  	}
> -	musb_writew(regs, MUSB_CSR0, tmp);
> +	musb_writew(regs, MUSB_CSR0, csr);
>  }
>  
>  /*
> -- 
> 1.6.0.rc1.71.gfba5
> 


-- 
balbi
