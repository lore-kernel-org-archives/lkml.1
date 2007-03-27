Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXC0OR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXC0OR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbXC0OR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:17:29 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4860 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbXC0OR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:17:28 -0400
Date: Tue, 27 Mar 2007 15:17:15 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Andrey Panin <pazke@donpac.ru>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for ITE887x serial chipsets
Message-ID: <20070327141715.GA20671@flint.arm.linux.org.uk>
Mail-Followup-To: Niels de Vos <niels.devos@wincor-nixdorf.com>,
	Andrey Panin <pazke@donpac.ru>, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070326141702.GA28306@deexvs01.wincor-nixdorf.com> <20070326201705.GA14403@pazke.donpac.ru> <20070327140303.GA11233@deexvs01.wincor-nixdorf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327140303.GA11233@deexvs01.wincor-nixdorf.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 04:03:03PM +0200, Niels de Vos wrote:
> +static int __devinit pci_ite887x_init(struct pci_dev *dev)
> +{
> ...
> +	if (ret > 0) {
> +		dev->dev.driver_data = iobase;
> +	} else {
> +		/* the device has no UARTs if we get here */
> +		release_region(iobase->start, ITE_887x_IOSIZE);
> +	}
> +
> +	return ret;
> +}
> +
> +static void __devexit pci_ite887x_exit(struct pci_dev *dev)
> +{
> +	struct resource *iobase = (struct resource*) dev->dev.driver_data;
> +	/* free the private driver data */
> +	release_region(iobase->start, ITE_887x_IOSIZE);
> +	dev->dev.driver_data = NULL;
> +}
> +

You can't do that.  dev->dev.driver_data is used by this very driver
itself to store its own data, or alternatively the parport_serial
driver to store its private data.  Therefore, dev->dev.driver_data
will be corrupted between your _init function setting it and your
_exit function using it.

Suggest you read the iobase back from the device to release it.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
