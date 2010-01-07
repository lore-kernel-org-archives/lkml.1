Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605Ab0AGN4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0AGN4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266Ab0AGN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:56:15 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:43071 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab0AGN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:56:14 -0500
X-Greylist: delayed 797 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 08:56:11 EST
Subject: Re: [PATCH 1/2] i2c: Add support for Ux500/Nomadik I2C controller
From: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
To: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Cc: "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Sachin VERMA <sachin.verma@st.com>,
       Andrea GALLO <andrea.gallo@stericsson.com>, <rubini@unipv.it>
In-Reply-To: <27f8aa32bf40c690930a76ce5e1ee82cec86b248.1262870858.git.srinidhi.kasagar@stericsson.com>
References: <27f8aa32bf40c690930a76ce5e1ee82cec86b248.1262870858.git.srinidhi.kasagar@stericsson.com>
Content-Type: text/plain
Organization: ST-Ericsson
Date: Thu, 7 Jan 2010 07:08:55 +0530
Message-ID: <1262828335.23286.2.camel@vinay-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Alessandro Rubini in CC. I forgot to add you in copy.

Srinidhi
On Thu, 2010-01-07 at 14:41 +0100, Srinidhi KASAGAR wrote:
> This adds support for the ST-Ericsson's I2C
> block found in Ux500 and Nomadik 8815
> platforms.
> 
> Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
> Acked-by: Andrea Gallo <andrea.gallo@stericsson.com>
> ---
>  arch/arm/plat-nomadik/include/plat/i2c.h |   31 +
>  drivers/i2c/busses/Kconfig               |    7 +
>  drivers/i2c/busses/Makefile              |    1 +
>  drivers/i2c/busses/i2c-nmk.c             |  957 ++++++++++++++++++++++++++++++
>  4 files changed, 996 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/plat-nomadik/include/plat/i2c.h
>  create mode 100644 drivers/i2c/busses/i2c-nmk.c
> 
> diff --git a/arch/arm/plat-nomadik/include/plat/i2c.h b/arch/arm/plat-nomadik/include/plat/i2c.h
> new file mode 100644
> index 0000000..b5ed0db
> --- /dev/null
> +++ b/arch/arm/plat-nomadik/include/plat/i2c.h
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright (C) 2009 ST-Ericsson
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __PLAT_I2C_H
> +#define __PLAT_I2C_H
> +
> +enum i2c_freq_mode {
> +       I2C_FREQ_MODE_STANDARD,         /* up to 100 Kb/s */
> +       I2C_FREQ_MODE_FAST,             /* up to 400 Kb/s */
> +       I2C_FREQ_MODE_FAST_PLUS,        /* up to 1 Mb/s */
> +       I2C_FREQ_MODE_HIGH_SPEED        /* up to 3.4 Mb/s */
> +};
> +
> +enum i2c_addr_mode {
> +       I2C_7_BIT_ADDRESS = 0x1,
> +       I2C_10_BIT_ADDRESS = 0x2
> +};
> +
> +struct nmk_i2c_controller {
> +       unsigned long   clk_freq;
> +       unsigned short  slsu;   /* slave data set up time */
> +       unsigned char   tft;    /* Tx FIFO Threshold */
> +       unsigned char   rft;    /* Rx FIFO Threshold */
> +       unsigned short  sm;     /* speed mode */
> +};
> +
> +#endif /* __PLAT_I2C_H */
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 5f318ce..fbde486 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -439,6 +439,13 @@ config I2C_MV64XXX
>           This driver can also be built as a module.  If so, the module
>           will be called i2c-mv64xxx.
> 
> +config I2C_NOMADIK
> +       tristate "ST-Ericsson Nomadik/Ux500 I2C Controller"
> +       depends on PLAT_NOMADIK
> +       help
> +         If you say yes to this option, support will be included for the
> +         I2C interface from ST-Ericsson's Nomadik and Ux500 architectures.
> +
>  config I2C_OCORES
>         tristate "OpenCores I2C Controller"
>         depends on EXPERIMENTAL
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 302c551..621f04a 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_I2C_IOP3XX)      += i2c-iop3xx.o
>  obj-$(CONFIG_I2C_IXP2000)      += i2c-ixp2000.o
>  obj-$(CONFIG_I2C_MPC)          += i2c-mpc.o
>  obj-$(CONFIG_I2C_MV64XXX)      += i2c-mv64xxx.o
> +obj-$(CONFIG_I2C_NOMADIK)      += i2c-nmk.o
>  obj-$(CONFIG_I2C_OCORES)       += i2c-ocores.o
>  obj-$(CONFIG_I2C_OMAP)         += i2c-omap.o
>  obj-$(CONFIG_I2C_PASEMI)       += i2c-pasemi.o
> diff --git a/drivers/i2c/busses/i2c-nmk.c b/drivers/i2c/busses/i2c-nmk.c
> new file mode 100644
> index 0000000..28aaa88
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-nmk.c
> @@ -0,0 +1,957 @@
> +/*
> + * Copyright (C) 2009 ST-Ericsson
> + * Copyright (C) 2009 STMicroelectronics
> + *
> + * I2C master mode controller driver, used in Nomadik 8815
> + * and Ux500 platforms.
> + *
> + * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> + * Author: Sachin Verma <sachin.verma@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +
> +#include <plat/i2c.h>
> +
> +#define DRIVER_NAME "i2c-nmk"
> +
> +/* I2C Controller register offsets */
> +#define I2C_CR         (0x000)
> +#define I2C_SCR                (0x004)
> +#define I2C_HSMCR      (0x008)
> +#define I2C_MCR                (0x00C)
> +#define I2C_TFR                (0x010)
> +#define I2C_SR         (0x014)
> +#define I2C_RFR                (0x018)
> +#define I2C_TFTR       (0x01C)
> +#define I2C_RFTR       (0x020)
> +#define I2C_DMAR       (0x024)
> +#define I2C_BRCR       (0x028)
> +#define I2C_IMSCR      (0x02C)
> +#define I2C_RISR       (0x030)
> +#define I2C_MISR       (0x034)
> +#define I2C_ICR                (0x038)
> +
> +/* Control register bit positions */
> +#define I2C_CR_PE_POS          0       /* Peripheral Enable */
> +#define I2C_CR_OM_POS          1       /* Operating mode */
> +#define I2C_CR_SAM_POS         3       /* Slave addressing mode */
> +#define I2C_CR_SM_POS          4       /* Speed mode */
> +#define I2C_CR_SGCM_POS                6       /* Slave general call mode */
> +#define I2C_CR_FTX_POS         7       /* Flush Transmit */
> +#define I2C_CR_FRX_POS         8       /* Flush Receive */
> +#define I2C_CR_DMA_TX_EN_POS   9       /* DMA Tx enable */
> +#define I2C_CR_DMA_RX_EN_POS   10      /* DMA Rx Enable */
> +#define I2C_CR_DMA_SLE_POS     11      /* DMA sync. logic enable */
> +#define I2C_CR_LM_POS          12      /* Loopback mode */
> +#define I2C_CR_FON_POS         13      /* Filtering on */
> +#define I2C_CR_FS_POS          15      /* Force stop enable */
> +
> +#define I2C_CR_PE              (0x1 << I2C_CR_PE_POS)
> +#define I2C_CR_OM              (0x3 << I2C_CR_OM_POS)
> +#define I2C_CR_SAM             (0x1 << I2C_CR_SAM_POS)
> +#define I2C_CR_SM              (0x3 << I2C_CR_SM_POS)
> +#define I2C_CR_SGCM            (0x1 << I2C_CR_SGCM_POS)
> +#define I2C_CR_FTX             (0x1 << I2C_CR_FTX_POS)
> +#define I2C_CR_FRX             (0x1 << I2C_CR_FRX_POS)
> +#define I2C_CR_DMA_TX_EN       (0x1 << I2C_CR_DMA_TX_EN_POS)
> +#define I2C_CR_DMA_RX_EN       (0x1 << I2C_CR_DMA_RX_EN_POS)
> +#define I2C_CR_DMA_SLE         (0x1 << I2C_CR_DMA_SLE_POS)
> +#define I2C_CR_LM              (0x1 << I2C_CR_LM_POS)
> +#define I2C_CR_FON             (0x3 << I2C_CR_FON_POS)
> +#define I2C_CR_FS              (0x3 << I2C_CR_FS_POS)
> +
> +/* Master controller (MCR) bit positions */
> +#define I2C_MCR_OP_POS         0       /* Operation */
> +#define I2C_MCR_A7_POS         1       /* 7-bit address */
> +#define I2C_MCR_EA10_POS       8       /* 10-bit Extended address */
> +#define I2C_MCR_SB_POS         11      /* Extended address */
> +#define I2C_MCR_AM_POS         12      /* Address type */
> +#define I2C_MCR_STOP_POS       14      /* Stop condition */
> +#define I2C_MCR_LENGTH_POS     15      /* Transaction length */
> +
> +#define I2C_MCR_OP             (0x1 << I2C_MCR_OP_POS)
> +#define I2C_MCR_A7             (0x7F << I2C_MCR_A7_POS)
> +#define I2C_MCR_EA10           (0x7 << I2C_MCR_EA10_POS)
> +#define I2C_MCR_SB             (0x1 << I2C_MCR_SB_POS)
> +#define I2C_MCR_AM             (0x3 << I2C_MCR_AM_POS)
> +#define I2C_MCR_STOP           (0x1 << I2C_MCR_STOP_POS)
> +#define I2C_MCR_LENGTH         (0x7FF << I2C_MCR_LENGTH_POS)
> +
> +/* Status register (SR) */
> +#define I2C_SR_OP              (0x3 << 0)      /* Operation */
> +#define I2C_SR_STATUS          (0x3 << 2)      /* controller status */
> +#define I2C_SR_CAUSE           (0x7 << 4)      /* Abort cause */
> +#define I2C_SR_TYPE            (0x3 << 7)      /* Receive type */
> +#define I2C_SR_LENGTH          (0x7FF << 9)    /* Transfer length */
> +
> +/* Interrupt mask set/clear (IMSCR) bits */
> +#define I2C_IT_TXFE            (0x1 << 0)
> +#define I2C_IT_TXFNE           (0x1 << 1)
> +#define I2C_IT_TXFF            (0x1 << 2)
> +#define I2C_IT_TXFOVR          (0x1 << 3)
> +#define I2C_IT_RXFE            (0x1 << 4)
> +#define I2C_IT_RXFNF           (0x1 << 5)
> +#define I2C_IT_RXFF            (0x1 << 6)
> +#define I2C_IT_RFSR            (0x1 << 16)
> +#define I2C_IT_RFSE            (0x1 << 17)
> +#define I2C_IT_WTSR            (0x1 << 18)
> +#define I2C_IT_MTD             (0x1 << 19)
> +#define I2C_IT_STD             (0x1 << 20)
> +#define I2C_IT_MAL             (0x1 << 24)
> +#define I2C_IT_BERR            (0x1 << 25)
> +#define I2C_IT_MTDWS           (0x1 << 28)
> +
> +#define GEN_MASK(val, mask, sb)  (((val) << (sb)) & (mask))
> +
> +/* some bits in ICR are reserved */
> +#define I2C_CLEAR_ALL_INTS     0x131F007F
> +
> +/* first three msb bits are reserved */
> +#define IRQ_MASK(mask)         (mask & 0x1fffffff)
> +
> +/* maximum threshold value */
> +#define MAX_I2C_FIFO_THRESHOLD 15
> +
> +#define i2c_set_bit(reg, mask) (writel(readl(reg) | mask, (reg)))
> +#define i2c_clr_bit(reg, mask) (writel(readl(reg) & ~(mask), (reg)))
> +
> +enum {
> +       I2C_NOP,
> +       I2C_ON_GOING,
> +       I2C_OK,
> +       I2C_ABORT
> +};
> +
> +/* operation */
> +enum i2c_operation {
> +       I2C_NO_OPERATION = 0xff,
> +       I2C_WRITE = 0x00,
> +       I2C_READ = 0x01
> +};
> +
> +/* controller response timeout in ms */
> +#define I2C_TIMEOUT_MS 500
> +
> +/* client specific data */
> +struct i2c_nmk_client {
> +       unsigned short          slave_adr;  /* 7-bit slave address */
> +       unsigned long           count;      /* no. bytes to be transfered */
> +       unsigned char           *buffer;
> +       unsigned long           xfer_bytes; /* bytes xfered till now */
> +       enum i2c_operation      operation;
> +};
> +
> +/* private data structure for the controller */
> +struct nmk_i2c_dev {
> +       struct platform_device          *pdev;
> +       struct i2c_adapter              adap;
> +       int                             irq;
> +       void __iomem                    *virtbase;
> +       struct clk                      *clk;
> +       /* machine provided controller configuration */
> +       struct nmk_i2c_controller       cfg;
> +       /* client specific data */
> +       struct i2c_nmk_client           cli;
> +       int                             stop;
> +       struct completion               xfer_complete;
> +       int                             result;
> +};
> +
> +/* controller's abort causes */
> +static const char *abort_causes[] = {
> +       "no ack received after address transmission",
> +       "no ack received during data phase",
> +       "ack received after xmission of master code",
> +       "master lost arbitration",
> +       "slave restarts",
> +       "slave reset",
> +       "overflow, maxsize is 2047 bytes",
> +};
> +
> +static unsigned int nmk_i2c_functionality(struct i2c_adapter *adap);
> +static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
> +               struct i2c_msg msgs[], int num_msgs);
> +
> +static const struct i2c_algorithm nmk_i2c_algo = {
> +       .master_xfer    = nmk_i2c_xfer,
> +       .functionality  = nmk_i2c_functionality
> +};
> +
> +static unsigned int nmk_i2c_functionality(struct i2c_adapter *adap)
> +{
> +       return I2C_FUNC_I2C
> +               | I2C_FUNC_SMBUS_BYTE_DATA
> +               | I2C_FUNC_SMBUS_WORD_DATA
> +               | I2C_FUNC_SMBUS_I2C_BLOCK;
> +}
> +
> +/**
> + * flush_i2c_fifo - This function flushes the I2C FIFO
> + * @dev: private data of I2C Driver
> + *
> + * This function flushes the I2C Tx and Rx FIFOs. It returns
> + * 0 on successful flushing of FIFO
> + */
> +static int flush_i2c_fifo(struct nmk_i2c_dev *dev)
> +{
> +#define LOOP_ATTEMPTS 10
> +       int i;
> +       unsigned long timeout;
> +       /*
> +        * flush the transmit and receive FIFO. The flushing
> +        * operation takes several cycles before to be completed.
> +        * On the completion, the I2C internal logic clears these
> +        * bits, until then no one must access Tx, Rx FIFO and
> +        * should poll on these bits waiting for the completion.
> +        */
> +       writel((I2C_CR_FTX | I2C_CR_FRX), dev->virtbase + I2C_CR);
> +
> +       for (i = 0; i < LOOP_ATTEMPTS; i++) {
> +               timeout = jiffies + msecs_to_jiffies(I2C_TIMEOUT_MS);
> +
> +               while (!time_after(jiffies, timeout)) {
> +                       if ((readl(dev->virtbase + I2C_CR) &
> +                               (I2C_CR_FTX | I2C_CR_FRX)) == 0)
> +                                       return 0;
> +               }
> +       }
> +
> +       dev_err(&dev->pdev->dev, "flushing operation timed out "
> +               "giving up after %d attempts", LOOP_ATTEMPTS);
> +
> +       return -ETIMEDOUT;
> +}
> +
> +/**
> + * disable_all_interrupts - Disable all interrupts of this I2c Bus
> + * @dev: private data of I2C Driver
> + */
> +static void disable_all_interrupts(struct nmk_i2c_dev *dev)
> +{
> +       u32 mask = 0;
> +       mask = IRQ_MASK(mask);
> +       writel(mask, dev->virtbase + I2C_IMSCR);
> +}
> +
> +/**
> + * clear_all_interrupts - Clear all interrupts of I2C Controller
> + * @dev: private data of I2C Driver
> + */
> +static void clear_all_interrupts(struct nmk_i2c_dev *dev)
> +{
> +       u32 mask;
> +       mask = IRQ_MASK(I2C_CLEAR_ALL_INTS);
> +       writel(mask, dev->virtbase + I2C_ICR);
> +}
> +
> +/**
> + * init_hw - initialize the I2C hardware
> + * @dev: private data of I2C Driver
> + */
> +static int init_hw(struct nmk_i2c_dev *dev)
> +{
> +       int stat;
> +
> +       stat = flush_i2c_fifo(dev);
> +       if (stat)
> +               return stat;
> +
> +       /* disable the controller */
> +       i2c_clr_bit(dev->virtbase + I2C_CR , I2C_CR_PE);
> +
> +       disable_all_interrupts(dev);
> +
> +       clear_all_interrupts(dev);
> +
> +       dev->cli.operation = I2C_NO_OPERATION;
> +
> +       return 0;
> +}
> +
> +/* enable peripheral, master mode operation */
> +#define DEFAULT_I2C_REG_CR     ((1 << I2C_CR_OM_POS) | I2C_CR_PE)
> +
> +/**
> + * load_i2c_mcr_reg - load the MCR register
> + * @dev: private data of controller
> + */
> +static u32 load_i2c_mcr_reg(struct nmk_i2c_dev *dev)
> +{
> +       u32 mcr = 0;
> +
> +       mcr |= GEN_MASK(I2C_7_BIT_ADDRESS, I2C_MCR_AM, I2C_MCR_AM_POS);
> +       mcr |= GEN_MASK(dev->cli.slave_adr, I2C_MCR_A7, I2C_MCR_A7_POS);
> +
> +       /* start byte procedure not applied */
> +       mcr |= GEN_MASK(0, I2C_MCR_SB, I2C_MCR_SB_POS);
> +
> +       /* check the operation, master read/write? */
> +       if (dev->cli.operation == I2C_WRITE)
> +               mcr |= GEN_MASK(I2C_WRITE, I2C_MCR_OP, I2C_MCR_OP_POS);
> +       else
> +               mcr |= GEN_MASK(I2C_READ, I2C_MCR_OP, I2C_MCR_OP_POS);
> +
> +       /* stop or repeated start? */
> +       if (dev->stop)
> +               mcr |= GEN_MASK(1, I2C_MCR_STOP, I2C_MCR_STOP_POS);
> +       else
> +               mcr &= ~(GEN_MASK(1, I2C_MCR_STOP, I2C_MCR_STOP_POS));
> +
> +       mcr |= GEN_MASK(dev->cli.count, I2C_MCR_LENGTH,
> +                                       I2C_MCR_LENGTH_POS);
> +       return mcr;
> +}
> +
> +/**
> + * setup_i2c_controller - setup the controller
> + * @dev: private data of controller
> + */
> +static void setup_i2c_controller(struct nmk_i2c_dev *dev)
> +{
> +       u32 brcr1, brcr2, sm;
> +       u32 i2c_clk, div;
> +
> +       writel(0x0, dev->virtbase + I2C_CR);
> +       writel(0x0, dev->virtbase + I2C_HSMCR);
> +       writel(0x0, dev->virtbase + I2C_TFTR);
> +       writel(0x0, dev->virtbase + I2C_RFTR);
> +       writel(0x0, dev->virtbase + I2C_DMAR);
> +
> +       /*
> +        * set the slsu:
> +        *
> +        * slsu defines the data setup time after SCL clock
> +        * stretching in terms of i2c clk cycles. The
> +        * needed setup time for the three modes are 250ns,
> +        * 100ns, 10ns repectively thus leading to the values
> +        * of 14, 6, 2 for a 48 MHz i2c clk.
> +        */
> +       writel(dev->cfg.slsu << 16, dev->virtbase + I2C_SCR);
> +
> +       i2c_clk = clk_get_rate(dev->clk);
> +
> +       /* fallback to std. mode if machine has not provided it */
> +       if (dev->cfg.clk_freq == 0)
> +               dev->cfg.clk_freq = 100000;
> +
> +       /*
> +        * The spec says, in case of std. mode the divider is
> +        * 2 whereas it is 3 for fast and fastplus mode of
> +        * operation. TODO - high speed support.
> +        */
> +       div = (dev->cfg.clk_freq > 100000) ? 3 : 2;
> +
> +       /*
> +        * generate the mask for baud rate counters. The controller
> +        * has two baud rate counters. One is used for High speed
> +        * operation, and the other is for std, fast mode, fast mode
> +        * plus operation. Currently we do not supprt high speed mode
> +        * so set brcr1 to 0.
> +        */
> +       brcr1 = 0 << 16;
> +       brcr2 = (i2c_clk/(dev->cfg.clk_freq * div)) & 0xffff;
> +
> +       /* set the baud rate counter register */
> +       writel((brcr1 | brcr2), dev->virtbase + I2C_BRCR);
> +
> +       /*
> +        * set the speed mode. Currently we support
> +        * only standard and fast mode of operation
> +        * TODO - support for fast mode plus (upto 1Mb/s)
> +        * and high speed (up to 3.4 Mb/s)
> +        */
> +       sm = (dev->cfg.clk_freq > 100000) ?
> +               (1 << I2C_CR_SM_POS) : (0 << I2C_CR_SM_POS);
> +
> +       writel(sm, dev->virtbase + I2C_CR);
> +
> +       /* set the Tx and Rx FIFO threshold */
> +       writel(dev->cfg.tft, dev->virtbase + I2C_TFTR);
> +       writel(dev->cfg.rft, dev->virtbase + I2C_RFTR);
> +}
> +
> +/**
> + * read_i2c - Read from I2C client device
> + * @dev: private data of I2C Driver
> + *
> + * This function reads from i2c client device when controller is in
> + * master mode. There is a completion timeout. If there is no transfer
> + * before timeout error is returned.
> + */
> +static int read_i2c(struct nmk_i2c_dev *dev)
> +{
> +       u32 status = 0;
> +       u32 mcr;
> +       u32 irq_mask = 0;
> +       int timeout;
> +
> +       mcr = load_i2c_mcr_reg(dev);
> +       writel(mcr, dev->virtbase + I2C_MCR);
> +
> +       /* load the current CR value */
> +       writel(readl(dev->virtbase + I2C_CR) | DEFAULT_I2C_REG_CR,
> +                       dev->virtbase + I2C_CR);
> +
> +       /* enable the controller */
> +       i2c_set_bit(dev->virtbase + I2C_CR, I2C_CR_PE);
> +
> +       init_completion(&dev->xfer_complete);
> +
> +       /* enable interrupts by setting the mask */
> +       irq_mask = (I2C_IT_RXFNF | I2C_IT_RXFF |
> +                       I2C_IT_MAL | I2C_IT_BERR);
> +
> +       if (dev->stop)
> +               irq_mask |= I2C_IT_MTD;
> +       else
> +               irq_mask |= I2C_IT_MTDWS;
> +
> +       irq_mask = I2C_CLEAR_ALL_INTS & IRQ_MASK(irq_mask);
> +
> +       writel(readl(dev->virtbase + I2C_IMSCR) | irq_mask,
> +                       dev->virtbase + I2C_IMSCR);
> +
> +       timeout = wait_for_completion_interruptible_timeout(
> +               &dev->xfer_complete, msecs_to_jiffies(I2C_TIMEOUT_MS));
> +
> +       if (timeout < 0) {
> +               dev_err(&dev->pdev->dev,
> +                       "wait_for_completion_interruptible_timeout"
> +                       "returned %d waiting for event\n", timeout);
> +               status = timeout;
> +       }
> +
> +       if (timeout == 0) {
> +               /* controler has timedout, re-init the h/w */
> +               dev_err(&dev->pdev->dev, "controller has timed out"
> +                       "waiting for event, re-init h/w\n");
> +               (void) init_hw(dev);
> +               status = -ETIMEDOUT;
> +       }
> +
> +       return status;
> +}
> +
> +/**
> + * write_i2c - Write data to I2C client.
> + * @dev: private data of I2C Driver
> + *
> + * This function writes data to I2C client
> + */
> +static int write_i2c(struct nmk_i2c_dev *dev)
> +{
> +       u32 status = 0;
> +       u32 mcr;
> +       u32 irq_mask = 0;
> +       int timeout;
> +
> +       mcr = load_i2c_mcr_reg(dev);
> +
> +       writel(mcr, dev->virtbase + I2C_MCR);
> +
> +       /* load the current CR value */
> +       writel(readl(dev->virtbase + I2C_CR) | DEFAULT_I2C_REG_CR,
> +                       dev->virtbase + I2C_CR);
> +
> +       /* enable the controller */
> +       i2c_set_bit(dev->virtbase + I2C_CR , I2C_CR_PE);
> +
> +       init_completion(&dev->xfer_complete);
> +
> +       /* enable interrupts by settings the masks */
> +       irq_mask = (I2C_IT_TXFNE | I2C_IT_TXFOVR |
> +                       I2C_IT_MAL | I2C_IT_BERR);
> +
> +       /*
> +        * check if we want to transfer a single or multiple bytes, if so
> +        * set the MTDWS bit (Master Transaction Done Without Stop)
> +        * to start repeated start operation
> +        */
> +       if (dev->stop)
> +               irq_mask |= I2C_IT_MTD;
> +       else
> +               irq_mask |= I2C_IT_MTDWS;
> +
> +       irq_mask = I2C_CLEAR_ALL_INTS & IRQ_MASK(irq_mask);
> +
> +       writel(readl(dev->virtbase + I2C_IMSCR) | irq_mask,
> +                       dev->virtbase + I2C_IMSCR);
> +
> +       timeout = wait_for_completion_interruptible_timeout(
> +               &dev->xfer_complete, msecs_to_jiffies(I2C_TIMEOUT_MS));
> +
> +       if (timeout < 0) {
> +               dev_err(&dev->pdev->dev,
> +                       "wait_for_completion_interruptible_timeout"
> +                       "returned %d waiting for event\n", timeout);
> +               status = timeout;
> +       }
> +
> +       if (timeout == 0) {
> +               /* controler has timedout, re-init the h/w */
> +               dev_err(&dev->pdev->dev, "controller has timed out"
> +                       "waiting for event, re-init h/w\n");
> +               (void) init_hw(dev);
> +               status = -ETIMEDOUT;
> +       }
> +
> +       return status;
> +}
> +
> +/**
> + * nmk_i2c_xfer - I2C transfer function used by kernel framework
> + * @i2c_adap   - Adapter pointer to the controller
> + * @msgs[] - Pointer to data to be written.
> + * @num_msgs - Number of messages to be executed
> + *
> + * This is the function called by the generic kernel i2c_transfer()
> + * or i2c_smbus...() API calls. Note that this code is protected by the
> + * semaphore set in the kernel i2c_transfer() function.
> + *
> + * NOTE:
> + * READ TRANSFER : We impose a restriction of the first message to be the
> + *             index message for any read transaction.
> + *             - a no index is coded as '0',
> + *             - 2byte big endian index is coded as '3'
> + *             !!! msg[0].buf holds the actual index.
> + *             This is compatible with generic messages of smbus emulator
> + *             that send a one byte index.
> + *             eg. a I2C transation to read 2 bytes from index 0
> + *                     idx = 0;
> + *                     msg[0].addr = client->addr;
> + *                     msg[0].flags = 0x0;
> + *                     msg[0].len = 1;
> + *                     msg[0].buf = &idx;
> + *
> + *                     msg[1].addr = client->addr;
> + *                     msg[1].flags = I2C_M_RD;
> + *                     msg[1].len = 2;
> + *                     msg[1].buf = rd_buff
> + *                     i2c_transfer(adap, msg, 2);
> + *
> + * WRITE TRANSFER : The I2C standard interface interprets all data as payload.
> + *             If you want to emulate an SMBUS write transaction put the
> + *             index as first byte(or first and second) in the payload.
> + *             eg. a I2C transation to write 2 bytes from index 1
> + *                     wr_buff[0] = 0x1;
> + *                     wr_buff[1] = 0x23;
> + *                     wr_buff[2] = 0x46;
> + *                     msg[0].flags = 0x0;
> + *                     msg[0].len = 3;
> + *                     msg[0].buf = wr_buff;
> + *                     i2c_transfer(adap, msg, 1);
> + *
> + * To read or write a block of data (multiple bytes) using SMBUS emulation
> + * please use the i2c_smbus_read_i2c_block_data()
> + * or i2c_smbus_write_i2c_block_data() API
> + *
> + * i2c_master_recv() API is not supported as single read message is not
> + * accepted by our interface (it has to be preceded by an index message)
> + */
> +static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
> +               struct i2c_msg msgs[], int num_msgs)
> +{
> +       int status;
> +       int i;
> +       u32 cause;
> +       struct nmk_i2c_dev *dev = i2c_get_adapdata(i2c_adap);
> +
> +       status = init_hw(dev);
> +       if (status)
> +               return status;
> +
> +       /* setup the i2c controller */
> +       setup_i2c_controller(dev);
> +
> +       for (i = 0; i < num_msgs; i++) {
> +               if (unlikely(msgs[i].flags & I2C_M_TEN)) {
> +                       dev_err(&dev->pdev->dev, "10 bit addressing"
> +                                       "not supported\n");
> +                       return -EINVAL;
> +               }
> +               dev->cli.slave_adr      = msgs[i].addr;
> +               dev->cli.buffer         = msgs[i].buf;
> +               dev->cli.count          = msgs[i].len;
> +               dev->stop = (i < (num_msgs - 1)) ? 0 : 1;
> +               dev->result = 0;
> +
> +               if (msgs[i].flags & I2C_M_RD) {
> +                       /* it is a read operation */
> +                       dev->cli.operation = I2C_READ;
> +                       status = read_i2c(dev);
> +               } else {
> +                       /* write operation */
> +                       dev->cli.operation = I2C_WRITE;
> +                       status = write_i2c(dev);
> +               }
> +               if (status || (dev->result)) {
> +                       /* get the abort cause */
> +                       cause = (readl(dev->virtbase + I2C_SR) >> 4) & 0x7;
> +                       dev_err(&dev->pdev->dev, "error during I2C"
> +                                       "message xfer: %d\n", cause);
> +                       dev_err(&dev->pdev->dev, "%s\n",
> +                               cause >= ARRAY_SIZE(abort_causes)
> +                               ? "unknown reason" : abort_causes[cause]);
> +                       return status;
> +               }
> +               mdelay(1);
> +       }
> +       return status;
> +}
> +
> +/**
> + * disable_interrupts - disable the interrupts
> + * @dev: private data of controller
> + */
> +static int disable_interrupts(struct nmk_i2c_dev *dev, u32 irq)
> +{
> +       irq = IRQ_MASK(irq);
> +       writel(readl(dev->virtbase + I2C_IMSCR) & ~(I2C_CLEAR_ALL_INTS & irq),
> +                       dev->virtbase + I2C_IMSCR);
> +       return 0;
> +}
> +
> +/**
> + * i2c_irq_handler - interrupt routine
> + * @irq: interrupt number
> + * @arg: data passed to the handler
> + *
> + * This is the interrupt handler for the i2c driver. Currently
> + * it handles the major interrupts like Rx & Tx FIFO management
> + * interrupts, master transaction interrupts, arbitration and
> + * bus error interrupts. The rest of the interrupts are treated as
> + * unhandled.
> + */
> +static irqreturn_t i2c_irq_handler(int irq, void *arg)
> +{
> +       struct nmk_i2c_dev *dev = arg;
> +       u32 tft, rft;
> +       u32 count;
> +       u32 misr;
> +       u32 src = 0;
> +
> +       /* load Tx FIFO and Rx FIFO threshold values */
> +       tft = readl(dev->virtbase + I2C_TFTR);
> +       rft = readl(dev->virtbase + I2C_RFTR);
> +
> +       /* read interrupt status register */
> +       misr = readl(dev->virtbase + I2C_MISR);
> +
> +       src = __ffs(misr);
> +       switch ((1 << src)) {
> +
> +       /* Transmit FIFO nearly empty interrupt */
> +       case I2C_IT_TXFNE:
> +       {
> +               if (dev->cli.operation == I2C_READ) {
> +                       /*
> +                        * in read operation why do we care for writing?
> +                        * so disable the Transmit FIFO interrupt
> +                        */
> +                       disable_interrupts(dev, I2C_IT_TXFNE);
> +               } else {
> +                       for (count = (MAX_I2C_FIFO_THRESHOLD - tft - 2);
> +                                       (count > 0) &&
> +                                       (dev->cli.count != 0);
> +                                       count--) {
> +                               /* write to the Tx FIFO */
> +                               writeb(*dev->cli.buffer,
> +                                       dev->virtbase + I2C_TFR);
> +                               dev->cli.buffer++;
> +                               dev->cli.count--;
> +                               dev->cli.xfer_bytes++;
> +                       }
> +                       /*
> +                        * if done, close the transfer by disabling the
> +                        * corresponding TXFNE interrupt
> +                        */
> +                       if (dev->cli.count == 0)
> +                               disable_interrupts(dev, I2C_IT_TXFNE);
> +               }
> +       }
> +       break;
> +
> +       /*
> +        * Rx FIFO nearly full interrupt.
> +        * This is set when the numer of entries in Rx FIFO is
> +        * greater or equal than the threshold value programmed
> +        * in RFT
> +        */
> +       case I2C_IT_RXFNF:
> +               for (count = rft; count > 0; count--) {
> +                       /* Read the Rx FIFO */
> +                       *dev->cli.buffer = readb(dev->virtbase + I2C_RFR);
> +                       dev->cli.buffer++;
> +               }
> +               dev->cli.count -= rft;
> +               dev->cli.xfer_bytes += rft;
> +               break;
> +
> +       /* Rx FIFO full */
> +       case I2C_IT_RXFF:
> +               for (count = MAX_I2C_FIFO_THRESHOLD; count > 0; count--) {
> +                       *dev->cli.buffer = readb(dev->virtbase + I2C_RFR);
> +                       dev->cli.buffer++;
> +               }
> +               dev->cli.count -= MAX_I2C_FIFO_THRESHOLD;
> +               dev->cli.xfer_bytes += MAX_I2C_FIFO_THRESHOLD;
> +               break;
> +
> +       /* Master Transaction Done with/without stop */
> +       case I2C_IT_MTD:
> +       case I2C_IT_MTDWS:
> +               if (dev->cli.operation == I2C_READ) {
> +                       while (!readl(dev->virtbase + I2C_RISR) & I2C_IT_RXFE) {
> +                               if (dev->cli.count == 0)
> +                                       break;
> +                               *dev->cli.buffer =
> +                                       readb(dev->virtbase + I2C_RFR);
> +                               dev->cli.buffer++;
> +                               dev->cli.count--;
> +                               dev->cli.xfer_bytes++;
> +                       }
> +               }
> +
> +               i2c_set_bit(dev->virtbase + I2C_ICR, I2C_IT_MTD);
> +               i2c_set_bit(dev->virtbase + I2C_ICR, I2C_IT_MTDWS);
> +
> +               disable_interrupts(dev,
> +                               (I2C_IT_TXFNE | I2C_IT_TXFE | I2C_IT_TXFF
> +                                       | I2C_IT_TXFOVR | I2C_IT_RXFNF
> +                                       | I2C_IT_RXFF | I2C_IT_RXFE));
> +
> +               if (dev->cli.count) {
> +                       dev->result = -1;
> +                       dev_err(&dev->pdev->dev, "%lu bytes still remain to be"
> +                                       "xfered\n", dev->cli.count);
> +                       (void) init_hw(dev);
> +               }
> +               complete(&dev->xfer_complete);
> +
> +               break;
> +
> +       /* Master Arbitration lost interrupt */
> +       case I2C_IT_MAL:
> +               dev->result = -1;
> +               (void) init_hw(dev);
> +
> +               i2c_set_bit(dev->virtbase + I2C_ICR, I2C_IT_MAL);
> +               complete(&dev->xfer_complete);
> +
> +               break;
> +
> +       /*
> +        * Bus Error interrupt.
> +        * This happens when an unexpected start/stop condition occurs
> +        * during the transaction.
> +        */
> +       case I2C_IT_BERR:
> +               dev->result = -1;
> +               /* get the status */
> +               if (((readl(dev->virtbase + I2C_SR) >> 2) & 0x3) == I2C_ABORT)
> +                       (void) init_hw(dev);
> +
> +               i2c_set_bit(dev->virtbase + I2C_ICR, I2C_IT_BERR);
> +               complete(&dev->xfer_complete);
> +
> +               break;
> +
> +       /*
> +        * Tx FIFO overrun interrupt.
> +        * This is set when a write operation in Tx FIFO is performed and
> +        * the Tx FIFO is full.
> +        */
> +       case I2C_IT_TXFOVR:
> +               dev->result = -1;
> +               (void) init_hw(dev);
> +
> +               dev_err(&dev->pdev->dev, "Tx Fifo Over run\n");
> +               complete(&dev->xfer_complete);
> +
> +               break;
> +
> +       /* unhandled interrupts by this driver - TODO*/
> +       case I2C_IT_TXFE:
> +       case I2C_IT_TXFF:
> +       case I2C_IT_RXFE:
> +       case I2C_IT_RFSR:
> +       case I2C_IT_RFSE:
> +       case I2C_IT_WTSR:
> +       case I2C_IT_STD:
> +               dev_err(&dev->pdev->dev, "unhandled Interrupt\n");
> +               break;
> +       default:
> +               dev_err(&dev->pdev->dev, "spurious Interrupt..\n");
> +               break;
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int __init nmk_i2c_probe(struct platform_device *pdev)
> +{
> +       int ret = 0;
> +       struct resource *res;
> +       struct nmk_i2c_controller *pdata =
> +                       pdev->dev.platform_data;
> +       struct nmk_i2c_dev      *dev;
> +       struct i2c_adapter *adap;
> +
> +       dev = kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
> +       if (!dev) {
> +               dev_err(&pdev->dev, "cannot allocate memory\n");
> +               ret = -ENOMEM;
> +               goto err_no_mem;
> +       }
> +
> +       dev->pdev = pdev;
> +       platform_set_drvdata(pdev, dev);
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               ret = -ENOENT;
> +               goto err_no_resource;
> +       }
> +
> +       if (request_mem_region(res->start, resource_size(res),
> +               DRIVER_NAME "I/O region") ==    NULL)   {
> +               ret = -EBUSY;
> +               goto err_no_region;
> +       }
> +
> +       dev->virtbase = ioremap(res->start, resource_size(res));
> +       if (!dev->virtbase) {
> +               ret = -ENOMEM;
> +               goto err_no_ioremap;
> +       }
> +
> +       dev->irq = platform_get_irq(pdev, 0);
> +       ret = request_irq(dev->irq, i2c_irq_handler, IRQF_DISABLED,
> +                               DRIVER_NAME, dev);
> +       if (ret) {
> +               dev_err(&pdev->dev, "cannot claim the irq %d\n", dev->irq);
> +               goto err_irq;
> +       }
> +
> +       dev->clk = clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(dev->clk)) {
> +               dev_err(&pdev->dev, "could not get i2c clock\n");
> +               ret = PTR_ERR(dev->clk);
> +               goto err_no_clk;
> +       }
> +
> +       clk_enable(dev->clk);
> +
> +       adap = &dev->adap;
> +       adap->dev.parent = &pdev->dev;
> +       adap->owner     = THIS_MODULE;
> +       adap->class     = I2C_CLASS_HWMON | I2C_CLASS_SPD;
> +       adap->algo      = &nmk_i2c_algo;
> +
> +       /* fetch the controller id */
> +       adap->nr        = pdev->id;
> +
> +       /* fetch the controller configuration from machine */
> +       dev->cfg.clk_freq = pdata->clk_freq;
> +       dev->cfg.slsu   = pdata->slsu;
> +       dev->cfg.tft    = pdata->tft;
> +       dev->cfg.rft    = pdata->rft;
> +       dev->cfg.sm     = pdata->sm;
> +
> +       i2c_set_adapdata(adap, dev);
> +
> +       ret = init_hw(dev);
> +       if (ret != 0) {
> +               dev_err(&pdev->dev, "error in initializing i2c hardware\n");
> +               goto err_init_hw;
> +       }
> +
> +       dev_dbg(&pdev->dev, "initialize I2C%d bus on virtual "
> +               "base %p\n", pdev->id, dev->virtbase);
> +
> +       ret = i2c_add_numbered_adapter(adap);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to add adapter\n");
> +               goto err_add_adap;
> +       }
> +
> +       return 0;
> +
> + err_init_hw:
> +       clk_disable(dev->clk);
> + err_add_adap:
> +       clk_put(dev->clk);
> + err_no_clk:
> +       free_irq(dev->irq, dev);
> + err_irq:
> +       iounmap(dev->virtbase);
> + err_no_ioremap:
> +       release_mem_region(res->start, resource_size(res));
> + err_no_region:
> +       platform_set_drvdata(pdev, NULL);
> + err_no_resource:
> +       kfree(dev);
> + err_no_mem:
> +
> +       return ret;
> +}
> +
> +static int __exit nmk_i2c_remove(struct platform_device *pdev)
> +{
> +       struct nmk_i2c_dev *dev = platform_get_drvdata(pdev);
> +
> +       i2c_del_adapter(&dev->adap);
> +       flush_i2c_fifo(dev);
> +       disable_all_interrupts(dev);
> +       clear_all_interrupts(dev);
> +       /* disable the controller */
> +       i2c_clr_bit(dev->virtbase + I2C_CR, I2C_CR_PE);
> +       free_irq(dev->irq, dev);
> +       iounmap(dev->virtbase);
> +       clk_disable(dev->clk);
> +       clk_put(dev->clk);
> +       platform_set_drvdata(pdev, NULL);
> +       kfree(dev);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver nmk_i2c_driver = {
> +       .driver = {
> +               .owner = THIS_MODULE,
> +               .name = DRIVER_NAME,
> +       },
> +
> +       .probe = nmk_i2c_probe,
> +       .remove = __exit_p(nmk_i2c_remove),
> +};
> +
> +static int __init nmk_i2c_init(void)
> +{
> +       return platform_driver_register(&nmk_i2c_driver);
> +}
> +
> +static void __exit nmk_i2c_exit(void)
> +{
> +       platform_driver_unregister(&nmk_i2c_driver);
> +       return;
> +}
> +
> +subsys_initcall(nmk_i2c_init);
> +module_exit(nmk_i2c_exit);
> +
> +MODULE_AUTHOR("Sachin Verma, Srinidhi KASAGAR");
> +MODULE_DESCRIPTION("Nomadik/Ux500 I2C driver");
> +MODULE_LICENSE("GPL");
> --
> 1.6.3.GIT
> 

