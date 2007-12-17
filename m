Return-Path: <linux-kernel-owner+w=401wt.eu-S1765308AbXLQIpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765308AbXLQIpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 03:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbXLQIpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 03:45:31 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:4186 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbXLQIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 03:45:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=M9nM7GyC6PBFMyFupH2vRZ+pvTYGon0i1z74QowLyIaVvAO0nLFbT9UTR18UcRX6lZuzljTlQM0buiGSnjx/JVkz1zElSy4hU7SuYlx38Xv3+eayoGMowfwumY6BmvA6mEUBj3+Wh92wzPlCeqVKfaEYXOXDZQdodiljM3CgvUw=
Message-ID: <47663726.3010508@gmail.com>
Date: Mon, 17 Dec 2007 09:45:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: chripell@gmail.com
CC: linux-kernel@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>
Subject: Re: [PATCH] max3100 driver
References: <1197879438299-git-send-email-chripell@gmail.com>
In-Reply-To: <1197879438299-git-send-email-chripell@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2007 09:17 AM, chripell@gmail.com wrote:
> This patch adds support for the MAX3100 SPI UART.
> 
> Generated on  20071217  against v2.6.23
> 
> Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
> ---
>  drivers/serial/Kconfig         |    7 +
>  drivers/serial/Makefile        |    1 +
>  drivers/serial/max3100.c       |  956 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/serial_max3100.h |   25 +
>  4 files changed, 989 insertions(+), 0 deletions(-)
> 
[...]
> diff --git a/drivers/serial/max3100.c b/drivers/serial/max3100.c
> new file mode 100644
> index 0000000..d07936d
> --- /dev/null
> +++ b/drivers/serial/max3100.c
[...]
> +static int __devexit max3100_remove(struct spi_device *spi)
> +{
> +	int i;
> +
> +	i = 0;
> +
> +	for (i = 0; i < MAX_MAX3100; i++)
> +		if (max3100s[i] && max3100s[i]->ref_count > 0)
> +			return -EBUSY;
> +
> +	for (i = 0; i < MAX_MAX3100; i++)
> +		if (max3100s[i]) {
> +			tty_unregister_device(serial_driver, i);
> +			kfree(max3100s[i]);
> +			max3100s[i] = NULL;
> +		}
> +
> +	if (serial_driver)
> +		tty_unregister_driver(serial_driver);

You probably wanted to unregister it after _all_ cards are removed, not after
each...

> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int max3100_suspend(struct spi_device *spi, pm_message_t state)
> +{
> +	struct max3100_port_s *s = dev_get_drvdata(&spi->dev);
> +	u16 tx, rx;
> +
> +	tx = MAX3100_WC | MAX3100_SHDN;
> +	max3100_sr(s, tx, &rx, 0);

Also you should synchronize_irq() after stopping them here.

> +	return 0;
> +}

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
