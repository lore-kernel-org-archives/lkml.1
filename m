Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYFUOnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYFUOnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYFUOnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:43:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:14805 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYFUOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Od2Py25m6UGsbO9LBVZdGilD8WNAT1xBB9rCzU5+zc5J/snTx1QUwGVL4PeUA9ZePd
         k9IWUtpN8aa7f3xJypt+8bUWugfw85DMlSM3CZ8D0n6RUJoOHmB1rhd8hyaKfMWll9N0
         xONDldo4t1s84fmB8c4iCeoyD4MtsMTkHdOIU=
Message-ID: <74d0deb30806210743x44f9d68elf2a394902c3fb8ce@mail.gmail.com>
Date: Sat, 21 Jun 2008 16:43:08 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Samuel Ortiz" <sameo@openedhand.com>
Subject: Re: [PATCH -mm 3/5] asic3: New gpio configuration code
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080511174444.455389162@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080511173653.869192035@sortiz.org>
	 <20080511174444.455389162@sortiz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 7:36 PM, Samuel Ortiz <sameo@openedhand.com> wrote:
> The ASIC3 GPIO configuration code is a bit obscure and hardly readable.
> This patch changes it so that it is now more readable and understandable,
> by being more explicit.
>
> Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
> ---
>  drivers/mfd/asic3.c       |   99 +++++++++++++++++++---------------------------
>  include/linux/mfd/asic3.h |   34 +++++++++++----
>  2 files changed, 67 insertions(+), 66 deletions(-)
>
> Index: linux-2.6-htc-asic3/drivers/mfd/asic3.c
> ===================================================================
> --- linux-2.6-htc-asic3.orig/drivers/mfd/asic3.c        2008-05-11 17:47:15.000000000 +0200
> +++ linux-2.6-htc-asic3/drivers/mfd/asic3.c     2008-05-11 18:20:35.000000000 +0200
> @@ -465,69 +465,54 @@ static void asic3_gpio_set(struct gpio_c
>        return;
>  }
>
> -static inline u32 asic3_get_gpio(struct asic3 *asic, unsigned int base,
> -                                unsigned int function)
> +static int asic3_gpio_probe(struct platform_device *pdev,
> +                           u16 *gpio_config, int num)
>  {
> -       return asic3_read_register(asic, base + function);
> -}
> -
> -static void asic3_set_gpio(struct asic3 *asic, unsigned int base,
> -                          unsigned int function, u32 bits, u32 val)
> -{
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&asic->lock, flags);
> -       val |= (asic3_read_register(asic, base + function) & ~bits);
> -
> -       asic3_write_register(asic, base + function, val);
> -       spin_unlock_irqrestore(&asic->lock, flags);
> -}
> -
> -#define asic3_set_gpio_a(asic, fn, bits, val) \
> -       asic3_set_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##fn, bits, val)
> -#define asic3_set_gpio_b(asic, fn, bits, val) \
> -       asic3_set_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##fn, bits, val)
> -#define asic3_set_gpio_c(asic, fn, bits, val) \
> -       asic3_set_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##fn, bits, val)
> -#define asic3_set_gpio_d(asic, fn, bits, val) \
> -       asic3_set_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##fn, bits, val)
> -
> -#define asic3_set_gpio_banks(asic, fn, bits, pdata, field)               \
> -       do {                                                              \
> -            asic3_set_gpio_a((asic), fn, (bits), (pdata)->gpio_a.field); \
> -            asic3_set_gpio_b((asic), fn, (bits), (pdata)->gpio_b.field); \
> -            asic3_set_gpio_c((asic), fn, (bits), (pdata)->gpio_c.field); \
> -            asic3_set_gpio_d((asic), fn, (bits), (pdata)->gpio_d.field); \
> -       } while (0)
> -
> -
> -static int asic3_gpio_probe(struct platform_device *pdev)
> -{
> -       struct asic3_platform_data *pdata = pdev->dev.platform_data;
>        struct asic3 *asic = platform_get_drvdata(pdev);
> +       u16 alt_reg[ASIC3_NUM_GPIO_BANKS];
> +       u16 out_reg[ASIC3_NUM_GPIO_BANKS];
> +       u16 dir_reg[ASIC3_NUM_GPIO_BANKS];
> +       int i;
> +
> +       memset(alt_reg, 0, ASIC3_NUM_GPIO_BANKS);
> +       memset(out_reg, 0, ASIC3_NUM_GPIO_BANKS);
> +       memset(dir_reg, 0, ASIC3_NUM_GPIO_BANKS);

Those should be
       memset(alt_reg, 0, ASIC3_NUM_GPIO_BANKS*sizeof(u16));
       memset(out_reg, 0, ASIC3_NUM_GPIO_BANKS*sizeof(u16));
       memset(dir_reg, 0, ASIC3_NUM_GPIO_BANKS*sizeof(u16));

With that change,
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>

This is the configuration I'm using for hx4700 currently:

u16 asic3_gpio_config[] = {
	/* ASIC3 GPIO banks A and B along with some of C and D
	   implement the buffering for the CF slot. */
	ASIC3_CONFIG_GPIO(0, 1, 1, 0),
	ASIC3_CONFIG_GPIO(1, 1, 1, 0),
	ASIC3_CONFIG_GPIO(2, 1, 1, 0),
	ASIC3_CONFIG_GPIO(3, 1, 1, 0),
	ASIC3_CONFIG_GPIO(4, 1, 1, 0),
	ASIC3_CONFIG_GPIO(5, 1, 1, 0),
	ASIC3_CONFIG_GPIO(6, 1, 1, 0),
	ASIC3_CONFIG_GPIO(7, 1, 1, 0),
	ASIC3_CONFIG_GPIO(8, 1, 1, 0),
	ASIC3_CONFIG_GPIO(9, 1, 1, 0),
	ASIC3_CONFIG_GPIO(10, 1, 1, 0),
	ASIC3_CONFIG_GPIO(11, 1, 1, 0),
	ASIC3_CONFIG_GPIO(12, 1, 1, 0),
	ASIC3_CONFIG_GPIO(13, 1, 1, 0),
	ASIC3_CONFIG_GPIO(14, 1, 1, 0),
	ASIC3_CONFIG_GPIO(15, 1, 1, 0),

	ASIC3_CONFIG_GPIO(16, 1, 1, 0),
	ASIC3_CONFIG_GPIO(17, 1, 1, 0),
	ASIC3_CONFIG_GPIO(18, 1, 1, 0),
	ASIC3_CONFIG_GPIO(19, 1, 1, 0),
	ASIC3_CONFIG_GPIO(20, 1, 1, 0),
	ASIC3_CONFIG_GPIO(21, 1, 1, 0),
	ASIC3_CONFIG_GPIO(22, 1, 1, 0),
	ASIC3_CONFIG_GPIO(23, 1, 1, 0),
	ASIC3_CONFIG_GPIO(24, 1, 1, 0),
	ASIC3_CONFIG_GPIO(25, 1, 1, 0),
	ASIC3_CONFIG_GPIO(26, 1, 1, 0),
	ASIC3_CONFIG_GPIO(27, 1, 1, 0),
	ASIC3_CONFIG_GPIO(28, 1, 1, 0),
	ASIC3_CONFIG_GPIO(29, 1, 1, 0),
	ASIC3_CONFIG_GPIO(30, 1, 1, 0),
	ASIC3_CONFIG_GPIO(31, 1, 1, 0),

	/* GPIOC - CF, LEDs, SD */
	ASIC3_CONFIG_GPIO(32,1,1,0),	/* GPIOC_LED_RED */
	ASIC3_CONFIG_GPIO(33,1,1,0),	/* GPIOC_LED_GREEN */
	ASIC3_CONFIG_GPIO(34,1,1,0),	/* GPIOC_LED_BLUE */
	ASIC3_CONFIG_GPIO(35,0,0,0),	/* GPIOC_nSD_CS */
	ASIC3_CONFIG_GPIO(36,1,0,0),	/* GPIOC_CF_nCD */
	ASIC3_CONFIG_GPIO(37,1,1,0),	/* GPIOC_nCIOW */
	ASIC3_CONFIG_GPIO(38,1,1,0),	/* GPIOC_nCIOR */
	ASIC3_CONFIG_GPIO(39,1,0,0),	/* GPIOC_nPCE1 */
	ASIC3_CONFIG_GPIO(40,1,0,0),	/* GPIOC_nPCE2 */
	ASIC3_CONFIG_GPIO(41,1,0,0),	/* GPIOC_nPOE */
	ASIC3_CONFIG_GPIO(42,1,0,0),	/* GPIOC_CF_nPWE */
	ASIC3_CONFIG_GPIO(43,1,0,0),	/* GPIOC_PSKTSEL */
	ASIC3_CONFIG_GPIO(44,1,0,0),	/* GPIOC_nPREG */
	ASIC3_CONFIG_GPIO(45,1,1,0),	/* GPIOC_nPWAIT */
	ASIC3_CONFIG_GPIO(46,1,1,0),	/* GPIOC_nPIOS16 */
	ASIC3_CONFIG_GPIO(47,1,0,0),	/* GPIOC_nPIOR */

	/* GPIOD: all inputs */
	ASIC3_CONFIG_GPIO_DEFAULT(48,0,0),	/* GPIOD_CPU_SS_INT */
	ASIC3_CONFIG_GPIO_DEFAULT(49,0,0),	/* GPIOD_nKEY_AP2 */
	ASIC3_CONFIG_GPIO_DEFAULT(50,0,0),	/* GPIOD_BLUETOOTH_WAKEUP */
	ASIC3_CONFIG_GPIO_DEFAULT(51,0,0),	/* GPIOD_nKEY_AP4 */
	ASIC3_CONFIG_GPIO_DEFAULT(52,0,0),	/* GPIOD_CF_nCD */
	ASIC3_CONFIG_GPIO_DEFAULT(53,0,0),	/* GPIOD_nPIO */
	ASIC3_CONFIG_GPIO_DEFAULT(54,0,0),	/* GPIOD_nKEY_RECORD */
	ASIC3_CONFIG_GPIO_DEFAULT(55,0,0),	/* GPIOD_nSDIO_DETECT */
	ASIC3_CONFIG_GPIO_DEFAULT(56,0,0),	/* GPIOD_COM_DCD */
	ASIC3_CONFIG_GPIO_DEFAULT(57,0,0),	/* GPIOD_nAC_IN */
	ASIC3_CONFIG_GPIO_DEFAULT(58,0,0),	/* GPIOD_nSDIO_IRQ */
	ASIC3_CONFIG_GPIO(59,1,0,0),		/* GPIOD_nCIOIS16 */
	ASIC3_CONFIG_GPIO(60,1,0,0),		/* GPIOD_nCWAIT */
	ASIC3_CONFIG_GPIO_DEFAULT(61,0,0),	/* GPIOD_CF_RNB */
	ASIC3_CONFIG_GPIO_DEFAULT(62,0,0),	/* GPIOD_nUSBC_DETECT */
	ASIC3_CONFIG_GPIO(63,1,0,0),		/* GPIOD_ASIC3_nPIOW */
};

Do you think it would make sense to include constants for the
alternate functions like
#define ASIC3_GPIO32_LED0 ASIC3_CONFIG_GPIO(32,1,1,0)
#define ASIC3_GPIO43_PSKTSEL ASIC3_CONFIG_GPIO(43,1,0,0)
etc. in asic3.h?

How does the array look like that you use for Universal?

> +       /* Enable all GPIOs */
>        asic3_write_register(asic, ASIC3_GPIO_OFFSET(A, Mask), 0xffff);
>        asic3_write_register(asic, ASIC3_GPIO_OFFSET(B, Mask), 0xffff);
>        asic3_write_register(asic, ASIC3_GPIO_OFFSET(C, Mask), 0xffff);
>        asic3_write_register(asic, ASIC3_GPIO_OFFSET(D, Mask), 0xffff);
>
> -       asic3_set_gpio_a(asic, SleepMask, 0xffff, 0xffff);
> -       asic3_set_gpio_b(asic, SleepMask, 0xffff, 0xffff);
> -       asic3_set_gpio_c(asic, SleepMask, 0xffff, 0xffff);
> -       asic3_set_gpio_d(asic, SleepMask, 0xffff, 0xffff);
> -
> -       if (pdata) {
> -               asic3_set_gpio_banks(asic, Out, 0xffff, pdata, init);
> -               asic3_set_gpio_banks(asic, Direction, 0xffff, pdata, dir);
> -               asic3_set_gpio_banks(asic, SleepMask, 0xffff, pdata,
> -                                    sleep_mask);
> -               asic3_set_gpio_banks(asic, SleepOut, 0xffff, pdata, sleep_out);
> -               asic3_set_gpio_banks(asic, BattFaultOut, 0xffff, pdata,
> -                                    batt_fault_out);
> -               asic3_set_gpio_banks(asic, SleepConf, 0xffff, pdata,
> -                                    sleep_conf);
> -               asic3_set_gpio_banks(asic, AltFunction, 0xffff, pdata,
> -                                    alt_function);
> +       for (i = 0; i < num; i++) {
> +               u8 alt, pin, dir, init, bank_num, bit_num;
> +               u16 config = gpio_config[i];
> +
> +               pin = ASIC3_CONFIG_GPIO_PIN(config);
> +               alt = ASIC3_CONFIG_GPIO_ALT(config);
> +               dir = ASIC3_CONFIG_GPIO_DIR(config);
> +               init = ASIC3_CONFIG_GPIO_INIT(config);
> +
> +               bank_num = ASIC3_GPIO_TO_BANK(pin);
> +               bit_num = ASIC3_GPIO_TO_BIT(pin);
> +
> +               alt_reg[bank_num] |= (alt << bit_num);
> +               out_reg[bank_num] |= (init << bit_num);
> +               dir_reg[bank_num] |= (dir << bit_num);
> +       }
> +
> +       for (i = 0; i < ASIC3_NUM_GPIO_BANKS; i++) {
> +               asic3_write_register(asic,
> +                                    ASIC3_BANK_TO_BASE(i) +
> +                                    ASIC3_GPIO_Direction,
> +                                    dir_reg[i]);
> +               asic3_write_register(asic,
> +                                    ASIC3_BANK_TO_BASE(i) + ASIC3_GPIO_Out,
> +                                    out_reg[i]);
> +               asic3_write_register(asic,
> +                                    ASIC3_BANK_TO_BASE(i) +
> +                                    ASIC3_GPIO_AltFunction,
> +                                    alt_reg[i]);
>        }
>
>        return gpiochip_add(&asic->gpio);
> @@ -598,7 +583,9 @@ static int asic3_probe(struct platform_d
>        asic->gpio.direction_input = asic3_gpio_direction_input;
>        asic->gpio.direction_output = asic3_gpio_direction_output;
>
> -       ret = asic3_gpio_probe(pdev);
> +       ret = asic3_gpio_probe(pdev,
> +                              pdata->gpio_config,
> +                              pdata->gpio_config_num);
>        if (ret < 0) {
>                printk(KERN_ERR "GPIO probe failed\n");
>                goto out_irq;
> Index: linux-2.6-htc-asic3/include/linux/mfd/asic3.h
> ===================================================================
> --- linux-2.6-htc-asic3.orig/include/linux/mfd/asic3.h  2008-05-11 17:47:15.000000000 +0200
> +++ linux-2.6-htc-asic3/include/linux/mfd/asic3.h       2008-05-11 18:12:07.000000000 +0200
> @@ -8,7 +8,7 @@
>  * published by the Free Software Foundation.
>  *
>  * Copyright 2001 Compaq Computer Corporation.
> - * Copyright 2007 OpendHand.
> + * Copyright 2007-2008 OpenedHand Ltd.
>  */
>
>  #ifndef __ASIC3_H__
> @@ -17,15 +17,8 @@
>  #include <linux/types.h>
>
>  struct asic3_platform_data {
> -       struct {
> -               u32 dir;
> -               u32 init;
> -               u32 sleep_mask;
> -               u32 sleep_out;
> -               u32 batt_fault_out;
> -               u32 sleep_conf;
> -               u32 alt_function;
> -       } gpio_a, gpio_b, gpio_c, gpio_d;
> +       u16 *gpio_config;
> +       unsigned int gpio_config_num;
>
>        unsigned int bus_shift;
>
> @@ -86,6 +79,27 @@ struct asic3_platform_data {
>                                          */
>  #define ASIC3_GPIO_Status        0x30    /* R   Pin status */
>
> +/*
> + * ASIC3 GPIO config
> + *
> + * Bits 0..6   gpio number
> + * Bits 7..13  Alternate function
> + * Bit  14     Direction
> + * Bit  15     Initial value
> + *
> + */
> +#define ASIC3_CONFIG_GPIO_PIN(config) ((config) & 0x7f)
> +#define ASIC3_CONFIG_GPIO_ALT(config)  (((config) & (0x7f << 7)) >> 7)
> +#define ASIC3_CONFIG_GPIO_DIR(config)  ((config & (1 << 14)) >> 14)
> +#define ASIC3_CONFIG_GPIO_INIT(config) ((config & (1 << 15)) >> 15)
> +#define ASIC3_CONFIG_GPIO(gpio, alt, dir, init) (((gpio) & 0x7f) \
> +       | (((alt) & 0x7f) << 7) | (((dir) & 0x1) << 14) \
> +       | (((init) & 0x1) << 15))
> +#define ASIC3_CONFIG_GPIO_DEFAULT(gpio, dir, init) \
> +       ASIC3_CONFIG_GPIO((gpio), 0, (dir), (init))
> +#define ASIC3_CONFIG_GPIO_DEFAULT_OUT(gpio, init) \
> +       ASIC3_CONFIG_GPIO((gpio), 0, 1, (init))
> +
>  #define ASIC3_SPI_Base               0x0400
>  #define ASIC3_SPI_Control               0x0000
>  #define ASIC3_SPI_TxData                0x0004
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

regards
Philipp
