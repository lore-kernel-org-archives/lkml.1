Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYGGTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYGGTVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYGGTVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:21:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:10149 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbYGGTVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WJJ+osoizHpo6/8KBrFMqdGLrW0rPpXLnT0xn3Q6Tc+8tquLVw8/2pNXyZ6HoVPHXg
         7iLKZvE5Q5dBBN9bhody0N+Chdrc0Xlss4w/GvBwJrX7q3DEGvH2Xz0WAjAwKT6obdtv
         fr/dJLNIocL1u873g1tsyKfuMlj8GgriFX7mQ=
Message-ID: <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com>
Date: Mon, 7 Jul 2008 21:21:07 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: stefan@datenfreihafen.org
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile phones
Cc: linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com,
       linux-kernel@vger.kernel.org, "Daniel Ribeiro" <wyrm@openezx.org>
In-Reply-To: <20080707184129.554483476@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080707184000.411913919@datenfreihafen.org>
	 <20080707184129.554483476@datenfreihafen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 8:40 PM,  <stefan@datenfreihafen.org> wrote:
> The PCAP Asic as present on EZX phones is a multi function device with voltage
> regulators, irq expander, touch screen controller and audio codec.
> It is connected to the processor via SPI, this driver provides read/write
> functions to its registers and a irq demultiplexer.

Are the EZX phones expected to be the only linux devices with PCAP?
Otherwise I'd dislike the hardcoded IRQ numbers in the MFD driver.

The machine_is_xyz() calls inside ezx-pcap could be replaced with
configuration via platform_data (have pcap_platform_data->cs_inverted,
for example)

