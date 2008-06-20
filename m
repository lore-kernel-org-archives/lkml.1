Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYFTJW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYFTJW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 05:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYFTJWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 05:22:48 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:54140
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbYFTJWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 05:22:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsUAABEUW0h8qNQu/2dsb2JhbAAIr2I
X-IronPort-AV: E=Sophos;i="4.27,678,1204470000"; 
   d="c'?scan'208";a="331804884"
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
From: Ben Nizette <bn@niasdigital.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <20080620065253.GA14238@ca-server1.us.oracle.com>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <20080619024804.GA29765@mail.oracle.com>
	 <1213942750.2336.43.camel@moss.renham>
	 <20080620065253.GA14238@ca-server1.us.oracle.com>
Content-Type: multipart/mixed; boundary="=-q3hgE7LBuCy670maxJiC"
Organization: Nias Digital
Date: Fri, 20 Jun 2008 19:22:56 +1000
Message-Id: <1213953776.2336.75.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q3hgE7LBuCy670maxJiC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 2008-06-19 at 23:52 -0700, Joel Becker wrote:
> On Fri, Jun 20, 2008 at 04:19:10PM +1000, Ben Nizette wrote:
> > Looks great, thx :-).  I'll convert some of my stuff over to this
> > interface and see how it flies in the real world.
> 
> 	Excellent.  What is your stuff, btw?  Got code?  Love to see it.

I've done a few things recently.  Haavard Skinnemoen has got an
out-of-tree, avr32-specific gpio interface [1] which I first converted
to the generic gpio framework then completely re-wrote.  Both use
configfs but before either version could reach completion they were
obsoleted by David Brownell's gpio sysfs interface.

A version of my gpio-dev interface is attached.  Bear in mind it was
never completed, it's full of known bugs but hey, might be useful for
you anyway :-)

At the moment I'm experimenting with configfs for pinmux control on
AVR32 SoCs.  There's really nothing to see there yet, it's all just
dicking about atm.

> 
> > ISTR when I did this I kept the old semantics and used ERR_PTR and
> > friends if things went pear-shaped.  Given the small number of in-tree
> > users needing to be moved over, a more intrusive change for the sake of
> > a cleaner API like you've done is probably a good thing anyway :-)
> 
> 	Yeah, I like this better than ERR_PTR.
> 	If you like the macros, I'll try to make the next merge window
> as well.  So let me know.

np, will do :-)

	--Ben.

> 
> joel
> 

[1]
http://git.kernel.org/?p=linux/kernel/git/hskinnemoen/avr32-2.6.git;a=blob;f=arch/avr32/mach-at32ap/gpio-dev.c;h=8cf6d1182c31db88fc069a046112a4eaac589308;hb=atmel-2.6.25


--=-q3hgE7LBuCy670maxJiC
Content-Disposition: attachment; filename=gpio-dev.c
Content-Type: text/x-csrc; name=gpio-dev.c; charset=utf-8
Content-Transfer-Encoding: 7bit

/*
 * GPIO /dev and configfs interface
 *
 * Copyright (C) 2008 Nias Digital P/L
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/err.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/spinlock.h>
#include <linux/configfs.h>
#include <linux/types.h>
#include <linux/platform_device.h>
#include <linux/poll.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <linux/kfifo.h>

#include <asm/uaccess.h>
#include <asm/bug.h>
#include <asm/gpio.h>

#include "gpio-dev.h"

#define MAX_NR_DEVICES	8
#define IRQ_BUFFER_SIZE	256

#define BUF_PUT_INT(k, b) \
			do { \
				char *p = (char *)&b; \
				kfifo_put(k, p, sizeof(int)); \
			} while (0)

#define BUF_GET_INT(k, b) \
			do { \
				char *p = (char *)&b; \
				kfifo_get(k, p, sizeof(int)); \
			} while (0)

static struct class *dev_class;
static dev_t base_devt;

struct gpiodev {
	spinlock_t lock;

	int id;
	char *bankname;

	struct gpiodev_pin *pins;
	int nr_pins;

	int io_enabled;
	int irq_enabled;

	struct kfifo *irq_buf;
	spinlock_t irq_lock;

	struct device *io_dev;
	struct device *irq_dev;

	/* We can unify these somewhat by doing some fop switching
	 * magic, though I can't convince myself it's worth it*/
	struct cdev io_char_dev;
	struct cdev irq_char_dev;

	wait_queue_head_t irq_wq;
	struct fasync_struct *async_queue;

	struct config_group group;
};

