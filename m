Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZGELXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZGELXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZGELXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:23:30 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:38029 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZGELX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=VweLKjvFQDNTdD1zCmpqhFikJTSyyry7548yuDygNhAoW10skIsyAyENTVEwPwMRZ3
         Z8ZfCr6WYCjSohV0pRmNidXQ5IvA6WYzxDREnj7yOYtkT+sWZTmysZaRdgh65x5lcMRH
         rKhvAf6ZwI8VEsBxzICfH6QT90jnSHFy2WQXw=
From: Florian Fainelli <florian@openwrt.org>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/3] drivers/vlynq/vlynq.c: Fix resource size off by 1 error
Date: Sun, 5 Jul 2009 13:23:23 +0200
User-Agent: KMail/1.9.9
Cc: openwrt-devel@lists.openwrt.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0907042332300.9841@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907042332300.9841@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907051323.24140.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 04 July 2009 23:33:21 Julia Lawall, vous avez écrit :
> From: Julia Lawall <julia@diku.dk>
>
> In this case, the calls to request_mem_region, ioremap, and
> release_mem_region all have a consistent length argument, len, but since in
> other files (res->end - res->start) + 1, equivalent to resource_size(res),
> is used for a resource-typed structure res, one could consider whether the
> same should be done here.

Thanks for spotting this Julia.

>
> The problem was found using the following semantic patch:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@
> struct resource *res;
> @@
>
> - (res->end - res->start) + 1
> + resource_size(res)
>
> @@
> struct resource *res;
> @@
>
> - res->end - res->start
> + BAD(resource_size(res))
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Florian Fainelli <florian@openwrt.org>

>
> ---
>  drivers/vlynq/vlynq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -u -p
> a/drivers/vlynq/vlynq.c
> b/drivers/vlynq/vlynq.c
> --- a/drivers/vlynq/vlynq.c 2009-06-24 21:18:50.000000000 +0200
> +++ b/drivers/vlynq/vlynq.c 2009-07-04 21:37:28.000000000 +0200
> @@ -703,7 +703,7 @@ static int vlynq_probe(struct platform_d
>  	dev->mem_start = mem_res->start;
>  	dev->mem_end = mem_res->end;
>
> -	len = regs_res->end - regs_res->start;
> +	len = resource_size(regs_res);
>  	if (!request_mem_region(regs_res->start, len, dev_name(&dev->dev))) {
>  		printk(KERN_ERR "%s: Can't request vlynq registers\n",
>  		       dev_name(&dev->dev));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
