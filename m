Return-Path: <linux-kernel-owner+w=401wt.eu-S1763785AbZE1S6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763785AbZE1S6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbZE1S6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:58:17 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:51995 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbZE1S6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:58:17 -0400
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH 1/3] regulator/max1586: support increased V3 voltage range
References: <878wkibmv9.fsf@free.fr>
	<1243487718-5423-2-git-send-email-philipp.zabel@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 28 May 2009 20:58:05 +0200
In-Reply-To: <1243487718-5423-2-git-send-email-philipp.zabel@gmail.com> (Philipp Zabel's message of "Thu\, 28 May 2009 07\:15\:16 +0200")
Message-ID: <87skip2gxu.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Zabel <philipp.zabel@gmail.com> writes:

<snip>
> @@ -164,14 +184,25 @@ static int max1586_pmic_probe(struct i2c_client *client,
>  {
>  	struct regulator_dev **rdev;
>  	struct max1586_platform_data *pdata = client->dev.platform_data;
> -	int i, id, ret = 0;
> +	struct max1586_data *max1586;
> +	int i, id, ret = -ENOMEM;
> +
> +	max1586 = kzalloc(sizeof(struct max1586_data) +
> +			sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
> +			GFP_KERNEL);
> +	if (!max1586)
> +		goto out;
>  
> -	rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
> -		       GFP_KERNEL);
> -	if (!rdev)
> -		return -ENOMEM;
> +	max1586->client = client;
>  
> -	ret = -EINVAL;
> +	if (!pdata->v3_gain) {
> +		ret = -EINVAL;
> +		goto out_unmap;
> +	}

> +	max1586->min_uV = MAX1586_V3_MIN_UV * pdata->v3_gain / 1000000;
> +	max1586->max_uV = MAX1586_V3_MAX_UV * pdata->v3_gain / 1000000;
My last comment : you'll overflow an integer capacity here, and will get
min_uV=max_uV=0.

Please replace by :
       max1586->min_uV = MAX1586_V3_MIN_UV / 1000 * (pdata->v3_gain / 1000);
       max1586->max_uV = MAX1586_V3_MAX_UV / 1000 * (pdata->v3_gain / 1000);

And then add my :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert

