Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYKJWtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYKJWtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYKJWtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:49:23 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:41272 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752155AbYKJWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:49:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DHJKV91P8a2eW1w9jGVQ5vlkRSwBnmrf4C98034+XdSCRyW/Z5TUCMdJ+UBjKlj19KygoEQZ/T6fEhC0hJJx8xbWqQqg2YuUArgXTb17/V8fQdw7AwDBqh4oadcNYs8nKcuyBUGjvfDlzZ8jlYlhg9mDglKWQtGWx2IM5m3/hGI=  ;
X-YMail-OSG: 9CaVYOQVM1lMp1lOB1COIKSbvtFJf0yxwCDEV1Fh_9BgXdTgFNDp9O9KR4D07RCxtdNtxtLc0pJmp6UAfroffv9Pem.jkV8PT23UbxxvdHtp0yqFJwRoEAFuZ4.M5qbsf__xo3oXe7rNOsKGaROvdj3XJy19sn34jM8uv.eFPEmpA.kx5wMliOaY82CH
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Jackson <mpfj@mimc.co.uk>
Subject: Re: [PATCH v6] Add Dallas DS1390/93/94 RTC chips
Date: Mon, 10 Nov 2008 14:49:17 -0800
User-Agent: KMail/1.9.10
Cc: dbrownell@users.sourceforge.net, lkml <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net
References: <4912B459.2020704@mimc.co.uk>
In-Reply-To: <4912B459.2020704@mimc.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811101449.17972.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008, Mark Jackson wrote:
> v6 (!!) of this patch with even more code tidying as per previous comments.
> Also only a single tx/rx buffer is used.
> Now uses spi_write_then_read()
> Comments changed to include extra chips in the family
> 
> This patch adds support for the Dallas DS1390/93/94 SPI RTC chip.
> 
> Signed-off-by: Mark Jackson <mpfj@mimc.co.uk>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Although I wouldn't bother using the "wday" field at all.
Linux doesn't use that field, so trying to maintain it isn't
useful ... though it probably doesn't hurt, assuming the
chip behaves OK when invalid data is written there.


Also, in probe():

> +       printk(KERN_INFO "DS1390 SPI RTC driver\n");

I dislike those banners in general.  Best to remove that,
since the RTC framework announces the registration.  Or
at least, dev_info().


> +	spi->mode = SPI_MODE_3;
> +	spi->bits_per_word = 8;
> +	spi_setup(spi);

Unlikely to fail ... but 

	res = spi_setup(spi);
	if (res < 0) {
		/* or do it before the kzalloc, no kfree
		 * ... likewise with reading the register
		 * as an "is it there" check:  do it earlier
		 * and get a similar minor codeshrink.
		 */
		kfree(chip);
		return res;
	}

> +
> +	dev_set_drvdata(&spi->dev, chip);
> +
> +	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
> +	if (res) {
> +		dev_err(&spi->dev, "DS1390: unable to read device\n");
> +		kfree(chip);
> +		return res;
> +	}
> +
> +	rtc = rtc_device_register("ds1390",
> +				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
