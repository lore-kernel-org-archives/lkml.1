Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZLHVhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZLHVhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZLHVhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:37:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46876 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbZLHVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:37:32 -0500
Date: Tue, 8 Dec 2009 22:37:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091208213727.GA4164@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <4B1EB57D.6070408@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1EB57D.6070408@bluewatersys.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +#undef MODULE_PARAM_PREFIX
> > +#define MODULE_PARAM_PREFIX "board_dream."
> 
> This looks a bit dodgy. Is this
> (http://lkml.indiana.edu/hypermail/linux/kernel/0903.0/02768.html) the
> preferred way?

I don't think that would help that much here....

> > +static void update_pwrsink(unsigned gpio, unsigned on)
> > +{
> > +	switch(gpio) {
> > +	case DREAM_GPIO_UI_LED_EN:
> > +		break;
> > +	case DREAM_GPIO_QTKEY_LED_EN:
> > +		break;
> > +	}
> > +}
> 
> What is this function for?

Power accounting... should be removed. Fixed.

> > +static void dream_gpio_irq_ack(unsigned int irq)
> > +{
> > +	int bank = DREAM_INT_TO_BANK(irq);
> > +	uint8_t mask = DREAM_INT_TO_MASK(irq);
> > +	int reg = DREAM_BANK_TO_STAT_REG(bank);
> > +	/*printk(KERN_INFO "dream_gpio_irq_ack irq %d\n", irq);*/
> 
> pr_debug, or just remove it?

Remove.

> > +	desc->chip->ack(irq);
> > +}
> 
> Some blank lines here and there would make this more readable. All your
> code is wedged together :-).

Well, added some blank lines; not sure it is improvement.

> > +#define DREAM_INT_TO_BANK(n) ((n - DREAM_INT_START) / DREAM_INT_BANK0_COUNT)
> > +#define DREAM_INT_TO_MASK(n) (1U << ((n - DREAM_INT_START) & 7))
> > +#define DREAM_BANK_TO_MASK_REG(bank) \
> > +	(bank ? DREAM_GPIO_INT_MASK1_REG : DREAM_GPIO_INT_MASK0_REG)
> > +#define DREAM_BANK_TO_STAT_REG(bank) \
> > +	(bank ? DREAM_GPIO_INT_STAT1_REG : DREAM_GPIO_INT_STAT0_REG)
> 
> Are these needed outside of the gpiolib code? If not, they should be
> moved there. I also think they should have lower case names since they
> act like a function, and make the code where they are used nicer to
> read.

I guess these logically belong here.

No, macros are macros, that means upcase.

> > +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> > +	if (err)
> > +		kfree(new_gpio_chip->state);
> > +	return err;
> > +}
> 
> Thats big, hard to read, has about 3 blank lines total and no comments.

I tried to improve it, but it needs more. Here are my cleanups.
									Pavel

diff --git a/arch/arm/mach-msm/board-dream-gpio.c b/arch/arm/mach-msm/board-dream-gpio.c
index 1b23a84..7796254 100644
--- a/arch/arm/mach-msm/board-dream-gpio.c
+++ b/arch/arm/mach-msm/board-dream-gpio.c
@@ -18,7 +18,7 @@
 #include <linux/irq.h>
 #include <linux/pm.h>
 #include <linux/sysdev.h>
-#include <linux/io.h> 
+#include <linux/io.h>
 
 #include <asm/gpio.h>
 #include <asm/mach-types.h>
@@ -35,21 +35,21 @@ module_param_named(usb_h2w_sw, cpld_usb_h2w_sw, uint, 0);
 static uint8_t dream_cpld_shadow[4] = {
 #if defined(CONFIG_MSM_DEBUG_UART1)
 	/* H2W pins <-> UART1 */
-        [0] = 0x40, // for serial debug, low current
+	[0] = 0x40, /* for serial debug, low current */
 #else
 	/* H2W pins <-> UART3, Bluetooth <-> UART1 */
-        [0] = 0x80, // for serial debug, low current
+	[0] = 0x80, /* for serial debug, low current */
 #endif
-        [1] = 0x04, // I2C_PULL
-        [3] = 0x04, // mmdi 32k en
+	[1] = 0x04, /* I2C_PULL */
+	[3] = 0x04, /* mmdi 32k en */
 };
 static uint8_t dream_int_mask[2] = {
-        [0] = 0xff, /* mask all interrupts */
-        [1] = 0xff,
+	[0] = 0xff, /* mask all interrupts */
+	[1] = 0xff,
 };
 static uint8_t dream_sleep_int_mask[] = {
-        [0] = 0xff,
-        [1] = 0xff,
+	[0] = 0xff,
+	[1] = 0xff,
 };
 static int dream_suspended;
 
@@ -60,26 +60,16 @@ static int dream_gpio_read(struct gpio_chip *chip, unsigned n)
 	if (n >= DREAM_GPIO_VIRTUAL_BASE)
 		n += DREAM_GPIO_VIRTUAL_TO_REAL_OFFSET;
 	b = 1U << (n & 7);
-	reg = (n & 0x78) >> 2; // assumes base is 128
+	reg = (n & 0x78) >> 2; /* assumes base is 128 */
 	return !!(readb(DREAM_CPLD_BASE + reg) & b);
 }
 
-static void update_pwrsink(unsigned gpio, unsigned on)
-{
-	switch(gpio) {
-	case DREAM_GPIO_UI_LED_EN:
-		break;
-	case DREAM_GPIO_QTKEY_LED_EN:
-		break;
-	}
-}
-
 static uint8_t dream_gpio_write_shadow(unsigned n, unsigned on)
 {
 	uint8_t b = 1U << (n & 7);
-	int reg = (n & 0x78) >> 2; // assumes base is 128
+	int reg = (n & 0x78) >> 2; /* assumes base is 128 */
 
-	if(on)
+	if (on)
 		return dream_cpld_shadow[reg >> 1] |= b;
 	else
 		return dream_cpld_shadow[reg >> 1] &= ~b;
@@ -87,7 +77,7 @@ static uint8_t dream_gpio_write_shadow(unsigned n, unsigned on)
 
 static int dream_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on)
 {
-	int reg = (n & 0x78) >> 2; // assumes base is 128
+	int reg = (n & 0x78) >> 2; /* assumes base is 128 */
 	unsigned long flags;
 	uint8_t reg_val;
 
@@ -97,7 +87,6 @@ static int dream_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on)
 	}
 
 	local_irq_save(flags);
-	update_pwrsink(n, on);
 	reg_val = dream_gpio_write_shadow(n, on);
 	writeb(reg_val, DREAM_CPLD_BASE + reg);
 	local_irq_restore(flags);
@@ -106,7 +95,7 @@ static int dream_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on)
 
 static int dream_gpio_configure(struct gpio_chip *chip, unsigned int gpio, unsigned long flags)
 {
-	if(flags & (GPIOF_OUTPUT_LOW | GPIOF_OUTPUT_HIGH))
+	if (flags & (GPIOF_OUTPUT_LOW | GPIOF_OUTPUT_HIGH))
 		dream_gpio_write(chip, gpio, flags & GPIOF_OUTPUT_HIGH);
 	return 0;
 }
@@ -119,7 +108,7 @@ static int dream_gpio_get_irq_num(struct gpio_chip *chip, unsigned int gpio, uns
 	     gpio > DREAM_GPIO_BANK1_LAST_INT_SOURCE))
 		return -ENOENT;
 	*irqp = DREAM_GPIO_TO_INT(gpio);
-	if(irqnumflagsp)
+	if (irqnumflagsp)
 		*irqnumflagsp = 0;
 	return 0;
 }
@@ -129,7 +118,7 @@ static void dream_gpio_irq_ack(unsigned int irq)
 	int bank = DREAM_INT_TO_BANK(irq);
 	uint8_t mask = DREAM_INT_TO_MASK(irq);
 	int reg = DREAM_BANK_TO_STAT_REG(bank);
-	/*printk(KERN_INFO "dream_gpio_irq_ack irq %d\n", irq);*/
+
 	writeb(mask, DREAM_CPLD_BASE + reg);
 }
 
