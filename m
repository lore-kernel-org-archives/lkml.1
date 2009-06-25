Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZFYBjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZFYBjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 21:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZFYBjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 21:39:47 -0400
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:60573 "HELO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752430AbZFYBjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 21:39:46 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
Date: Wed, 24 Jun 2009 21:39:46 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909019BE1CE@mi8nycmail19.Mi8.com>
In-Reply-To: <4A3F017B.2010409@bluewatersys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
Thread-Index: Acny7Zc4SWEyo9NCTSOyHEHux5phawCRQZJg
References: <4A3F017B.2010409@bluewatersys.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Ryan Mallon" <ryan@bluewatersys.com>,
       "David Woodhouse" <dwmw2@infradead.org>,
       <linux-mtd@lists.infradead.org>,
       <spi-devel-general@lists.sourceforge.net>, <mike@steroidmicros.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Jun 2009 01:39:47.0617 (UTC) FILETIME=[D2D75910:01C9F535]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 21, 2009 8:59 PM, Ryan Mallon wrote:
>
> Add support for the non JEDEC SST25L SPI Flash devices.
>
> Signed-off-by: Andre Renaud <andre@bluewatersys.com>
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>

> +struct flash_info {
> +	const char		*name;
> +	u16			device_id;
> +	unsigned		page_size;
> +	unsigned		nr_pages;
> +	unsigned		erase_size;
> +};
> +
> +#define to_sst25l_flash(x) container_of(x, struct sst25l_flash, mtd)
> +
> +static struct flash_info __devinitdata sst25l_flash_info[] = {
> +	{"sst25lf020a", 0xbf43, 256, 1024, 32 * 1024},
> +	{"sst25lf040a",	0xbf44,	256, 2048, 32 * 1024},
> +};
> +

Ryan,

I finally got a chance to test this on my hardware.  Previously
I was using a hacked version on the m25p80 driver to access the
SST23LF020A on my board.

The driver works fine but you are only supporting the block erase,
SST25L_CMD_BLOCK_ERASE (opcode 0x52).  The SST25L chips also can do a
sector erase (opcode 0x20) and a full chip erase (opcode 0x60).

The full chip erase is not that important but might give a slight
performance increase on larger devices.  Max block erase time is
listed as 25ms at 25MHz in the datasheet.  The SST25LF020A contains
8 blocks so it's "typical" full chip erase time should be around
200ms.  For comparison, the chip erase time is listed as 100ms.

The sector erase is a bigger deal.  On the EDB93xx boards one of the
SPI flash uses is used to store the MAC address at offset 0x2000 (4K
offset).  The board can also be configured to boot from offset 0x0000
in the SPI flash.  This basically gives the user a three partition
setup:

static struct mtd_partition edb93xx_spi_flash_partitions[] = {
	{
		.name	= "SPI bootstrap",
		.offset	= 0,
		.size	= SZ_4K,
	}, {
		.name	= "Bootstrap config",
		.offset	= MTDPART_OFS_APPEND,
		.size	= SZ_4K,
	}, {
		.name	= "unallocated",
		.offset	= MTDPART_OFS_APPEND,
		.size	= MTDPART_SIZ_FULL,
	},
};

Without the sector erase this partition setup results in all of the
partitions being forced read-only.

Just my two cents...

Regards,
Hartley
