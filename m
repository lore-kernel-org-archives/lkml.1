Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXLLLKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXLLLKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbXLLLKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:10:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbXLLLKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:10:03 -0500
Date: Wed, 12 Dec 2007 03:09:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/47] Add new driver files for Artpec-3.
Message-Id: <20071212030954.a18e5b04.akpm@linux-foundation.org>
In-Reply-To: <12cbfaacef5f6845538315485219e13b3b973eeb.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<12cbfaacef5f6845538315485219e13b3b973eeb.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 17:03:41 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> Adds gpio and nandflash handling for Artpec-3.
> 
> ...
>
> +static volatile unsigned long *data_out[NUM_PORTS] = {

all these volatiles really shouldn't be here.

> +static void
> +gpio_set_alarm(struct gpio_private *priv)
> +{
> +	int bit;
> +	int intr_cfg;
> +	int mask;
> +	int pins;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);

Will never run on SMP?

> +
> +inline unsigned long setget_input(struct gpio_private *priv, unsigned long arg)
> +{
> +	/* Set direction 0=unchanged 1=input,
> +	 * return mask with 1=input
> +	 */
> +	unsigned long flags;
> +	unsigned long dir_shadow;
> +
> +	local_irq_save(flags);
> +	dir_shadow = *dir_oe[priv->minor];
> +	dir_shadow &= ~(arg & changeable_dir[priv->minor]);
> +	*dir_oe[priv->minor] = dir_shadow;
> +	local_irq_restore(flags);
> +
> +	if (priv->minor == GPIO_MINOR_C)
> +		dir_shadow ^= 0xFFFF;		/* Only 16 bits */
> +#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
> +	else if (priv->minor == GPIO_MINOR_V)
> +		dir_shadow ^= 0xFFFF;		/* Only 16 bits */
> +#endif
> +	else
> +		dir_shadow ^= 0xFFFFFFFF;	/* PA, PB and PD 32 bits */
> +
> +	return dir_shadow;
> +
> +} /* setget_input */
> +
> +inline unsigned long setget_output(struct gpio_private *priv, unsigned long arg)
> +{
> +	unsigned long flags;
> +	unsigned long dir_shadow;
> +
> +	local_irq_save(flags);
> +	dir_shadow = *dir_oe[priv->minor];
> +	dir_shadow |=  (arg & changeable_dir[priv->minor]);
> +	*dir_oe[priv->minor] = dir_shadow;
> +	local_irq_restore(flags);
> +	return dir_shadow;
> +} /* setget_output */

The `inline's here are surely deoptimising the code.

> +static int
> +gpio_leds_ioctl(unsigned int cmd, unsigned long arg);
> +
> +static int
> +gpio_pwm_ioctl(struct gpio_private *priv, unsigned int cmd, unsigned long arg);
> +
> +static int
> +gpio_ioctl(struct inode *inode, struct file *file,
> +	   unsigned int cmd, unsigned long arg)
> +{
> +	unsigned long flags;
> +	unsigned long val;
> +	unsigned long shadow;
> +	struct gpio_private *priv = (struct gpio_private *)file->private_data;

Unneeded and undesirable cast of void*.

> +
> +	if (_IOC_TYPE(cmd) != ETRAXGPIO_IOCTYPE)
> +		return -EINVAL;

Not ENOTTY?

> +	/* Check for special ioctl handlers first */
> +
> +#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
> +	if (priv->minor == GPIO_MINOR_V)
> +		return virtual_gpio_ioctl(file, cmd, arg);
> +#endif
> +
> +	if (priv->minor == GPIO_MINOR_LEDS)
> +		return gpio_leds_ioctl(cmd, arg);
> +
> +	if (priv->minor >= GPIO_MINOR_PWM0 &&
> +	    priv->minor <= GPIO_MINOR_LAST_PWM)
> +		return gpio_pwm_ioctl(priv, cmd, arg);
> +
> +	switch (_IOC_NR(cmd)) {
> +	case IO_READBITS: /* Use IO_READ_INBITS and IO_READ_OUTBITS instead */
> +		/* Read the port. */
> +		return *data_in[priv->minor];

Really.  Nuke the volatiles, use readl().

> +		break;
> +	case IO_SETBITS:
> +		local_irq_save(flags);
> +		/* Set changeable bits with a 1 in arg. */
> +		shadow = *data_out[priv->minor];

readl()

> +		shadow |=  (arg & changeable_bits[priv->minor]);
> +		*data_out[priv->minor] = shadow;

writel()

> +		local_irq_restore(flags);
> +		break;
> +	case IO_CLRBITS:
> +		local_irq_save(flags);
> +		/* Clear changeable bits with a 1 in arg. */
> +		shadow = *data_out[priv->minor];
> +		shadow &=  ~(arg & changeable_bits[priv->minor]);
> +		*data_out[priv->minor] = shadow;
> +		local_irq_restore(flags);
> +		break;
> +	case IO_HIGHALARM:
> +		/* Set alarm when bits with 1 in arg go high. */
> +		priv->highalarm |= arg;
> +		gpio_set_alarm(priv);
> +		break;
> +	case IO_LOWALARM:
> +		/* Set alarm when bits with 1 in arg go low. */
> +		priv->lowalarm |= arg;
> +		gpio_set_alarm(priv);
> +		break;
> +	case IO_CLRALARM:
> +		/* Clear alarm for bits with 1 in arg. */
> +		priv->highalarm &= ~arg;
> +		priv->lowalarm  &= ~arg;
> +		gpio_set_alarm(priv);
> +		break;
> +	case IO_READDIR: /* Use IO_SETGET_INPUT/OUTPUT instead! */
> +		/* Read direction 0=input 1=output */
> +		return *dir_oe[priv->minor];
> +	case IO_SETINPUT: /* Use IO_SETGET_INPUT instead! */
> +		/* Set direction 0=unchanged 1=input,
> +		 * return mask with 1=input
> +		 */
> +		return setget_input(priv, arg);
> +		break;

That break is a bit pointless.

> +	case IO_SETOUTPUT: /* Use IO_SETGET_OUTPUT instead! */
> +		/* Set direction 0=unchanged 1=output,
> +		 * return mask with 1=output
> +		 */
> +		return setget_output(priv, arg);
> +
> +	case IO_CFG_WRITE_MODE:
> +	{
> +		unsigned long dir_shadow;
> +		dir_shadow = *dir_oe[priv->minor];
> +
> +		priv->clk_mask = arg & 0xFF;
> +		priv->data_mask = (arg >> 8) & 0xFF;
> +		priv->write_msb = (arg >> 16) & 0x01;
> +		/* Check if we're allowed to change the bits and
> +		 * the direction is correct
> +		 */
> +		if (!((priv->clk_mask & changeable_bits[priv->minor]) &&
> +		      (priv->data_mask & changeable_bits[priv->minor]) &&
> +		      (priv->clk_mask & dir_shadow) &&
> +		      (priv->data_mask & dir_shadow))) {
> +			priv->clk_mask = 0;
> +			priv->data_mask = 0;
> +			return -EPERM;
> +		}
> +		break;
> +	}
> +	case IO_READ_INBITS:
> +		/* *arg is result of reading the input pins */
> +		val = *data_in[priv->minor];
> +		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))

Strange cast.  Maybe void __user *?

> +			return -EFAULT;
> +		return 0;
> +		break;
> +	case IO_READ_OUTBITS:
> +		 /* *arg is result of reading the output shadow */
> +		val = *data_out[priv->minor];
> +		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
> +			return -EFAULT;
> +		break;
> +	case IO_SETGET_INPUT:
> +		/* bits set in *arg is set to input,
> +		 * *arg updated with current input pins.
> +		 */
> +		if (copy_from_user(&val, (unsigned long *)arg, sizeof(val)))
> +			return -EFAULT;
> +		val = setget_input(priv, val);
> +		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
> +			return -EFAULT;
> +		break;
> +	case IO_SETGET_OUTPUT:
> +		/* bits set in *arg is set to output,
> +		 * *arg updated with current output pins.
> +		 */
> +		if (copy_from_user(&val, (unsigned long *)arg, sizeof(val)))
> +			return -EFAULT;
> +		val = setget_output(priv, val);
> +		if (copy_to_user((unsigned long *)arg, &val, sizeof(val)))
> +			return -EFAULT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	} /* switch */
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
> +static int
> +virtual_gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	unsigned long flags;
> +	unsigned short val;
> +	unsigned short shadow;
> +	struct gpio_private *priv = (struct gpio_private *)file->private_data;

unneeded cast.

> +	int mode;
> +	reg_gio_rw_pwm0_ctrl rw_pwm_ctrl = {
> +		.ccd_val = 0,
> +		.ccd_override = regk_gio_no,
> +		.mode = regk_gio_no
> +	};
> +	int allocstatus;
> +
> +	if (get_user(mode, &((struct io_pwm_set_mode *) arg)->mode))
> +		return -EFAULT;
> +	rw_pwm_ctrl.mode = mode;
> +	if (mode != PWM_OFF)
> +		allocstatus = crisv32_pinmux_alloc_fixed(pinmux_pwm);
> +	else
> +		allocstatus = crisv32_pinmux_dealloc_fixed(pinmux_pwm);
> +	if (allocstatus)
> +		return allocstatus;
> +	REG_WRITE(reg_gio_rw_pwm0_ctrl, REG_ADDR(gio, regi_gio, rw_pwm0_ctrl) +
> +		12 * pwm_port, rw_pwm_ctrl);
> +	return 0;
> +}

You might like to run sparse across this code (make C=1)

> +static int gpio_pwm_set_period(unsigned long arg, int pwm_port)
> +{
> +	struct io_pwm_set_period periods;
> +	reg_gio_rw_pwm0_var rw_pwm_widths;
> +
> +	if (copy_from_user(&periods, (struct io_pwm_set_period *) arg,
> +			sizeof(periods)))
> +		return -EFAULT;
> +	if (periods.lo > 8191 || periods.hi > 8191)
> +		return -EINVAL;

(Can't find the definition of io_pwm_set_period)

I hope .lo and .hi are unsigned.

> +	rw_pwm_widths.lo = periods.lo;
> +	rw_pwm_widths.hi = periods.hi;
> +	REG_WRITE(reg_gio_rw_pwm0_var, REG_ADDR(gio, regi_gio, rw_pwm0_var) +
> +		12 * pwm_port, rw_pwm_widths);
> +	return 0;
> +}
> +
> +static int gpio_pwm_set_duty(unsigned long arg, int pwm_port)
> +{
> +	unsigned int duty;
> +	reg_gio_rw_pwm0_data rw_pwm_duty;
> +
> +	if (get_user(duty, &((struct io_pwm_set_duty *) arg)->duty))
> +		return -EFAULT;
> +	if (duty > 255)
> +		return -EINVAL;
> +	rw_pwm_duty.data = duty;
> +	REG_WRITE(reg_gio_rw_pwm0_data, REG_ADDR(gio, regi_gio, rw_pwm0_data) +
> +		12 * pwm_port, rw_pwm_duty);
> +	return 0;
> +}
> +
> +static int
> +gpio_pwm_ioctl(struct gpio_private *priv, unsigned int cmd, unsigned long arg)
> +{
> +	int pwm_port = priv->minor - GPIO_MINOR_PWM0;
> +
> +	switch (_IOC_NR(cmd)) {
> +	case IO_PWM_SET_MODE:
> +		return gpio_pwm_set_mode(arg, pwm_port);
> +	case IO_PWM_SET_PERIOD:
> +		return gpio_pwm_set_period(arg, pwm_port);
> +	case IO_PWM_SET_DUTY:
> +		return gpio_pwm_set_duty(arg, pwm_port);
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}

What a lot of ioctls

> +struct file_operations gpio_fops = {
> +	.owner       = THIS_MODULE,
> +	.poll        = gpio_poll,
> +	.ioctl       = gpio_ioctl,
> +	.write       = gpio_write,
> +	.open        = gpio_open,
> +	.release     = gpio_release,
> +};

static?

> +static __init int
> +gpio_init(void)

Normally we'd do `static int __init'.  Cosmetic.

> +{
> +	int res;
> +
> +	/* do the formalities */
> +
> +	res = register_chrdev(GPIO_MAJOR, gpio_name, &gpio_fops);
> +	if (res < 0) {
> +		printk(KERN_ERR "gpio: couldn't get a major number.\n");
> +		return res;
> +	}
> +
> +	/* Clear all leds */
> +	LED_NETWORK_GRP0_SET(0);
> +	LED_NETWORK_GRP1_SET(0);
> +	LED_ACTIVE_SET(0);
> +	LED_DISK_READ(0);
> +	LED_DISK_WRITE(0);
> +
> +	printk(KERN_INFO "ETRAX FS GPIO driver v2.6, (c) 2003-2007 "
> +		"Axis Communications AB\n");
> +	if (request_irq(GIO_INTR_VECT, gpio_interrupt,
> +			IRQF_SHARED | IRQF_DISABLED, "gpio", &alarmlist))
> +		printk(KERN_ERR "err: irq for gpio\n");

Should handle this properly.

> +	/* No IRQs by default. */
> +	REG_WR_INT(gio, regi_gio, rw_intr_pins, 0);
> +
> +#ifdef CONFIG_ETRAX_VIRTUAL_GPIO
> +	virtual_gpio_init();
> +#endif
> +
> +	return res;
> +}
>
> ...
>
> +/*
> + *	hardware specific access to control-lines
> + */
> +static void crisv32_hwcontrol(struct mtd_info *mtd, int cmd,
> +			      unsigned int ctrl)
> +{
> +	unsigned long flags;
> +	reg_pio_rw_dout dout;
> +	struct nand_chip *this = mtd->priv;
> +
> +	local_irq_save(flags);
> +
> +	/* control bits change */
> +	if (ctrl & NAND_CTRL_CHANGE) {
> +		dout = REG_RD(pio, regi_pio, rw_dout);
> +		dout.regf_NCE = (ctrl & NAND_NCE) ? 0 : 1;
> +
> +#if !MANUAL_ALE_CLE_CONTROL
> +		if (ctrl & NAND_ALE) {
> +			/* A0 = ALE high */
> +			this->IO_ADDR_W = (void __iomem *)REG_ADDR(pio,
> +				regi_pio, rw_io_access1);
> +		} else if (ctrl & NAND_CLE) {
> +			/* A1 = CLE high */
> +			this->IO_ADDR_W = (void __iomem *)REG_ADDR(pio,
> +				regi_pio, rw_io_access2);
> +		} else {
> +			/* A1 = CLE and A0 = ALE low */
> +			this->IO_ADDR_W = (void __iomem *)REG_ADDR(pio,
> +				regi_pio, rw_io_access0);
> +		}
> +#else
> +
> +		dout.regf_CLE = (ctrl & NAND_CLE) ? 1 : 0;
> +		dout.regf_ALE = (ctrl & NAND_ALE) ? 1 : 0;
> +#endif
> +		REG_WR(pio, regi_pio, rw_dout, dout);
> +	}
> +
> +	/* command to chip */
> +	if (cmd != NAND_CMD_NONE)
> +		writeb(cmd, this->IO_ADDR_W);
> +
> +	local_irq_restore(flags);
> +}

Maybe the MTD developers should have a look at this code.

> +/*
> +*	read device ready pin
> +*/
> +int crisv32_device_ready(struct mtd_info *mtd)
> +{
> +	reg_pio_r_din din = REG_RD(pio, regi_pio, r_din);
> +	return din.rdy;
> +}

Please check that all new global symbols do indeed need to be global.

> +/*
> + * Main initialization routine
> + */
> +struct mtd_info *__init crisv32_nand_flash_probe(void)
> +{
> +	void __iomem *read_cs;
> +	void __iomem *write_cs;
> +
> +	struct nand_chip *this;
> +	int err = 0;
> +
> +	reg_pio_rw_man_ctrl man_ctrl = {
> +		.regf_NCE = regk_pio_yes,
> +#if MANUAL_ALE_CLE_CONTROL
> +		.regf_ALE = regk_pio_yes,
> +		.regf_CLE = regk_pio_yes
> +#endif
> +	};
> +	reg_pio_rw_oe oe = {
> +		.regf_NCE = regk_pio_yes,
> +#if MANUAL_ALE_CLE_CONTROL
> +		.regf_ALE = regk_pio_yes,
> +		.regf_CLE = regk_pio_yes
> +#endif
> +	};
> +	reg_pio_rw_dout dout = { .regf_NCE = 1 };
> +
> +	/* Allocate pio pins to pio */
> +	crisv32_pinmux_alloc_fixed(pinmux_pio);
> +	/* Set up CE, ALE, CLE (ce0_n, a0, a1) for manual control and output */
> +	REG_WR(pio, regi_pio, rw_man_ctrl, man_ctrl);
> +	REG_WR(pio, regi_pio, rw_dout, dout);
> +	REG_WR(pio, regi_pio, rw_oe, oe);
> +
> +	/* Allocate memory for MTD device structure and private data */
> +	crisv32_mtd = kmalloc(sizeof(struct mtd_info) +
> +		sizeof(struct nand_chip), GFP_KERNEL);
> +	if (!crisv32_mtd) {
> +		printk(KERN_ERR "Unable to allocate CRISv32 NAND MTD "
> +			"device structure.\n");
> +		err = -ENOMEM;
> +		return NULL;
> +	}
> +
> +	read_cs = write_cs = (void __iomem *)REG_ADDR(pio, regi_pio,
> +		rw_io_access0);
> +
> +	/* Get pointer to private data */
> +	this = (struct nand_chip *) (&crisv32_mtd[1]);

What on earth is going on here?  We cast a struct mtd_info* into a struct
nand_chip*?

otoh maybe I don't want to know what's going on here.

oic we've jammed two structs together into the same kmalloc.  If that's
_really_ worth bothering about, why not do it properly?

struct foo {
	struct mtd_info a;
	struct nand_chip b;
};

rather than this gruesomeness.

> +	/* Initialize structures */
> +	memset((char *) crisv32_mtd, 0, sizeof(struct mtd_info));
> +	memset((char *) this, 0, sizeof(struct nand_chip));

kzalloc()...

> +	/* Link the private data with the MTD structure */
> +	crisv32_mtd->priv = this;
> +
> +	/* Set address of NAND IO lines */
> +	this->IO_ADDR_R = read_cs;
> +	this->IO_ADDR_W = write_cs;
> +	this->cmd_ctrl = crisv32_hwcontrol;
> +	this->dev_ready = crisv32_device_ready;
> +	/* 20 us command delay time */
> +	this->chip_delay = 20;
> +	this->ecc.mode = NAND_ECC_SOFT;
> +
> +	/* Enable the following for a flash based bad block table */
> +	/* this->options = NAND_USE_FLASH_BBT; */
> +
> +	/* Scan to find existance of the device */
> +	if (nand_scan(crisv32_mtd, 1)) {
> +		err = -ENXIO;
> +		goto out_mtd;
> +	}
> +
> +	return crisv32_mtd;
> +
> +out_mtd:
> +	kfree(crisv32_mtd);
> +	return NULL;
> +}

This code all looks rather hacky.

