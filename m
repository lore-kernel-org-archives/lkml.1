Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbYBHQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbYBHQvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbYBHQu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:50:58 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17005 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343AbYBHQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:50:57 -0500
Date: Fri, 8 Feb 2008 08:49:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Xilinx: hwicap driver
Message-Id: <20080208084954.9c311e36.randy.dunlap@oracle.com>
In-Reply-To: <20080208021747.92253161805C@mail10-sin.bigfish.com>
References: <47AB6552.7040503@gmail.com>
	<20080208021747.92253161805C@mail10-sin.bigfish.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Feb 2008 18:17:41 -0800 Stephen Neuendorffer wrote:

>  drivers/char/Kconfig                       |    7 +
>  drivers/char/Makefile                      |    1 +
>  drivers/char/xilinx_hwicap/Makefile        |    7 +
>  drivers/char/xilinx_hwicap/buffer_icap.c   |  380 ++++++++++++
>  drivers/char/xilinx_hwicap/buffer_icap.h   |   57 ++
>  drivers/char/xilinx_hwicap/fifo_icap.c     |  381 ++++++++++++
>  drivers/char/xilinx_hwicap/fifo_icap.h     |   62 ++
>  drivers/char/xilinx_hwicap/xilinx_hwicap.c |  923 ++++++++++++++++++++++++++++
>  drivers/char/xilinx_hwicap/xilinx_hwicap.h |  193 ++++++
>  9 files changed, 2011 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/char/xilinx_hwicap/Makefile
>  create mode 100644 drivers/char/xilinx_hwicap/buffer_icap.c
>  create mode 100644 drivers/char/xilinx_hwicap/buffer_icap.h
>  create mode 100644 drivers/char/xilinx_hwicap/fifo_icap.c
>  create mode 100644 drivers/char/xilinx_hwicap/fifo_icap.h
>  create mode 100644 drivers/char/xilinx_hwicap/xilinx_hwicap.c
>  create mode 100644 drivers/char/xilinx_hwicap/xilinx_hwicap.h
> 
> diff --git a/drivers/char/xilinx_hwicap/buffer_icap.c b/drivers/char/xilinx_hwicap/buffer_icap.c
> new file mode 100644
> index 0000000..dfea2bd
> --- /dev/null
> +++ b/drivers/char/xilinx_hwicap/buffer_icap.c
> @@ -0,0 +1,380 @@

> +/**
> + * buffer_icap_get_status: Get the contents of the status register.
> + * @parameter base_address: is the base address of the device
> + *

Hi,
For this function and many others in these source files:
Please see Documentation/kernel-doc-nano-HOWTO.txt for the correct
kernel-doc notation format.

If you have questions or need help, please ask.

Hints:
a. function name & short description: separate name & description with '-'
b. parameters are listed as: @base_address: (without "parameter")


> + * The status register contains the ICAP status and the done bit.
> + *
> + * D8 - cfgerr
> + * D7 - dalign
> + * D6 - rip
> + * D5 - in_abort_l
> + * D4 - Always 1
> + * D3 - Always 1
> + * D2 - Always 1
> + * D1 - Always 1
> + * D0 - Done bit
> + **/
> +static inline u32 buffer_icap_get_status(void __iomem *base_address)
> +{
> +	return in_be32(base_address + XHI_STATUS_REG_OFFSET);
> +}


> diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.h b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
> new file mode 100644
> index 0000000..5718679
> --- /dev/null
> +++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
> @@ -0,0 +1,193 @@

> +#ifndef XILINX_HWICAP_H_	/* prevent circular inclusions */
> +#define XILINX_HWICAP_H_	/* by using protection macros */
> +
> +#include <linux/types.h>
> +#include <linux/cdev.h>
> +#include <linux/version.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/io.h>
> +
> +struct hwicap_drvdata {

BTW, you can also use kernel-doc for structs, unions, & enums.

> +	u32 write_buffer_in_use;  /* Always in [0,3] */
> +	u8 write_buffer[4];
> +	u32 read_buffer_in_use;	  /* Always in [0,3] */
> +	u8 read_buffer[4];
> +	resource_size_t mem_start;/* phys. address of the control registers */
> +	resource_size_t mem_end;  /* phys. address of the control registers */
> +	resource_size_t mem_size;
> +	void __iomem *base_address;/* virt. address of the control registers */
> +
> +	struct device *dev;
> +	struct cdev cdev;	/* Char device structure */
> +	dev_t devt;
> +
> +	const struct hwicap_driver_config *config;
> +	const struct config_registers *config_regs;
> +	void *private_data;
> +	bool is_open;
> +	struct mutex sem;
> +};
> +
> +struct hwicap_driver_config {
> +	int (*get_configuration)(struct hwicap_drvdata *drvdata, u32 *data,
> +			u32 size);
> +	int (*set_configuration)(struct hwicap_drvdata *drvdata, u32 *data,
> +			u32 size);
> +	void (*reset)(struct hwicap_drvdata *drvdata);
> +};
> +
> +/* Number of times to poll the done regsiter */
> +#define XHI_MAX_RETRIES     10


---
~Randy
