Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZCBWiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZCBWiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZCBWh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:37:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbZCBWh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:37:56 -0500
Date: Mon, 2 Mar 2009 14:36:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <mike@compulab.co.il>
Cc: alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, raph@8d.com, mike@compulab.co.il,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] rtc-v3020: add ability to access v3020 chip with GPIOs
Message-Id: <20090302143604.57bd4f53.akpm@linux-foundation.org>
In-Reply-To: <d2392eac1d61487c6e56341271e7ba10c16b94b9.1235400430.git.mike@compulab.co.il>
References: <cover.1235400430.git.mike@compulab.co.il>
	<d2392eac1d61487c6e56341271e7ba10c16b94b9.1235400430.git.mike@compulab.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Mar 2009 13:40:57 +0200
Mike Rapoport <mike@compulab.co.il> wrote:

> +static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
> +			  struct v3020_platform_data *pdata)
> +{
> +	int i, err;
> +
> +	v3020_gpio[V3020_CS].gpio = pdata->gpio_cs;
> +	v3020_gpio[V3020_WR].gpio = pdata->gpio_wr;
> +	v3020_gpio[V3020_RD].gpio = pdata->gpio_rd;
> +	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
> +
> +	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
> +		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
> +		if (err)
> +			goto err_request;
> +
> +		gpio_direction_output(v3020_gpio[i].gpio, 1);
> +	}
> +
> +	chip->gpio = v3020_gpio;
> +
> +	return 0;
> +
> +err_request:
> +	for (; i >= 0; i--)
> +		gpio_free(v3020_gpio[i].gpio);
> +
> +	return err;
> +}

It needs this fix, I think?


fix off-by-one in error path

--- a/drivers/rtc/rtc-v3020.c~rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix
+++ a/drivers/rtc/rtc-v3020.c
@@ -136,7 +136,7 @@ static int v3020_gpio_map(struct v3020 *
 	return 0;
 
 err_request:
-	for (; i >= 0; i--)
+	while (--i >= 0)
 		gpio_free(v3020_gpio[i].gpio);
 
 	return err;

