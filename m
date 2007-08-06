Return-Path: <linux-kernel-owner+w=401wt.eu-S1764282AbXHFMGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764282AbXHFMGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763198AbXHFMFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:05:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:59401 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbXHFMFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:05:53 -0400
Date: Mon, 6 Aug 2007 14:05:51 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: [PATCH][RESEND][ISDN] fix possible NULL deref on low memory condition in capidrv.c::send_message()
Message-ID: <20070806120551.GA12243@pingi.kke.suse.de>
Mail-Followup-To: Jesper Juhl <jesper.juhl@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
	Karsten Keil <kkeil@suse.de>,
	Kai Germaschewski <kai.germaschewski@gmx.de>,
	Kai Germaschewski <kai@germaschewski.name>
References: <200708042031.38203.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708042031.38203.jesper.juhl@gmail.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 08:31:37PM +0200, Jesper Juhl wrote:
> (first send: Monday 25 June 2007, resending due to no response)
> (resending again since there has still been no response)
> 
> 
> If we fail to allocate an skb in 
> drivers/isdn/capi/capidrv.c::send_message(), then we'll end up 
> dereferencing a NULL pointer.
> Since out of memory conditions are not unheard of, I believe it 
> is better to print a error message and just return rather than 
> bring down the whole kernel. 
> Sure, doing this may upset some application, but that's still 
> better than crashing the whole system.
> 
> (ps. please Cc me on replies from the isdn4linux list since I'm not subscribed 
>  there)
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Karsten Keil <kkeil@suse.de>

> ---
> 
>  drivers/isdn/capi/capidrv.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
> index 23b6f7b..476012b 100644
> --- a/drivers/isdn/capi/capidrv.c
> +++ b/drivers/isdn/capi/capidrv.c
> @@ -506,9 +506,14 @@ static void send_message(capidrv_contr * card, _cmsg * cmsg)
>  {
>  	struct sk_buff *skb;
>  	size_t len;
> +
>  	capi_cmsg2message(cmsg, cmsg->buf);
>  	len = CAPIMSG_LEN(cmsg->buf);
>  	skb = alloc_skb(len, GFP_ATOMIC);
> +	if (!skb) {
> +		printk(KERN_ERR "capidrv::send_message: can't allocate mem\n");
> +		return;
> +	}
>  	memcpy(skb_put(skb, len), cmsg->buf, len);
>  	if (capi20_put_message(&global.ap, skb) != CAPI_NOERROR)
>  		kfree_skb(skb);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
