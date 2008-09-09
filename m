Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYIIOZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYIIOZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYIIOZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:25:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYIIOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:25:46 -0400
Date: Tue, 9 Sep 2008 09:01:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080909130102.GB27837@infradead.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220933164-10160-2-git-send-email-jwilson@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +menuconfig INPUT_LIRC
> +	bool "Linux Infrared Remote Control IR receiver/transmitter drivers"
> +	default n

n is the default, no needed add a "default n" line for it.

Anyone configuring the kernel should know he's on Linux, so strike the
Linux away :)

> +if INPUT_LIRC
> +
> +config LIRC_DEV
> +	tristate "LIRC device loadable module support"
> +	default n
> +	help
> +	  LIRC device loadable module support, required for most LIRC drivers

Obviously this can be built in, so it should be named better.  Also I
don't think LIRC means anything to a user, so use Infrared Remote
Control support or something similar instead.

I don't quite understand why this needs a different option from
INPUT_LIRC.

> +#define __KERNEL_SYSCALLS__

No need for this in any semi-recent kernel.

> +#include <linux/unistd.h>
> +#include <linux/kthread.h>
> +
> +/* SysFS header */
> +#include <linux/device.h>

That comment is not quite correct, just remove it.

> +/*  helper function
> + *  initializes the irctl structure
> + */
> +static inline void init_irctl(struct irctl *ir)
> +{
> +	memset(&ir->p, 0, sizeof(struct lirc_plugin));
> +	mutex_init(&ir->buffer_lock);
> +	ir->p.minor = NOPLUG;
> +
> +	ir->task = NULL;
> +	ir->jiffies_to_wait = 0;
> +
> +	ir->open = 0;
> +	ir->attached = 0;
> +}

Please don't mark funtion inline unless there's a very good reason for
it.

> +static void cleanup(struct irctl *ir)
> +{
> +	dprintk(LOGHEAD "cleaning up\n", ir->p.name, ir->p.minor);
> +
> +	device_destroy(lirc_class, MKDEV(IRCTL_DEV_MAJOR, ir->p.minor));
> +
> +	if (ir->buf != ir->p.rbuf) {
> +		lirc_buffer_free(ir->buf);
> +		kfree(ir->buf);
> +	}
> +	ir->buf = NULL;
> +
> +	init_irctl(ir);
> +}

What's the init doing in a cleanup routine?  Oh, you initialize it again
becaus of the static array.  I think the right approach is to
dynamically allocate struct irctl.

> +static inline int add_to_buf(struct irctl *ir)

The inline thing also applies here and in various other placez.

