Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYJNIug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYJNIug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYJNIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:50:24 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:54781 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbYJNIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=XH6u6L/R/3Dtt2JRZCRmYHXoJMwMYJ/W/8+y0h7Q4gzL7Y0cs5W0FyBACTNeUqoE1n
         tsyapXnemI7NykK7AaUKccmQi+VnjjMWFWVyhLy1nTEoVOIsU9sBfAjBL4buHxgqecee
         w7s6DblnG5MJO6+9dA+KPbG5FpjgD3Hm6auSo=
Message-ID: <386072610810140150t4c960a17yf7bfd6032b8710f2@mail.gmail.com>
Date: Tue, 14 Oct 2008 16:50:20 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Subject: Re: [PATCH 1/1] netdev: DM9000: Added typecasting to supress some warnings on Blackfin
Cc: ben@simtec.co.uk, s.hauer@pengutronix.de, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Javier Herrero" <jherrero@hvsistemas.es>
In-Reply-To: <20081013054119.7f360ee1@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223889009-31336-1-git-send-email-cooloney@kernel.org>
	 <20081013054119.7f360ee1@extreme>
X-Google-Sender-Auth: aab7c3e3cd6d3200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 8:41 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Mon, 13 Oct 2008 17:10:09 +0800
> Bryan Wu <cooloney@kernel.org> wrote:
>
>> From: Javier Herrero <jherrero@hvsistemas.es>
>>
>> Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/net/dm9000.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
>> index f42c23f..c4737ca 100644
>> --- a/drivers/net/dm9000.c
>> +++ b/drivers/net/dm9000.c
>> @@ -188,35 +188,35 @@ iow(board_info_t * db, int reg, int value)
>>
>>  static void dm9000_outblk_8bit(void __iomem *reg, void *data, int count)
>>  {
>> -     writesb(reg, data, count);
>> +     writesb((int)reg, data, count);
>>  }
>
> You lose the sparse checking for misuse by doing this.
>
> Why not this instead?
>
>
> --- a/drivers/net/dm9000.c      2008-10-13 05:29:15.000000000 -0700
> +++ b/drivers/net/dm9000.c      2008-10-13 05:40:13.000000000 -0700
> @@ -47,14 +47,6 @@
>  #define CARDNAME       "dm9000"
>  #define DRV_VERSION    "1.31"
>
> -#ifdef CONFIG_BLACKFIN
> -#define readsb insb
> -#define readsw insw
> -#define readsl insl
> -#define writesb        outsb
> -#define writesw        outsw
> -#define writesl        outsl
> -#endif
>
>  /*
>  * Transmit timeout, default 5 seconds.
> @@ -185,7 +177,40 @@ iow(board_info_t * db, int reg, int valu
>  }
>
>  /* routines for sending block to chip */
> +#ifdef CONFIG_BLACKFIN
> +static void dm9000_outblk_8bit(void __iomem *reg, void *data, int count)
> +{
> +       outsb((unsigned long)reg, data, count);
> +}
>

I added readsl/writesl to blackfin arch, so we don't need to mess up
the common DM9000 netdev driver here.

-Bryan

> +static void dm9000_outblk_16bit(void __iomem *reg, void *data, int count)
> +{
> +       outsw((unsigned long)reg, data, (count+1) >> 1);
> +}
> +
> +static void dm9000_outblk_32bit(void __iomem *reg, void *data, int count)
> +{
> +       outsl((unsigned long)reg, data, (count+3) >> 2);
> +}
> +
> +/* input block from chip to memory */
> +
> +static void dm9000_inblk_8bit(void __iomem *reg, void *data, int count)
> +{
> +       insb((unsigned long)reg, data, count);
> +}
> +
> +
> +static void dm9000_inblk_16bit(void __iomem *reg, void *data, int count)
> +{
> +       insw((unsigned long)reg, data, (count+1) >> 1);
> +}
> +
> +static void dm9000_inblk_32bit(void __iomem *reg, void *data, int count)
> +{
> +       insl((unsigned long)reg, data, (count+3) >> 2);
> +}
> +#else
>  static void dm9000_outblk_8bit(void __iomem *reg, void *data, int count)
>  {
>        writesb(reg, data, count);
> @@ -218,6 +243,7 @@ static void dm9000_inblk_32bit(void __io
>  {
>        readsl(reg, data, (count+3) >> 2);
>  }
> +#endif
>
>  /* dump block from chip to null */
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