struct gpiodev *devices[MAX_NR_DEVICES];
spinlock_t devices_lock;

static irqreturn_t irq_interrupt(int irq, void *dev_id)
{
	int i, found = 0;
	int gpio = irq_to_gpio(irq);

	struct gpiodev *bank = dev_id;

	for (i = 0; i < bank->nr_pins; i++) {
		if (bank->pins[i].pin == gpio) {
			found = 1;
			break;
		}
	}

	if (!found)
		return IRQ_NONE;

	BUF_PUT_INT(bank->irq_buf, i);

	wake_up_interruptible(&bank->irq_wq);

	if (bank->async_queue)
		kill_fasync(&bank->async_queue, SIGIO, POLL_IN);

	return IRQ_HANDLED;
}


static int io_open(struct inode *inode, struct file *file)
{
	struct gpiodev *bank = container_of(inode->i_cdev,
					      struct gpiodev,
					      io_char_dev);

	spin_lock(&bank->lock);
	config_item_get(&bank->group.cg_item);
	file->private_data = bank;
	spin_unlock(&bank->lock);

	return 0;
}

static int io_release(struct inode *inode, struct file *file)
{
	struct gpiodev *bank = file->private_data;

	spin_lock(&bank->lock);
	config_item_put(&bank->group.cg_item);
	spin_unlock(&bank->lock);

	return 0;
}

static ssize_t io_read(struct file *file, char __user *buf,
			     size_t count, loff_t *offset)
{
	int i, ret = 0;
	char *val;

	struct gpiodev *bank = file->private_data;

	count = min(count, (size_t)(bank->nr_pins - *offset));

	val = kmalloc(sizeof(char) * count, GFP_KERNEL);
	if (!val)
		return -ENOMEM;

	spin_lock(&bank->lock);
	for (i = *offset; i < *offset + count; i++) {
		int pin = bank->pins[i].pin;
		int value;

		if (file->f_flags & O_NONBLOCK)
			value = gpio_get_value(pin);
		else
			value = gpio_get_value_cansleep(pin);

		val[i] = (!!value) + '0';
	}

	*offset += count;
	spin_unlock(&bank->lock);

	if (copy_to_user(buf, val, count))
		ret = -EFAULT;

	kfree(val);
	return ret ? ret : count;
}

static ssize_t io_write(struct file *file, const char __user *buf,
			      size_t count, loff_t *offset)
{
	int i, ret = 0;
	char *val, *p;

	struct gpiodev *bank = file->private_data;

	count = min(count, (size_t)(bank->nr_pins - *offset));

	val = kmalloc(sizeof(char) * count, GFP_KERNEL);
	if (!val)
		return -ENOMEM;

	if (copy_from_user(val, buf, count)) {
		ret = -EFAULT;
		goto out_cpy;
	}

	p = val;

	spin_lock(&bank->lock);

	for (i = *offset; i < *offset + count; i++) {
		int pin = bank->pins[i].pin;
		int value = val[i] - '0';

		if (value != 0 || value != 1)
			break;

		bank->pins[i].outval = value;

		if (file->f_flags & O_NONBLOCK)
			gpio_set_value(pin, value);
		else
			gpio_set_value_cansleep(pin, value);
	}

	*offset = i;

	spin_unlock(&bank->lock);

out_cpy:
	kfree(val);
	return ret ? ret : count;
}

static loff_t io_llseek(struct file *file, loff_t off, int whence)
{
	struct gpiodev *bank = file->private_data;
	loff_t newpos;

	spin_lock(&bank->lock);

	switch (whence) {
	case SEEK_SET:
		newpos = off;
		break;
	case SEEK_CUR:
		newpos = file->f_pos + off;
		break;
	case SEEK_END:
		newpos = bank->nr_pins + off;
		break;
	default:
		return -EINVAL;
	}

	spin_unlock(&bank->lock);

	return newpos;
}

static struct file_operations io_fops = {
	.owner		= THIS_MODULE,
	.llseek		= io_llseek,
	.open		= io_open,
	.release	= io_release,
	.read		= io_read,
	.write		= io_write,
};