> +{
> +	if (lirc_buffer_full(ir->buf)) {
> +		dprintk(LOGHEAD "buffer overflow\n",
> +			ir->p.name, ir->p.minor);
> +		return -EOVERFLOW;
> +	}
> +
> +	if (ir->p.add_to_buf) {
> +		int res = -ENODATA;
> +		int got_data = 0;
> +
> +		/* service the device as long as it is returning
> +		 * data and we have space
> +		 */
> +		while (!lirc_buffer_full(ir->buf)) {
> +			res = ir->p.add_to_buf(ir->p.data, ir->buf);
> +			if (res == SUCCESS)
> +				got_data++;
> +			else
> +				break;
> +		}
> +
> +		if (res == -ENODEV)
> +			kthread_stop(ir->task);
> +
> +		return got_data ? SUCCESS : res;
> +	}
> +
> +	return SUCCESS;

I guess success is a #define for 0?  Just user 0 directly.  Also the
kthread_stop here looks odd.  The normal way to use kthreads is to
start them when bringing up an interface of some sorts, and call
kthread_stop when the interface is brought down.  Doing it in a routine
like this screams "unclear lifetime rules".

> +	do {
> +		if (ir->open) {
> +			if (ir->jiffies_to_wait) {
> +				set_current_state(TASK_INTERRUPTIBLE);
> +				schedule_timeout(ir->jiffies_to_wait);
> +			} else {
> +				interruptible_sleep_on(
> +					ir->p.get_queue(ir->p.data));
> +			}

No sleep on, please.  But this one should be trivial to fix anyway, by
just changing this to a

	set_current_state(TASK_INTERRUPTIBLE);
	schedule();

and using wake_up_process in the wakeup path.

> +		} else {
> +			/* if device not opened so we can sleep half a second */
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			schedule_timeout(HZ/2);
> +		}

Yikes.  This should use some form of more fine-grained wakeus.

> +int lirc_register_plugin(struct lirc_plugin *p)
> +{

Please add a kerneldoc comments for exported functions like this,
instead of the comments in the header.

> +	struct irctl *ir;
> +	int minor;
> +	int bytes_in_key;
> +	int err;
> +	DECLARE_COMPLETION(tn);
> +
> +	if (!p) {
> +		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
> +		       "plugin pointer must be not NULL!\n");
> +		err = -EBADRQC;
> +		goto out;
> +	}

No need for this, a null pointer derference should be a clear enough
warning for the writer of the broken pluging..

> +int lirc_unregister_plugin(int minor)

Why doesn't this one take a struct lirc_plugin pointer?

> +{
> +	struct irctl *ir;
> +	DECLARE_COMPLETION(tn);
> +	DECLARE_COMPLETION(tn2);

both completion seems unused.

> +	/* end up polling thread */
> +	if (ir->task) {
> +		wake_up_process(ir->task);
> +		kthread_stop(ir->task);
> +	}

kthread_stop already wakes the thread up. 

> +/*
> + * Recent kernels should handle this autmatically by increasing/decreasing
> + * use count when a dependant module is loaded/unloaded.
> + */
> +
> +	return SUCCESS;

The comment above looks superflous.

> +static int irctl_open(struct inode *inode, struct file *file)
> +{
> +	struct irctl *ir;
> +	int retval;
> +
> +	if (MINOR(inode->i_rdev) >= MAX_IRCTL_DEVICES) {

iminor.

> +	/* if the plugin has an open function use it instead */
> +	if (ir->p.fops && ir->p.fops->open)
> +		return ir->p.fops->open(inode, file);

in which case this 'plugin' should just install it's own fops.  Thanks
to cdev_add we can install fops at minor number granularity.

> +static unsigned int irctl_poll(struct file *file, poll_table *wait)
> +{
> +	struct irctl *ir = &irctls[MINOR(file->f_dentry->d_inode->i_rdev)];
> +	unsigned int ret;
> +
> +	dprintk(LOGHEAD "poll called\n", ir->p.name, ir->p.minor);
> +
> +	/* if the plugin has a poll function use it instead */
> +	if (ir->p.fops && ir->p.fops->poll)
> +		return ir->p.fops->poll(file, wait);
> +
> +	mutex_lock(&ir->buffer_lock);

->poll ust not sleep.

> +/*
> + *
> + */

???

> +
> +void *lirc_get_pdata(struct file *file)
> +{
> +	void *data = NULL;
> +
> +	if (file && file->f_dentry && file->f_dentry->d_inode &&
> +	    file->f_dentry->d_inode->i_rdev) {
> +		struct irctl *ir;
> +		ir = &irctls[MINOR(file->f_dentry->d_inode->i_rdev)];
> +		data = ir->p.data;
> +	}
> +
> +	return data;
> +}
> +EXPORT_SYMBOL(lirc_get_pdata);

Yikes. All these should never really be null.  But once you have a
struct file you should just use file->private_data.


> +/* #define LIRC_BUFF_POWER_OF_2 */
> +#ifdef LIRC_BUFF_POWER_OF_2
> +#define mod(n, div) ((n) & ((div) - 1))
> +#else
> +#define mod(n, div) ((n) % (div))
> +#endif

??

> +static inline void _lirc_buffer_clear(struct lirc_buffer *buf)
> +{
> +	buf->head = 0;
> +	buf->tail = 0;
> +	buf->fill = 0;
> +}
> +static inline int lirc_buffer_init(struct lirc_buffer *buf,
> +				    unsigned int chunk_size,
> +				    unsigned int size)
> +{
> +	/* Adjusting size to the next power of 2 would allow for
> +	 * inconditional LIRC_BUFF_POWER_OF_2 optimization */
> +	init_waitqueue_head(&buf->wait_poll);
> +	spin_lock_init(&buf->lock);
> +	_lirc_buffer_clear(buf);
> +	buf->chunk_size = chunk_size;
> +	buf->size = size;
> +	buf->data = kmalloc(size*chunk_size, GFP_KERNEL);
> +	if (buf->data == NULL)
> +		return -1;
> +	memset(buf->data, 0, size*chunk_size);
> +	return 0;
> +}
> +static inline void lirc_buffer_free(struct lirc_buffer *buf)
> +{
> +	kfree(buf->data);
> +	buf->data = NULL;
> +	buf->head = 0;
> +	buf->tail = 0;
> +	buf->fill = 0;
> +	buf->chunk_size = 0;
> +	buf->size = 0;
> +}

Please move these out of line.  And please document all the functions.
Or switch to a kfifo or the existing tty buffering helpers.

> +static inline void lirc_buffer_lock(struct lirc_buffer *buf,
> +				    unsigned long *flags)
> +{
> +	spin_lock_irqsave(&buf->lock, *flags);
> +}
> +static inline void lirc_buffer_unlock(struct lirc_buffer *buf,
> +				      unsigned long *flags)
> +{
> +	spin_unlock_irqrestore(&buf->lock, *flags);
> +}

Please don't do you own spinlock wrappers.

