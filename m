Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZCCGQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZCCGQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZCCGQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:16:24 -0500
Received: from cathcart.site5.com ([74.54.107.137]:34680 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZCCGQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:16:24 -0500
Message-ID: <49ACCB2E.8020400@compulab.co.il>
Date: Tue, 03 Mar 2009 08:16:14 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, raph@8d.com,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] rtc-v3020: add ability to access v3020 chip with GPIOs
References: <cover.1235400430.git.mike@compulab.co.il>	<d2392eac1d61487c6e56341271e7ba10c16b94b9.1235400430.git.mike@compulab.co.il> <20090302143604.57bd4f53.akpm@linux-foundation.org>
In-Reply-To: <20090302143604.57bd4f53.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Mon,  2 Mar 2009 13:40:57 +0200
> Mike Rapoport <mike@compulab.co.il> wrote:
> 
>> +static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
>> +			  struct v3020_platform_data *pdata)
>> +{
>> +	int i, err;
>> +
>> +	v3020_gpio[V3020_CS].gpio = pdata->gpio_cs;
>> +	v3020_gpio[V3020_WR].gpio = pdata->gpio_wr;
>> +	v3020_gpio[V3020_RD].gpio = pdata->gpio_rd;
>> +	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
>> +		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
>> +		if (err)
>> +			goto err_request;
>> +
>> +		gpio_direction_output(v3020_gpio[i].gpio, 1);
>> +	}
>> +
>> +	chip->gpio = v3020_gpio;
>> +
>> +	return 0;
>> +
>> +err_request:
>> +	for (; i >= 0; i--)
>> +		gpio_free(v3020_gpio[i].gpio);
>> +
>> +	return err;
>> +}
> 
> It needs this fix, I think?

Indeed. Thanks.

> 
> fix off-by-one in error path
> 
> --- a/drivers/rtc/rtc-v3020.c~rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix
> +++ a/drivers/rtc/rtc-v3020.c
> @@ -136,7 +136,7 @@ static int v3020_gpio_map(struct v3020 *
>  	return 0;
>  
>  err_request:
> -	for (; i >= 0; i--)
> +	while (--i >= 0)
>  		gpio_free(v3020_gpio[i].gpio);
>  
>  	return err;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.

