Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYILARM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYILARM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 20:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYILAQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 20:16:44 -0400
Received: from scing.com ([217.160.110.58]:45447 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYILAQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 20:16:43 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Fri, 12 Sep 2008 02:16:30 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>, Janne Grunau <j@jannau.net>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909130102.GB27837@infradead.org>
In-Reply-To: <20080909130102.GB27837@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200809120216.31153.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 15:01:02 Christoph Hellwig wrote:
> > +menuconfig INPUT_LIRC
> > +	bool "Linux Infrared Remote Control IR receiver/transmitter
> > drivers" +	default n
>
> n is the default, no needed add a "default n" line for it.

removed

> > +if INPUT_LIRC
> > +
> > +config LIRC_DEV
> > +	tristate "LIRC device loadable module support"
> > +	default n
> > +	help
> > +	  LIRC device loadable module support, required for most LIRC
> > drivers
>
> Obviously this can be built in, so it should be named better.  Also I
> don't think LIRC means anything to a user, so use Infrared Remote
> Control support or something similar instead.

I'm pretty sure LIRC will be recognized by its current users, it is 
probably enough if it is in the help text though.

> > +#define __KERNEL_SYSCALLS__
>
> No need for this in any semi-recent kernel.

already gone

> > +#include <linux/unistd.h>
> > +#include <linux/kthread.h>
> > +
> > +/* SysFS header */
> > +#include <linux/device.h>
>
> That comment is not quite correct, just remove it.

removed

> > +/*  helper function
> > + *  initializes the irctl structure
> > + */
> > +static inline void init_irctl(struct irctl *ir)
> > +{
> > +	memset(&ir->p, 0, sizeof(struct lirc_plugin));
> > +	mutex_init(&ir->buffer_lock);
> > +	ir->p.minor = NOPLUG;
> > +
> > +	ir->task = NULL;
> > +	ir->jiffies_to_wait = 0;
> > +
> > +	ir->open = 0;
> > +	ir->attached = 0;
> > +}
>
> Please don't mark funtion inline unless there's a very good reason
> for it.

all inlines (65 in drivers/inpu/lirc) removed

> > +static void cleanup(struct irctl *ir)
> > +{
> > +	dprintk(LOGHEAD "cleaning up\n", ir->p.name, ir->p.minor);
> > +
> > +	device_destroy(lirc_class, MKDEV(IRCTL_DEV_MAJOR, ir->p.minor));
> > +
> > +	if (ir->buf != ir->p.rbuf) {
> > +		lirc_buffer_free(ir->buf);
> > +		kfree(ir->buf);
> > +	}
> > +	ir->buf = NULL;
> > +
> > +	init_irctl(ir);
> > +}
>
> What's the init doing in a cleanup routine?  Oh, you initialize it
> again becaus of the static array.  I think the right approach is to
> dynamically allocate struct irctl.

agree, it's done dynamically now

> > +{
> > +	if (lirc_buffer_full(ir->buf)) {
> > +		dprintk(LOGHEAD "buffer overflow\n",
> > +			ir->p.name, ir->p.minor);
> > +		return -EOVERFLOW;
> > +	}
> > +
> > +	if (ir->p.add_to_buf) {
> > +		int res = -ENODATA;
> > +		int got_data = 0;
> > +
> > +		/* service the device as long as it is returning
> > +		 * data and we have space
> > +		 */
> > +		while (!lirc_buffer_full(ir->buf)) {
> > +			res = ir->p.add_to_buf(ir->p.data, ir->buf);
> > +			if (res == SUCCESS)
> > +				got_data++;
> > +			else
> > +				break;
> > +		}
> > +
> > +		if (res == -ENODEV)
> > +			kthread_stop(ir->task);
> > +
> > +		return got_data ? SUCCESS : res;
> > +	}
> > +
> > +	return SUCCESS;
>
> I guess success is a #define for 0?  Just user 0 directly.

yes, already removed. also removed custom TRUE/FALSE defines

> Also the 
> kthread_stop here looks odd.  The normal way to use kthreads is to
> start them when bringing up an interface of some sorts, and call
> kthread_stop when the interface is brought down.  Doing it in a
> routine like this screams "unclear lifetime rules".
>
> > +		} else {
> > +			/* if device not opened so we can sleep half a second */
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			schedule_timeout(HZ/2);
> > +		}
>
> Yikes.  This should use some form of more fine-grained wakeus.

added a waitqueue and wait_event

> > +	struct irctl *ir;
> > +	int minor;
> > +	int bytes_in_key;
> > +	int err;
> > +	DECLARE_COMPLETION(tn);
> > +
> > +	if (!p) {
> > +		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
> > +		       "plugin pointer must be not NULL!\n");
> > +		err = -EBADRQC;
> > +		goto out;
> > +	}
>
> No need for this, a null pointer derference should be a clear enough
> warning for the writer of the broken pluging..

