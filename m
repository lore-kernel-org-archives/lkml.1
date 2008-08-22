Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYHVSTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYHVSTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHVSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:19:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbYHVSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:19:30 -0400
Date: Fri, 22 Aug 2008 11:19:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Niels de Vos" <niels.devos@wincor-nixdorf.com>
Cc: linux-input@vger.kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] POSKeyboard driver for exclusive keyboard access
Message-Id: <20080822111924.d0713931.akpm@linux-foundation.org>
In-Reply-To: <1b51b6f80808220917t20fdb09el78b117c5ba5b7f7c@mail.gmail.com>
References: <1b51b6f80808220917t20fdb09el78b117c5ba5b7f7c@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 18:17:28 +0200
"Niels de Vos" <niels.devos@wincor-nixdorf.com> wrote:

> This new driver makes it possible for middleware like JavaPOS to use
> a POSKeyboard (connected to PS/2) with exclusive access. This is
> required by the UnifiedPOS Specification which is available from
> http://www.nrf-arts.org/UnifiedPOS. Any middleware using this driver
> should implement the full exception-handling in user-space. Therefor
> it is possible to use specific POS-extensions of POSKeyboards, without
> abusing other keyboard-drivers.
> 
> Opening /dev/poskeyboard will route all scancodes to this device. The
> scancodes will not be processes by the input-subsystem anymore. Reading
> /dev/poskeyboard results in receiving the scancodes as raw data for
> further processing by the reader. Sending commands to the hardware can
> be done by writing to /dev/poskeyboard.
> 
> If the driver is loaded and /dev/poskeyboard is not opened, all
> scancodes are given to the input-subsystem. This allows 'normal' use of
> the keyboard.
> 
> Making the driver active involves some commands like the following:
>    echo -n serio1 > /sys/bus/serio/drivers/atkbd/unbind
>    echo -n serio1 > /sys/bus/serio/drivers/poskbd/bind
> 
> Open questions:
> - How to achieve the same with USB-HID complaint keyboards?
> - Does serio_unregister_port() a kfree() on the port?
> 
> CC: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
> 
> ---
>  drivers/input/keyboard/Kconfig  |   12 +
>  drivers/input/keyboard/Makefile |    1 +
>  drivers/input/keyboard/poskbd.c |  445 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 458 insertions(+), 0 deletions(-)
> ---
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index efd70a9..0ed311f 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -323,4 +323,16 @@ config KEYBOARD_SH_KEYSC
> 
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called sh_keysc.
> +
> +config KEYBOARD_POSKBD
> +	tristate "UnifiedPOS complaint POS Keyboard access"
> +	default n
> +	select SERIO
> +	help
> +	  Say Y here if you need a driver which allows exclusive-use
> +	  to keyboard devices. This is required by the UnifiedPOS
> +	  Specification for the POS Keyboard device.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called poskbd.
>  endif
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index 0edc8f2..aa4ad17 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -27,3 +27,4 @@ obj-$(CONFIG_KEYBOARD_HP7XX)		+= jornada720_kbd.o
>  obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
>  obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
>  obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
> +obj-$(CONFIG_KEYBOARD_POSKBD)		+= poskbd.o
> diff --git a/drivers/input/keyboard/poskbd.c b/drivers/input/keyboard/poskbd.c
> new file mode 100644
> index 0000000..7d7e1d5
> --- /dev/null
> +++ b/drivers/input/keyboard/poskbd.c
> @@ -0,0 +1,445 @@
> +/**
> + * Serio driver for exclusive-use keyboard access
> + *
> + * The UnifiedPOS Specification requires the POS keyboard to be an
> + * exclusive-use device. This means that the device is not allowed to
> + * send and/or receive events from processes other than the process
> + * which 'claimed' the device. This driver uses the serio-subsystem
> + * to get access to connected keyboard. After opening the associated
> + * device-node, the scancodes will only be available to the reader of
> + * the device-node. Therefore the reader must understand the protocol
> + * of the keyboard and implement the handling of exceptions and
> + * extensions by itself. Sending commands to the hardware is possible
> + * by writing the required bytes to the open file-descriptor.
> + *
> + * UnifiedPOS Sepecification: http://www.nrf-arts.org/UnifiedPOS
> + *
> + * This driver can be used by unbinding i.e. atkbd and binding poskbd:
> + * # echo -n serio1 > /sys/bus/serio/drivers/atkbd/unbind
> + * # echo -n serio1 > /sys/bus/serio/drivers/poskbd/bind
> + *
> + * Copyright (C) 2008 Wincor Nixdorf International
> + *
> + * Idea by and with help from SUSE Labs, Jiri Kosina <jkosina@suse.cz>.
> + *
> + * Author:
> + *   Niels de Vos <niels.devos@wincor-nixdorf.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +
> +#include <linux/serio.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqreturn.h>
> +
> +#include <linux/types.h>
> +#include <linux/wait.h>
> +#include <linux/slab.h>
> +#include <asm/uaccess.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +
> +/* driver info */
> +#define DRIVER_NAME	"poskbd"
> +#define DRIVER_DESC	"POSKeyboard driver for exclusive keyboard access"
> +#define DRIVER_AUTHOR	"Niels de Vos, Wincor Nixdorf International"
> +#define POSKBD_DEV	"poskeyboard"
> +
> +
> +/* enable debugging over a module-parameter */
> +#define dbg(fmt, args...) \
> +	if (debug >= 2) { printk(KERN_DEBUG "%s: " fmt, __func__, ##args); }
> +#define verbose(fmt, args...) \
> +	if (debug) { printk(KERN_INFO "%s: " fmt, __func__, ##args); }
> +#define warning(fmt, args...) \
> +	printk(KERN_WARNING "%s(%s): " fmt, DRIVER_NAME, __func__, ##args);

I think the new dynamic-debugging infrastructure is in Greg's tree (and
hence linux-next) now.  If not, it soon will be.

> +
> +/* for struct serio_driver*/
> +static int poskbd_connect(struct serio *serio, struct serio_driver *drv);
> +static void poskbd_disconnect(struct serio *serio);
> +static irqreturn_t poskbd_interrupt(struct serio *serio,
> +	unsigned char scancode, unsigned int flags);
> +
> +
> +/* for struct serio */
> +static int poskbd_port_open(struct serio *port);
> +static void poskbd_port_close(struct serio *port);
> +
> +
> +/* for struct file_operations */
> +static int poskbd_fs_open(struct inode *, struct file *);
> +static int poskbd_fs_release(struct inode *, struct file *);
> +static ssize_t poskbd_fs_read(struct file *, char __user *, size_t, loff_t *);
> +static ssize_t poskbd_fs_write(struct file *, const char __user *,
> size_t, loff_t *);
> +
> +
> +static struct serio_device_id poskbd_ids[] = {
> +	{
> +		.type   = SERIO_8042_XL,
> +		.proto  = SERIO_ANY,
> +		.id     = SERIO_ANY,
> +		.extra  = SERIO_ANY,
> +	},
> +	{ 0 }
> +};
> +
> +
> +static struct serio_driver poskbd_drv = {
> +	.driver         = {
> +		.name   = DRIVER_NAME,
> +	},
> +	.description    = DRIVER_DESC,
> +	.id_table       = poskbd_ids,
> +	.interrupt      = poskbd_interrupt,
> +	.connect        = poskbd_connect,
> +	.disconnect     = poskbd_disconnect,
> +};
> +
> +static struct file_operations poskbd_fs = {
> +	.owner		= THIS_MODULE,
> +	.read		= poskbd_fs_read,
> +	.write		= poskbd_fs_write,
> +	.open		= poskbd_fs_open,
> +	.release	= poskbd_fs_release,
> +	.llseek		= no_llseek,
> +};
> +
> +
> +static struct miscdevice poskbd_md = {
> +        .minor	= MISC_DYNAMIC_MINOR,
> +        .name	= POSKBD_DEV,
> +        .fops	= &poskbd_fs,
> +};
> +
> +
> +/**
> + * struct scancode_buf: list of buffered scancodes
> + *
> + * @list: for a dynamical list
> + * @scancode: the scancode
> + */
> +struct scancode_buf {
> +	struct list_head list;
> +	unsigned char scancode;
> +};
> +
> +
> +/**
> + * struct poskbd_status: driver internal status
> + *
> + * @hw_port: the real port to write the commands to (struct serio from atkbd)
> + * @kbd_port: the port for the POSKeyboard
> + * @wq: blocked on while waiting for more data
> + * @data: the list of buffered scancodes
> + * @opened: counter for of opened device-nodes
> + */
> +static struct poskbd_status {
> +	struct serio *hw_port;
> +	struct serio *kbd_port;
> +	wait_queue_head_t wq;
> +	struct scancode_buf *data;
> +	short opened;
> +} *poskbd_status;
> +
> +
> +/* parameters for the driver */
> +static int debug = 0;

unneeded initialisation.

Please run scripts/checkpatch.pl across the diff.  It finds rather a
lot of things.

> +static int poskbd_port_open(struct serio *port)
> +{
> +	dbg("nothing to do for %s\n", port->name);
> +	return 0;
> +}
> +
> +static void poskbd_port_close(struct serio *port)
> +{
> +	dbg("nothing to do for %s\n", port->name);
> +}
> +
> +
> +/**
> + * called on binding a serio* to the module
> + *    echo -n serio1 > /sys/bus/serio/drivers/wn_kbd/bind
> + */
> +static int poskbd_connect(struct serio *port, struct serio_driver *drv)
> +{
> +	int ret = 0;
> +	if (poskbd_status->hw_port) {

Please prefer to leave a blank line between end-of-local and start-of-code.

> +		dbg("a hw_port has already been opened...\n");
> +		return ret;
> +	}
> +
> +	ret = serio_open(port, drv);
> +
> +	if (!ret) {
> +		poskbd_status->hw_port = port;
> +	}

unneeded braces

> +	dbg("serio_open() on %s was %s\n", port->name, (ret ? "failed" :
> "was successful"));
> +	return ret;
> +}
> +
> +
> +/**
> + * called on binding a serio* to the module
> + *    echo -n serio1 > /sys/bus/serio/drivers/wn_kbd/unbind
> + */
> +static void poskbd_disconnect(struct serio *port)
> +{
> +	dbg("going to do serio_close(%s)\n", port->name);
> +	serio_close(port);
> +	if (port == poskbd_status->hw_port)
> +		poskbd_status->hw_port = NULL;
> +}
> +
> +
> +/**
> + * called on every keypress, keylock-rotate and card-swipe
> + */

The /** pattern is specificially used to flag a kerneldoc-style
comment.  This isn't a kerneldoc comment, so please just use /*.  (many
instances)

> +static irqreturn_t poskbd_interrupt(struct serio *port,
> +	unsigned char scancode, unsigned int flags)
> +{
> +	struct scancode_buf *data;
> +
> +	if (poskbd_status->opened) {
> +		/* add new scancode to the buffer */
> +		data = kzalloc(sizeof(struct scancode_buf), GFP_KERNEL);

Is this really an interrupt handler?  Looks like it.  If so, use of
GFP_KERNEL uis a big bug and suggests that the code wasn't tested with
suitable kerenl debugging options enabled (see
Documentation/SubmitChecklist).

> +		data->scancode = scancode;

kzalloc() can fail, and this will crash the machine.

> +		list_add_tail(&(data->list), &poskbd_status->data->list);

locking needed for that list?

> +		dbg("added scancode (0x%.2x) to the buffer\n", scancode);
> +
> +		/* wake_up() the read() */
> +		wake_up(&(poskbd_status->wq));
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (!poskbd_status->kbd_port) {
> +		dbg("BUG: no port has been assigned to poskbd_status!\n");
> +		return IRQ_NONE;
> +	}
> +	
> +	dbg("passing scancode (0x%.2x) to serio_interrupt()\n", scancode);
> +	return serio_interrupt(poskbd_status->kbd_port, scancode, flags);
> +}
> +
> +
> +/**
> + * poskbd_fs_open: exclusive open on PS/2 devices
> + *
> + * Only one open allowed, make it really exclusive.
> + */
> +static int poskbd_fs_open(struct inode *inode, struct file *file)
> +{
> +	int ret = 0;
> +
> +	if (poskbd_status->opened) {
> +		verbose("device already opened\n");
> +		ret = -EBUSY;
> +	} else {
> +		poskbd_status->opened = 1;
> +	}
> +	return ret;
> +}
> +
> +
> +/**
> + * poskbd_fs_release: close()
> + */
> +static int poskbd_fs_release(struct inode *inode, struct file *file)
> +{
> +	poskbd_status->opened = 0;
> +	return 0;
> +}
> +
> +
> +/**
> + * poskbd_fs_read: block until data arrived
> + */
> +static ssize_t poskbd_fs_read(struct file *file, char __user *data,
> size_t size, loff_t *pos)

Indent the continuation line a bit.

> +{
> +	struct scancode_buf *buf;
> +	struct list_head *i, *q;
> +	size_t cnt = 0;
> +	int ret;
> +
> +	/* wait until data is available or read() is aborted */
> +	verbose("userspace wants %d/%d of data\n", (int) (size - cnt), (int) size);
> +	if (list_empty(&poskbd_status->data->list)) {
> +		ret = wait_event_interruptible(poskbd_status->wq,
> !list_empty(&poskbd_status->data->list));

ditto

> +		if (ret) {
> +			verbose("read() interrupted: %d\n", ret);
> +			return ret;
> +		}
> +		dbg("I'm awake!\n");
> +	}
> +
> +	/* loop through all buffered scancodes and send them to userspace */
> +	do {
> +		list_for_each_safe(i, q, &poskbd_status->data->list) {
> +			buf = list_entry(i, struct scancode_buf, list);

list_for_each_entry_safe()

> +			dbg("sending scancode (0x%.2x) to userspace\n", buf->scancode);
> +			if (copy_to_user((data + cnt), &(buf->scancode), sizeof(unsigned
> char)) != 0) {
> +				warning("could not copy data to userspace\n");
> +				return -EACCES;

-EFAULT

> +			}
> +			cnt++;
> +
> +			/* remove the scancode from the buffer */
> +			list_del(i);

locking?

> +			kfree(buf);
> +		}
> +	} while (!list_empty(&poskbd_status->data->list) || cnt == size);
> +
> +	verbose("sent %d bytes to userspace\n", (int) cnt);
> +	return cnt;
> +}
> +
> +
> +/**
> + * poskbd_fs_write: send commands to the keyboard
> + */
> +static ssize_t poskbd_fs_write(struct file *file, const char __user
> *data, size_t len, loff_t *pos)

indent

> +{
> +	size_t i;
> +	unsigned char c;
> +	int ret = 0;
> +
> +	if (!poskbd_status->hw_port) {
> +		warning("no device connected\n");
> +		return -ENODEV;

can this happen?

> +	}
> +
> +	for (i = 0; i < len; i++) {
> +		if (copy_from_user(&c, data + i, 1)) {
> +			warning("could not get data from userspace\n");
> +			return -EACCES;

-EFAULT

> +		}
> +		
> +		dbg("going to serio_write(%s, 0x%.2x)\n", poskbd_status->hw_port->name, c);
> +		ret = serio_write(poskbd_status->hw_port, c);
> +		if (ret < 0)
> +			return ret;

Normally a write() will return the number of bytes written even if it
encountered an error.  It will only return -EFOO if the error occurred
and zero bytes were written.

This policy is perhaps not appropriate in a driver however.

> +	}
> +	return i;
> +}
> +
> +
> +/**
> + * called on module loading
> + */
> +static int __init poskbd_init(void)
> +{
> +	int err = 0;
> +
> +	poskbd_status = kzalloc(sizeof(struct poskbd_status), GFP_KERNEL);
> +	if (!poskbd_status) {
> +		warning("could not allocate enough memory for driver status\n");
> +		return -ENOMEM;
> +	}
> +
> +	poskbd_status->data = kzalloc(sizeof(struct scancode_buf), GFP_KERNEL);
> +	if (!poskbd_status->data) {
> +		warning("could not allocate enough memory for scancode buffer\n");
> +		err = -ENOMEM;
> +		goto free1_exit;
> +	}
> +	
> +	INIT_LIST_HEAD(&(poskbd_status->data->list));
> +	init_waitqueue_head(&(poskbd_status->wq));
> +
> +	dbg("going to register_port()\n");
> +	poskbd_status->kbd_port = kzalloc(sizeof(struct serio), GFP_KERNEL);
> +	if (!poskbd_status->kbd_port) {
> +		warning("could not allocate enough memory for port\n");
> +		err = -ENOMEM;
> +		goto free2_exit;
> +	}
> +	/* fill the struct serio with valid data */
> +	poskbd_status->kbd_port->id.type 	= SERIO_8042_XL;
> +	poskbd_status->kbd_port->open		= poskbd_port_open;
> +	poskbd_status->kbd_port->close		= poskbd_port_close;
> +	snprintf(poskbd_status->kbd_port->name,
> sizeof(poskbd_status->kbd_port->name), "POSKeyboard");
> +	snprintf(poskbd_status->kbd_port->phys,
> sizeof(poskbd_status->kbd_port->name), "POSKeyboard");
> +
> +	serio_register_port(poskbd_status->kbd_port);
> +
> +	dbg("going to register_driver()\n");
> +	err = serio_register_driver(&poskbd_drv);
> +	if (err) {
> +		warning("could not register driver (%d)\n", err);
> +		goto free3_exit;
> +	}
> +
> +	dbg("registering character device\n");
> +	err = misc_register(&poskbd_md);
> +	if (err) {
> +		warning("could not register device (%d)\n", err);
> +		goto free4_exit;
> +	}
> +	return 0;
> +
> +free4_exit:
> +	serio_unregister_driver(&poskbd_drv);
> +free3_exit:
> +	serio_unregister_port(poskbd_status->kbd_port);
> +	kfree(poskbd_status->kbd_port);
> +free2_exit:
> +	kfree(poskbd_status->data);
> +free1_exit:
> +	kfree(poskbd_status);
> +	return err;
> +}
> +
> +
> +/**
> + * called on module unloading
> + */
> +static void __exit poskbd_exit(void)
> +{
> +	int err = 0;
> +	struct scancode_buf *data;
> +	struct list_head *pos, *q;
> +	
> +	dbg("unregistering character device\n");
> +	err = misc_deregister(&poskbd_md);
> +
> +	dbg("going to unregister_port %s\n", poskbd_status->kbd_port->name);
> +	serio_unregister_port(poskbd_status->kbd_port);
> +#if 0 /* TODO: does serio_unregister_port() a kfree() on the port? */
> +	kfree(poskbd_status->kbd_port);
> +#endif
> +
> +	dbg("going to unregister_driver()\n");
> +	serio_unregister_driver(&poskbd_drv);
> +
> +	if (!list_empty(&poskbd_status->data->list)) {
> +		dbg("freeing buffer:\n");
> +		list_for_each_safe(pos, q, &poskbd_status->data->list) {
> +			data = list_entry(pos, struct scancode_buf, list);
> +			list_del(pos);
> +			kfree(data);
> +		}
> +	}
> +	kfree(poskbd_status->data);
> +	kfree(poskbd_status);
> +}
> +
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_LICENSE("GPL");
> +MODULE_DEVICE_TABLE(serio, poskbd_ids);
> +MODULE_PARM_DESC(debug, "show additional debug information (default: 0)");
> +
> +module_param(debug, int, 0);
> +
> +module_init(poskbd_init);
> +module_exit(poskbd_exit);