@@ -143,8 +132,7 @@ static void dream_gpio_irq_mask(unsigned int irq)
 
 	local_irq_save(flags);
 	reg_val = dream_int_mask[bank] |= mask;
-	/*printk(KERN_INFO "dream_gpio_irq_mask irq %d => %d:%02x\n",
-	       irq, bank, reg_val);*/
+
 	if (!dream_suspended)
 		writeb(reg_val, DREAM_CPLD_BASE + reg);
 	local_irq_restore(flags);
@@ -160,8 +148,7 @@ static void dream_gpio_irq_unmask(unsigned int irq)
 
 	local_irq_save(flags);
 	reg_val = dream_int_mask[bank] &= ~mask;
-	/*printk(KERN_INFO "dream_gpio_irq_unmask irq %d => %d:%02x\n",
-	       irq, bank, reg_val);*/
+
 	if (!dream_suspended)
 		writeb(reg_val, DREAM_CPLD_BASE + reg);
 	local_irq_restore(flags);
@@ -174,7 +161,7 @@ int dream_gpio_irq_set_wake(unsigned int irq, unsigned int on)
 	uint8_t mask = DREAM_INT_TO_MASK(irq);
 
 	local_irq_save(flags);
-	if(on)
+	if (on)
 		dream_sleep_int_mask[bank] &= ~mask;
 	else
 		dream_sleep_int_mask[bank] |= mask;
@@ -195,17 +182,17 @@ static void dream_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 		stat_reg = DREAM_BANK_TO_STAT_REG(bank);
 		v = readb(DREAM_CPLD_BASE + stat_reg);
 		int_mask = dream_int_mask[bank];
+
 		if (v & int_mask) {
 			writeb(v & int_mask, DREAM_CPLD_BASE + stat_reg);
 			printk(KERN_ERR "dream_gpio_irq_handler: got masked "
 			       "interrupt: %d:%02x\n", bank, v & int_mask);
 		}
+
 		v &= ~int_mask;
 		while (v) {
 			m = v & -v;
 			j = fls(m) - 1;
-			/*printk(KERN_INFO "msm_gpio_irq_handler %d:%02x %02x b"
-			       "it %d irq %d\n", bank, v, m, j, int_base + j);*/
 			v &= ~m;
 			generic_handle_irq(int_base + j);
 		}
