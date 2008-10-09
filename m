Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYJIQro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYJIQro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYJIQrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:47:35 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:52943 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYJIQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:47:33 -0400
Date: Thu, 9 Oct 2008 19:47:23 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] OMAP SSI API documentation
Message-ID: <20081009164715.GB12091@frodo>
Reply-To: me@felipebalbi.com
References: <1223034606.32631.156.camel@groo.research.nokia.com> <1223034750-18690-1-git-send-email-carlos.chinea@nokia.com> <1223034750-18690-2-git-send-email-carlos.chinea@nokia.com> <1223034750-18690-3-git-send-email-carlos.chinea@nokia.com> <1223034750-18690-4-git-send-email-carlos.chinea@nokia.com> <1223034750-18690-5-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223034750-18690-5-git-send-email-carlos.chinea@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 02:52:30PM +0300, Carlos Chinea wrote:

there are issues in the documentation as well.

> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  Documentation/arm/OMAP/ssi/board-ssi.c.example |  216 ++++++++++++++++++++++
>  Documentation/arm/OMAP/ssi/ssi                 |  232 ++++++++++++++++++++++++
>  2 files changed, 448 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/arm/OMAP/ssi/board-ssi.c.example
>  create mode 100644 Documentation/arm/OMAP/ssi/ssi
> 
> diff --git a/Documentation/arm/OMAP/ssi/board-ssi.c.example b/Documentation/arm/OMAP/ssi/board-ssi.c.example
> new file mode 100644
> index 0000000..a346628
> --- /dev/null
> +++ b/Documentation/arm/OMAP/ssi/board-ssi.c.example
> @@ -0,0 +1,216 @@
> +/*
> + * board-ssi.c.example
> + *
> + * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
> + *
> + * Contact: Carlos Chinea <carlos.chinea@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#ifdef CONFIG_OMAP_SSI

don't ifdef here. This file should only be built if SSI is selected.

> +
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/ssi_driver_if.h>
> +#include <mach/ssi/ssi_sys_reg.h>
> +#include <mach/ssi/ssi_ssr_reg.h>
> +#include <mach/ssi/ssi_sst_reg.h>

you see how many includes you need to make it work ?

It should be #include <linux/ssi.h> and that's all. This driver can be
generic enough to build and work on non-omap platforms, can't it ?

> +
> +#include "clock.h"
> +
> +struct ssi_internal_clk {
> +	struct clk clk;
> +	struct clk **childs;
> +	int n_childs;
> +	struct platform_device *pdev;

why do you need to let the internal clock know so much about the user ?
I think struct device * should be enough here.

> +};
> +
> +static struct ssi_internal_clk ssi_clock;
> +
> +static void ssi_pdev_release(struct device *dev)
> +{
> +}
> +
> +static struct ssi_port_pd ssi_ports[] = {
> +	[0] = {
> +		.tx_mode = SSI_MODE_FRAME,
> +		.tx_frame_size = SSI_FRAMESIZE_DEFAULT,
> +		.divisor = SSI_DIVISOR_DEFAULT,
> +		.tx_ch = SSI_CHANNELS_DEFAULT,
> +		.arb_mode = SSI_ARBMODE_ROUNDROBIN,
> +		.rx_mode = SSI_MODE_FRAME,
> +		.rx_frame_size = SSI_FRAMESIZE_DEFAULT,
> +		.rx_ch = SSI_CHANNELS_DEFAULT,
> +		.timeout = SSI_TIMEOUT_DEFAULT,
> +		.n_irq = 0,
> +		},

tabify these.

> +};
> +
> +static struct ssi_platform_data ssi_p_d = {
> +	.clk_name = "ssi_clk",
> +	.num_ports = ARRAY_SIZE(ssi_ports),
> +	.ports = ssi_ports,

tabify

> +};
> +
> +static struct resource ssi_resources[] = {
> +	[0] = {
> +		.start = SSI_IOMEM_BASE_ADDR,
> +		.end = SSI_IOMEM_BASE_ADDR + SSI_IOMEM_SIZE,
> +		.name = SSI_IOMEM_NAME,
> +		.flags = IORESOURCE_MEM,
> +		},

tabify and the closing bracket should be aligned with [0]

> +	[1] = 	{
	     ^  trailing whitespace

> +		.start = SSI_P1_MPU_IRQ0,
> +		.end = SSI_P1_MPU_IRQ0,
> +		.name = SSI_P1_MPU_IRQ0_NAME,
> +		.flags = IORESOURCE_IRQ,
> +		},

tabify
tabify and the closing bracket should be aligned with [1]

> +	[2] = 	{
	     ^  trailing whitespace

> +		.start = SSI_P1_MPU_IRQ1,
> +		.end = SSI_P1_MPU_IRQ1,
> +		.name = SSI_P1_MPU_IRQ1_NAME,
> +		.flags = IORESOURCE_IRQ,
> +		},

tabify
tabify and the closing bracket should be aligned with [2]

> +	[3] = 	{
	     ^  trailing whitespace

> +		.start = SSI_P2_MPU_IRQ0,
> +		.end = SSI_P2_MPU_IRQ0,
> +		.name = SSI_P2_MPU_IRQ0_NAME,
> +		.flags = IORESOURCE_IRQ,
> +		},

tabify
tabify and the closing bracket should be aligned with [3]

> +	[4] = 	{
	     ^  trailing whitespace

> +		.start = SSI_P2_MPU_IRQ1,
> +		.end = SSI_P2_MPU_IRQ1,
> +		.name = SSI_P2_MPU_IRQ1_NAME,
> +		.flags = IORESOURCE_IRQ,
> +		},

tabify
tabify and the closing bracket should be aligned with [4]

> +	[5] = 	{
	     ^  trailing whitespace

> +		.start = SSI_GDD_MPU_IRQ,
> +		.end = SSI_GDD_MPU_IRQ,
> +		.name = SSI_GDD_MPU_IRQ_NAME,
> +		.flags = IORESOURCE_IRQ,
> +		},

tabify and the closing bracket should be aligned with [5]

> +};
> +
> +static struct platform_device ssi_pdev = {
> +	.name = "omap_ssi",
> +	.id = -1,
> +	.num_resources = ARRAY_SIZE(ssi_resources),
> +	.resource = ssi_resources,
> +	.dev = 	{
	      ^  trailing whitespace

> +		.release = ssi_pdev_release,
> +		.platform_data = &ssi_p_d,
> +		},

this bracket should be aligned with .dev

> +};
> +
> +static void set_ssi_mode(struct platform_device *pdev, u32 mode)
> +{
> +	void __iomem *base = (void __iomem *)pdev->resource[0].start;

this is wrong, looks like mode sould be passed down to the driver and
the driver would set_ssi_mode().

> +	int port;
> +	int num_ports = ((struct ssi_platform_data *)

the cast is unnecessary and you're abusing platform_data, I'd say.

> +					(pdev->dev.platform_data))->num_ports;
> +
> +	for (port = 0; port < num_ports; port++) {
> +		outl(mode, OMAP2_IO_ADDRESS(base + SSI_SST_MODE_REG(port)));
> +		outl(mode, OMAP2_IO_ADDRESS(base + SSI_SSR_MODE_REG(port)));
> +	}
> +}
> +
> +static int ssi_clk_init(struct ssi_internal_clk *ssi_clk)
> +{
> +	const char *clk_names[] = { "ssi_ick", "ssi_ssr_fck" };
> +	int i;
> +	int j;
> +
> +	ssi_clk->n_childs = ARRAY_SIZE(clk_names);
> +	ssi_clk->childs = kzalloc(ssi_clk->n_childs * sizeof(*ssi_clk->childs),
> +								GFP_KERNEL);
> +	if (!ssi_clk->childs)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < ssi_clk->n_childs; i++) {
> +		ssi_clk->childs[i] = clk_get(NULL, clk_names[i]);
> +		if (IS_ERR(ssi_clk->childs[i])) {
> +			pr_err("Unable to get SSI clock: %s", clk_names[i]);
> +			for (j = i - 1; j >= 0; j--)
> +				clk_put(ssi_clk->childs[j]);
> +			return -ENODEV;
> +		}
> +	}

this looks like it should be done by the driver and not board-specific.

> +
> +	return 0;
> +}
> +
> +static int ssi_clk_enable(struct clk *clk)
> +{
> +	struct ssi_internal_clk *ssi_clk =
> +				container_of(clk, struct ssi_internal_clk, clk);
> +	int err = 0;
> +	int i;
> +	int j;
> +
> +	for (i = 0; ((i < ssi_clk->n_childs) && (err >= 0)); i++)
> +		err = omap2_clk_enable(ssi_clk->childs[i]);
> +
> +	if (unlikely(err < 0)) {
> +		pr_err("Error on SSI clk %d\n", i);
> +		for (j = i - 1; j >= 0; j--)
> +			omap2_clk_disable(ssi_clk->childs[j]);

if you get and error, return already, will avoid the else below.

> +	} else {
> +		if (ssi_clk->clk.usecount == 1)
> +			set_ssi_mode(ssi_clk->pdev, SSI_MODE_FRAME);
> +	}
> +
> +	return err;
> +}
> +
> +static void ssi_clk_disable(struct clk *clk)
> +{
> +	struct ssi_internal_clk *ssi_clk =
> +				container_of(clk, struct ssi_internal_clk, clk);
> +
> +	int i;
> +
> +	if (ssi_clk->clk.usecount == 0)
> +		set_ssi_mode(ssi_clk->pdev, SSI_MODE_SLEEP);
> +
> +	for (i = 0; i < ssi_clk->n_childs; i++)
> +		omap2_clk_disable(ssi_clk->childs[i]);
> +}
> +
> +static struct ssi_internal_clk ssi_clock = {
> +	.clk = {
> +		.name = "ssi_clk",
> +		.id = -1,
> +		.enable = ssi_clk_enable,
> +		.disable = ssi_clk_disable,
> +	},
> +	.pdev = &ssi_pdev,
> +};

it doesn't look like you do anything useful with this ssi_internal_clk
structure. I'd say you can move the clk definition to <mach/clock.h> if
Tony, Paul and Kevin are ok with it.

> +
> +void __init ssi_init(void)
> +{
> +	int err;
> +
> +	ssi_clk_init(&ssi_clock);
> +	clk_register(&ssi_clock.clk);
> +
> +	err = platform_device_register(&ssi_pdev);
> +	if (err < 0)
> +		pr_err("Unable to register SSI platform device: %d\n", err);

if the clk definition can be moved to <mach/clock.h> then you can
simply:

return platform_device_register(&ssi_pdev);

> +}
> +#endif
> diff --git a/Documentation/arm/OMAP/ssi/ssi b/Documentation/arm/OMAP/ssi/ssi
> new file mode 100644
> index 0000000..990ae48
> --- /dev/null
> +++ b/Documentation/arm/OMAP/ssi/ssi

let's use an extension to this file: ssi.txt

> @@ -0,0 +1,232 @@
> +OMAP SSI API's How To
> +=====================
> +
> +The Synchronous Serial Interface (SSI) is a high speed communication interface
> +that is used for connecting OMAP to a cellular modem engine.
> +
> +The SSI interface supports full duplex communication over multiple channels and
> +is capable of reaching speeds up to 110 Mbit/s
> +
> +I OMAP SSI driver API overview
> +-----------------------------
> +
> +A) SSI Bus, SSI channels and protocol drivers overview. 
							  ^ trailing whitespace

> +
> +The OMAP SSI driver is intended to be used inside the kernel by protocol drivers.
> +
> +The OMAP SSI abstracts the concept of SSI channels by creating an SSI bus an

s/an/and (at the end)

> +attaching SSI channel devices to it.(see Figure 1)
				       ^ add a space

> +
> +Protocol drivers will then claim one or more SSI channels, after registering with the OMAP SSI driver.
> +
> +	+---------------------+		+----------------+
> +	+  SSI channel device +		+  SSI protocol  +
> +	+  (omap_ssi.pX-cY)   +	<-------+  driver        +
> +	+---------------------+		+----------------+
> +		|				|
> +(/sys/bus/ssi/devices/omap_ssi.pX-cy)	(/sys/bus/ssi/drivers/ssi_protocol)
> +		|				|
> ++---------------------------------------------------------------+
> ++			SSI bus					+	
> ++---------------------------------------------------------------+	
> +	
> +			Figure 1.
> +
> +(NOTE: omap_ssi.pX-cY represents the SSI channel Y on port X from the omap_ssi
> +device)

you could go simpler and call it:

/sys/bus/ssi/devices/X-Y: (X == port, Y == channel);

> +
> +B) Data transfers
> +
> +The OMAP SSI driver exports an asynchronous interface for sending and receiving
> +data over the SSI channels. Protocol drivers will register a set of read and write
> +completion callbacks for each SSI channel they use.
> +
> +Protocol drivers call ssi_write/ssi_read functions to signal the OMAP SSI driver
> +that is willing to write/read data to/from a channel. Transfers are completed only
> +when the OMAP SSI driver calls the completion callback.
> +
> +An SSI channel can simultaneously have both a read and a write request
> +pending, however, requests cannot be queued.
> +
> +It is safe to call ssi_write/ssi_read functions inside the callbacks functions.
> +In fact, a protocol driver should normally re-issue the read request from within
> +the read callback, in order to not miss any incoming messages.
> +
> +C) Error handling
> +
> +SSI is a multi channel interface but the channels share the same physical wires.
> +Therefore, any transmission error potentially affects all the protocol drivers
> +that sit on top of the SSI driver. Whenever an error occurs, it is broadcasted to
> +all protocol drivers.
> +
> +Errors are signaled to the protocol drivers through the port_event callback.
> +Protocol drivers can avoid receiving those notifications by not setting the
> +SSI_EVENT_ERROR in the event_mask field.(see struct ssi_device_driver)
> +
> +Completion callbacks functions are only called when a transfer has succeed.
> +
> +II OMAP SSI API's
> +-----------------
> +
> +A) Include
> +
> +#include<linux/ssi_driver_if.h>
> +
> +B) int register_ssi_driver(struct ssi_device_driver *driver);
> +
> +Description: Register an SSI protocol driver
> +
> +Parameter: A protocol driver declaration (see struct ssi_device_driver)
> +
> +B) void unregister_ssi_driver(struct ssi_device_driver *driver);
> +
> +Description: Unregister an SSI protocol driver
> +
> +Parameter: A protocol driver declaration (see struct ssi_device_driver)
> +
> +C) int ssi_open(struct ssi_device *dev);
> +
> +Description: Open an SSI device channel
> +
> +Parameter: The SSI channel
> +
> +D) int ssi_write(struct ssi_device *dev, u32 *data, unsigned int count);
> +
> +Description: Send data through an SSI channel. The transfer is only completed
> +when the write_complete callback is called
> +
> +Parameters:
> +	- dev: SSI channel
> +	- data: pointer to the data to send
> +	- count: number of 32-bit words to be sent
> +
> +E) void ssi_write_cancel(struct ssi_device *dev);
> +
> +Description: Cancel current pending write operation
> +
> +Parameters: SSI channel
> +	
> +F) int ssi_read(struct ssi_device *dev, u32 *data, unsigned int w_count);
> +
> +Description: Receive data through an SSI channel. The transfer is only completed
> +when the read_complete callback is called
> +
> +Parameters:
> +	- dev: SSI channel
> +	- data: pointer where to store the data
> +	- count: number of 32-bit words to be read
> +
> +
> +G) void ssi_read_cancel(struct ssi_device *dev);
> +
> +Description: Cancel current pending read operation
> +
> +Parameters: SSI channel
> +
> +H) int ssi_ioctl(struct ssi_device *dev, unsigned int command, void *arg);
> +
> +Description: Apply some control command to the port associated to the given
> +SSI channel
> +
> +Parameters:
> +	- dev: SSI channel
> +	- command: command to execute
> +	- arg: parameter for the control command
> +
> +Commands:
> +	- SSI_IOCTL_WAKE_UP: 
> +		Description: Set SSI wakeup line for the channel
> +		Parameters: None
> +	- SSI_IOCTL_WAKE_DOWN:
> +		Description: Unset SSI wakeup line for the channel
> +		Parameters: None
> +	- SSI_IOCTL_SEND_BREAK:
> +		Description: Send a HW BREAK frame in FRAME mode
> +		Parameters: None
> +	- SSI_IOCTL_WAKE:
> +		Description: Get wakeup line status
> +		Parameters: Pointer to a u32 variable to return result
> +		(Result: 0 means wakeline DOWN, other result means wakeline UP)
> +
> +I)void ssi_close(struct ssi_device *dev);
> +
> +Description: Close an SSI channel
> +
> +Parameters: The SSI channel to close
> +
> +J) void ssi_dev_set_cb(	struct ssi_device *dev,
> +			void (*r_cb)(struct ssi_device *dev),
> +			void (*w_cb)(struct ssi_device *dev));
> +
> +Description: Set the read and write callbacks for the SSI channel. This
> +function is usually called in the probe function of the SSI protocol driver to
> +set completion callbacks for the asynchronous read and write transfer
> +
> +Parameters:
> +	- dev: SSI channel
> +	- r_cb: Pointer to a callback function to signal that a read transfer is
> +		completed
> +	- w_cb: Pointer to a callback function to signal that a write transfer
> +		is completed
> +
> +H) struct ssi_device_driver
> +
> +Description: Protocol drivers pass this struct to the register_ssi_driver function
> +in order to register with the OMAP SSI driver. Among other things it tells the
> +OMAP SSI driver which channels the protocol driver wants to allocate for its use
> +
> +Declaration:
> +struct ssi_device_driver {
> +	unsigned long		ctrl_mask;
> +	unsigned long		ch_mask[SSI_MAX_PORTS];
> +	unsigned long		event_mask;
> +	void 			(*port_event) (int c_id, unsigned int port,
> +						unsigned int event, void *arg);
> +	int			(*probe)(struct ssi_device *dev);
> +	int			(*remove)(struct ssi_device *dev);
> +	int			(*suspend)(struct ssi_device *dev,
> +						pm_message_t mesg);
> +	int			(*resume)(struct ssi_device *dev);
> +	struct device_driver 	driver;
> +};
> +
> +Fields description:
> +	ctrl_mask: SSI block ids to use
> +	ch_mask[SSI_MAX_PORTS]: SSI channels to use
> +	event_mask: SSI events to be notified
> +	port_event: Function callback for notifying SSI events
> +		   (i.e.: error transfer)
> +		Parameters:
> +			c_id: SSI Block id which generate the event
> +			port: Port number which generate the event
> +			event: Event code
> +	probe: Probe function
> +		Parameters: SSI channel
> +	remove: Remove function
> +		Parameters: SSI channel
> +
> +Example:
> +
> +static struct ssi_device_driver ssi_protocol_driver = {
> +	.ctrl_mask = ANY_SSI_CONTROLLER,
> +	.ch_mask[0] = CHANNEL(0) | CHANNEL(1),
> +	.event_mask = SSI_EVENT_ERROR_MASK,
> +	.port_event = port_event_callback,
> +	.probe = ssi_proto_probe,
> +	.remove = __devexit_p(ssi_proto_remove),
> +	.driver = {
> +			.name = "ssi_protocol",
> +	},
> +};
> +
> +
> +III OMAP SSI platform_device
> +----------------------------
> +
> +You can find a example of how to define an SSI platform device in:
> +
> +Documentation/arm/OMAP/ssi/board-ssi.c.example
> +
> +=================================================
> +Contact: Carlos Chinea <carlos.chinea@nokia.com>
> +Copyright (C) 2008 Nokia Corporation.
> -- 
> 1.5.3.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
balbi
