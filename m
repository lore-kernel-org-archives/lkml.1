Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZLNJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZLNJf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZLNJfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:35:24 -0500
Received: from darkstar.wilibox.com ([195.14.175.138]:51331 "EHLO
	darkstar.wilibox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZLNJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:35:23 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 04:35:23 EST
Message-ID: <4B260474.2010608@gmail.com>
Date: Mon, 14 Dec 2009 11:25:08 +0200
From: Darius Augulis <augulis.darius@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] 8250_pci: add support for MCS9865 / SYBA 6x Serial Port
   Card
References: <20091204222415.GB2816@ovro.caltech.edu>
In-Reply-To: <20091204222415.GB2816@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi community!

can anybody ack this simple patch and merge it to 2.6.33-rc1 ?
I still waiting for this half year!

Darius A.


On 12/05/2009 12:24 AM, Ira W. Snyder wrote:
> This patch is heavily based on an earlier patch found on the linux-serial
> mailing list [1], written by Darius Augulis.
>
> The previous incarnation of this patch only supported a 2x serial port
> card. I have added support for my SYBA 6x serial port card, and tested on
> x86.
>
> [1]: http://marc.info/?l=linux-serial&m=124975806304760
>
> Signed-off-by: Ira W. Snyder<iws@ovro.caltech.edu>
> Cc: Darius Augulis<augulis.darius@gmail.com>
> Cc: linux-serial@vger.kernel.org
> ---
>
> According to MAINTAINERS the 8250/16550 support currently lacks a
> maintainer. The earlier incarnation of this patch was posted all the way
> back in August.
>
> If necessary, I can post an incremental patch from the Darius' earlier
> patch. It would be great if someone could pick it up. I hate when new
> hardware doesn't work, especially something as simple as this.
>
>   drivers/parport/parport_pc.c |    6 ++++++
>   drivers/serial/8250_pci.c    |   22 +++++++++++++++++++++-
>   include/linux/pci_ids.h      |    1 +
>   3 files changed, 28 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index 2597145..85204f0 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -2908,6 +2908,7 @@ enum parport_pc_pci_cards {
>   	netmos_9805,
>   	netmos_9815,
>   	netmos_9901,
> +	netmos_9865,
>   	quatech_sppxp100,
>   };
>
> @@ -2989,6 +2990,7 @@ static struct parport_pc_pci {
>   	/* netmos_9805 */               { 1, { { 0, -1 }, } },
>   	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } },
>   	/* netmos_9901 */               { 1, { { 0, -1 }, } },
> +	/* netmos_9865 */               { 1, { { 0, -1 }, } },
>   	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
>   };
>
> @@ -3092,6 +3094,10 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
>   	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
>   	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
>   	  0xA000, 0x2000, 0, 0, netmos_9901 },
> +	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
> +	  0xA000, 0x1000, 0, 0, netmos_9865 },
> +	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
> +	  0xA000, 0x2000, 0, 0, netmos_9865 },
>   	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
>   	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
>   	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
> diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
> index b28af13..8b18c3c 100644
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -760,7 +760,8 @@ static int pci_netmos_init(struct pci_dev *dev)
>   	/* subdevice 0x00PS means<P>  parallel,<S>  serial */
>   	unsigned int num_serial = dev->subsystem_device&  0xf;
>
> -	if (dev->device == PCI_DEVICE_ID_NETMOS_9901)
> +	if ((dev->device == PCI_DEVICE_ID_NETMOS_9901) ||
> +		(dev->device == PCI_DEVICE_ID_NETMOS_9865))
>   		return 0;
>   	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM&&
>   			dev->subsystem_device == 0x0299)
> @@ -1479,6 +1480,7 @@ enum pci_board_num_t {
>
>   	pbn_b0_bt_1_115200,
>   	pbn_b0_bt_2_115200,
> +	pbn_b0_bt_4_115200,
>   	pbn_b0_bt_8_115200,
>
>   	pbn_b0_bt_1_460800,
> @@ -1703,6 +1705,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
>   		.base_baud	= 115200,
>   		.uart_offset	= 8,
>   	},
> +	[pbn_b0_bt_4_115200] = {
> +		.flags		= FL_BASE0|FL_BASE_BARS,
> +		.num_ports	= 4,
> +		.base_baud	= 115200,
> +		.uart_offset	= 8,
> +	},
>   	[pbn_b0_bt_8_115200] = {
>   		.flags		= FL_BASE0|FL_BASE_BARS,
>   		.num_ports	= 8,
> @@ -3649,6 +3657,18 @@ static struct pci_device_id serial_pci_tbl[] = {
>   		0, 0, pbn_b0_1_115200 },
>
>   	/*
> +	 * Best Connectivity PCI Multi I/O cards
> +	 */
> +
> +	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
> +		0xA000, 0x1000,
> +		0, 0, pbn_b0_1_115200 },
> +
> +	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
> +		0xA000, 0x3004,
> +		0, 0, pbn_b0_bt_4_115200 },
> +
> +	/*
>   	 * These entries match devices with class COMMUNICATION_SERIAL,
>   	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
>   	 */
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 84cf1f3..b2c0bf3 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2675,6 +2675,7 @@
>   #define PCI_DEVICE_ID_NETMOS_9835	0x9835
>   #define PCI_DEVICE_ID_NETMOS_9845	0x9845
>   #define PCI_DEVICE_ID_NETMOS_9855	0x9855
> +#define PCI_DEVICE_ID_NETMOS_9865	0x9865
>   #define PCI_DEVICE_ID_NETMOS_9901	0x9901
>
>   #define PCI_VENDOR_ID_3COM_2		0xa727

