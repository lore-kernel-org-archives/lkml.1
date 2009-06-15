Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZFODVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZFODVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZFODRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:17:06 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:56547
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755806AbZFODRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:17:03 -0400
Message-ID: <4A35BD7F.3020803@bluewatersys.com>
Date: Mon, 15 Jun 2009 15:18:23 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Brian Swetland <swetland@google.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, Robert Love <rlove@google.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard
 serial	peripheral.
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com>
In-Reply-To: <1245033557-10968-2-git-send-email-swetland@google.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Swetland wrote:
> From: Robert Love <rlove@google.com>
> 
> Signed-off-by: Brian Swetland <swetland@google.com>

Hi Brian, some comments below:

> +
> +struct msm_port {
> +	struct uart_port	uart;
> +	char			name[16];
> +	struct clk		*clk;
> +	unsigned int		imr;
> +};
> +
> +#define UART_TO_MSM(uart_port)	((struct msm_port *) uart_port)

Should this be:

#define to_msm_uart(up) container_of(up, msm_port, uart_port)

Container conversion macros are usually lower case.

> +static int msm_startup(struct uart_port *port)
> +{
> +	struct msm_port *msm_port = UART_TO_MSM(port);
> +	unsigned int data, rfr_level;
> +	int ret;
> +
> +	snprintf(msm_port->name, sizeof(msm_port->name),
> +		 "msm_serial%d", port->line);
> +
> +	ret = request_irq(port->irq, msm_irq, IRQF_TRIGGER_HIGH,
> +			  msm_port->name, port);
> +	if (unlikely(ret))
> +		return ret;

Not sure that you need the likely/unlikely macros here or in the other
startup/release functions. They are usually for hot-path code. They
aren't strictly wrong, its just probably not necessary.

> +
> +static struct uart_ops msm_uart_pops = {
> +	.tx_empty = msm_tx_empty,
> +	.set_mctrl = msm_set_mctrl,
> +	.get_mctrl = msm_get_mctrl,
> +	.stop_tx = msm_stop_tx,
> +	.start_tx = msm_start_tx,
> +	.stop_rx = msm_stop_rx,
> +	.enable_ms = msm_enable_ms,
> +	.break_ctl = msm_break_ctl,
> +	.startup = msm_startup,
> +	.shutdown = msm_shutdown,
> +	.set_termios = msm_set_termios,
> +	.type = msm_type,
> +	.release_port = msm_release_port,
> +	.request_port = msm_request_port,
> +	.config_port = msm_config_port,
> +	.verify_port = msm_verify_port,
> +	.pm = msm_power,
> +};

Tab-delimit this to make it look nicer, ie:

	.tx_empty	= msm_tx_empty,
	.set_mctrl	= msm_set_mctrl,
	...

> +
> +static struct msm_port msm_uart_ports[] = {
> +	{
> +		.uart = {
> +			.iotype = UPIO_MEM,
> +			.ops = &msm_uart_pops,
> +			.flags = UPF_BOOT_AUTOCONF,
> +			.fifosize = 512,
> +			.line = 0,
> +		},

Same here, and all the other struct initialisations.

> +
> +static int __init msm_console_setup(struct console *co, char *options)
> +{
> +	struct uart_port *port;
> +	int baud, flow, bits, parity;
> +
> +	if (unlikely(co->index >= UART_NR || co->index < 0))
> +		return -ENXIO;
> +
> +	port = get_port_from_line(co->index);
> +
> +	if (unlikely(!port->membase))
> +		return -ENXIO;
> +
> +	port->cons = co;
> +
> +	msm_init_clock(port);
> +
> +	if (options)
> +		uart_parse_options(options, &baud, &parity, &bits, &flow);
> +
> +	bits = 8;
> +	parity = 'n';
> +	flow = 'n';
> +	msm_write(port, UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE,
> +		  UART_MR2);	/* 8N1 */
> +
> +	if (baud < 300 || baud > 115200)
> +		baud = 115200;

return -EINVAL?

> +	msm_set_baud_rate(port, baud);
> +
> +	msm_reset(port);
> +
> +	printk(KERN_INFO "msm_serial: console setup on port #%d\n", port->line);

pr_info? Also, this may just be noise, IIRC, the serial sub-system
prints information about the uarts anyway.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
