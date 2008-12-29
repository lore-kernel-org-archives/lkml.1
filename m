Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYL2Di0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYL2Di0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYL2DiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:38:12 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:60840 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYL2DiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QL92KOTO7O91lluKQTGoXO7R6RkcEixv6McX5riWgnB1zhBhEocU0GV0gsbDHh2rB5
         wAupgR4Ox8QGv6YsU9mDIJVhjiLgY4QXuUhHFbwEY1/yV79BgL3A+LGnz6NgbjmL7Ch0
         DY4R/Jl752mv+aSqlh7SVE85MN28chd8Pc9c0=
Message-ID: <f17812d70812281938h1b8ad9ecq49a460ac7786ae76@mail.gmail.com>
Date: Mon, 29 Dec 2008 11:38:07 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add batch set/get
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "David Brownell" <david-b@pacbell.net>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1230395048446-git-send-email-jayakumar.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230395048446-git-send-email-jayakumar.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 12:24 AM, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> Hi friends,
>
> This is v2 of my attempt to add batch support to gpiolib. Thanks to
> David Brownell, Eric Miao, Paulius Zaleckas, Geert, and Sam for prior
> feedback. I have tested set_batch using the am300 driver. get_batch
> is not tested.
>
> Please let me know your feedback.
>
> Thanks,
> jaya
>
> am300epd was doing 800*600*16*gpio_set_value for each framebuffer transfer
> (it uses 16-pins of gpio as its data bus). I found this caused a wee
> performance limitation. This patch adds an API for gpio_s/get_batch
> which allows drivers to s/get batches of gpio together in a single call.
> I have done a test implementation on gumstix (pxa255) with am300epd
> and it provides a nice improvement in performance.
>
> Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Eric Miao <eric.miao@marvell.com>
> Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Ben Gardner <bgardner@wabtec.com>
> CC: Greg KH <greg@kroah.com>
> Cc: linux-arm-kernel@lists.arm.linux.org.uk
> Cc: linux-fbdev-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-pxa/Kconfig             |    1 +
>  arch/arm/mach-pxa/am300epd.c          |    9 ++-
>  arch/arm/mach-pxa/gpio.c              |   72 +++++++++++++++++++
>  arch/arm/mach-pxa/include/mach/gpio.h |   47 +++++++++++++
>  drivers/gpio/Kconfig                  |    5 ++
>  drivers/gpio/gpiolib.c                |  122 +++++++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h            |   15 ++++-
>  7 files changed, 269 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
> index 768618b..a5a306e 100644
> --- a/arch/arm/mach-pxa/Kconfig
> +++ b/arch/arm/mach-pxa/Kconfig
> @@ -41,6 +41,7 @@ config GUMSTIX_AM200EPD
>        bool "Enable AM200EPD board support"
>
>  config GUMSTIX_AM300EPD
> +       select GPIOLIB_BATCH
>        bool "Enable AM300EPD board support"
>
>  endchoice
> diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
> index 4bd10a1..9594cf0 100644
> --- a/arch/arm/mach-pxa/am300epd.c
> +++ b/arch/arm/mach-pxa/am300epd.c
> @@ -190,9 +190,12 @@ static u16 am300_get_hdb(struct broadsheetfb_par *par)
>        u16 res = 0;
>        int i;
>
> +#ifdef CONFIG_GPIOLIB_BATCH
> +       res = gpio_get_batch(DB0_GPIO_PIN, 0xFFFF, 16);
> +#else
>        for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
>                res |= (gpio_get_value(DB0_GPIO_PIN + i)) ? (1 << i) : 0;
> -
> +#endif
>        return res;
>  }
>
> @@ -200,8 +203,12 @@ static void am300_set_hdb(struct broadsheetfb_par *par, u16 data)
>  {
>        int i;
>
> +#ifdef CONFIG_GPIOLIB_BATCH
> +       gpio_set_batch(DB0_GPIO_PIN, data, 0xFFFF, 16);
> +#else
>        for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
>                gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
> +#endif

Well, if AM300 selects GPIOLIB_BATCH, I don't think we need the
gpio_set_value() stuffs, and get rid of this #ifdef completely.

>  }
>
>
> diff --git a/arch/arm/mach-pxa/gpio.c b/arch/arm/mach-pxa/gpio.c
> index 5fec1e4..d85cf2e 100644
> --- a/arch/arm/mach-pxa/gpio.c
> +++ b/arch/arm/mach-pxa/gpio.c
> @@ -162,6 +162,76 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>                __raw_writel(mask, pxa->regbase + GPCR_OFFSET);
>  }
>
> +#ifdef CONFIG_GPIOLIB_BATCH
> +/*
> + * Set output GPIO level in batches
> + */
> +static void pxa_gpio_set_batch(struct gpio_chip *chip, unsigned offset,
> +                               u32 values, u32 bitmask)
> +{
> +       struct pxa_gpio_chip *pxa;
> +
> +       /* we're guaranteed by the caller that offset + bitmask remains
> +        * in this chip.
> +        */
> +       pxa = container_of(chip, struct pxa_gpio_chip, chip);
> +
> +       /* shift the bits into our register specific position */
> +       values <<= offset;
> +       bitmask <<= offset;
> +
> +       values &= bitmask;

or a single 'values = (values & bitmask) << offset' ?

> +       if (values)
> +               __raw_writel(values, pxa->regbase + GPSR_OFFSET);
> +
> +       values = ~values;
> +       values &= bitmask;

ditto

> +       if (values)
> +               __raw_writel(values, pxa->regbase + GPCR_OFFSET);
> +}
> +
> +/*
> + * Get output GPIO level in batches
> + */
> +static u32 pxa_gpio_get_batch(struct gpio_chip *chip, unsigned offset,
> +                               u32 bitmask)
> +{
> +       u32 values;
> +       struct pxa_gpio_chip *pxa;
> +
> +       /* we're guaranteed by the caller that offset + bitmask remains
> +        * in this chip.
> +        */
> +       pxa = container_of(chip, struct pxa_gpio_chip, chip);
> +
> +       values = __raw_readl(pxa->regbase + GPLR_OFFSET);
> +
> +       /* shift the result back into original position */
> +       values >>= offset;
> +       /* no need to shift bitmask since we've already shifted values */
> +       values &= bitmask;
> +
> +       return values;

or a single 'return (values >> offset) & bitmask;' should be enough.

> +}
> +#endif
> +
> +#ifdef CONFIG_GPIOLIB_BATCH
> +#define GPIO_CHIP(_n)                                                  \
> +       [_n] = {                                                        \
> +               .regbase = GPIO##_n##_BASE,                             \
> +               .chip = {                                               \
> +                       .label            = "gpio-" #_n,                \
> +                       .direction_input  = pxa_gpio_direction_input,   \
> +                       .direction_output = pxa_gpio_direction_output,  \
> +                       .get              = pxa_gpio_get,               \
> +                       .set              = pxa_gpio_set,               \
> +                       .base             = (_n) * 32,                  \
> +                       .ngpio            = 32,                         \
> +                       .set_batch        = pxa_gpio_set_batch,         \
> +                       .get_batch        = pxa_gpio_get_batch,         \

This is a bit ugly, define pxa_gpio_set_batch to NULL #ifndef GPIOLIB_BATCH
in the above code, and force .{set,get}_batch assignment anyway, this will
look a bit better, the same way as PM. However, this requires a modification
to gpio_chip to always allow these two pointers, which might be a concern.

> +               },                                                      \
> +       }
> +#else
>  #define GPIO_CHIP(_n)                                                  \
>        [_n] = {                                                        \
>                .regbase = GPIO##_n##_BASE,                             \
> @@ -175,6 +245,8 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>                        .ngpio            = 32,                         \
>                },                                                      \
>        }
> +#endif
> +
>
>  static struct pxa_gpio_chip pxa_gpio_chip[] = {
>        GPIO_CHIP(0),
> diff --git a/arch/arm/mach-pxa/include/mach/gpio.h b/arch/arm/mach-pxa/include/mach/gpio.h
> index 2c538d8..e66e752 100644
> --- a/arch/arm/mach-pxa/include/mach/gpio.h
> +++ b/arch/arm/mach-pxa/include/mach/gpio.h
> @@ -56,6 +56,53 @@ static inline void gpio_set_value(unsigned gpio, int value)
>        }
>  }
>
> +#ifdef CONFIG_GPIOLIB_BATCH
> +static inline void gpio_set_batch(unsigned gpio, u32 values, u32 bitmask,
> +                                       int bitwidth)
> +{
> +       if (__builtin_constant_p(gpio) &&
> +               (gpio + bitwidth < NR_BUILTIN_GPIO) &&
> +               ((gpio + bitwidth) <= roundup(gpio+1, 32))) {
> +               int shift;
> +
> +               shift = gpio % 32;
> +               values <<= shift;
> +               bitmask <<= shift;
> +
> +               values &= bitmask;
> +               if (values)
> +                       GPSR(gpio) = values;
> +
> +               values = ~values;
> +               values &= bitmask;
> +               if (values)
> +                       GPCR(gpio) = values;

I doubt the optimization of GPIO being a constant is essential for
batch operation ... anyway, this is plus.

> +       } else {
> +               __gpio_set_batch(gpio, values, bitmask, bitwidth);
> +       }
> +}
> +
> +static inline u32 gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth)
> +{
> +       if (__builtin_constant_p(gpio) &&
> +               (gpio + bitwidth < NR_BUILTIN_GPIO) &&
> +               ((gpio + bitwidth) <= roundup(gpio+1, 32))) {
> +               int shift;
> +               u32 values;
> +
> +               shift = gpio % 32;
> +
> +               values = GPLR(gpio);
> +               values >>= shift;
> +               values &= bitmask;
> +
> +               return values;
> +       } else {
> +               return __gpio_get_batch(gpio, bitmask, bitwidth);
> +       }
> +}
> +#endif
> +
>  #define gpio_cansleep __gpio_cansleep
>
>  #define gpio_to_irq(gpio)      IRQ_GPIO(gpio)
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 48f49d9..aeeb83c 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -37,6 +37,11 @@ menuconfig GPIOLIB
>
>  if GPIOLIB
>
> +config GPIOLIB_BATCH
> +       bool "Batch GPIO support"
> +       help
> +         Say Y here to add the capability to batch set/get GPIOs.
> +
>  config DEBUG_GPIO
>        bool "Debug GPIO calls"
>        depends on DEBUG_KERNEL
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 82020ab..7b36573 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1056,6 +1056,128 @@ void __gpio_set_value(unsigned gpio, int value)
>  }
>  EXPORT_SYMBOL_GPL(__gpio_set_value);
>
> +#ifdef CONFIG_GPIOLIB_BATCH
> +/**
> + * __gpio_set_batch() - assign a batch of gpio pins together
> + * @gpio: starting gpio pin
> + * @values: values to assign, sequential and including masked bits
> + * @bitmask: bitmask to be applied to values
> + * @bitwidth: width inclusive of masked-off bits
> + * Context: any
> + *
> + * This is used directly or indirectly to implement gpio_set_value().
> + * It invokes the associated gpio_chip.set_batch() method. If that
> + * method does not exist for any segment that is involved, then it drops
> + * back down to standard gpio_chip.set()
> + */
> +void __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth)
> +{
> +       struct gpio_chip *chip;
> +       int i = 0;
> +       int value, width, remwidth;
> +       u32 mask;
> +
> +       do {
> +               chip = gpio_to_chip(gpio + i);
> +               WARN_ON(extra_checks && chip->can_sleep);
> +
> +               if (!chip->set_batch) {
> +                       while (((gpio + i) < (chip->base + chip->ngpio))
> +                               && bitwidth) {
> +                               mask = 1 << i;
> +                               value = values & mask;
> +                               if (bitmask & mask)
> +                                       chip->set(chip, gpio + i - chip->base,
> +                                                       value);
> +                               i++;
> +                               bitwidth--;

I recommend this being put into something like 'default_gpio_set_batch', and
assign this to 'chip->set_batch' when the gpio chip is being registered and
found 'chip->set_batch == NULL', so to keep this block consistent.

Same comment to the 'get_batch' implementation below.

> +                       }
> +               } else {
> +                       value = values >> i; /* shift off the used data bits */
> +                       remwidth = ((chip->base + (int) chip->ngpio) -
> +                                       ((int) gpio + i));
> +                       width = min(bitwidth, remwidth);
> +
> +                       /* shift off the used mask bits */
> +                       mask = bitmask >> i;
> +                       /* now adjust mask by width of set */
> +                       mask &= ((1 << width) - 1);
> +
> +                       chip->set_batch(chip, gpio + i - chip->base, value,
> +                                               mask);
> +                       i += width;
> +                       bitwidth -= width;
> +               }
> +       } while (bitwidth);
> +}
> +EXPORT_SYMBOL_GPL(__gpio_set_batch);
> +
> +/**
> + * __gpio_get_batch() - get a batch of gpio pins together
> + * @gpio: starting gpio pin
> + * @bitmask: bitmask to be applied to values
> + * @bitwidth: width inclusive of masked-off bits
> + * Context: any
> + *
> + * This is used directly or indirectly to implement gpio_get_value().
> + * It invokes the associated gpio_chip.get_batch() method and returns
> + * zero if no such method is provided.
> + */
> +u32 __gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth)
> +{
> +       struct gpio_chip *chip;
> +       int i = 0;
> +       int width, remwidth;
> +       u32 mask;
> +       u32 values = 0;
> +       u32 value;
> +
> +       do {
> +               chip = gpio_to_chip(gpio + i);
> +               WARN_ON(extra_checks && chip->can_sleep);
> +
> +               /*
> +                * check if we have batch capability on this chip.
> +                * if not, then we use the single bit gets
> +                * any masked or inaccessible bits are already 0
> +                */
> +               if (!chip->get_batch) {
> +                       while (((gpio + i) < (chip->base + chip->ngpio))
> +                               && bitwidth) {
> +                               mask = 1 << i;
> +                               /* skip if no get or masked out */
> +                               if (chip->get && (bitmask & mask)) {
> +                                       if (chip->get(chip,
> +                                               gpio + i - chip->base))
> +                                               values |= mask;
> +                               }
> +                               i++;
> +                               bitwidth--;
> +                       }
> +               } else {
> +                       remwidth = ((chip->base + (int) chip->ngpio) -
> +                                       ((int) gpio + i));
> +                       width = min(bitwidth, remwidth);
> +
> +                       /* shift off the used mask bits */
> +                       mask = bitmask >> i;
> +                       /* now adjust mask by width of get */
> +                       mask &= ((1 << width) - 1);
> +
> +                       value = chip->get_batch(chip, gpio + i - chip->base,
> +                                                       mask);
> +                       /* shift result back into caller position */
> +                       values |= value << i;
> +                       i += width;
> +                       bitwidth -= width;
> +               }
> +       } while (bitwidth);
> +
> +       return values;
> +}
> +EXPORT_SYMBOL_GPL(__gpio_get_batch);
> +#endif
> +
>  /**
>  * __gpio_cansleep() - report whether gpio value access will sleep
>  * @gpio: gpio in question
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 81797ec..fa716a7 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -44,6 +44,8 @@ struct module;
>  *     returns either the value actually sensed, or zero
>  * @direction_output: configures signal "offset" as output, or returns error
>  * @set: assigns output value for signal "offset"
> + * @set_batch: batch assigns output values for consecutive signals starting at
> + *     "offset" with mask in "bitmask" all within this gpio_chip
>  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
>  *     implementation may not sleep
>  * @dbg_show: optional routine to show contents in debugfs; default code
> @@ -84,7 +86,13 @@ struct gpio_chip {
>                                                unsigned offset, int value);
>        void                    (*set)(struct gpio_chip *chip,
>                                                unsigned offset, int value);
> -
> +#ifdef CONFIG_GPIOLIB_BATCH
> +       void                    (*set_batch)(struct gpio_chip *chip,
> +                                               unsigned offset, u32 values,
> +                                               u32 bitmask);
> +       u32                     (*get_batch)(struct gpio_chip *chip,
> +                                               unsigned offset, u32 bitmask);
> +#endif
>        int                     (*to_irq)(struct gpio_chip *chip,
>                                                unsigned offset);
>
> @@ -124,6 +132,11 @@ extern void gpio_set_value_cansleep(unsigned gpio, int value);
>  */
>  extern int __gpio_get_value(unsigned gpio);
>  extern void __gpio_set_value(unsigned gpio, int value);
> +#ifdef CONFIG_GPIOLIB_BATCH
> +extern void __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask,
> +                               int bitwidth);
> +extern u32 __gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth);
> +#endif
>
>  extern int __gpio_cansleep(unsigned gpio);
>
> --
> 1.5.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