static int irq_open(struct inode *inode, struct file *file)
{
	struct gpiodev *bank = container_of(inode->i_cdev,
					      struct gpiodev,
					      io_char_dev);

	nonseekable_open(inode, file);

	spin_lock(&bank->lock);
	config_item_get(&bank->group.cg_item);
	file->private_data = bank;
	spin_unlock(&bank->lock);

	return 0;
}

static int irq_release(struct inode *inode, struct file *file)
{
	struct gpiodev *bank = file->private_data;

	spin_lock(&bank->lock);
	config_item_put(&bank->group.cg_item);
	spin_unlock(&bank->lock);

	return 0;
}

static ssize_t irq_read(struct file *file, char __user *buf,
			     size_t count, loff_t *offset)
{
	int i, len, *kbuf;
	struct gpiodev *bank = file->private_data;

	while (!kfifo_len(bank->irq_buf)) {

		if (file->f_flags & O_NONBLOCK)
			return -EAGAIN;

		if (wait_event_interruptible(bank->irq_wq,
					     kfifo_len(bank->irq_buf)))
			return -ERESTARTSYS;

	}

	len = min((size_t)kfifo_len(bank->irq_buf), count);

	kbuf = kmalloc(len * sizeof(int), GFP_KERNEL);

	if (!kbuf)
		return -ENOMEM;

	for (i = 0; i < len; i++)
		BUF_GET_INT(bank->irq_buf, kbuf[i]);

	if (copy_to_user(buf, kbuf, len)) {
		kfree(kbuf);
		return -EFAULT;
	}

	kfree(kbuf);
	return len;
}

static ssize_t irq_write(struct file *file, const char __user *buf,
			      size_t count, loff_t *offset)
{
	struct gpiodev *bank = file->private_data;

	/* Flush buffer */
	kfifo_reset(bank->irq_buf);

	return count;
}

static int irq_fasync(int fd, struct file *file, int mode)
{
	struct gpiodev *bank = file->private_data;

	return fasync_helper(fd, file, mode, &bank->async_queue);
}

static struct file_operations irq_fops = {
	.owner		= THIS_MODULE,
	.llseek		= no_llseek,
	.open		= irq_open,
	.release	= irq_release,
	.read		= irq_read,
	.write		= irq_write,
	.fasync		= irq_fasync,
};

/*
 * {enable,disable}_bank_{io,irq}() must be called under that bank's
 * lock.  They should only be called through their
 * set_bank_{io,irq}_enabled() which will (amongst other things)
 * take care of this locking for you.
 */
static int enable_bank_io(struct gpiodev *bank)
{
	int i;

	/* What error should a pin request failure be?? */
	int ret = -ENODEV;

	BUG_ON(!bank);

	for (i = 0; i < bank->nr_pins; i++) {
		if (!gpio_request(bank->pins[i].pin, bank->pins[i].label))
			goto err_alloc_pins;
	}

	cdev_init(&bank->io_char_dev, &io_fops);
	bank->io_char_dev.owner = THIS_MODULE;
	ret = cdev_add(&bank->io_char_dev, MKDEV(MAJOR(base_devt),
						 bank->id * 2), 1);

	if (ret < 0)
		goto err_cdev_add;

	bank->io_dev = device_create(dev_class, NULL,
				     MKDEV(MAJOR(base_devt), bank->id * 2),
				     "gpiod-%s", bank->bankname);

	if (IS_ERR(bank->io_dev)) {
		printk(KERN_ERR "gpio-dev: failed to create gpiod%d\n",
		       bank->id);
		ret = PTR_ERR(bank->io_dev);
		goto err_dev;
	}

	printk(KERN_INFO "gpio-dev: created gpiod%d as (%d:%d)\n",
	       bank->id, MAJOR(bank->io_dev->devt),
	       MINOR(bank->io_dev->devt));

	return 0;

err_dev:
	cdev_del(&bank->io_char_dev);
err_cdev_add:
err_alloc_pins:

	while (i--)
		gpio_free(bank->pins[i].pin);

	return ret;
}

static int disable_bank_io(struct gpiodev *bank)
{
	int i;

	BUG_ON(!bank);

	device_unregister(bank->io_dev);
	cdev_del(&bank->io_char_dev);

	for (i = 0; i < bank->nr_pins; i++)
		gpio_free(bank->pins[i].pin);

	return 0;
}