> Signed-off-by: Daniel Ribeiro <wyrm@openezx.org>
>
> PATCH FOLLOWS
> KernelVersion: 2.6-arm-git pxa branch
>
> Index: linux-2.6-arm/drivers/mfd/ezx-pcap.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6-arm/drivers/mfd/ezx-pcap.c
> @@ -0,0 +1,402 @@
> +/* Driver for Motorola PCAP2 as present in EZX phones
> + *
> + * This is both a SPI device driver for PCAP itself, as well as
> + * an IRQ demultiplexer for handling PCAP generated events such as
> + * headphone jack sense by downstream drivers.
> + *
> + * Copyright (C) 2006 Harald Welte <laforge@openezx.org>
> + * Copyright (C) 2007-2008 Daniel Ribeiro <wyrm@openezx.org>
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel_stat.h>
> +#include <linux/proc_fs.h>
> +#include <linux/mfd/ezx-pcap.h>
> +#include <linux/delay.h>
> +#include <linux/gpio.h>
> +
> +#include <asm/hardware.h>
> +#include <asm/mach-types.h>
> +
> +#include <asm/arch/ssp.h>
> +#include <asm/arch/pxa-regs.h>
> +#include <asm/arch/regs-ssp.h>
> +#include <asm/arch/mfp-pxa27x.h>
> +#include <asm/arch/irqs.h>
> +#include <asm/arch/mmc.h>
> +#include <asm/mach/irq.h>
> +
> +#if 0
> +#define DEBUGP(x, args...) printk(x, ## args)
> +#else
> +#define DEBUGP(x, args...)
> +#endif

Could you remove the custom debug macros and use pr_debug (or even
better, dev_dbg) instead?

> +static DEFINE_SPINLOCK(ezx_ssp_lock);
> +static struct ssp_dev ezx_ssp_dev;
> +static struct ssp_state ezx_ssp_state;
> +static struct pcap_platform_data *pcap_data;
> +static int pcap_irq;
> +
> +static u_int32_t ezx_ssp_pcap_putget(u_int32_t data)
> +{
> +       unsigned long flag;
> +       u_int32_t ret = 0;
> +
> +       spin_lock_irqsave(&ezx_ssp_lock, flag);
> +       if (pcap_data->cs >= 0) {
> +               if (machine_is_ezx_a780() || machine_is_ezx_e680())
> +                       gpio_set_value(pcap_data->cs, 0);
> +               else
> +                       gpio_set_value(pcap_data->cs, 1);
> +       }
> +
> +       ssp_write_word(&ezx_ssp_dev, data);
> +       ssp_read_word(&ezx_ssp_dev, &ret);
> +
> +       if (pcap_data->cs >= 0) {
> +               if (machine_is_ezx_a780() || machine_is_ezx_e680())
> +                       gpio_set_value(pcap_data->cs, 1);
> +               else
> +                       gpio_set_value(pcap_data->cs, 0);
> +       }
> +
> +       spin_unlock_irqrestore(&ezx_ssp_lock, flag);
> +
> +       return ret;
> +}
> +
> +void ezx_pcap_write(u_int8_t reg_num, u_int32_t value)
> +{
> +       value &= PCAP_REGISTER_VALUE_MASK;
> +       value |= PCAP_REGISTER_WRITE_OP_BIT
> +               | (reg_num<<PCAP_REGISTER_ADDRESS_SHIFT);
> +
> +       ezx_ssp_pcap_putget(value);
> +
> +       DEBUGP("pcap write r%x: 0x%08x\n", reg_num, value);
> +}
> +EXPORT_SYMBOL_GPL(ezx_pcap_write);
> +
> +void ezx_pcap_read(u_int8_t reg_num, u_int32_t *value)
> +{
> +       u_int32_t frame = PCAP_REGISTER_READ_OP_BIT
> +               | (reg_num<<PCAP_REGISTER_ADDRESS_SHIFT);
> +
> +       *value = ezx_ssp_pcap_putget(frame);
> +
> +       DEBUGP("pcap read r%x:  0x%08x\n", reg_num, *value);
> +}
> +EXPORT_SYMBOL_GPL(ezx_pcap_read);
> +
> +void ezx_pcap_set_sw(u_int8_t sw, u_int8_t what, u_int8_t val)
> +{
> +       u_int32_t tmp;
> +
> +       ezx_pcap_read(PCAP_REG_LOWPWR, &tmp);
> +       tmp &= ~(0xf << (sw + what));
> +       tmp |= ((val & 0xf) << (sw + what));
> +       ezx_pcap_write(PCAP_REG_LOWPWR, tmp);
> +}
> +EXPORT_SYMBOL_GPL(ezx_pcap_set_sw);
> +
> +static u_int8_t vaux_table[][8] = {
> +       /*              EN      INDEX   MASK    STBY    LOWPWR  */
> +       [VAUX1] = {     1,      2,      0x3,    22,     23,     },
> +       [VAUX2] = {     4,      5,      0x3,    0,      1,      },
> +       [VAUX3] = {     7,      8,      0xf,    2,      3,      },
> +       [VAUX4] = {     12,     13,     0x3,    4,      5,      },
> +       [VSIM]  = {     17,     18,     0x1,    0xff,   6,      },
> +       [VSIM2] = {     16,     0xff,   0x0,    0xff,   7,      },
> +       [VVIB]  = {     19,     20,     0x3,    0xff,   0xff,   },
> +       [VC]    = {     0xff,   0xff,   0x0,    24,     0xff,   },
> +};
> +
> +int ezx_pcap_set_vaux(u_int8_t vaux, u_int8_t what, u_int8_t val)
> +{
> +       u_int8_t reg, shift, mask;
> +       u_int32_t tmp;
> +
> +       switch (what) {
> +       case VAUX_EN:
> +               reg = PCAP_REG_AUXVREG;
> +               shift = vaux_table[vaux][VAUX_EN];
> +               mask = 0x1;
> +               break;
> +       case VAUX_VAL:
> +               reg = PCAP_REG_AUXVREG;
> +               shift = vaux_table[vaux][VAUX_VAL];
> +               mask = vaux_table[vaux][VAUX_MASK];
> +               break;
> +       case VAUX_STBY:
> +               if (vaux == VAUX1) /* exception */
> +                       reg = PCAP_REG_AUXVREG;
> +               else
> +                       reg = PCAP_REG_LOWPWR;
> +               shift = vaux_table[vaux][VAUX_STBY];
> +               mask = 0x1;
> +               break;
> +       case VAUX_LOWPWR:
> +               if (vaux == VAUX1)
> +                       reg = PCAP_REG_AUXVREG;
> +               else
> +                       reg = PCAP_REG_LOWPWR;
> +               shift = vaux_table[vaux][VAUX_LOWPWR];
> +               mask = 0x1;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       /* invalid setting */
> +       if (shift == 0xff || val > mask)
> +               return -EINVAL;
> +
> +       ezx_pcap_read(reg, &tmp);
> +       tmp &= ~(mask << shift);
> +       tmp |= ((val & mask) << shift);
> +       ezx_pcap_write(reg, tmp);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(ezx_pcap_set_vaux);
> +
> +/* IRQ Handling */
> +
> +/* Array indexed by BIT POSITION of PCAP register, returns IRQ number */
> +static unsigned int pcap2irq[] = {
> +       [0]     = EZX_IRQ_ADCDONE,
> +       [1]     = EZX_IRQ_TS,
> +       [2]     = EZX_IRQ_1HZ, /* 1HZ */
> +       [3]     = EZX_IRQ_WH, /* WH */
> +       [4]     = EZX_IRQ_WL, /* WL */
> +       [5]     = EZX_IRQ_TODA, /* TODA */
> +       [6]     = EZX_IRQ_USB4V,
> +       [7]     = EZX_IRQ_ONOFF, /* ONOFF */
> +       [8]     = EZX_IRQ_ONOFF2, /* ONOFF2 */
> +       [9]     = EZX_IRQ_USB1V,
> +       [10]    = EZX_IRQ_MOBPORT, /* MOBPORT */
> +       [11]    = EZX_IRQ_MIC,
> +       [12]    = EZX_IRQ_HEADJACK,
> +       [13]    = EZX_IRQ_ST, /* ST */
> +       [14]    = EZX_IRQ_PC, /* PC */
> +       [15]    = EZX_IRQ_WARM, /* WARM */
> +       [16]    = EZX_IRQ_EOL, /* EOL */
> +       [17]    = EZX_IRQ_CLK, /* CLK */
> +       [18]    = EZX_IRQ_SYSRST, /* SYSRST */
> +       [19]    = 0,
> +       [20]    = EZX_IRQ_ADCDONE2,
> +       [21]    = EZX_IRQ_SOFTRESET, /* SOFTRESET */
> +       [22]    = EZX_IRQ_MNEXB, /* MNEXB */
> +};
> +
> +/* Array indexed by IRQ NUMBER, returns PCAP absolute value */
> +static unsigned int irq2pcap[] = {
> +       [EZX_IRQ_MNEXB]         = PCAP_IRQ_MNEXB,
> +       [EZX_IRQ_SOFTRESET]     = PCAP_IRQ_SOFTRESET,
> +       [EZX_IRQ_SYSRST]        = PCAP_IRQ_SYSRST,
> +       [EZX_IRQ_CLK]           = PCAP_IRQ_CLK,
> +       [EZX_IRQ_EOL]           = PCAP_IRQ_EOL,
> +       [EZX_IRQ_WARM]          = PCAP_IRQ_WARM,
> +       [EZX_IRQ_PC]            = PCAP_IRQ_PC,
> +       [EZX_IRQ_ST]            = PCAP_IRQ_ST,
> +       [EZX_IRQ_MOBPORT]       = PCAP_IRQ_MOBPORT,
> +       [EZX_IRQ_ONOFF2]        = PCAP_IRQ_ONOFF2,
> +       [EZX_IRQ_ONOFF]         = PCAP_IRQ_ONOFF,
> +       [EZX_IRQ_TODA]          = PCAP_IRQ_TODA,
> +       [EZX_IRQ_WL]            = PCAP_IRQ_WL,
> +       [EZX_IRQ_WH]            = PCAP_IRQ_WH,
> +       [EZX_IRQ_1HZ]           = PCAP_IRQ_1HZ,
> +       [EZX_IRQ_USB4V]         = PCAP_IRQ_USB4V,
> +       [EZX_IRQ_USB1V]         = PCAP_IRQ_USB1V,
> +       [EZX_IRQ_HEADJACK]      = PCAP_IRQ_A1,
> +       [EZX_IRQ_MIC]           = PCAP_IRQ_MB2,
> +       [EZX_IRQ_TS]            = PCAP_IRQ_TS,
> +       [EZX_IRQ_ADCDONE]       = PCAP_IRQ_ADCDONE,
> +       [EZX_IRQ_ADCDONE2]      = PCAP_IRQ_ADCDONE2,
> +};
> +
> +static void pcap_ack_irq(unsigned int irq)
> +{
> +       DEBUGP("pcap_ack_irq: %u\n", irq);
> +       ezx_pcap_write(PCAP_REG_ISR, irq2pcap[irq]);
> +}
> +
> +static void pcap_mask_irq(unsigned int irq)
> +{
> +       u_int32_t reg;
> +       unsigned long flag;
> +
> +       spin_lock_irqsave(&ezx_ssp_lock, flag);
> +       DEBUGP("pcap_mask_irq: %u\n", irq);
> +       ezx_pcap_read(PCAP_REG_MSR, &reg);
> +       reg |= irq2pcap[irq];
> +       ezx_pcap_write(PCAP_REG_MSR, reg);
> +       spin_unlock_irqrestore(&ezx_ssp_lock, flag);
> +}
> +
> +static void pcap_unmask_irq(unsigned int irq)
> +{
> +       u_int32_t tmp;
> +       unsigned long flag;
> +
> +       spin_lock_irqsave(&ezx_ssp_lock, flag);
> +       DEBUGP("pcap_unmask_irq: %u\n", irq);
> +       ezx_pcap_read(PCAP_REG_MSR, &tmp);
> +       tmp &= ~irq2pcap[irq];
> +       ezx_pcap_write(PCAP_REG_MSR, tmp);
> +       spin_unlock_irqrestore(&ezx_ssp_lock, flag);
> +}
> +
> +static struct irq_chip pcap_chip = {
> +       .name   = "ezx-pcap",
> +       .ack    = pcap_ack_irq,
> +       .mask   = pcap_mask_irq,
> +       .unmask = pcap_unmask_irq,
> +};
> +
> +/* handler for interrupt received from PCAP via GPIO */
> +static void pcap_irq_demux_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +       int i;
> +       u_int32_t isr;
> +
> +       desc->chip->ack(irq);
> +       ezx_pcap_read(PCAP_REG_ISR, &isr);
> +       for (i = ARRAY_SIZE(pcap2irq)-1; i >= 0; i--) {
> +               unsigned int pirq = pcap2irq[i];
> +               if (!(isr & irq2pcap[pirq]))
> +                       continue;
> +               desc = &irq_desc[pirq];
> +               DEBUGP("found irq %u\n", pirq);
> +               desc_handle_irq(pirq, desc);
> +       }
> +}
> +
> +static int ezx_pcap_remove(struct platform_device *pdev)
> +{
> +       int irq;
> +       DEBUGP("exz_pcap_remove entered\n");
> +
> +       set_irq_chained_handler(pcap_irq, NULL);
> +
> +       for (irq = EZX_IRQ(0); irq <= EZX_IRQ(21); irq++) {
> +               set_irq_chip(irq, NULL);
> +               set_irq_handler(irq, NULL);
> +               set_irq_flags(irq, 0);
> +       }
> +
> +       ssp_exit(&ezx_ssp_dev);
> +
> +       return 0;
> +}
> +
> +static int __init ezx_pcap_probe(struct platform_device *pdev)
> +{
> +       unsigned int ret, irq;
> +       DEBUGP("ezx_pcap_probe entered\n");
> +
> +       pcap_data = pdev->dev.platform_data;
> +
> +       if (pcap_data->cs >= 0) {
> +               if (machine_is_ezx_a780() || machine_is_ezx_e680())
> +                       gpio_direction_output(pcap_data->cs, 1);
> +               else
> +                       gpio_direction_output(pcap_data->cs, 0);
> +       }
> +       pcap_irq = platform_get_irq(pdev, 0);
> +       if (pcap_irq < 0) {
> +               printk(KERN_ERR "Unable to get IRQ for pcap!\n");
> +               return pcap_irq;
> +       }
> +
> +       ret = ssp_init(&ezx_ssp_dev, pcap_data->port, 0);
> +       if (ret) {
> +               printk(KERN_ERR "Unable to register SSP handler!\n");
> +               return ret;
> +       }
> +
> +       ssp_disable(&ezx_ssp_dev);
> +       ssp_config(&ezx_ssp_dev,
> +               (SSCR0_Motorola | SSCR0_DataSize(16) | SSCR0_EDSS),
> +               (SSCR1_TxTresh(1) | SSCR1_RxTresh(1)),
> +               0, SSCR0_SerClkDiv(pcap_data->clk));
> +       ssp_enable(&ezx_ssp_dev);
> +
> +       if (pcap_data->init)
> +               pcap_data->init();
> +
> +       /* set up interrupt demultiplexing code for PCAP2 irqs */
> +       for (irq = EZX_IRQ(0); irq <= EZX_IRQ(21); irq++) {
> +               set_irq_chip(irq, &pcap_chip);
> +               set_irq_handler(irq, handle_level_irq);
> +               set_irq_flags(irq, IRQF_VALID);
> +       }
> +       set_irq_type(pcap_irq, IRQ_TYPE_EDGE_RISING);
> +       set_irq_chained_handler(pcap_irq, pcap_irq_demux_handler);
> +       set_irq_wake(pcap_irq, 1);
> +
> +       /* mask/ack all PCAP interrupts */
> +       ezx_pcap_write(PCAP_REG_MSR, PCAP_MASK_ALL_INTERRUPT);
> +       ezx_pcap_write(PCAP_REG_ISR, PCAP_CLEAR_INTERRUPT_REGISTER);
> +
> +
> +       printk(KERN_INFO "ezx-pcap: ssp driver registered\n");
> +       return ret;
> +}
> +
> +#ifdef CONFIG_PM
> +static int ezx_pcap_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +       DEBUGP("pcap suspend!\n");
> +       ssp_flush(&ezx_ssp_dev);
> +       ssp_save_state(&ezx_ssp_dev, &ezx_ssp_state);
> +       ssp_disable(&ezx_ssp_dev);
> +       return 0;
> +}
> +
> +static int ezx_pcap_resume(struct platform_device *dev)
> +{
> +       DEBUGP("pcap resume!\n");
> +       ssp_restore_state(&ezx_ssp_dev, &ezx_ssp_state);
> +       ssp_enable(&ezx_ssp_dev);
> +
> +       return 0;
> +}
> +#endif
> +
> +static struct platform_driver ezxpcap_driver = {
> +       .probe          = ezx_pcap_probe,
> +       .remove         = ezx_pcap_remove,
> +#ifdef CONFIG_PM
> +       .suspend        = ezx_pcap_suspend,
> +       .resume         = ezx_pcap_resume,
> +#endif
> +       .driver         = {
> +               .name   = "ezx-pcap",
> +               .owner  = THIS_MODULE,
> +       },
> +};
> +
> +static int __init ezx_pcap_init(void)
> +{
> +       DEBUGP("ezx_pcap_init entered\n");
> +       return platform_driver_register(&ezxpcap_driver);
> +}
> +
> +static void __exit ezx_pcap_exit(void)
> +{
> +       return platform_driver_unregister(&ezxpcap_driver);
> +}
> +
> +module_init(ezx_pcap_init);

