Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbXK1JLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbXK1JLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXK1JK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:10:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:46015 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbXK1JK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VgKkIVr/TXvZSU5ZuXBH2mc4brPydyUVko7l1nI2YzBPGJ3FvEon6mP5kIwVh8EZyp3MWWFrztAfh7MUIrrtZ+m+2IcZpEpmKkTXeP7RW7MDFtqnOdKeP2auM0HwaEdsDeFsuH0V1AKAkdXIv11vQoCXEpOZJ2uM22x16cfBN8I=
Message-ID: <f17812d70711280110k4f0e08a4lf4f7f6c9a4aa63a7@mail.gmail.com>
Date: Wed, 28 Nov 2007 17:10:55 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 2.6.24-rc3-mm] gpiolib grows a gpio_desc
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>, "Nicolas Pitre" <nico@cam.org>
In-Reply-To: <200711271915.26096.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200711261746.55235.david-b@pacbell.net>
	 <f17812d70711270258v1e2b47aam74da33687728a78@mail.gmail.com>
	 <200711271915.26096.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 28, 2007 11:15 AM, David Brownell <david-b@pacbell.net> wrote:
> Update gpiolib to use a table of per-GPIO "struct gpio_desc" instead of
> a table of "struct gpio_chip".
>
>  - Change "is_out" and "requested" from arrays in "struct gpio_chip" to
>    bit fields in "struct gpio_desc", eliminating ARCH_GPIOS_PER_CHIP.
>
>  - Stop overloading "requested" flag with "label" tracked for debugfs.
>
>  - Change gpiochip_is_requested() into a regular function, since it
>    now accesses data that's not exported from the gpiolib code.  Also
>    change its signature, for the same reason.
>
>  - Reduce default ARCH_NR_GPIOS to 256 to shrink gpio_desc table cost.
>    On 32-bit platforms without debugfs, that table size is 2KB.
>
> This makes it easier to work with chips with different numbers of GPIOs,
> and to avoid holes in GPIOs number sequences.  Those holes can cost a
> lot of unusable irq_desc space for GPIOs that act as IRQs.
>
> Based on a patch from Eric Miao.
>
> # NOT signed-off yet ... purely for comment.  It's been sanity tested.
> ---
> The question I'm most interested in is whether it's worth paying the
> extra data memory.  I'm currently leaning towards "yes", mostly since
> it'll let me be lazy about some development boards with four different
> kinds of GPIO controller, each with different numbers of GPIOs.
>
> Note that the ARM AT91 updates are against a patch which has been
> circulated for comment but not yet submitted.  The at32ap and mcp23s08
> parts are currently in the MM tree.  The PXA platform support didn't
> need changes; DaVinci won't either.  The OMAP support (not recently
> updated) will need slightly more updates than those shown here.
>
>  arch/arm/mach-at91/gpio.c            |    7 -
>  arch/avr32/mach-at32ap/pio.c         |    7 -
>  drivers/spi/mcp23s08.c               |    8 -
>  include/asm-avr32/arch-at32ap/gpio.h |    2
>  include/asm-generic/gpio.h           |   45 +-------
>  lib/gpiolib.c                        |  194 ++++++++++++++++++-----------------
>  6 files changed, 129 insertions(+), 134 deletions(-)
>
> --- at91.orig/arch/arm/mach-at91/gpio.c 2007-11-27 14:31:05.000000000 -0800
> +++ at91/arch/arm/mach-at91/gpio.c      2007-11-27 14:32:01.000000000 -0800
> @@ -484,7 +484,10 @@ at91_bank_show(struct seq_file *s, struc
>         mdsr = __raw_readl(pio + PIO_MDSR);
>
>         for (i = 0, mask = 1; i < chip->ngpio; i++, mask <<= 1) {
> -               if (!gpiochip_is_requested(chip, i)) {
> +               const char      *label;
> +
> +               label = gpiochip_is_requested(chip, i);
> +               if (!label) {
>                         /* peripheral-A or peripheral B?
>                          * else unused/unrequested GPIO; ignore.
>                          */
> @@ -501,7 +504,7 @@ at91_bank_show(struct seq_file *s, struc
>                  */
>                 seq_printf(s, " gpio-%-3d P%c%-2d (%-12s) %s %s %s",
>                         chip->base + i, 'A' + bank_num, i,
> -                       chip->requested[i],
> +                       label,
>                         (osr & mask) ? "out" : "in ",
>                         (mask & pdsr) ? "hi" : "lo",
>                         (mask & pusr) ? "  " : "up");
> --- at91.orig/arch/avr32/mach-at32ap/pio.c      2007-11-27 14:30:03.000000000 -0800
> +++ at91/arch/avr32/mach-at32ap/pio.c   2007-11-27 14:30:04.000000000 -0800
> @@ -315,12 +315,15 @@ static void pio_bank_show(struct seq_fil
>         bank = 'A' + pio->pdev->id;
>
>         for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
> -               if (!gpiochip_is_requested(chip, i))
> +               const char *label;
> +
> +               label = gpiochip_is_requested(chip, i);
> +               if (!label)
>                         continue;
>
>                 seq_printf(s, " gpio-%-3d P%c%-2d (%-12s) %s %s %s",
>                         chip->base + i, bank, i,
> -                       chip->requested[i],
> +                       label,
>                         (osr & mask) ? "out" : "in ",
>                         (mask & pdsr) ? "hi" : "lo",
>                         (mask & pusr) ? "  " : "up");
> --- at91.orig/drivers/spi/mcp23s08.c    2007-11-27 14:29:20.000000000 -0800
> +++ at91/drivers/spi/mcp23s08.c 2007-11-27 14:30:04.000000000 -0800
> @@ -184,12 +184,14 @@ static void mcp23s08_dbg_show(struct seq
>         }
>
>         for (t = 0, mask = 1; t < 8; t++, mask <<= 1) {
> -               if (!gpiochip_is_requested(chip, t))
> +               const char      *label;
> +
> +               label = gpiochip_is_requested(chip, t);
> +               if (!label)
>                         continue;
>
>                 seq_printf(s, " gpio-%-3d P%c.%d (%-12s) %s %s %s",
> -                       chip->base + t, bank, t,
> -                       chip->requested[t],
> +                       chip->base + t, bank, t, label,
>                         (mcp->cache[MCP_IODIR] & mask) ? "in " : "out",
>                         (mcp->cache[MCP_GPIO] & mask) ? "hi" : "lo",
>                         (mcp->cache[MCP_GPPU] & mask) ? "  " : "up");
> --- at91.orig/include/asm-avr32/arch-at32ap/gpio.h      2007-11-27 14:30:03.000000000 -0800
> +++ at91/include/asm-avr32/arch-at32ap/gpio.h   2007-11-27 14:30:04.000000000 -0800
> @@ -8,7 +8,7 @@
>  /* Some GPIO chips can manage IRQs; some can't.  The exact numbers can
>   * be changed if needed, but for the moment they're not configurable.
>   */
> -#define ARCH_NR_GPIOS  (NR_GPIO_IRQS + 2 * ARCH_GPIOS_PER_CHIP)
> +#define ARCH_NR_GPIOS  (NR_GPIO_IRQS + 2 * 32)
>
>
>  /* Arch-neutral GPIO API, supporting both "native" and external GPIOs. */
> --- at91.orig/include/asm-generic/gpio.h        2007-11-27 14:29:19.000000000 -0800
> +++ at91/include/asm-generic/gpio.h     2007-11-27 14:30:04.000000000 -0800
> @@ -4,21 +4,16 @@
>  #ifdef CONFIG_GPIO_LIB
>
>  /* Platforms may implement their GPIO interface with library code,
> - * at a small performance cost for non-inlined operations.
> + * at a small performance cost for non-inlined operations and some
> + * extra memory (for code and per-GPIO table entries).
>   *
>   * While the GPIO programming interface defines valid GPIO numbers
>   * to be in the range 0..MAX_INT, this library restricts them to the
> - * smaller range 0..ARCH_NR_GPIOS and allocates them in groups of
> - * ARCH_GPIOS_PER_CHIP (which will usually be the word size used for
> - * each bank of a SOC processor's integrated GPIO modules).
> + * smaller range 0..ARCH_NR_GPIOS.
>   */
>
>  #ifndef ARCH_NR_GPIOS
> -#define ARCH_NR_GPIOS          512
> -#endif
> -
> -#ifndef ARCH_GPIOS_PER_CHIP
> -#define ARCH_GPIOS_PER_CHIP    BITS_PER_LONG
> +#define ARCH_NR_GPIOS          256
>  #endif
>
>  struct seq_file;
> @@ -36,13 +31,10 @@ struct seq_file;
>   *     state (such as pullup/pulldown configuration).
>   * @base: identifies the first GPIO number handled by this chip; or, if
>   *     negative during registration, requests dynamic ID allocation.
> - * @ngpio: the number of GPIOs handled by this controller; the value must
> - *     be at most ARCH_GPIOS_PER_CHIP, so the last GPIO handled is
> - *     (base + ngpio - 1).
> + * @ngpio: the number of GPIOs handled by this controller; the last GPIO
> + *     handled is (base + ngpio - 1).
>   * @can_sleep: flag must be set iff get()/set() methods sleep, as they
>   *     must while accessing GPIO expander chips over I2C or SPI
> - * @is_out: bit array where bit N is true iff GPIO with offset N has been
> - *      called successfully to configure this as an output
>   *
>   * A gpio_chip can help platforms abstract various sources of GPIOs so
>   * they can all be accessed through a common programing interface.
> @@ -70,31 +62,10 @@ struct gpio_chip {
>         int                     base;
>         u16                     ngpio;
>         unsigned                can_sleep:1;
> -
> -       /* other fields are modified by the gpio library only */
> -       DECLARE_BITMAP(is_out, ARCH_GPIOS_PER_CHIP);
> -
> -#ifdef CONFIG_DEBUG_FS
> -       /* fat bits */
> -       const char              *requested[ARCH_GPIOS_PER_CHIP];
> -#else
> -       /* thin bits */
> -       DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);
> -#endif
>  };
>
> -/* returns true iff a given gpio signal has been requested;
> - * primarily for code dumping gpio_chip state.
> - */
> -static inline int
> -gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
> -{
> -#ifdef CONFIG_DEBUG_FS
> -       return chip->requested[offset] != NULL;
> -#else
> -       return test_bit(offset, chip->requested);
> -#endif
> -}
> +extern const char *gpiochip_is_requested(struct gpio_chip *chip,
> +                       unsigned offset);
>
>  /* add/remove chips */
>  extern int gpiochip_add(struct gpio_chip *chip);
> --- at91.orig/lib/gpiolib.c     2007-11-27 14:29:20.000000000 -0800
> +++ at91/lib/gpiolib.c  2007-11-27 14:30:04.000000000 -0800
> @@ -28,39 +28,41 @@
>  #define        extra_checks    0
>  #endif
>
> -/* gpio_lock protects the table of chips and gpio_chip->requested.
> +/* gpio_lock protects the gpio_desc[] table and desc->requested.
>   * While any GPIO is requested, its gpio_chip is not removable;
>   * each GPIO's "requested" flag serves as a lock and refcount.
>   */
>  static DEFINE_SPINLOCK(gpio_lock);
> -static struct gpio_chip *chips[DIV_ROUND_UP(ARCH_NR_GPIOS,
> -                                       ARCH_GPIOS_PER_CHIP)];
> +
> +struct gpio_desc {
> +       struct gpio_chip        *chip;
> +       unsigned                is_out:1;
> +       unsigned                requested:1;
> +#ifdef CONFIG_DEBUG_FS
> +       const char              *label;
> +#endif
> +};
> +static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
>
>
>  /* Warn when drivers omit gpio_request() calls -- legal but
>   * ill-advised when setting direction, and otherwise illegal.
>   */
> -static void gpio_ensure_requested(struct gpio_chip *chip, unsigned offset)
> +static void gpio_ensure_requested(struct gpio_desc *desc)
>  {
> -       int             requested;
> -
> +       if (!desc->requested) {
> +               desc->requested = 1;
> +               pr_warning("GPIO-%ld autorequested\n", gpio_desc - desc);

produces a warning here about %ld, and maybe you mean
desc - gpio_desc??

>  #ifdef CONFIG_DEBUG_FS
> -       requested = (int) chip->requested[offset];
> -       if (!requested)
> -               chip->requested[offset] = "[auto]";
> -#else
> -       requested = test_and_set_bit(offset, chip->requested);
> +               desc->label = "[auto]";
>  #endif
> -
> -       if (!requested)
> -               printk(KERN_DEBUG "GPIO-%d autorequested\n",
> -                               chip->base + offset);
> +       }
>  }
>
>  /* caller holds gpio_lock *OR* gpio is marked as requested */
>  static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
>  {
> -       return chips[gpio / ARCH_GPIOS_PER_CHIP];
> +       return gpio_desc[gpio].chip;
>  }
>
>  /**
> @@ -78,20 +80,26 @@ int gpiochip_add(struct gpio_chip *chip)
>         int             status = 0;
>         unsigned        id;
>
> -       if (chip->base < 0 || (chip->base % ARCH_GPIOS_PER_CHIP) != 0)
> -               return -EINVAL;
> -       if ((chip->base + chip->ngpio) >= ARCH_NR_GPIOS)
> -               return -EINVAL;
> -       if (chip->ngpio > ARCH_GPIOS_PER_CHIP)
> +       /* NOTE chip->base negative is reserved to mean a request for
> +        * dynamic allocation.  We probably won't ever use that ...
> +        */
> +
> +       if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS)
>                 return -EINVAL;
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       id = chip->base / ARCH_GPIOS_PER_CHIP;
> -       if (chips[id] == NULL)
> -               chips[id] = chip;
> -       else
> -               status = -EBUSY;
> +       /* make sure the GPIOs are not claimed by any gpio_chip */
> +       for (id = chip->base; id < chip->base + chip->ngpio; id++)
> +               if (gpio_desc[id].chip != NULL) {
> +                       status = -EBUSY;
> +                       break;
> +               }
> +
> +       if (status == 0) {
> +               for (id = chip->base; id < chip->base + chip->ngpio; id++)
> +                       gpio_desc[id].chip = chip;
> +       }
>
>         spin_unlock_irqrestore(&gpio_lock, flags);
>         return status;
> @@ -108,23 +116,19 @@ int gpiochip_remove(struct gpio_chip *ch
>  {
>         unsigned long   flags;
>         int             status = 0;
> -       int             offset;
> -       unsigned        id = chip->base / ARCH_GPIOS_PER_CHIP;
> +       unsigned        id;
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       for (offset = 0; offset < chip->ngpio; offset++) {
> -               if (gpiochip_is_requested(chip, offset)) {
> +       for (id = chip->base; id < chip->base + chip->ngpio; id++)
> +               if (gpio_desc[id].requested) {
>                         status = -EBUSY;
>                         break;
>                 }
> -       }
>
>         if (status == 0) {
> -               if (chips[id] == chip)
> -                       chips[id] = NULL;
> -               else
> -                       status = -EINVAL;
> +               for (id = chip->base; id < chip->base + chip->ngpio; id++)
> +                       gpio_desc[id].chip = NULL;
>         }
>
>         spin_unlock_irqrestore(&gpio_lock, flags);
> @@ -139,35 +143,28 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
>   */
>  int gpio_request(unsigned gpio, const char *label)
>  {
> -       struct gpio_chip        *chip;
> +       struct gpio_desc        *desc;
>         int                     status = -EINVAL;
>         unsigned long           flags;
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       chip = gpio_to_chip(gpio);
> -       if (!chip)
> -               goto done;
> -       gpio -= chip->base;
> -       if (gpio >= chip->ngpio)
> +       desc = &gpio_desc[gpio];
> +       if (desc->chip == NULL)
>                 goto done;
>
>         /* NOTE:  gpio_request() can be called in early boot,
>          * before IRQs are enabled.
>          */
>
> -       status = 0;
> +       if (!desc->requested) {
> +               desc->requested = 1;
>  #ifdef CONFIG_DEBUG_FS
> -       if (!label)
> -               label = "?";
> -       if (chip->requested[gpio])
> -               status = -EBUSY;
> -       else
> -               chip->requested[gpio] = label;
> -#else
> -       if (test_and_set_bit(gpio, chip->requested))
> -               status = -EBUSY;
> +               desc->label = (label == NULL) ? "?" : label;
>  #endif
> +               status = 0;
> +       } else
> +               status = -EBUSY;
>
>  done:
>         spin_unlock_irqrestore(&gpio_lock, flags);
> @@ -178,33 +175,51 @@ EXPORT_SYMBOL_GPL(gpio_request);
>  void gpio_free(unsigned gpio)
>  {
>         unsigned long           flags;
> -       struct gpio_chip        *chip;
> +       struct gpio_desc        *desc;
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       chip = gpio_to_chip(gpio);
> -       if (!chip)
> -               goto done;
> -       gpio -= chip->base;
> -       if (gpio >= chip->ngpio)
> -               goto done;
> -
> +       desc = &gpio_desc[gpio];
> +       if (desc->chip && desc->requested) {
> +               desc->requested = 0;
>  #ifdef CONFIG_DEBUG_FS
> -       if (chip->requested[gpio])
> -               chip->requested[gpio] = NULL;
> -       else
> -               chip = NULL;
> -#else
> -       if (!test_and_clear_bit(gpio, chip->requested))
> -               chip = NULL;
> +               desc->label = NULL;
>  #endif
> -       WARN_ON(extra_checks && chip == NULL);
> -done:
> +       } else
> +               WARN_ON(extra_checks);
> +
>         spin_unlock_irqrestore(&gpio_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(gpio_free);
>
>
> +/**
> + * gpiochip_is_requested - return string iff signal was requested
> + * @chip: controller managing the signal
> + * @offset: controller's identifer
> + *
> + * If debugfs support is enabled, the string returned is the label passed
> + * to gpio_request(); otherwise it is a meaningless constant.  When NULL
> + * is returned, the GPIO is not currently requested.
> + *
> + * This function is for use by GPIO controller drivers.  The label can
> + * help with diagnostics, and knowing that the signal is used as a GPIO
> + * can help ensure it's not accidentally given to another controller.
> + */
> +const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
> +{
> +       unsigned gpio = chip->base + offset;
> +
> +       if (gpio >= ARCH_NR_GPIOS || gpio_desc[gpio].chip != chip)
> +               return NULL;
> +#ifdef CONFIG_DEBUG_FS
> +       return gpio_desc[gpio].label;
> +#else
> +       return gpio_desc[gpio].requested ? "?" : NULL;
> +#endif
> +}
> +EXPORT_SYMBOL_GPL(gpiochip_is_requested);
> +
>
>  /* Drivers MUST make configuration calls before get/set calls
>   *
> @@ -218,17 +233,18 @@ int gpio_direction_input(unsigned gpio)
>  {
>         unsigned long           flags;
>         struct gpio_chip        *chip;
> +       struct gpio_desc        *desc = &gpio_desc[gpio];
>         int                     status = -EINVAL;
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       chip = gpio_to_chip(gpio);
> +       chip = desc->chip;
>         if (!chip || !chip->get || !chip->direction_input)
>                 goto fail;
>         gpio -= chip->base;
>         if (gpio >= chip->ngpio)
>                 goto fail;
> -       gpio_ensure_requested(chip, gpio);
> +       gpio_ensure_requested(desc);
>
>         /* now we know the gpio is valid and chip won't vanish */
>
> @@ -238,7 +254,7 @@ int gpio_direction_input(unsigned gpio)
>
>         status = chip->direction_input(chip, gpio);
>         if (status == 0)
> -               clear_bit(gpio, chip->is_out);
> +               desc->is_out = 0;
>         return status;
>  fail:
>         spin_unlock_irqrestore(&gpio_lock, flags);
> @@ -250,17 +266,18 @@ int gpio_direction_output(unsigned gpio,
>  {
>         unsigned long           flags;
>         struct gpio_chip        *chip;
> +       struct gpio_desc        *desc = &gpio_desc[gpio];
>         int                     status = -EINVAL;
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       chip = gpio_to_chip(gpio);
> +       chip = desc->chip;
>         if (!chip || !chip->set || !chip->direction_output)
>                 goto fail;
>         gpio -= chip->base;
>         if (gpio >= chip->ngpio)
>                 goto fail;
> -       gpio_ensure_requested(chip, gpio);
> +       gpio_ensure_requested(desc);
>
>         /* now we know the gpio is valid and chip won't vanish */
>
> @@ -270,7 +287,7 @@ int gpio_direction_output(unsigned gpio,
>
>         status = chip->direction_output(chip, gpio, value);
>         if (status == 0)
> -               set_bit(gpio, chip->is_out);
> +               desc->is_out = 1;
>         return status;
>  fail:
>         spin_unlock_irqrestore(&gpio_lock, flags);
> @@ -366,26 +383,23 @@ EXPORT_SYMBOL_GPL(gpio_set_value_canslee
>
>  static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  {
> -       unsigned        i;
> +       unsigned                i;
> +       unsigned                gpio = chip->base;
> +       struct gpio_desc        *gdesc = &gpio_desc[gpio];
>
> -       for (i = 0; i < chip->ngpio; i++) {
> -               unsigned        gpio;
> -               int             is_out;
>
> -               if (!chip->requested[i])
> +       for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
> +               if (!gdesc->requested)
>                         continue;
>
> -               gpio = chip->base + i;
> -               is_out = test_bit(i, chip->is_out);
> -
>                 seq_printf(s, " gpio-%-3d (%-12s) %s %s",
> -                       gpio, chip->requested[i],
> -                       is_out ? "out" : "in ",
> +                       gpio, gdesc->label,
> +                       gdesc->is_out ? "out" : "in ",
>                         chip->get
>                                 ? (chip->get(chip, i) ? "hi" : "lo")
>                                 : "?  ");
>
> -               if (!is_out) {
> +               if (!gdesc->is_out) {
>                         int             irq = gpio_to_irq(gpio);
>                         struct irq_desc *desc = irq_desc + irq;
>
> @@ -435,14 +449,16 @@ static void gpiolib_dbg_show(struct seq_
>
>  static int gpiolib_show(struct seq_file *s, void *unused)
>  {
> -       struct gpio_chip        *chip;
> -       unsigned                id;
> +       struct gpio_chip        *chip = NULL;
> +       unsigned                gpio;
>         int                     started = 0;
>
>         /* REVISIT this isn't locked against gpio_chip removal ... */
>
> -       for (id = 0; id < ARRAY_SIZE(chips); id++) {
> -               chip = chips[id];
> +       for (gpio = 0; gpio < ARCH_NR_GPIOS; gpio++) {
> +               if (chip == gpio_desc[gpio].chip)
> +                       continue;
> +               chip = gpio_desc[gpio].chip;
>                 if (!chip)
>                         continue;
>
>

Except for the above, I feel OK overall.

-- 
Cheers
- eric