static int set_bank_io_enabled(struct gpiodev *bank, int enabled)
{
	int ret = 0;

	if (!bank) {
		printk(KERN_ERR "gpio-dev: Attempt to change enable " \
				"without valid device binding\n");
		return -EINVAL;
	}

	pr_debug("gpio-dev: setting bank %s enabled from %d to %d\n",
	       bank->bankname, bank->io_enabled, enabled);

	spin_lock(&bank->lock);

	if (bank->io_enabled == enabled)
		goto out;

	if (enabled)
		ret = enable_bank_io(bank);
	else
		ret = disable_bank_io(bank);

	if (!ret)
		bank->io_enabled = enabled;

out:
	spin_unlock(&bank->lock);
	return ret;
}


static int enable_bank_irq(struct gpiodev *bank)
{
	int ret;

	BUG_ON(!bank);

	cdev_init(&bank->irq_char_dev, &irq_fops);
	bank->irq_char_dev.owner = THIS_MODULE;
	ret = cdev_add(&bank->irq_char_dev, MKDEV(MAJOR(base_devt),
						bank->id * 2 + 1), 1);

	if (ret < 0)
		goto err_cdev_add;

	bank->irq_dev = device_create(dev_class, NULL,
					     MKDEV(MAJOR(base_devt), bank->id),
					     "gpioi-%s", bank->bankname);

	if (IS_ERR(bank->irq_dev)) {
		printk(KERN_ERR "gpio-dev: failed to create gpioi%d\n",
		       bank->id);
		ret = PTR_ERR(bank->irq_dev);
		goto err_dev;
	}

	printk(KERN_INFO "gpio-dev: created gpioi%d as (%d:%d)\n",
	       bank->id, MAJOR(bank->irq_dev->devt),
	       MINOR(bank->irq_dev->devt));

	return 0;

err_dev:
	cdev_del(&bank->irq_char_dev);
err_cdev_add:

	return ret;
}

static int disable_bank_irq(struct gpiodev *bank)
{
	BUG_ON(!bank);

	device_unregister(bank->irq_dev);
	cdev_del(&bank->irq_char_dev);

	return 0;
}

static int set_bank_irq_enabled(struct gpiodev *bank, int enabled)
{
	int ret = 0;

	if (!bank) {
		printk(KERN_ERR "gpio-dev: Attempt to change irq enable " \
				"without valid device binding\n");
		return -EINVAL;
	}

	pr_debug("gpio-dev: setting bank irq %s enabled from %d to %d\n",
	       bank->bankname, bank->irq_enabled, enabled);

	spin_lock(&bank->lock);

	if (bank->irq_enabled == enabled)
		goto out;

	if (enabled)
		ret = enable_bank_irq(bank);
	else
		ret = disable_bank_irq(bank);

	if (!ret)
		bank->irq_enabled = enabled;

out:
	spin_unlock(&bank->lock);
	return ret;
}

static inline struct gpiodev *to_gpiodev(struct config_group *group)
{
	return group ? container_of(group, struct gpiodev, group) : NULL;
}

static struct configfs_attribute bank_attr_enableio = {
	.ca_owner = THIS_MODULE,
	.ca_name = "enable-io",
	.ca_mode = S_IRUGO | S_IWUGO,
};

static struct configfs_attribute bank_attr_enableirq = {
	.ca_owner = THIS_MODULE,
	.ca_name = "enable-irq",
	.ca_mode = S_IRUGO | S_IWUGO,
};

static struct configfs_attribute *cfg_bank_attrs[] = {
	&bank_attr_enableio,
	&bank_attr_enableirq,
	NULL,
};

static ssize_t cfg_bank_attr_show(struct config_item *item,
				      struct configfs_attribute *attr,
				      char *page)
{
	struct gpiodev *bank = to_gpiodev(to_config_group(item));

	if (attr == &bank_attr_enableio)
		return sprintf(page, "%d\n", bank->io_enabled);
	else if (attr == &bank_attr_enableirq)
		return sprintf(page, "%d\n", bank->irq_enabled);
	else
		WARN_ON(1);

	return 0;
}

