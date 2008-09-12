Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYILAQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYILAQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 20:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYILAQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 20:16:43 -0400
Received: from scing.com ([217.160.110.58]:45441 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYILAQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 20:16:42 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Fri, 12 Sep 2008 02:12:33 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909093308.0734a6ba@bike.lwn.net>
In-Reply-To: <20080909093308.0734a6ba@bike.lwn.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200809120212.33716.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 17:33:08 Jonathan Corbet wrote:
> I think it's most cool that this code is finally making its way
> toward the mainline.  What I have is mostly nits...

ignoring bits already handled in Christoph Hellwig's review

> > +		dprintk("lirc_dev [%d]: open result = -ENODEV\n",
> > +			MINOR(inode->i_rdev));
> > +		return -ENODEV;
> > +	}
> > +
> > +	ir = &irctls[MINOR(inode->i_rdev)];
> > +
> > +	dprintk(LOGHEAD "open called\n", ir->p.name, ir->p.minor);
> > +
> > +	/* if the plugin has an open function use it instead */
> > +	if (ir->p.fops && ir->p.fops->open)
> > +		return ir->p.fops->open(inode, file);
> > +
> > +	if (mutex_lock_interruptible(&plugin_lock))
> > +		return -ERESTARTSYS;
>
> So the plugin open() function is called outside of any lock.  Note
> that open() no longer has BKL protection as of 2.6.27.  This might
> all be OK, but I hope you're convinced of it.

plugins fops are called directly now

> > +	if (ir->p.owner != NULL && try_module_get(ir->p.owner)) {
> > +		++ir->open;
> > +		retval = ir->p.set_use_inc(ir->p.data);
>
> Why is there a set_use_inc() function separate from open()?

since not all plugins set p.fops? some of those functions in the drivers 
are even empty. I'll look at it.

> > +		if (retval != SUCCESS) {
> > +			module_put(ir->p.owner);
> > +			--ir->open;
> > +		}
> > +	} else {
> > +		if (ir->p.owner == NULL)
> > +			dprintk(LOGHEAD "no module owner!!!\n",
> > +				ir->p.name, ir->p.minor);
> > +
> > +		retval = -ENODEV;
> > +	}
>
> If "no owner" is a fatal condition, it seems better to check it when
> the plugin is registered.

maybe because it's not needed if the plugin has its own fops.open?

> (Also, BTW, your variant of dprintk() is 
> confusing to read - I was wondering where all the %'s were.  I still
> wonder, actually.  dev_printk() would be better.)

the LOGHEAD define is confusing, I'll look into make more clear