ok

> > +int lirc_unregister_plugin(int minor)
>
> Why doesn't this one take a struct lirc_plugin pointer?

I don't know, It doesn't really help though since the struct lirc_plugin 
is copied by value to irctl.p in lirc_register_plugin.

> > +{
> > +	struct irctl *ir;
> > +	DECLARE_COMPLETION(tn);
> > +	DECLARE_COMPLETION(tn2);
>
> both completion seems unused.

the one in lirc_register_plugin too, removed

> > +	/* end up polling thread */
> > +	if (ir->task) {
> > +		wake_up_process(ir->task);
> > +		kthread_stop(ir->task);
> > +	}
>
> kthread_stop already wakes the thread up.

removed

> > +/*
> > + * Recent kernels should handle this autmatically by
> > increasing/decreasing + * use count when a dependant module is
> > loaded/unloaded.
> > + */
> > +
> > +	return SUCCESS;
>
> The comment above looks superflous.

already removed.

> > +static int irctl_open(struct inode *inode, struct file *file)
> > +{
> > +	struct irctl *ir;
> > +	int retval;
> > +
> > +	if (MINOR(inode->i_rdev) >= MAX_IRCTL_DEVICES) {
>
> iminor.

replaced in all occurances

> > +	/* if the plugin has an open function use it instead */
> > +	if (ir->p.fops && ir->p.fops->open)
> > +		return ir->p.fops->open(inode, file);
>
> in which case this 'plugin' should just install it's own fops. 
> Thanks to cdev_add we can install fops at minor number granularity.

done

> > +static unsigned int irctl_poll(struct file *file, poll_table
> > *wait) +{
> > +	struct irctl *ir =
> > &irctls[MINOR(file->f_dentry->d_inode->i_rdev)]; +	unsigned int
> > ret;
> > +
> > +	dprintk(LOGHEAD "poll called\n", ir->p.name, ir->p.minor);
> > +
> > +	/* if the plugin has a poll function use it instead */
> > +	if (ir->p.fops && ir->p.fops->poll)
> > +		return ir->p.fops->poll(file, wait);
> > +
> > +	mutex_lock(&ir->buffer_lock);
>
> ->poll ust not sleep.

I don't see why poll has to hold the lock, removed

> > +/* #define LIRC_BUFF_POWER_OF_2 */
> > +#ifdef LIRC_BUFF_POWER_OF_2
> > +#define mod(n, div) ((n) & ((div) - 1))
> > +#else
> > +#define mod(n, div) ((n) % (div))
> > +#endif

removed

> > +static inline void _lirc_buffer_clear(struct lirc_buffer *buf)
> > +{
> > +	buf->head = 0;
> > +	buf->tail = 0;
> > +	buf->fill = 0;
> > +}
> > +static inline int lirc_buffer_init(struct lirc_buffer *buf,
> > +				    unsigned int chunk_size,
> > +				    unsigned int size)
> > +{
> > +	/* Adjusting size to the next power of 2 would allow for
> > +	 * inconditional LIRC_BUFF_POWER_OF_2 optimization */
> > +	init_waitqueue_head(&buf->wait_poll);
> > +	spin_lock_init(&buf->lock);
> > +	_lirc_buffer_clear(buf);
> > +	buf->chunk_size = chunk_size;
> > +	buf->size = size;
> > +	buf->data = kmalloc(size*chunk_size, GFP_KERNEL);
> > +	if (buf->data == NULL)
> > +		return -1;
> > +	memset(buf->data, 0, size*chunk_size);
> > +	return 0;
> > +}
> > +static inline void lirc_buffer_free(struct lirc_buffer *buf)
> > +{
> > +	kfree(buf->data);
> > +	buf->data = NULL;
> > +	buf->head = 0;
> > +	buf->tail = 0;
> > +	buf->fill = 0;
> > +	buf->chunk_size = 0;
> > +	buf->size = 0;
> > +}
>
> Please move these out of line.  And please document all the
> functions. Or switch to a kfifo or the existing tty buffering
> helpers.

I'll look at it.

> > +static inline void lirc_buffer_lock(struct lirc_buffer *buf,
> > +				    unsigned long *flags)
> > +{
> > +	spin_lock_irqsave(&buf->lock, *flags);
> > +}
> > +static inline void lirc_buffer_unlock(struct lirc_buffer *buf,
> > +				      unsigned long *flags)
> > +{
> > +	spin_unlock_irqrestore(&buf->lock, *flags);
> > +}
>
> Please don't do you own spinlock wrappers.

removed

Thanks for the review.

Janne