static ssize_t cfg_bank_attr_store(struct config_item *item,
				       struct configfs_attribute *attr,
				       const char *page, size_t count)
{
	struct gpiodev *bank = to_gpiodev(to_config_group(item));

	/* The only attributes which will come here are enable-{io,irq} */

	unsigned long tmp;
	int ret = 0;
	char *p = (char *) page;

	tmp = simple_strtoul(p, &p, 10);
	if (!p || (*p && (*p != '\n')))
		return -EINVAL;

	if (tmp > INT_MAX)
		return -ERANGE;

	/* Booleanize */
	tmp = !!tmp;

	pr_debug("gpio-dev: changing enabled attr on bank %s, attribute %d\n",
	       bank->bankname, (int)attr);

	if (attr == &bank_attr_enableio)
		ret = set_bank_io_enabled(bank, tmp);
	else if (attr == &bank_attr_enableirq)
		ret = set_bank_irq_enabled(bank, tmp);
	else {
		printk(KERN_ERR "unexpected attribute at %s, %d",
			__func__, __LINE__);
		WARN_ON(1);
	}

	return ret ? ret : count;
}

static struct configfs_item_operations cfg_bank_item_ops = {
	.show_attribute		= cfg_bank_attr_show,
	.store_attribute	= cfg_bank_attr_store,
};

static struct config_item_type cfg_bank_type = {
	.ct_owner	= THIS_MODULE,
	.ct_item_ops	= &cfg_bank_item_ops,
	.ct_attrs	= cfg_bank_attrs,
};

static struct config_group *cfg_make_group(struct config_group *group,
						   const char *name)
{
	int i;

	struct gpiodev *dev = NULL;

	spin_lock(&devices_lock);
	for (i = 0; i < MAX_NR_DEVICES; i++) {
		if (!devices[i])
			continue;

		if (strcmp(name, devices[i]->bankname) == 0) {
			dev = devices[i];
			printk(KERN_INFO "gpio-dev: Bound configfs instance" \
			       " to device %s\n", devices[i]->bankname);
		}
	}
	spin_unlock(&devices_lock);

	if (!dev) {
		printk(KERN_WARNING "gpio-dev: Can't find bank \"%s\"\n", name);
		/*
		 * Once I get home and can modify the configfs_mkdir code
		 * to allow more informative return types we can modify this
		 * to, eg, ERR_PTR(-ENODEV)
		 */
		return NULL;
	}

	/*
	 * REVISIT: Do we need to get this here?  The docco says we should drop
	 * a reference in drop_group() so I assume we need to actually get one
	 * at one stage
	 */
	config_item_get(&dev->group.cg_item);

	return &dev->group;
}

static void cfg_drop_group(struct config_group *group,
				   struct config_item *item)
{
	struct gpiodev *bank = to_gpiodev(to_config_group(item));

	pr_debug("gpio-dev: bank %s getting dropped\n",
	       bank->bankname);

	set_bank_io_enabled(bank, 0);
	set_bank_irq_enabled(bank, 0);

	config_item_put(item);
}

static struct configfs_attribute attr_banks = {
	.ca_owner = THIS_MODULE,
	.ca_name = "banks",
	.ca_mode = S_IRUGO,
};

static struct configfs_attribute *cfg_attrs[] = {
	&attr_banks,
	NULL,
};

static ssize_t cfg_attr_show(struct config_item *item,
					struct configfs_attribute *attr,
					char *page)
{
	int i;
	int count = 0;

	/* The only attribute which comes here is 'banks' */

	spin_lock(&devices_lock);
	for (i = 0; i < MAX_NR_DEVICES; i++) {
		if (devices[i])
			count += sprintf(page + count, "%s\n",
					 devices[i]->bankname);
	}
	spin_unlock(&devices_lock);

	return count;
}

static struct configfs_item_operations cfg_item_ops = {
	.show_attribute	= cfg_attr_show,
};

static struct configfs_group_operations cfg_group_ops = {
	.make_group	= cfg_make_group,
	.drop_item	= cfg_drop_group,
};

static struct config_item_type cfg_type = {
	.ct_item_ops	= &cfg_item_ops,
	.ct_group_ops	= &cfg_group_ops,
	.ct_attrs	= cfg_attrs,
	.ct_owner	= THIS_MODULE,
};

static struct configfs_subsystem cfg_subsys = {
	.su_group = {
		.cg_item = {
			.ci_namebuf = "gpio-dev",
			.ci_type = &cfg_type,
		},
	},
};


static struct configfs_attribute pin_attr_index = {
	.ca_owner = THIS_MODULE,
	.ca_name = "index",
	.ca_mode = S_IRUGO,
};

static struct configfs_attribute pin_attr_direction = {
	.ca_owner = THIS_MODULE,
	.ca_name = "direction",
	.ca_mode = S_IRUGO | S_IWUGO,
};