Depending on what platform_devices depend on this, maybe use
subsys_initcall here.

> +module_exit(ezx_pcap_exit);

Why bother with module_exit when the Kconfig option is bool?

> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Harald Welte");
> +MODULE_DESCRIPTION("Motorola PCAP2 ASIC Driver");
> +
> Index: linux-2.6-arm/include/linux/mfd/ezx-pcap.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6-arm/include/linux/mfd/ezx-pcap.h
> @@ -0,0 +1,248 @@
> +/*
> + * Copyright 2007 Daniel Ribeiro <wyrm@openezx.org>
> + *
> + * For further information, please see http://wiki.openezx.org/PCAP2
> + */
> +
> +#ifndef EZX_PCAP_H
> +#define EZX_PCAP_H
> +
> +struct pcap_platform_data {
> +       int port;               /* SSP port */
> +       int cs;                 /* CS gpio */
> +       int clk;
> +       int (*init)(void);      /* board specific driver init */
> +};
> +
> +#define PCAP_REGISTER_WRITE_OP_BIT     0x80000000
> +#define PCAP_REGISTER_READ_OP_BIT      0x00000000
> +
> +#define PCAP_REGISTER_VALUE_MASK       0x01ffffff
> +#define PCAP_REGISTER_ADDRESS_MASK     0x7c000000
> +#define PCAP_REGISTER_ADDRESS_SHIFT    26
> +#define PCAP_REGISTER_NUMBER           32
> +#define PCAP_CLEAR_INTERRUPT_REGISTER  0x01ffffff
> +#define PCAP_MASK_ALL_INTERRUPT                0x01ffffff
> +
> +
> +#define pbit(reg, bit) ((reg << PCAP_REGISTER_ADDRESS_SHIFT) | bit)
> +
> +/* registers acessible by both pcap ports */
> +#define PCAP_REG_ISR           0x0     /* Interrupt Status */
> +#define PCAP_REG_MSR           0x1     /* Interrupt Mask */
> +#define PCAP_REG_PSTAT         0x2     /* Processor Status */
> +#define PCAP_REG_VREG2         0x6     /* Regulator Bank 2 Control */
> +#define PCAP_REG_AUXVREG       0x7     /* Auxiliary Regulator Control */
> +#define PCAP_REG_BATT          0x8     /* Battery Control */
> +#define PCAP_REG_ADC           0x9     /* AD Control */
> +#define PCAP_REG_ADR           0xa     /* AD Result */
> +#define PCAP_REG_CODEC         0xb     /* Audio Codec Control */
> +#define PCAP_REG_RX_AMPS       0xc     /* RX Audio Amplifiers Control */
> +#define PCAP_REG_ST_DAC                0xd     /* Stereo DAC Control */
> +#define PCAP_REG_BUSCTRL       0x14    /* Connectivity Control */
> +#define PCAP_REG_PERIPH                0x15    /* Peripheral Control */
> +#define PCAP_REG_LOWPWR                0x18    /* Regulator Low Power Control */
> +#define PCAP_REG_TX_AMPS       0x1a    /* TX Audio Amplifiers Control */
> +#define PCAP_REG_GP            0x1b    /* General Purpose */
> +
> +/* registers acessible by pcap port 1 only (a1200, e2 & e6) */
> +#define PCAP_REG_INT_SEL       0x3     /* Interrupt Select */
> +#define PCAP_REG_SWCTRL                0x4     /* Switching Regulator Control */
> +#define PCAP_REG_VREG1         0x5     /* Regulator Bank 1 Control */
> +#define PCAP_REG_RTC_TOD       0xe     /* RTC Time of Day */
> +#define PCAP_REG_RTC_TODA      0xf     /* RTC Time of Day Alarm */
> +#define PCAP_REG_RTC_DAY       0x10    /* RTC Day */
> +#define PCAP_REG_RTC_DAYA      0x11    /* RTC Day Alarm */
> +#define PCAP_REG_MTRTMR                0x12    /* AD Monitor Timer */
> +#define PCAP_REG_PWR           0x13    /* Power Control */
> +#define PCAP_REG_AUXVREG_MASK  0x16    /* Auxiliary Regulator Mask */
> +#define PCAP_REG_VENDOR_REV    0x17
> +#define PCAP_REG_PERIPH_MASK   0x19    /* Peripheral Mask */
> +
> +/* interrupts - registers 0x0, 0x1, 0x2, 0x3 */
> +#define PCAP_IRQ_ADCDONE       (1 << 0)        /* AD Conversion Done Port 1 */
> +#define PCAP_IRQ_TS            (1 << 1)        /* Touch Screen */
> +#define PCAP_IRQ_1HZ           (1 << 2)        /* 1HZ Timer */
> +#define PCAP_IRQ_WH            (1 << 3)        /* "...high"??? */
> +#define PCAP_IRQ_WL            (1 << 4)        /* "...low"??? */
> +#define PCAP_IRQ_TODA          (1 << 5)        /* RTC Time Of Day?
> +                                                    (see "RTC_TODA") */
> +#define PCAP_IRQ_USB4V         (1 << 6)        /* USB above 4volt???
> +                                               called "USBDET_4V" in blob */