> > +static int irctl_close(struct inode *inode, struct file *file)
> > +{
> > +	struct irctl *ir = &irctls[MINOR(inode->i_rdev)];
> > +
> > +	dprintk(LOGHEAD "close called\n", ir->p.name, ir->p.minor);
> > +
> > +	/* if the plugin has a close function use it instead */
> > +	if (ir->p.fops && ir->p.fops->release)
> > +		return ir->p.fops->release(inode, file);
> > +
> > +	if (mutex_lock_interruptible(&plugin_lock))
> > +		return -ERESTARTSYS;
>
> Should this be interruptible?  You probably want the close call to
> get its job done.  Maybe mutex_lock_killable() - and still do the
> cleanup on a signal?

That's better than the current state.

> > +static int irctl_ioctl(struct inode *inode, struct file *file,
> > +		       unsigned int cmd, unsigned long arg)
> > +{
> > +	unsigned long mode;
> > +	int result;
> > +	struct irctl *ir = &irctls[MINOR(inode->i_rdev)];
> > +
> > +	dprintk(LOGHEAD "ioctl called (0x%x)\n",
> > +		ir->p.name, ir->p.minor, cmd);
> > +
> > +	/* if the plugin has a ioctl function use it instead */
> > +	if (ir->p.fops && ir->p.fops->ioctl)
> > +		return ir->p.fops->ioctl(inode, file, cmd, arg);
> > +
> > +	if (ir->p.minor == NOPLUG || !ir->attached) {
> > +		dprintk(LOGHEAD "ioctl result = -ENODEV\n",
> > +			ir->p.name, ir->p.minor);
> > +		return -ENODEV;
> > +	}
> > +
> > +	/* Give the plugin a chance to handle the ioctl */
> > +	if (ir->p.ioctl) {
> > +		result = ir->p.ioctl(inode, file, cmd, arg);
> > +		if (result != -ENOIOCTLCMD)
> > +			return result;
> > +	}
>
> Why two ioctl() handlers?  It seems better to just have one way for
> plugins to handle this call.

after a cursory look this is used if the plugin doesn't reimplement or 
want to overwrite the commands handled in irctl. I'll look if this can 
be handled better.

> > +	default:
> > +		result = -ENOIOCTLCMD;
>
> Hmm, I note with interest that unlocked_ioctl() remaps -ENOIOCTLCMD
> to -EINVAL, while regular, locked ioctl() (which this is) does not. 
> Not sure what to make of that.

changed this return value to -EINVAL

> > +static ssize_t irctl_read(struct file *file,
> > +			  char *buffer,
> > +			  size_t length,
> > +			  loff_t *ppos)
> > +{
>
>  ...
>
> > +			schedule();
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			if (!ir->attached) {
> > +				ret = -ENODEV;
> > +				break;
> > +			}
>
> How can ir->attached go to zero?  You checked it earlier and have
> been holding the mutex ever since.

I don't think the lock has to be held while sleeping

> > +static ssize_t irctl_write(struct file *file, const char *buffer,
> > +			   size_t length, loff_t *ppos)
> > +{
> > +	struct irctl *ir =
> > &irctls[MINOR(file->f_dentry->d_inode->i_rdev)];
> > +	dprintk(LOGHEAD "write called\n", ir->p.name, ir->p.minor);
> > +
> > +	/* if the plugin has a specific read function use it instead
> > */
> > +	if (ir->p.fops && ir->p.fops->write)
> > +		return ir->p.fops->write(file, buffer, length, ppos);
>
> Looks like you're using the "specific write function" instead :)

plugins fops will be used directly now, no need for this comment and 
code anymore ;)

> > +static struct file_operations fops = {
> > +	.read		= irctl_read,
> > +	.write		= irctl_write,
> > +	.poll		= irctl_poll,
> > +	.ioctl		= irctl_ioctl,
> > +	.open		= irctl_open,
> > +	.release	= irctl_close
> > +};
>
> You should probably set .owner too.

done

> > +static int lirc_dev_init(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < MAX_IRCTL_DEVICES; ++i)
> > +		init_irctl(&irctls[i]);
> > +
> > +	if (register_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME, &fops))
> > {
> > +		printk(KERN_ERR "lirc_dev: register_chrdev
> > failed\n");
> > +		goto out;
> > +	}
> > +
> > +	lirc_class = class_create(THIS_MODULE, "lirc");
> > +	if (IS_ERR(lirc_class)) {
> > +		printk(KERN_ERR "lirc_dev: class_create failed\n");
> > +		goto out_unregister;
> > +	}
> > +
> > +	printk(KERN_INFO "lirc_dev: IR Remote Control driver
> > registered, "
> > +	       "major %d \n", IRCTL_DEV_MAJOR);
> > +
> > +	return SUCCESS;
> > +
> > +out_unregister:
> > +	/* unregister_chrdev returns void now */
> > +	unregister_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME);
> > +out:
> > +	return -1;
> > +}
>
> Do you want to fail completely if class_create() fails?  What if
> somebody already opened one of your devices?

order reversed and using alloc_chrdev_region so there is no device which 
could be opened. Also returning correct error values now.

Thanks for the review.

Janne