static struct configfs_attribute pin_attr_irq = {
	.ca_owner = THIS_MODULE,
	.ca_name = "irq",
	.ca_mode = S_IRUGO | S_IWUGO,
};

static struct configfs_attribute *pin_attrs[] = {
	&pin_attr_index,
	&pin_attr_direction,
	&pin_attr_irq,
	NULL,
};

static inline struct gpiodev_pin *to_gpiodev_pin(struct config_group *group)
{
	return group ? container_of(group, struct gpiodev_pin, group) : NULL;
}

static ssize_t pin_show(struct config_item *item,
				      struct configfs_attribute *attr,
				      char *page)
{
	struct gpiodev_pin *pin = to_gpiodev_pin(to_config_group(item));

	/* All attributes for a pin come here */

	if (attr == &pin_attr_index)
		return sprintf(page, "%d\n", pin->index);
	else if (attr == &pin_attr_direction)
		return sprintf(page, "%d\n", pin->direction);
	else if (attr == &pin_attr_irq)
		return sprintf(page, "%d\n", pin->irq);
	else {
		printk(KERN_ERR "gpio-dev: Unexpected attribute in %s\n",
		       __func__);
		return 0;
	}
}

static ssize_t pin_store(struct config_item *item,
				 struct configfs_attribute *attr,
				 const char *page, size_t count)
{
	struct gpiodev_pin *pin = to_gpiodev_pin(to_config_group(item));
	char *p = (char *)page;
	int val;
	int ret = 0;

	val = simple_strtoul(p, &p, 0);
	if (!p || (*p && (*p != '\n')))
		return -EINVAL;

	if (attr == &pin_attr_direction) {
		pin->direction = val;

		if (val)
			gpio_direction_output(pin->pin, pin->outval);
		else
			gpio_direction_input(pin->pin);


	} else if (attr == &pin_attr_irq) {

		if (!pin->irq && val) {
			ret = request_irq(gpio_to_irq(pin->pin), irq_interrupt,
					  0, "gpio-dev", pin);
			if (ret)
				return ret;
		} else if (pin->irq && !val) {
			free_irq(gpio_to_irq(pin->pin), pin);
		}

		pin->irq = val;

		/*
		 * The values written by the user directly correspond to
		 * the values behind the IRQF_TRIGGER_* tokens.  Can we
		 * rely on this or should we explicitly check and set each
		 * possible trigger type?
		 */
		if (val)
			ret = set_irq_type(gpio_to_irq(pin->pin), val);

		if (ret)
			return -EINVAL;

	} else {
		printk(KERN_ERR "gpio-dev: Unexpected attribute in %s\n",
		       __func__);
	}

	return count;
}

static struct configfs_item_operations pin_ops = {
	.show_attribute = pin_show,
	.store_attribute = pin_store,
};

static struct config_item_type cfg_pin_type = {
	.ct_owner	= THIS_MODULE,
	.ct_attrs	= pin_attrs,
	.ct_item_ops	= &pin_ops,
};

