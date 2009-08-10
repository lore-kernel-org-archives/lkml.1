Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZHJWg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZHJWg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZHJWg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:36:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbZHJWg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:36:56 -0400
Date: Mon, 10 Aug 2009 15:35:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: ralf@linux-mips.org, torvalds@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       ddaney@caviumnetworks.com, Herbert Xu <herbert@gondor.apana.org.au>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2] hw_random: Add hardware RNG for Octeon SOCs.
Message-Id: <20090810153535.a1257613.akpm@linux-foundation.org>
In-Reply-To: <1249929025-29625-2-git-send-email-ddaney@caviumnetworks.com>
References: <4A806529.3060609@caviumnetworks.com>
	<1249929025-29625-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 11:30:25 -0700
David Daney <ddaney@caviumnetworks.com> wrote:
>

Now what's going on with all this typecasting?

> diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
> new file mode 100644
> index 0000000..84d33a7
> --- /dev/null
> +++ b/drivers/char/hw_random/octeon-rng.c
> @@ -0,0 +1,146 @@
> +/*
> + * Hardware Random Number Generator support for Cavium Networks
> + * Octeon processor family.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2009 Cavium Networks
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/device.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +
> +#include <asm/octeon/octeon.h>
> +#include <asm/octeon/cvmx-rnm-defs.h>
> +
> +struct octeon_rng {
> +	u64 control_status;
> +	u64 result;
> +};
> +
> +static int octeon_rng_init(struct hwrng *rng)
> +{
> +	struct octeon_rng *p = (struct octeon_rng *)rng->priv;

Here it's unavoidable because some bad person went and made hwrng.priv
an `unsigned long'.  I haven't checked, but I bet it should have been a
void*.

> +	union cvmx_rnm_ctl_status ctl;
> +
> +	ctl.u64 = 0;
> +	ctl.s.ent_en = 1; /* Enable the entropy source.  */
> +	ctl.s.rng_en = 1; /* Enable the RNG hardware.  */
> +	cvmx_write_csr(p->control_status, ctl.u64);
> +	return 0;
> +}
> +
> +static void octeon_rng_cleanup(struct hwrng *rng)
> +{
> +	struct octeon_rng *p = (struct octeon_rng *)rng->priv;
> +	union cvmx_rnm_ctl_status ctl;
> +
> +	ctl.u64 = 0;
> +	/* Disable everything.  */
> +	cvmx_write_csr(p->control_status, ctl.u64);
> +}
> +
> +static int octeon_rng_data_read(struct hwrng *rng, u32 *data)
> +{
> +	struct octeon_rng *p = (struct octeon_rng *)rng->priv;
> +
> +	*data = cvmx_read64_uint32(p->result);
> +	return sizeof(u32);
> +}
> +
> +static struct hwrng octeon_rng_ops = {
> +	.name		= "octeon",
> +	.init		= octeon_rng_init,
> +	.cleanup	= octeon_rng_cleanup,
> +	.data_read	= octeon_rng_data_read
> +};
> +
> +static int __devinit octeon_rng_probe(struct platform_device *pdev)
> +{
> +	struct resource *res_ports;
> +	struct resource *res_result;
> +	struct octeon_rng *p;
> +	int ret;
> +
> +	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	res_ports = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res_ports)
> +		goto err_ports;
> +
> +	res_result = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res_result)
> +		goto err_ports;
> +
> +
> +	p->control_status = (u64)devm_ioremap_nocache(&pdev->dev,
> +						      res_ports->start,
> +						      sizeof(u64));

devm_ioremap_nocache() returns a `void __iomem *'.  Hence we should be
recording that value in a field of type `void __iomem *'.  Instead,
we're wedging it into a u64.

Something went wrong!

> +	if (!p->control_status)
> +		goto err_ports;
> +
> +	p->result = (u64)devm_ioremap_nocache(&pdev->dev,
> +					      res_result->start,
> +					      sizeof(u64));

Ditto.

> +	if (!p->result)
> +		goto err_r;
> +	octeon_rng_ops.priv = (unsigned long)p;

The hwrng.priv problem again.

> +	dev_set_drvdata(&pdev->dev, &octeon_rng_ops);
> +	ret = hwrng_register(&octeon_rng_ops);
> +	if (ret)
> +		goto err;
> +
> +	dev_info(&pdev->dev, "Octeon Random Number Generator\n");
> +
> +	return 0;
> +err:
> +	devm_iounmap(&pdev->dev, (void *)p->control_status);
> +err_r:
> +	devm_iounmap(&pdev->dev, (void *)p->result);
> +err_ports:
> +	devm_kfree(&pdev->dev, p);
> +	return -ENOENT;
> +}
> +
> +static int __exit octeon_rng_remove(struct platform_device *pdev)
> +{
> +	struct hwrng *rng = dev_get_drvdata(&pdev->dev);
> +
> +	hwrng_unregister(rng);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver octeon_rng_driver = {
> +	.driver = {
> +		.name		= "octeon_rng",
> +		.owner		= THIS_MODULE,
> +	},
> +	.probe		= octeon_rng_probe,
> +	.remove		= __exit_p(octeon_rng_remove),
> +};
> +
> +static int __init octeon_rng_mod_init(void)
> +{
> +	return platform_driver_register(&octeon_rng_driver);
> +}
> +
> +static void __exit octeon_rng_mod_exit(void)
> +{
> +	platform_driver_unregister(&octeon_rng_driver);
> +}
> +
> +module_init(octeon_rng_mod_init);
> +module_exit(octeon_rng_mod_exit);
> +
> +MODULE_AUTHOR("David Daney");
> +MODULE_LICENSE("GPL");

Please take another look and check that the selection of types was as
good as it could possibly be?

Also, let's all send rude emails to Herbert over the type of hwrng.priv ;)