I assume that's for OTG operation. The VBUS voltage is valid from 4.4 V, and the
PXA27x UDC controller has "Vbus valid 4.0 V" and "Vbus valid 4.4 V" interrupts

> +#define PCAP_IRQ_ONOFF         (1 << 7)        /* in blob: "ONOFFSNS" */
> +#define PCAP_IRQ_ONOFF2                (1 << 8)        /* in blob: "ONOFFSNS2" */
> +#define PCAP_IRQ_USB1V         (1 << 9)        /* USB below 1volt???
> +                                                    in blob: "USBDET_1V" */
> +#define PCAP_IRQ_MOBPORT       (1 << 10)       /* GSM-related?? ("mobport",
> +                               see 958_MotDoc.pdf); in blob: "MOBSENSB" */
> +#define PCAP_IRQ_MB2           (1 << 11)       /* Mic; in blob: "MB2SNS" */
> +#define PCAP_IRQ_A1            (1 << 12)       /* Audio jack;
> +                                                    in blob: "A1SNS" */
> +#define PCAP_IRQ_ST            (1 << 13)       /* called "MSTB" in blob */
> +#define PCAP_IRQ_PC            (1 << 14)
> +#define PCAP_IRQ_WARM          (1 << 15)
> +#define PCAP_IRQ_EOL           (1 << 16)       /* battery End Of Life???
> +                                       (see below); in blob: "EOL_STAT" */
> +#define PCAP_IRQ_CLK           (1 << 17)       /* called "CLK_STAT" in blob */
> +#define PCAP_IRQ_SYSRST                (1 << 18)
> +#define PCAP_IRQ_ADCDONE2      (1 << 20)       /* AD Conversion Done Port 2 */
> +#define PCAP_IRQ_SOFTRESET     (1 << 21)
> +#define PCAP_IRQ_MNEXB         (1 << 22)
> +
> +/* register VREG2 (0x6) */
> +#define PCAP_VREG2_V1_STBY     (1 << 0)
> +#define PCAP_VREG2_V2_STBY     (1 << 1)
> +/* V3, SRAM: */
> +#define PCAP_VREG2_V3_STBY     (1 << 2)
> +#define PCAP_VREG2_V4_STBY     (1 << 3)
> +#define PCAP_VREG2_V5_STBY     (1 << 4)
> +/* V6, E680 I2C camera?: */
> +#define PCAP_VREG2_V6_STBY     (1 << 5)
> +#define PCAP_VREG2_V7_STBY     (1 << 6)
> +/* V8, PLL: */
> +#define PCAP_VREG2_V8_STBY     (1 << 7)
> +#define PCAP_VREG2_V9_STBY     (1 << 8)
> +#define PCAP_VREG2_V10_STBY    (1 << 9)
> +#define PCAP_VREG2_V1_LOWPWR   (1 << 10)
> +#define PCAP_VREG2_V2_LOWPWR   (1 << 11)
> +/* V3, SRAM: */
> +#define PCAP_VREG2_V3_LOWPWR   (1 << 12)
> +#define PCAP_VREG2_V4_LOWPWR   (1 << 13)
> +#define PCAP_VREG2_V5_LOWPWR   (1 << 14)
> +/* V6, E680 I2C camera?: */
> +#define PCAP_VREG2_V6_LOWPWR   (1 << 15)
> +#define PCAP_VREG2_V7_LOWPWR   (1 << 16)
> +/* V8, PLL: */
> +#define PCAP_VREG2_V8_LOWPWR   (1 << 17)
> +#define PCAP_VREG2_V9_LOWPWR   (1 << 18)
> +#define PCAP_VREG2_V10_LOWPWR  (1 << 19)
> +
> +/* register AUXVREG (0x7) */
> +#define VAUX1          0
> +#define VAUX2          1
> +#define VAUX3          2
> +#define VAUX4          3
> +#define VSIM           4
> +#define VSIM2          5
> +#define VVIB           6
> +#define VC             7
> +
> +#define VAUX_EN                0
> +#define VAUX_VAL       1
> +#define VAUX_MASK      2
> +#define VAUX_STBY      3
> +#define VAUX_LOWPWR    4
> +
> +#define PCAP_BATT_DAC_MASK             0x000000ff
> +#define PCAP_BATT_DAC_SHIFT            0
> +#define PCAP_BATT_B_FDBK               (1 << 8)
> +#define PCAP_BATT_EXT_ISENSE           (1 << 9)
> +#define PCAP_BATT_V_COIN_MASK          0x00003c00
> +#define PCAP_BATT_V_COIN_SHIFT         10
> +#define PCAP_BATT_I_COIN               (1 << 14)
> +#define PCAP_BATT_COIN_CH_EN           (1 << 15)
> +#define PCAP_BATT_EOL_SEL_MASK         0x000e0000
> +#define PCAP_BATT_EOL_SEL_SHIFT                17
> +#define PCAP_BATT_EOL_CMP_EN           (1 << 20)
> +#define PCAP_BATT_BATT_DET_EN          (1 << 21)
> +#define PCAP_BATT_THERMBIAS_CTRL       (1 << 22)
> +
> +#define PCAP_ADC_ADEN                  (1 << 0)
> +#define PCAP_ADC_RAND                  (1 << 1)
> +#define PCAP_ADC_AD_SEL1               (1 << 2)
> +#define PCAP_ADC_AD_SEL2               (1 << 3)
> +#define PCAP_ADC_ADA1_MASK             0x00000070
> +#define PCAP_ADC_ADA1_SHIFT            4
> +#define PCAP_ADC_ADA2_MASK             0x00000380
> +#define PCAP_ADC_ADA2_SHIFT            7
> +#define PCAP_ADC_ATO_MASK              0x00003c00
> +#define PCAP_ADC_ATO_SHIFT             10
> +#define PCAP_ADC_ATOX                  (1 << 14)
> +#define PCAP_ADC_MTR1                  (1 << 15)
> +#define PCAP_ADC_MTR2                  (1 << 16)
> +#define PCAP_ADC_TS_M_MASK             0x000e0000
> +#define PCAP_ADC_TS_M_SHIFT            17
> +#define PCAP_ADC_TS_REF_LOWPWR         (1 << 20)
> +#define PCAP_ADC_TS_REFENB             (1 << 21)
> +#define PCAP_ADC_BATT_I_POLARITY       (1 << 22)
> +#define PCAP_ADC_BATT_I_ADC            (1 << 23)
> +
> +#define PCAP_ADR_ADD1_MASK             0x000003ff
> +#define PCAP_ADR_ADD1_SHIFT            0
> +#define PCAP_ADR_ADD2_MASK             0x000ffc00
> +#define PCAP_ADR_ADD2_SHIFT            10
> +#define PCAP_ADR_ADINC1                        (1 << 20)
> +#define PCAP_ADR_ADINC2                        (1 << 21)
> +#define PCAP_ADR_ASC                   (1 << 22)
> +#define PCAP_ADR_ONESHOT               (1 << 23)
> +
> +#define PCAP_BUSCTRL_FSENB             (1 << 0)
> +#define PCAP_BUSCTRL_USB_SUSPEND       (1 << 1)
> +#define PCAP_BUSCTRL_USB_PU            (1 << 2)
> +#define PCAP_BUSCTRL_USB_PD            (1 << 3)
> +#define PCAP_BUSCTRL_VUSB_EN           (1 << 4)
> +#define PCAP_BUSCTRL_USB_PS            (1 << 5)
> +#define PCAP_BUSCTRL_VUSB_MSTR_EN      (1 << 6)
> +#define PCAP_BUSCTRL_VBUS_PD_ENB       (1 << 7)
> +#define PCAP_BUSCTRL_CURRLIM           (1 << 8)
> +#define PCAP_BUSCTRL_RS232ENB          (1 << 9)
> +#define PCAP_BUSCTRL_RS232_DIR         (1 << 10)
> +#define PCAP_BUSCTRL_SE0_CONN          (1 << 11)
> +#define PCAP_BUSCTRL_USB_PDM           (1 << 12)
> +#define PCAP_BUSCTRL_BUS_PRI_ADJ       (1 << 24)
> +
> +#define PCAP_BIT_PERIPH_BL_CTRL0       0x54000001
> +#define PCAP_BIT_PERIPH_BL_CTRL1       0x54000002
> +#define PCAP_BIT_PERIPH_BL_CTRL2       0x54000004
> +#define PCAP_BIT_PERIPH_BL_CTRL3       0x54000008
> +#define PCAP_BIT_PERIPH_BL_CTRL4       0x54000010
> +#define PCAP_BIT_PERIPH_LEDR_EN                0x54000020
> +#define PCAP_BIT_PERIPH_LEDG_EN                0x54000040
> +#define PCAP_BIT_PERIPH_LEDR_CTRL0     0x54000080
> +#define PCAP_BIT_PERIPH_LEDR_CTRL1     0x54000100
> +#define PCAP_BIT_PERIPH_LEDR_CTRL2     0x54000200
> +#define PCAP_BIT_PERIPH_LEDR_CTRL3     0x54000400
> +#define PCAP_BIT_PERIPH_LEDG_CTRL0     0x54000800
> +#define PCAP_BIT_PERIPH_LEDG_CTRL1     0x54001000
> +#define PCAP_BIT_PERIPH_LEDG_CTRL2     0x54002000
> +#define PCAP_BIT_PERIPH_LEDG_CTRL3     0x54004000
> +#define PCAP_BIT_PERIPH_LEDR_I0                0x54008000
> +#define PCAP_BIT_PERIPH_LEDR_I1                0x54010000
> +#define PCAP_BIT_PERIPH_LEDG_I0                0x54020000
> +#define PCAP_BIT_PERIPH_LEDG_I1                0x54040000
> +#define PCAP_BIT_PERIPH_SKIP           0x54080000
> +#define PCAP_BIT_PERIPH_BL2_CTRL0      0x54100000
> +#define PCAP_BIT_PERIPH_BL2_CTRL1      0x54200000
> +#define PCAP_BIT_PERIPH_BL2_CTRL2      0x54400000
> +#define PCAP_BIT_PERIPH_BL2_CTRL3      0x54800000
> +#define PCAP_BIT_PERIPH_BL2_CTRL4      0x55000000
> +
> +/* LOWPWR */
> +#define SW1            8
> +#define SW2            16
> +
> +#define SW_MODE                0
> +#define SW_VOLTAGE     4
> +
> +#define SW_VOLTAGE_900 0x0
> +#define SW_VOLTAGE_950 0x1
> +#define SW_VOLTAGE_1000        0x2
> +#define SW_VOLTAGE_1050        0x3
> +#define SW_VOLTAGE_1100        0x4
> +#define SW_VOLTAGE_1150        0x5
> +#define SW_VOLTAGE_1200        0x6
> +#define SW_VOLTAGE_1250        0x7
> +#define SW_VOLTAGE_1300        0x8
> +#define SW_VOLTAGE_1350        0x9
> +#define SW_VOLTAGE_1400        0xa
> +#define SW_VOLTAGE_1500        0xb
> +#define SW_VOLTAGE_1600        0xc
> +#define SW_VOLTAGE_1875        0xd
> +#define SW_VOLTAGE_2250        0xe
> +#define SW_VOLTAGE_4400        0xf
> +
> +void ezx_pcap_write(u_int8_t, u_int32_t);
> +void ezx_pcap_read(u_int8_t, u_int32_t *);
> +void ezx_pcap_set_sw(u_int8_t, u_int8_t, u_int8_t);
> +int ezx_pcap_set_vaux(u_int8_t, u_int8_t, u_int8_t);
> +#endif
> Index: linux-2.6-arm/include/asm-arm/arch-pxa/irqs.h
> ===================================================================
> --- linux-2.6-arm.orig/include/asm-arm/arch-pxa/irqs.h
> +++ linux-2.6-arm/include/asm-arm/arch-pxa/irqs.h
> @@ -89,7 +89,7 @@
>  * within sensible limits.
>  */
>  #define IRQ_BOARD_START                (PXA_GPIO_IRQ_BASE + PXA_GPIO_IRQ_NUM)
> -#define IRQ_BOARD_END          (IRQ_BOARD_START + 16)
> +#define IRQ_BOARD_END          (IRQ_BOARD_START + 22)
>
>  #define IRQ_SA1111_START       (IRQ_BOARD_END)
>  #define IRQ_GPAIN0             (IRQ_BOARD_END + 0)
> @@ -183,7 +183,8 @@
>       defined(CONFIG_MACH_TOSA) || \
>       defined(CONFIG_MACH_MAINSTONE) || \
>       defined(CONFIG_MACH_PCM027) || \
> -      defined(CONFIG_MACH_MAGICIAN)
> +      defined(CONFIG_MACH_MAGICIAN) || \
> +      defined(CONFIG_PXA_EZX)
>  #define NR_IRQS                        (IRQ_BOARD_END)
>  #else
>  #define NR_IRQS                        (IRQ_BOARD_START)
> @@ -237,6 +238,31 @@
>  #define PCM027_MMCDET_IRQ      PCM027_IRQ(2)
>  #define PCM027_PM_5V_IRQ       PCM027_IRQ(3)
>
> +/* EZX Interrupts (CONFIG_EZX) */
> +#define EZX_IRQ(x)         (IRQ_BOARD_START + (x))
> +#define EZX_IRQ_USB4V      EZX_IRQ(0) /* EMU */
> +#define EZX_IRQ_USB1V      EZX_IRQ(1) /* EMU */
> +#define EZX_IRQ_HEADJACK   EZX_IRQ(2) /* Audio connector */
> +#define EZX_IRQ_MIC        EZX_IRQ(3) /* Audio connector */
> +#define EZX_IRQ_ADCDONE    EZX_IRQ(4)
> +#define EZX_IRQ_TS         EZX_IRQ(5) /* TS touch */
> +#define EZX_IRQ_ADCDONE2   EZX_IRQ(6) /* TS x/y ADC ready */
> +#define EZX_IRQ_WH         EZX_IRQ(7)
> +#define EZX_IRQ_WL         EZX_IRQ(8)
> +#define EZX_IRQ_ONOFF      EZX_IRQ(9)
> +#define EZX_IRQ_ONOFF2     EZX_IRQ(10)
> +#define EZX_IRQ_MOBPORT    EZX_IRQ(11)
> +#define EZX_IRQ_TODA       EZX_IRQ(12)
> +#define EZX_IRQ_1HZ        EZX_IRQ(13)
> +#define EZX_IRQ_MNEXB      EZX_IRQ(14)
> +#define EZX_IRQ_ST         EZX_IRQ(15)
> +#define EZX_IRQ_PC         EZX_IRQ(16)
> +#define EZX_IRQ_SYSRST     EZX_IRQ(17)
> +#define EZX_IRQ_SOFTRESET  EZX_IRQ(18)
> +#define EZX_IRQ_EOL        EZX_IRQ(19)
> +#define EZX_IRQ_CLK        EZX_IRQ(20)
> +#define EZX_IRQ_WARM       EZX_IRQ(21)
> +
>  /* ITE8152 irqs */
>  /* add IT8152 IRQs beyond BOARD_END */
>  #ifdef CONFIG_PCI_HOST_ITE8152
> Index: linux-2.6-arm/drivers/mfd/Kconfig
> ===================================================================
> --- linux-2.6-arm.orig/drivers/mfd/Kconfig
> +++ linux-2.6-arm/drivers/mfd/Kconfig
> @@ -49,6 +49,13 @@
>        help
>          Support for Toshiba Mobile IO Controller TC6393XB
>
> +config EZX_PCAP
> +       bool "PCAP Support"
> +       depends on PXA_SSP && PXA_EZX
> +       help
> +         This enables the PCAP ASIC present on EZX Phones. This is
> +         needed for MMC, TouchScreen, Sound, USB, etc..
> +
>  endmenu
>
>  menu "Multimedia Capabilities Port drivers"
> Index: linux-2.6-arm/drivers/mfd/Makefile
> ===================================================================
> --- linux-2.6-arm.orig/drivers/mfd/Makefile
> +++ linux-2.6-arm/drivers/mfd/Makefile
> @@ -12,6 +12,8 @@
>
>  obj-$(CONFIG_MFD_CORE)         += mfd-core.o
>
> +obj-$(CONFIG_EZX_PCAP)         += ezx-pcap.o
> +
>  obj-$(CONFIG_MCP)              += mcp-core.o
>  obj-$(CONFIG_MCP_SA11X0)       += mcp-sa11x0.o
>  obj-$(CONFIG_MCP_UCB1200)      += ucb1x00-core.o
> Index: linux-2.6-arm/arch/arm/mach-pxa/Kconfig
> ===================================================================
> --- linux-2.6-arm.orig/arch/arm/mach-pxa/Kconfig
> +++ linux-2.6-arm/arch/arm/mach-pxa/Kconfig
> @@ -224,6 +224,8 @@
>        select PXA27x
>        select IWMMXT
>        select HAVE_PWM
> +       select PXA_SSP
> +       select EZX_PCAP
>
>  config MACH_EZX_A780
>        bool "Motorola EZX A780"
> Index: linux-2.6-arm/arch/arm/mach-pxa/ezx.c
> ===================================================================
> --- linux-2.6-arm.orig/arch/arm/mach-pxa/ezx.c
> +++ linux-2.6-arm/arch/arm/mach-pxa/ezx.c
> @@ -15,7 +15,9 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/delay.h>
> +#include <linux/gpio.h>
>  #include <linux/pwm_backlight.h>
> +#include <linux/mfd/ezx-pcap.h>
>
>  #include <asm/setup.h>
>  #include <asm/arch/pxafb.h>
> @@ -87,6 +89,51 @@
>        .lcd_conn       = LCD_COLOR_TFT_18BPP,
>  };
>
> +/* PCAP */
> +static int ezx_pcap_init(void)
> +{
> +       /* disable all voltage regulators */
> +       ezx_pcap_write(PCAP_REG_AUXVREG, 0);
> +
> +       /* set SW1 sleep to keep SW1 1.3v in sync mode */
> +       /*  SW1 active in sync mode */
> +       ezx_pcap_set_sw(SW1, SW_MODE, 0x1);
> +
> +       /*  set core voltage */
> +       ezx_pcap_set_sw(SW1, SW_VOLTAGE, SW_VOLTAGE_1250);

Btw, did you see the voltage regulator framework that is in linux-next?

> +
> +       /* redirect all interrupts to AP */
> +       if (!(machine_is_ezx_a780() || machine_is_ezx_e680()))
> +               ezx_pcap_write(PCAP_REG_INT_SEL, 0);
> +
> +       return 0;
> +}
> +
> +static struct pcap_platform_data ezx_pcap_platform_data = {
> +       .port   = 1,
> +       .cs     = 24,
> +       .clk    = 1,
> +       .init   = ezx_pcap_init,
> +};
> +
> +static struct resource ezx_pcap_resources[] = {
> +       [0] = {
> +               .start      = IRQ_GPIO1,
> +               .end        = IRQ_GPIO1,
> +               .flags      = IORESOURCE_IRQ,
> +       },
> +};
> +
> +struct platform_device ezx_pcap_device = {
> +       .name       = "ezx-pcap",
> +       .id     = -1,
> +       .num_resources  = ARRAY_SIZE(ezx_pcap_resources),
> +       .resource   = ezx_pcap_resources,
> +       .dev        = {
> +               .platform_data = &ezx_pcap_platform_data,
> +       },
> +};
> +
>  static struct platform_device *devices[] __initdata = {
>        &ezx_backlight_device,
>  };
> @@ -105,6 +152,11 @@
>        GPIO46_STUART_RXD,
>        GPIO47_STUART_TXD,
>
> +       /* PCAP SSP */
> +       GPIO29_SSP1_SCLK,
> +       GPIO25_SSP1_TXD,
> +       GPIO26_SSP1_RXD,
> +
>        /* For A780 support (connected with Neptune GSM chip) */
>        GPIO30_USB_P3_2,        /* ICL_TXENB */
>        GPIO31_USB_P3_6,        /* ICL_VPOUT */
> @@ -122,7 +174,7 @@
>                set_pxa_fb_info(&ezx_fb_info_1);
>        else
>                set_pxa_fb_info(&ezx_fb_info_2);
> -
> +       platform_device_register(&ezx_pcap_device);
>        platform_add_devices(devices, ARRAY_SIZE(devices));

You could put ezx_pcap_device into the beginning of devices[].

>  }
>
>
> --
>

regards
Philipp