static int __init gpiodev_probe(struct platform_device *pdev)
{
	int i, ret;
	struct gpiodev *bank = NULL;
	struct device *dev = &pdev->dev;
	struct gpiodev_pdata *pdata = dev->platform_data;

	if (!pdata) {
		printk(KERN_ERR "gpio-dev: No configuration data available; "\
			"aborting probe.");
		return -EINVAL;
	}

	bank = kzalloc(sizeof(struct gpiodev), GFP_KERNEL);
	if (!bank)
		return -ENOMEM;

	spin_lock_init(&bank->lock);
	spin_lock_init(&bank->irq_lock);

	bank->bankname = pdata->bankname;
	bank->nr_pins = pdata->nr_pins;

	bank->pins = kmalloc(bank->nr_pins * sizeof(struct gpiodev_pin),
			     GFP_KERNEL);

	if (!bank->pins) {
		ret = -ENOMEM;
		goto err_pin_alloc;
	}

	bank->irq_buf = kfifo_alloc(IRQ_BUFFER_SIZE, GFP_KERNEL,
				    &bank->irq_lock);

	if (IS_ERR(bank->irq_buf)) {
		ret = PTR_ERR(bank->irq_buf);
		goto err_irq_buf_alloc;
	}

	memcpy(bank->pins, pdata->pins,
	       bank->nr_pins * sizeof(struct gpiodev_pin));

	pr_debug("gpio-dev: initing device group %s\n", bank->bankname);

	config_group_init_type_name(&bank->group, bank->bankname,
				    &cfg_bank_type);

	bank->group.default_groups = kzalloc(sizeof(struct config_group)
					     * bank->nr_pins, GFP_KERNEL);

	if (!bank->group.default_groups) {
		ret = -ENOMEM;
		goto err_group_alloc;
	}

	for (i = 0; i < bank->nr_pins; i++) {
		pr_debug("gpio-dev: initing pin %s on bank %s\n",
			bank->pins[i].label, bank->bankname);
		config_group_init_type_name(&bank->pins[i].group,
			bank->pins[i].label, &cfg_pin_type);
		bank->group.default_groups[i] = &bank->pins[i].group;
	}

	bank->io_enabled = 0;
	bank->irq_enabled = 0;

	platform_set_drvdata(pdev, bank);

	bank->id = -1;

	/* Find first empty slot */
	spin_lock(&devices_lock);
	for (i = 0; i < MAX_NR_DEVICES; i++) {
		if (devices[i] == NULL) {
			devices[i] = bank;
			bank->id = i;
			break;
		}
	}
	spin_unlock(&devices_lock);

	if (bank->id == -1) {
		printk(KERN_ERR "gpio-dev: More than MAX_NR_DEVICES probed;"\
				" no free slots found!");
		ret = -ENODEV;
		goto err_no_slot;
	}

	return 0;

err_no_slot:
	kfree(bank->group.default_groups);
err_group_alloc:
	kfifo_free(bank->irq_buf);
err_irq_buf_alloc:
	kfree(bank->pins);
err_pin_alloc:
	kfree(bank);

	return ret;
}

static int __exit gpiodev_remove(struct platform_device *pdev)
{
	struct gpiodev *bank = platform_get_drvdata(pdev);

	spin_lock(&devices_lock);
	devices[bank->id] = NULL;
	spin_unlock(&devices_lock);

	kfifo_free(bank->irq_buf);

	kfree(bank->pins);
	kfree(bank);

	return 0;
}

static struct platform_driver gpiodev_driver = {
	.driver		= {
		.name	= "gpio-dev",
		.owner	= THIS_MODULE,
	},
	.remove		= __exit_p(gpiodev_remove),
	.probe		= gpiodev_probe,
};

static int __init gpiodev_init(void)
{
	int ret;

	spin_lock_init(&devices_lock);

	dev_class = class_create(THIS_MODULE, "gpio-dev");
	if (IS_ERR(dev_class)) {
		ret = PTR_ERR(dev_class);
		goto err_class_create;
	}

	ret = alloc_chrdev_region(&base_devt, 0, MAX_NR_DEVICES * 2, "gpio-dev");
	if (ret < 0)
		goto err_alloc_chrdev;

	pr_debug("gpio-dev: Registering configfs subsystem %s\n",
		cfg_subsys.su_group.cg_item.ci_namebuf);
	config_group_init(&cfg_subsys.su_group);
	mutex_init(&cfg_subsys.su_mutex);
	ret = configfs_register_subsystem(&cfg_subsys);
	if (ret) {
		printk(KERN_ERR "Error %d while registering subsystem %s\n",
		       ret,
		       cfg_subsys.su_group.cg_item.ci_namebuf);
		goto err_subsys;
	}


	ret = platform_driver_register(&gpiodev_driver);
	if (ret)
		goto err_dev_register;

	return 0;

err_dev_register:
	configfs_unregister_subsystem(&cfg_subsys);
err_subsys:
	unregister_chrdev_region(base_devt, MAX_NR_DEVICES);
err_alloc_chrdev:
	class_destroy(dev_class);
err_class_create:
	printk(KERN_ALERT "gpio-dev: Failed to init gpio-dev interface\n");
	return ret;
}

static void __exit gpiodev_exit(void)
{
	platform_driver_unregister(&gpiodev_driver);

	configfs_unregister_subsystem(&cfg_subsys);

	unregister_chrdev_region(base_devt, MAX_NR_DEVICES * 2);

	class_destroy(dev_class);

	printk(KERN_INFO "gpio-dev: unloaded gpio-dev\n");
}

module_init(gpiodev_init);
module_exit(gpiodev_exit);
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ben Nizette <bn@niasdigital.com>");
MODULE_DESCRIPTION("Userspace interface to the gpio framework");

--=-q3hgE7LBuCy670maxJiC--
