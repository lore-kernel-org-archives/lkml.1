Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbZFQMSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbZFQMSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZFQMRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:17:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZFQMRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:17:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=JLOSOe5gqa6wA3KXqx3iRK/3r47Kqfo5lHlQLFP7U7d24OaKOXAMbXegJh+KZdfdU
	A1wstLlQlprwxbVwq6NZA==
MIME-Version: 1.0
In-Reply-To: <1245033557-10968-2-git-send-email-swetland@google.com>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
Date: Wed, 17 Jun 2009 08:17:51 -0400
Message-ID: <21c5ff280906170517y65de7326t6e4c8f3faaf543dd@mail.gmail.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard 
	serial peripheral.
From: Robert Love <rlove@google.com>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Love <rlove@google.com>

      Robert


On Sun, Jun 14, 2009 at 10:39 PM, Brian Swetland<swetland@google.com> wrote:
> From: Robert Love <rlove@google.com>
>
> Signed-off-by: Brian Swetland <swetland@google.com>
> ---
>  drivers/serial/Kconfig      |   10 +
>  drivers/serial/Makefile     |    1 +
>  drivers/serial/msm_serial.c |  767 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/serial/msm_serial.h |  117 +++++++
>  include/linux/serial_core.h |    3 +
>  5 files changed, 898 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/serial/msm_serial.c
>  create mode 100644 drivers/serial/msm_serial.h
>
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 1132c5c..037c1e0 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1320,6 +1320,16 @@ config SERIAL_SGI_IOC3
>          If you have an SGI Altix with an IOC3 serial card,
>          say Y or M.  Otherwise, say N.
>
> +config SERIAL_MSM
> +       bool "MSM on-chip serial port support"
> +       depends on ARM && ARCH_MSM
> +       select SERIAL_CORE
> +
> +config SERIAL_MSM_CONSOLE
> +       bool "MSM serial console support"
> +       depends on SERIAL_MSM=y
> +       select SERIAL_CORE_CONSOLE
> +
>  config SERIAL_NETX
>        tristate "NetX serial port support"
>        depends on ARM && ARCH_NETX
> diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
> index 45a8658..d5a2998 100644
> --- a/drivers/serial/Makefile
> +++ b/drivers/serial/Makefile
> @@ -71,6 +71,7 @@ obj-$(CONFIG_SERIAL_SGI_IOC4) += ioc4_serial.o
>  obj-$(CONFIG_SERIAL_SGI_IOC3) += ioc3_serial.o
>  obj-$(CONFIG_SERIAL_ATMEL) += atmel_serial.o
>  obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
> +obj-$(CONFIG_SERIAL_MSM) += msm_serial.o
>  obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
>  obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
>  obj-$(CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL) += nwpserial.o
> diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
> new file mode 100644
> index 0000000..1a7c856
> --- /dev/null
> +++ b/drivers/serial/msm_serial.c
> @@ -0,0 +1,767 @@
> +/*
> + * drivers/serial/msm_serial.c - driver for msm7k serial device and console
> + *
> + * Copyright (C) 2007 Google, Inc.
> + * Author: Robert Love <rlove@google.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#if defined(CONFIG_SERIAL_MSM_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +# define SUPPORT_SYSRQ
> +#endif
> +
> +#include <linux/hrtimer.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/irq.h>
> +#include <linux/init.h>
> +#include <linux/console.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/serial_core.h>
> +#include <linux/serial.h>
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +
> +#include "msm_serial.h"
> +
> +struct msm_port {
> +       struct uart_port        uart;
> +       char                    name[16];
> +       struct clk              *clk;
> +       unsigned int            imr;
> +};
> +
> +#define UART_TO_MSM(uart_port) ((struct msm_port *) uart_port)
> +
> +static inline void msm_write(struct uart_port *port, unsigned int val,
> +                            unsigned int off)
> +{
> +       __raw_writel(val, port->membase + off);
> +}
> +
> +static inline unsigned int msm_read(struct uart_port *port, unsigned int off)
> +{
> +       return __raw_readl(port->membase + off);
> +}
> +
> +static void msm_stop_tx(struct uart_port *port)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +
> +       msm_port->imr &= ~UART_IMR_TXLEV;
> +       msm_write(port, msm_port->imr, UART_IMR);
> +}
> +
> +static void msm_start_tx(struct uart_port *port)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +
> +       msm_port->imr |= UART_IMR_TXLEV;
> +       msm_write(port, msm_port->imr, UART_IMR);
> +}
> +
> +static void msm_stop_rx(struct uart_port *port)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +
> +       msm_port->imr &= ~(UART_IMR_RXLEV | UART_IMR_RXSTALE);
> +       msm_write(port, msm_port->imr, UART_IMR);
> +}
> +
> +static void msm_enable_ms(struct uart_port *port)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +
> +       msm_port->imr |= UART_IMR_DELTA_CTS;
> +       msm_write(port, msm_port->imr, UART_IMR);
> +}
> +
> +static void handle_rx(struct uart_port *port)
> +{
> +       struct tty_struct *tty = port->info->port.tty;
> +       unsigned int sr;
> +
> +       /*
> +        * Handle overrun. My understanding of the hardware is that overrun
> +        * is not tied to the RX buffer, so we handle the case out of band.
> +        */
> +       if ((msm_read(port, UART_SR) & UART_SR_OVERRUN)) {
> +               port->icount.overrun++;
> +               tty_insert_flip_char(tty, 0, TTY_OVERRUN);
> +               msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
> +       }
> +
> +       /* and now the main RX loop */
> +       while ((sr = msm_read(port, UART_SR)) & UART_SR_RX_READY) {
> +               unsigned int c;
> +               char flag = TTY_NORMAL;
> +
> +               c = msm_read(port, UART_RF);
> +
> +               if (sr & UART_SR_RX_BREAK) {
> +                       port->icount.brk++;
> +                       if (uart_handle_break(port))
> +                               continue;
> +               } else if (sr & UART_SR_PAR_FRAME_ERR) {
> +                       port->icount.frame++;
> +               } else {
> +                       port->icount.rx++;
> +               }
> +
> +               /* Mask conditions we're ignorning. */
> +               sr &= port->read_status_mask;
> +
> +               if (sr & UART_SR_RX_BREAK) {
> +                       flag = TTY_BREAK;
> +               } else if (sr & UART_SR_PAR_FRAME_ERR) {
> +                       flag = TTY_FRAME;
> +               }
> +
> +               if (!uart_handle_sysrq_char(port, c))
> +                       tty_insert_flip_char(tty, c, flag);
> +       }
> +
> +       tty_flip_buffer_push(tty);
> +}
> +
> +static void handle_tx(struct uart_port *port)
> +{
> +       struct circ_buf *xmit = &port->info->xmit;
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +       int sent_tx;
> +
> +       if (port->x_char) {
> +               msm_write(port, port->x_char, UART_TF);
> +               port->icount.tx++;
> +               port->x_char = 0;
> +       }
> +
> +       while (msm_read(port, UART_SR) & UART_SR_TX_READY) {
> +               if (uart_circ_empty(xmit)) {
> +                       /* disable tx interrupts */
> +                       msm_port->imr &= ~UART_IMR_TXLEV;
> +                       msm_write(port, msm_port->imr, UART_IMR);
> +                       break;
> +               }
> +
> +               msm_write(port, xmit->buf[xmit->tail], UART_TF);
> +
> +               xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
> +               port->icount.tx++;
> +               sent_tx = 1;
> +       }
> +
> +       if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> +               uart_write_wakeup(port);
> +}
> +
> +static void handle_delta_cts(struct uart_port *port)
> +{
> +       msm_write(port, UART_CR_CMD_RESET_CTS, UART_CR);
> +       port->icount.cts++;
> +       wake_up_interruptible(&port->info->delta_msr_wait);
> +}
> +
> +static irqreturn_t msm_irq(int irq, void *dev_id)
> +{
> +       struct uart_port *port = dev_id;
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +       unsigned int misr;
> +
> +       spin_lock(&port->lock);
> +       misr = msm_read(port, UART_MISR);
> +       msm_write(port, 0, UART_IMR); /* disable interrupt */
> +
> +       if (misr & (UART_IMR_RXLEV | UART_IMR_RXSTALE))
> +               handle_rx(port);
> +       if (misr & UART_IMR_TXLEV)
> +               handle_tx(port);
> +       if (misr & UART_IMR_DELTA_CTS)
> +               handle_delta_cts(port);
> +
> +       msm_write(port, msm_port->imr, UART_IMR); /* restore interrupt */
> +       spin_unlock(&port->lock);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static unsigned int msm_tx_empty(struct uart_port *port)
> +{
> +       return (msm_read(port, UART_SR) & UART_SR_TX_EMPTY) ? TIOCSER_TEMT : 0;
> +}
> +
> +static unsigned int msm_get_mctrl(struct uart_port *port)
> +{
> +       return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR | TIOCM_RTS;
> +}
> +
> +static void msm_set_mctrl(struct uart_port *port, unsigned int mctrl)
> +{
> +       unsigned int mr;
> +
> +       mr = msm_read(port, UART_MR1);
> +
> +       if (!(mctrl & TIOCM_RTS)) {
> +               mr &= ~UART_MR1_RX_RDY_CTL;
> +               msm_write(port, mr, UART_MR1);
> +               msm_write(port, UART_CR_CMD_RESET_RFR, UART_CR);
> +       } else {
> +               mr |= UART_MR1_RX_RDY_CTL;
> +               msm_write(port, mr, UART_MR1);
> +       }
> +}
> +
> +static void msm_break_ctl(struct uart_port *port, int break_ctl)
> +{
> +       if (break_ctl)
> +               msm_write(port, UART_CR_CMD_START_BREAK, UART_CR);
> +       else
> +               msm_write(port, UART_CR_CMD_STOP_BREAK, UART_CR);
> +}
> +
> +static void msm_set_baud_rate(struct uart_port *port, unsigned int baud)
> +{
> +       unsigned int baud_code, rxstale, watermark;
> +
> +       switch (baud) {
> +       case 300:
> +               baud_code = UART_CSR_300;
> +               rxstale = 1;
> +               break;
> +       case 600:
> +               baud_code = UART_CSR_600;
> +               rxstale = 1;
> +               break;
> +       case 1200:
> +               baud_code = UART_CSR_1200;
> +               rxstale = 1;
> +               break;
> +       case 2400:
> +               baud_code = UART_CSR_2400;
> +               rxstale = 1;
> +               break;
> +       case 4800:
> +               baud_code = UART_CSR_4800;
> +               rxstale = 1;
> +               break;
> +       case 9600:
> +               baud_code = UART_CSR_9600;
> +               rxstale = 2;
> +               break;
> +       case 14400:
> +               baud_code = UART_CSR_14400;
> +               rxstale = 3;
> +               break;
> +       case 19200:
> +               baud_code = UART_CSR_19200;
> +               rxstale = 4;
> +               break;
> +       case 28800:
> +               baud_code = UART_CSR_28800;
> +               rxstale = 6;
> +               break;
> +       case 38400:
> +               baud_code = UART_CSR_38400;
> +               rxstale = 8;
> +               break;
> +       case 57600:
> +               baud_code = UART_CSR_57600;
> +               rxstale = 16;
> +               break;
> +       case 115200:
> +       default:
> +               baud_code = UART_CSR_115200;
> +               rxstale = 31;
> +               break;
> +       }
> +
> +       msm_write(port, baud_code, UART_CSR);
> +
> +       /* RX stale watermark */
> +       watermark = UART_IPR_STALE_LSB & rxstale;
> +       watermark |= UART_IPR_RXSTALE_LAST;
> +       watermark |= UART_IPR_STALE_TIMEOUT_MSB & (rxstale << 2);
> +       msm_write(port, watermark, UART_IPR);
> +
> +       /* set RX watermark */
> +       watermark = (port->fifosize * 3) / 4;
> +       msm_write(port, watermark, UART_RFWR);
> +
> +       /* set TX watermark */
> +       msm_write(port, 10, UART_TFWR);
> +}
> +
> +static void msm_reset(struct uart_port *port)
> +{
> +       /* reset everything */
> +       msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
> +       msm_write(port, UART_CR_CMD_RESET_TX, UART_CR);
> +       msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
> +       msm_write(port, UART_CR_CMD_RESET_BREAK_INT, UART_CR);
> +       msm_write(port, UART_CR_CMD_RESET_CTS, UART_CR);
> +       msm_write(port, UART_CR_CMD_SET_RFR, UART_CR);
> +}
> +
> +static void msm_init_clock(struct uart_port *port)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +
> +       clk_enable(msm_port->clk);
> +
> +       msm_write(port, 0xC0, UART_MREG);
> +       msm_write(port, 0xB2, UART_NREG);
> +       msm_write(port, 0x7D, UART_DREG);
> +       msm_write(port, 0x1C, UART_MNDREG);
> +}
> +
> +static int msm_startup(struct uart_port *port)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +       unsigned int data, rfr_level;
> +       int ret;
> +
> +       snprintf(msm_port->name, sizeof(msm_port->name),
> +                "msm_serial%d", port->line);
> +
> +       ret = request_irq(port->irq, msm_irq, IRQF_TRIGGER_HIGH,
> +                         msm_port->name, port);
> +       if (unlikely(ret))
> +               return ret;
> +
> +       msm_init_clock(port);
> +
> +       if (likely(port->fifosize > 12))
> +               rfr_level = port->fifosize - 12;
> +       else
> +               rfr_level = port->fifosize;
> +
> +       /* set automatic RFR level */
> +       data = msm_read(port, UART_MR1);
> +       data &= ~UART_MR1_AUTO_RFR_LEVEL1;
> +       data &= ~UART_MR1_AUTO_RFR_LEVEL0;
> +       data |= UART_MR1_AUTO_RFR_LEVEL1 & (rfr_level << 2);
> +       data |= UART_MR1_AUTO_RFR_LEVEL0 & rfr_level;
> +       msm_write(port, data, UART_MR1);
> +
> +       /* make sure that RXSTALE count is non-zero */
> +       data = msm_read(port, UART_IPR);
> +       if (unlikely(!data)) {
> +               data |= UART_IPR_RXSTALE_LAST;
> +               data |= UART_IPR_STALE_LSB;
> +               msm_write(port, data, UART_IPR);
> +       }
> +
> +       msm_reset(port);
> +
> +       msm_write(port, 0x05, UART_CR); /* enable TX & RX */
> +
> +       /* turn on RX and CTS interrupts */
> +       msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
> +                       UART_IMR_CURRENT_CTS;
> +       msm_write(port, msm_port->imr, UART_IMR);
> +
> +       return 0;
> +}
> +
> +static void msm_shutdown(struct uart_port *port)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +
> +       msm_port->imr = 0;
> +       msm_write(port, 0, UART_IMR); /* disable interrupts */
> +
> +       clk_disable(msm_port->clk);
> +
> +       free_irq(port->irq, port);
> +}
> +
> +static void msm_set_termios(struct uart_port *port, struct ktermios *termios,
> +                           struct ktermios *old)
> +{
> +       unsigned long flags;
> +       unsigned int baud, mr;
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +
> +       /* calculate and set baud rate */
> +       baud = uart_get_baud_rate(port, termios, old, 300, 115200);
> +       msm_set_baud_rate(port, baud);
> +
> +       /* calculate parity */
> +       mr = msm_read(port, UART_MR2);
> +       mr &= ~UART_MR2_PARITY_MODE;
> +       if (termios->c_cflag & PARENB) {
> +               if (termios->c_cflag & PARODD)
> +                       mr |= UART_MR2_PARITY_MODE_ODD;
> +               else if (termios->c_cflag & CMSPAR)
> +                       mr |= UART_MR2_PARITY_MODE_SPACE;
> +               else
> +                       mr |= UART_MR2_PARITY_MODE_EVEN;
> +       }
> +
> +       /* calculate bits per char */
> +       mr &= ~UART_MR2_BITS_PER_CHAR;
> +       switch (termios->c_cflag & CSIZE) {
> +       case CS5:
> +               mr |= UART_MR2_BITS_PER_CHAR_5;
> +               break;
> +       case CS6:
> +               mr |= UART_MR2_BITS_PER_CHAR_6;
> +               break;
> +       case CS7:
> +               mr |= UART_MR2_BITS_PER_CHAR_7;
> +               break;
> +       case CS8:
> +       default:
> +               mr |= UART_MR2_BITS_PER_CHAR_8;
> +               break;
> +       }
> +
> +       /* calculate stop bits */
> +       mr &= ~(UART_MR2_STOP_BIT_LEN_ONE | UART_MR2_STOP_BIT_LEN_TWO);
> +       if (termios->c_cflag & CSTOPB)
> +               mr |= UART_MR2_STOP_BIT_LEN_TWO;
> +       else
> +               mr |= UART_MR2_STOP_BIT_LEN_ONE;
> +
> +       /* set parity, bits per char, and stop bit */
> +       msm_write(port, mr, UART_MR2);
> +
> +       /* calculate and set hardware flow control */
> +       mr = msm_read(port, UART_MR1);
> +       mr &= ~(UART_MR1_CTS_CTL | UART_MR1_RX_RDY_CTL);
> +       if (termios->c_cflag & CRTSCTS) {
> +               mr |= UART_MR1_CTS_CTL;
> +               mr |= UART_MR1_RX_RDY_CTL;
> +       }
> +       msm_write(port, mr, UART_MR1);
> +
> +       /* Configure status bits to ignore based on termio flags. */
> +       port->read_status_mask = 0;
> +       if (termios->c_iflag & INPCK)
> +               port->read_status_mask |= UART_SR_PAR_FRAME_ERR;
> +       if (termios->c_iflag & (BRKINT | PARMRK))
> +               port->read_status_mask |= UART_SR_RX_BREAK;
> +
> +       uart_update_timeout(port, termios->c_cflag, baud);
> +
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static const char *msm_type(struct uart_port *port)
> +{
> +       return "MSM";
> +}
> +
> +static void msm_release_port(struct uart_port *port)
> +{
> +       struct platform_device *pdev = to_platform_device(port->dev);
> +       struct resource *resource;
> +       resource_size_t size;
> +
> +       resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (unlikely(!resource))
> +               return;
> +       size = resource->end - resource->start + 1;
> +
> +       release_mem_region(port->mapbase, size);
> +       iounmap(port->membase);
> +       port->membase = NULL;
> +}
> +
> +static int msm_request_port(struct uart_port *port)
> +{
> +       struct platform_device *pdev = to_platform_device(port->dev);
> +       struct resource *resource;
> +       resource_size_t size;
> +
> +       resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (unlikely(!resource))
> +               return -ENXIO;
> +       size = resource->end - resource->start + 1;
> +
> +       if (unlikely(!request_mem_region(port->mapbase, size, "msm_serial")))
> +               return -EBUSY;
> +
> +       port->membase = ioremap(port->mapbase, size);
> +       if (!port->membase) {
> +               release_mem_region(port->mapbase, size);
> +               return -EBUSY;
> +       }
> +
> +       return 0;
> +}
> +
> +static void msm_config_port(struct uart_port *port, int flags)
> +{
> +       if (flags & UART_CONFIG_TYPE) {
> +               port->type = PORT_MSM;
> +               msm_request_port(port);
> +       }
> +}
> +
> +static int msm_verify_port(struct uart_port *port, struct serial_struct *ser)
> +{
> +       if (unlikely(ser->type != PORT_UNKNOWN && ser->type != PORT_MSM))
> +               return -EINVAL;
> +       if (unlikely(port->irq != ser->irq))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static void msm_power(struct uart_port *port, unsigned int state,
> +                     unsigned int oldstate)
> +{
> +       struct msm_port *msm_port = UART_TO_MSM(port);
> +
> +       switch (state) {
> +       case 0:
> +               clk_enable(msm_port->clk);
> +               break;
> +       case 3:
> +               clk_disable(msm_port->clk);
> +               break;
> +       default:
> +               printk(KERN_ERR "msm_serial: Unknown PM state %d\n", state);
> +       }
> +}
> +
> +static struct uart_ops msm_uart_pops = {
> +       .tx_empty = msm_tx_empty,
> +       .set_mctrl = msm_set_mctrl,
> +       .get_mctrl = msm_get_mctrl,
> +       .stop_tx = msm_stop_tx,
> +       .start_tx = msm_start_tx,
> +       .stop_rx = msm_stop_rx,
> +       .enable_ms = msm_enable_ms,
> +       .break_ctl = msm_break_ctl,
> +       .startup = msm_startup,
> +       .shutdown = msm_shutdown,
> +       .set_termios = msm_set_termios,
> +       .type = msm_type,
> +       .release_port = msm_release_port,
> +       .request_port = msm_request_port,
> +       .config_port = msm_config_port,
> +       .verify_port = msm_verify_port,
> +       .pm = msm_power,
> +};
> +
> +static struct msm_port msm_uart_ports[] = {
> +       {
> +               .uart = {
> +                       .iotype = UPIO_MEM,
> +                       .ops = &msm_uart_pops,
> +                       .flags = UPF_BOOT_AUTOCONF,
> +                       .fifosize = 512,
> +                       .line = 0,
> +               },
> +       },
> +       {
> +               .uart = {
> +                       .iotype = UPIO_MEM,
> +                       .ops = &msm_uart_pops,
> +                       .flags = UPF_BOOT_AUTOCONF,
> +                       .fifosize = 512,
> +                       .line = 1,
> +               },
> +       },
> +       {
> +               .uart = {
> +                       .iotype = UPIO_MEM,
> +                       .ops = &msm_uart_pops,
> +                       .flags = UPF_BOOT_AUTOCONF,
> +                       .fifosize = 64,
> +                       .line = 2,
> +               },
> +       },
> +};
> +
> +#define UART_NR        ARRAY_SIZE(msm_uart_ports)
> +
> +static inline struct uart_port *get_port_from_line(unsigned int line)
> +{
> +       return &msm_uart_ports[line].uart;
> +}
> +
> +#ifdef CONFIG_SERIAL_MSM_CONSOLE
> +
> +static void msm_console_putchar(struct uart_port *port, int c)
> +{
> +       while (!(msm_read(port, UART_SR) & UART_SR_TX_READY))
> +               ;
> +       msm_write(port, c, UART_TF);
> +}
> +
> +static void msm_console_write(struct console *co, const char *s,
> +                             unsigned int count)
> +{
> +       struct uart_port *port;
> +       struct msm_port *msm_port;
> +
> +       BUG_ON(co->index < 0 || co->index >= UART_NR);
> +
> +       port = get_port_from_line(co->index);
> +       msm_port = UART_TO_MSM(port);
> +
> +       spin_lock(&port->lock);
> +       uart_console_write(port, s, count, msm_console_putchar);
> +       spin_unlock(&port->lock);
> +}
> +
> +static int __init msm_console_setup(struct console *co, char *options)
> +{
> +       struct uart_port *port;
> +       int baud, flow, bits, parity;
> +
> +       if (unlikely(co->index >= UART_NR || co->index < 0))
> +               return -ENXIO;
> +
> +       port = get_port_from_line(co->index);
> +
> +       if (unlikely(!port->membase))
> +               return -ENXIO;
> +
> +       port->cons = co;
> +
> +       msm_init_clock(port);
> +
> +       if (options)
> +               uart_parse_options(options, &baud, &parity, &bits, &flow);
> +
> +       bits = 8;
> +       parity = 'n';
> +       flow = 'n';
> +       msm_write(port, UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE,
> +                 UART_MR2);    /* 8N1 */
> +
> +       if (baud < 300 || baud > 115200)
> +               baud = 115200;
> +       msm_set_baud_rate(port, baud);
> +
> +       msm_reset(port);
> +
> +       printk(KERN_INFO "msm_serial: console setup on port #%d\n", port->line);
> +
> +       return uart_set_options(port, co, baud, parity, bits, flow);
> +}
> +
> +static struct uart_driver msm_uart_driver;
> +
> +static struct console msm_console = {
> +       .name = "ttyMSM",
> +       .write = msm_console_write,
> +       .device = uart_console_device,
> +       .setup = msm_console_setup,
> +       .flags = CON_PRINTBUFFER,
> +       .index = -1,
> +       .data = &msm_uart_driver,
> +};
> +
> +#define MSM_CONSOLE    (&msm_console)
> +
> +#else
> +#define MSM_CONSOLE    NULL
> +#endif
> +
> +static struct uart_driver msm_uart_driver = {
> +       .owner = THIS_MODULE,
> +       .driver_name = "msm_serial",
> +       .dev_name = "ttyMSM",
> +       .nr = UART_NR,
> +       .cons = MSM_CONSOLE,
> +};
> +
> +static int __init msm_serial_probe(struct platform_device *pdev)
> +{
> +       struct msm_port *msm_port;
> +       struct resource *resource;
> +       struct uart_port *port;
> +
> +       if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
> +               return -ENXIO;
> +
> +       printk(KERN_INFO "msm_serial: detected port #%d\n", pdev->id);
> +
> +       port = get_port_from_line(pdev->id);
> +       port->dev = &pdev->dev;
> +       msm_port = UART_TO_MSM(port);
> +
> +       msm_port->clk = clk_get(&pdev->dev, "uart_clk");
> +       if (unlikely(IS_ERR(msm_port->clk)))
> +               return PTR_ERR(msm_port->clk);
> +       port->uartclk = clk_get_rate(msm_port->clk);
> +
> +       resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (unlikely(!resource))
> +               return -ENXIO;
> +       port->mapbase = resource->start;
> +
> +       port->irq = platform_get_irq(pdev, 0);
> +       if (unlikely(port->irq < 0))
> +               return -ENXIO;
> +
> +       platform_set_drvdata(pdev, port);
> +
> +       return uart_add_one_port(&msm_uart_driver, port);
> +}
> +
> +static int __devexit msm_serial_remove(struct platform_device *pdev)
> +{
> +       struct msm_port *msm_port = platform_get_drvdata(pdev);
> +
> +       clk_put(msm_port->clk);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver msm_platform_driver = {
> +       .probe = msm_serial_probe,
> +       .remove = msm_serial_remove,
> +       .driver = {
> +               .name = "msm_serial",
> +               .owner = THIS_MODULE,
> +       },
> +};
> +
> +static int __init msm_serial_init(void)
> +{
> +       int ret;
> +
> +       ret = uart_register_driver(&msm_uart_driver);
> +       if (unlikely(ret))
> +               return ret;
> +
> +       ret = platform_driver_probe(&msm_platform_driver, msm_serial_probe);
> +       if (unlikely(ret))
> +               uart_unregister_driver(&msm_uart_driver);
> +
> +       printk(KERN_INFO "msm_serial: driver initialized\n");
> +
> +       return ret;
> +}
> +
> +static void __exit msm_serial_exit(void)
> +{
> +#ifdef CONFIG_SERIAL_MSM_CONSOLE
> +       unregister_console(&msm_console);
> +#endif
> +       platform_driver_unregister(&msm_platform_driver);
> +       uart_unregister_driver(&msm_uart_driver);
> +}
> +
> +module_init(msm_serial_init);
> +module_exit(msm_serial_exit);
> +
> +MODULE_AUTHOR("Robert Love <rlove@google.com>");
> +MODULE_DESCRIPTION("Driver for msm7x serial device");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/serial/msm_serial.h b/drivers/serial/msm_serial.h
> new file mode 100644
> index 0000000..689f1fa
> --- /dev/null
> +++ b/drivers/serial/msm_serial.h
> @@ -0,0 +1,117 @@
> +/*
> + * drivers/serial/msm_serial.h
> + *
> + * Copyright (C) 2007 Google, Inc.
> + * Author: Robert Love <rlove@google.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __DRIVERS_SERIAL_MSM_SERIAL_H
> +#define __DRIVERS_SERIAL_MSM_SERIAL_H
> +
> +#define UART_MR1                       0x0000
> +
> +#define UART_MR1_AUTO_RFR_LEVEL0       0x3F
> +#define UART_MR1_AUTO_RFR_LEVEL1       0x3FF00
> +#define UART_MR1_RX_RDY_CTL                    (1 << 7)
> +#define UART_MR1_CTS_CTL                       (1 << 6)
> +
> +#define UART_MR2                       0x0004
> +#define UART_MR2_ERROR_MODE            (1 << 6)
> +#define UART_MR2_BITS_PER_CHAR         0x30
> +#define UART_MR2_BITS_PER_CHAR_5       (0x0 << 4)
> +#define UART_MR2_BITS_PER_CHAR_6       (0x1 << 4)
> +#define UART_MR2_BITS_PER_CHAR_7       (0x2 << 4)
> +#define UART_MR2_BITS_PER_CHAR_8       (0x3 << 4)
> +#define UART_MR2_STOP_BIT_LEN_ONE      (0x1 << 2)
> +#define UART_MR2_STOP_BIT_LEN_TWO      (0x3 << 2)
> +#define UART_MR2_PARITY_MODE_NONE      0x0
> +#define UART_MR2_PARITY_MODE_ODD       0x1
> +#define UART_MR2_PARITY_MODE_EVEN      0x2
> +#define UART_MR2_PARITY_MODE_SPACE     0x3
> +#define UART_MR2_PARITY_MODE           0x3
> +
> +#define UART_CSR       0x0008
> +#define UART_CSR_115200        0xFF
> +#define UART_CSR_57600 0xEE
> +#define UART_CSR_38400 0xDD
> +#define UART_CSR_28800 0xCC
> +#define UART_CSR_19200 0xBB
> +#define UART_CSR_14400 0xAA
> +#define UART_CSR_9600  0x99
> +#define UART_CSR_4800  0x77
> +#define UART_CSR_2400  0x55
> +#define UART_CSR_1200  0x44
> +#define UART_CSR_600   0x33
> +#define UART_CSR_300   0x22
> +
> +#define UART_TF                0x000C
> +
> +#define UART_CR                                0x0010
> +#define UART_CR_CMD_NULL               (0 << 4)
> +#define UART_CR_CMD_RESET_RX           (1 << 4)
> +#define UART_CR_CMD_RESET_TX           (2 << 4)
> +#define UART_CR_CMD_RESET_ERR          (3 << 4)
> +#define UART_CR_CMD_RESET_BREAK_INT    (4 << 4)
> +#define UART_CR_CMD_START_BREAK                (5 << 4)
> +#define UART_CR_CMD_STOP_BREAK         (6 << 4)
> +#define UART_CR_CMD_RESET_CTS          (7 << 4)
> +#define UART_CR_CMD_PACKET_MODE                (9 << 4)
> +#define UART_CR_CMD_MODE_RESET         (12 << 4)
> +#define UART_CR_CMD_SET_RFR            (13 << 4)
> +#define UART_CR_CMD_RESET_RFR          (14 << 4)
> +#define UART_CR_TX_DISABLE             (1 << 3)
> +#define UART_CR_TX_ENABLE              (1 << 3)
> +#define UART_CR_RX_DISABLE             (1 << 3)
> +#define UART_CR_RX_ENABLE              (1 << 3)
> +
> +#define UART_IMR               0x0014
> +#define UART_IMR_TXLEV         (1 << 0)
> +#define UART_IMR_RXSTALE       (1 << 3)
> +#define UART_IMR_RXLEV         (1 << 4)
> +#define UART_IMR_DELTA_CTS     (1 << 5)
> +#define UART_IMR_CURRENT_CTS   (1 << 6)
> +
> +#define UART_IPR_RXSTALE_LAST          0x20
> +#define UART_IPR_STALE_LSB             0x1F
> +#define UART_IPR_STALE_TIMEOUT_MSB     0x3FF80
> +
> +#define UART_IPR       0x0018
> +#define UART_TFWR      0x001C
> +#define UART_RFWR      0x0020
> +#define UART_HCR       0x0024
> +
> +#define UART_MREG              0x0028
> +#define UART_NREG              0x002C
> +#define UART_DREG              0x0030
> +#define UART_MNDREG            0x0034
> +#define UART_IRDA              0x0038
> +#define UART_MISR_MODE         0x0040
> +#define UART_MISR_RESET                0x0044
> +#define UART_MISR_EXPORT       0x0048
> +#define UART_MISR_VAL          0x004C
> +#define UART_TEST_CTRL         0x0050
> +
> +#define UART_SR                        0x0008
> +#define UART_SR_HUNT_CHAR      (1 << 7)
> +#define UART_SR_RX_BREAK       (1 << 6)
> +#define UART_SR_PAR_FRAME_ERR  (1 << 5)
> +#define UART_SR_OVERRUN                (1 << 4)
> +#define UART_SR_TX_EMPTY       (1 << 3)
> +#define UART_SR_TX_READY       (1 << 2)
> +#define UART_SR_RX_FULL                (1 << 1)
> +#define UART_SR_RX_READY       (1 << 0)
> +
> +#define UART_RF                0x000C
> +#define UART_MISR      0x0010
> +#define UART_ISR       0x0014
> +
> +#endif /* __DRIVERS_SERIAL_MSM_SERIAL_H */
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 6fd80c4..23d2fb0 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -171,6 +171,9 @@
>  /* Timberdale UART */
>  #define PORT_TIMBUART  87
>
> +/* Qualcomm MSM SoCs */
> +#define PORT_MSM       88
> +
>  #ifdef __KERNEL__
>
>  #include <linux/compiler.h>
> --
> 1.6.2.4
>
>