@@ -242,7 +229,6 @@ static struct irq_chip dream_gpio_irq_chip = {
 	.mask      = dream_gpio_irq_mask,
 	.unmask    = dream_gpio_irq_unmask,
 	.set_wake  = dream_gpio_irq_set_wake,
-	//.set_type  = dream_gpio_irq_set_type,
 };
 
 static struct gpio_chip dream_gpio_chip = {
@@ -252,8 +238,6 @@ static struct gpio_chip dream_gpio_chip = {
 	.get_irq_num = dream_gpio_get_irq_num,
 	.read = dream_gpio_read,
 	.write = dream_gpio_write,
-//	.read_detect_status = dream_gpio_read_detect_status,
-//	.clear_detect_status = dream_gpio_clear_detect_status
 };
 
 struct sysdev_class dream_sysdev_class = {
@@ -277,10 +261,10 @@ static int __init dream_init_gpio(void)
 	pr_info("dream_init_gpio: cpld_usb_hw2_sw = %d\n", cpld_usb_h2w_sw);
 	dream_gpio_write_shadow(DREAM_GPIO_USB_H2W_SW, cpld_usb_h2w_sw);
 
-	for(i = 0; i < ARRAY_SIZE(dream_cpld_shadow); i++)
+	for (i = 0; i < ARRAY_SIZE(dream_cpld_shadow); i++)
 		writeb(dream_cpld_shadow[i], DREAM_CPLD_BASE + i * 2);
 
-	for(i = DREAM_INT_START; i <= DREAM_INT_END; i++) {
+	for (i = DREAM_INT_START; i <= DREAM_INT_END; i++) {
 		set_irq_chip(i, &dream_gpio_irq_chip);
 		set_irq_handler(i, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
@@ -292,7 +276,7 @@ static int __init dream_init_gpio(void)
 	set_irq_chained_handler(MSM_GPIO_TO_INT(17), dream_gpio_irq_handler);
 	set_irq_wake(MSM_GPIO_TO_INT(17), 1);
 
-	if(sysdev_class_register(&dream_sysdev_class) == 0)
+	if (sysdev_class_register(&dream_sysdev_class) == 0)
 		sysdev_register(&dream_irq_device);
 
 	return 0;
diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
index 4758957..3e8e54a 100644
--- a/arch/arm/mach-msm/board-dream.c
+++ b/arch/arm/mach-msm/board-dream.c
@@ -59,6 +59,23 @@ static void __init dream_fixup(struct machine_desc *desc, struct tag *tags,
 
 static void __init dream_init(void)
 {
+	gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
+        mdelay(300);
+	gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
+        mdelay(300);
+        gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
+	mdelay(300);
+        gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
+	mdelay(300);
+        gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
+        mdelay(300);
+        gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
+        mdelay(300);
+	gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
+        mdelay(300);
+	gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
+        mdelay(300);
+
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
diff --git a/arch/arm/mach-msm/generic_gpio.c b/arch/arm/mach-msm/generic_gpio.c
index fe24d38..cde1685 100644
--- a/arch/arm/mach-msm/generic_gpio.c
+++ b/arch/arm/mach-msm/generic_gpio.c
@@ -40,8 +40,10 @@ int register_gpio_chip(struct gpio_chip *new_gpio_chip)
 	int i;
 	unsigned long irq_flags;
 	unsigned int chip_array_start_index, chip_array_end_index;
+	int size = (new_gpio_chip->end + 1 - new_gpio_chip->start) *
+		   sizeof(new_gpio_chip->state[0]);
 
-	new_gpio_chip->state = kzalloc((new_gpio_chip->end + 1 - new_gpio_chip->start) * sizeof(new_gpio_chip->state[0]), GFP_KERNEL);
+	new_gpio_chip->state = kzalloc(size, GFP_KERNEL);
 	if (new_gpio_chip->state == NULL) {
 		printk(KERN_ERR "register_gpio_chip: failed to allocate state\n");
 		return -ENOMEM;
@@ -50,12 +52,13 @@ int register_gpio_chip(struct gpio_chip *new_gpio_chip)
 	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
 	chip_array_start_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->start);
 	chip_array_end_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->end);
+
 	if (chip_array_end_index >= gpio_chip_array_size) {
 		struct gpio_chip **new_gpio_chip_array;
 		unsigned long new_gpio_chip_array_size = chip_array_end_index + 1;
 
 		new_gpio_chip_array = kmalloc(new_gpio_chip_array_size * sizeof(new_gpio_chip_array[0]), GFP_ATOMIC);
-		if (new_gpio_chip_array == NULL) {
+		if (!new_gpio_chip_array) {
 			printk(KERN_ERR "register_gpio_chip: failed to allocate array\n");
 			err = -ENOMEM;
 			goto failed;
@@ -67,6 +70,7 @@ int register_gpio_chip(struct gpio_chip *new_gpio_chip)
 		gpio_chip_array = new_gpio_chip_array;
 		gpio_chip_array_size = new_gpio_chip_array_size;
 	}
+
 	list_for_each_entry(gpio_chip, &gpio_chip_list, list) {
 		if (gpio_chip->start > new_gpio_chip->end) {
 			list_add_tail(&new_gpio_chip->list, &gpio_chip->list);
@@ -80,10 +84,11 @@ int register_gpio_chip(struct gpio_chip *new_gpio_chip)
 			goto failed;
 		}
 	}
+
 	list_add_tail(&new_gpio_chip->list, &gpio_chip_list);
 added:
 	for (i = chip_array_start_index; i <= chip_array_end_index; i++) {
-		if (gpio_chip_array[i] == NULL || gpio_chip_array[i]->start > new_gpio_chip->start)
+		if ((!gpio_chip_array[i]) || gpio_chip_array[i]->start > new_gpio_chip->start)
 			gpio_chip_array[i] = new_gpio_chip;
 	}
 failed:

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
