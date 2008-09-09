Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYIIPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYIIPdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYIIPdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:33:12 -0400
Received: from vena.lwn.net ([206.168.112.25]:45511 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbYIIPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:33:11 -0400
Date: Tue, 9 Sep 2008 09:33:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080909093308.0734a6ba@bike.lwn.net>
In-Reply-To: <1220933164-10160-2-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it's most cool that this code is finally making its way toward
the mainline.  What I have is mostly nits...

> +int lirc_unregister_plugin(int minor)
> +{
 ... 
> +	/* end up polling thread */
> +	if (ir->task) {
> +		wake_up_process(ir->task);
> +		kthread_stop(ir->task);
> +	}

kthread_stop() will wake up the process, so there is no need to do it
separately here.  In fact, it almost looks like the separate
wake_up_process() call could create an (unlikely) race where the thread
would miss the fact that it's supposed to stop and sleep again.  Fixing the
sleep_on() call there to use something like wait_event() would help in that
regard.


> +static int irctl_open(struct inode *inode, struct file *file)
> +{
> +	struct irctl *ir;
> +	int retval;
> +
> +	if (MINOR(inode->i_rdev) >= MAX_IRCTL_DEVICES) {

All of these might be better as iminor(inode)

> +		dprintk("lirc_dev [%d]: open result = -ENODEV\n",
> +			MINOR(inode->i_rdev));
> +		return -ENODEV;
> +	}
> +
> +	ir = &irctls[MINOR(inode->i_rdev)];
> +
> +	dprintk(LOGHEAD "open called\n", ir->p.name, ir->p.minor);
> +
> +	/* if the plugin has an open function use it instead */
> +	if (ir->p.fops && ir->p.fops->open)
> +		return ir->p.fops->open(inode, file);
> +
> +	if (mutex_lock_interruptible(&plugin_lock))
> +		return -ERESTARTSYS;

So the plugin open() function is called outside of any lock.  Note that
open() no longer has BKL protection as of 2.6.27.  This might all be OK,
but I hope you're convinced of it.

...
> +	if (ir->p.owner != NULL && try_module_get(ir->p.owner)) {
> +		++ir->open;
> +		retval = ir->p.set_use_inc(ir->p.data);

Why is there a set_use_inc() function separate from open()?

> +		if (retval != SUCCESS) {
> +			module_put(ir->p.owner);
> +			--ir->open;
> +		}
> +	} else {
> +		if (ir->p.owner == NULL)
> +			dprintk(LOGHEAD "no module owner!!!\n",
> +				ir->p.name, ir->p.minor);
> +
> +		retval = -ENODEV;
> +	}

If "no owner" is a fatal condition, it seems better to check it when the
plugin is registered.  (Also, BTW, your variant of dprintk() is confusing
to read - I was wondering where all the %'s were.  I still wonder,
actually.  dev_printk() would be better.)

> +static int irctl_close(struct inode *inode, struct file *file)
> +{
> +	struct irctl *ir = &irctls[MINOR(inode->i_rdev)];
> +
> +	dprintk(LOGHEAD "close called\n", ir->p.name, ir->p.minor);
> +
> +	/* if the plugin has a close function use it instead */
> +	if (ir->p.fops && ir->p.fops->release)
> +		return ir->p.fops->release(inode, file);
> +
> +	if (mutex_lock_interruptible(&plugin_lock))
> +		return -ERESTARTSYS;

Should this be interruptible?  You probably want the close call to get its
job done.  Maybe mutex_lock_killable() - and still do the cleanup on a
signal? 

> +static int irctl_ioctl(struct inode *inode, struct file *file,
> +		       unsigned int cmd, unsigned long arg)
> +{
> +	unsigned long mode;
> +	int result;
> +	struct irctl *ir = &irctls[MINOR(inode->i_rdev)];
> +
> +	dprintk(LOGHEAD "ioctl called (0x%x)\n",
> +		ir->p.name, ir->p.minor, cmd);
> +
> +	/* if the plugin has a ioctl function use it instead */
> +	if (ir->p.fops && ir->p.fops->ioctl)
> +		return ir->p.fops->ioctl(inode, file, cmd, arg);
> +
> +	if (ir->p.minor == NOPLUG || !ir->attached) {
> +		dprintk(LOGHEAD "ioctl result = -ENODEV\n",
> +			ir->p.name, ir->p.minor);
> +		return -ENODEV;
> +	}
> +
> +	/* Give the plugin a chance to handle the ioctl */
> +	if (ir->p.ioctl) {
> +		result = ir->p.ioctl(inode, file, cmd, arg);
> +		if (result != -ENOIOCTLCMD)
> +			return result;
> +	}

Why two ioctl() handlers?  It seems better to just have one way for plugins
to handle this call.

...
> +	default:
> +		result = -ENOIOCTLCMD;

Hmm, I note with interest that unlocked_ioctl() remaps -ENOIOCTLCMD to
-EINVAL, while regular, locked ioctl() (which this is) does not.  Not sure
what to make of that.

> +static ssize_t irctl_read(struct file *file,
> +			  char *buffer,
> +			  size_t length,
> +			  loff_t *ppos)
> +{
 ...
> +			schedule();
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			if (!ir->attached) {
> +				ret = -ENODEV;
> +				break;
> +			}

How can ir->attached go to zero?  You checked it earlier and have been
holding the mutex ever since.

> +static ssize_t irctl_write(struct file *file, const char *buffer,
> +			   size_t length, loff_t *ppos)
> +{
> +	struct irctl *ir =
> &irctls[MINOR(file->f_dentry->d_inode->i_rdev)]; 
> +	dprintk(LOGHEAD "write called\n", ir->p.name, ir->p.minor);
> +
> +	/* if the plugin has a specific read function use it instead
> */
> +	if (ir->p.fops && ir->p.fops->write)
> +		return ir->p.fops->write(file, buffer, length, ppos);

Looks like you're using the "specific write function" instead :)

> +static struct file_operations fops = {
> +	.read		= irctl_read,
> +	.write		= irctl_write,
> +	.poll		= irctl_poll,
> +	.ioctl		= irctl_ioctl,
> +	.open		= irctl_open,
> +	.release	= irctl_close
> +};

You should probably set .owner too.

> +static int lirc_dev_init(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_IRCTL_DEVICES; ++i)
> +		init_irctl(&irctls[i]);
> +
> +	if (register_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME, &fops))
> {
> +		printk(KERN_ERR "lirc_dev: register_chrdev
> failed\n");
> +		goto out;
> +	}
> +
> +	lirc_class = class_create(THIS_MODULE, "lirc");
> +	if (IS_ERR(lirc_class)) {
> +		printk(KERN_ERR "lirc_dev: class_create failed\n");
> +		goto out_unregister;
> +	}
> +
> +	printk(KERN_INFO "lirc_dev: IR Remote Control driver
> registered, "
> +	       "major %d \n", IRCTL_DEV_MAJOR);
> +
> +	return SUCCESS;
> +
> +out_unregister:
> +	/* unregister_chrdev returns void now */
> +	unregister_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME);
> +out:
> +	return -1;
> +}

Do you want to fail completely if class_create() fails?  What if somebody
already opened one of your devices?

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

All of these inlines probably shouldn't be.

jon
