Return-Path: <linux-kernel-owner+w=401wt.eu-S1750703AbXB0UZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750703AbXB0UZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXB0UZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:25:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbXB0UZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:25:45 -0500
Date: Tue, 27 Feb 2007 12:25:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Simmons <jsimmons@infradead.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] display class
Message-Id: <20070227122531.542a2c33.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702251833500.30828@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702251833500.30828@pentafluge.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 25 Feb 2007 18:39:57 +0000 (GMT) James Simmons <jsimmons@infradead.org> wrote:
> 
> Here is the second round to the new display class. This is meant to unite 
> the various solutions to display units ie acpi output device, auxdisplay 
> and the defunct lcd class in the backlight directory. Please apply.
> 

Little things..

> +static ssize_t display_show_name(struct device *dev, struct device_attribute *attr,
> +static ssize_t display_show_type(struct device *dev, struct device_attribute *attr,
> +static ssize_t display_show_contrast(struct device *dev, struct device_attribute *attr,

this stuff looks el-crappo in an 80-col display.

> +DECLARE_BITMAP(inuse, NUM_OF_DISPLAYS);

This guy can have static scope.

It's a bit awkward having a fixed size.  I think lib/idr.c would suit for
this.

Also, we do set_bit() and clear_bit() on this, which are needlessly atomic. 
If we hold a suitable lock then we can use __set_bit() and __clear_bit().

And we do need a suitable lock.

> +
> +struct display_device *display_device_register(struct display_driver *driver,
> +						struct device *parent, void *devdata)
> +{
> +	int idx = find_first_zero_bit(inuse, NUM_OF_DISPLAYS);
> +	struct display_device *new_dev = NULL;
> +	struct device *display_device = NULL;
> +
> +	if (unlikely(!driver))
> +		return ERR_PTR(-EINVAL);
> +
> +	display_device = device_create(display_class, parent, 0, "display%d", idx);
> +	if (IS_ERR(display_device))
> +		return ERR_PTR(-ENOMEM);
> +
> +	new_dev = kzalloc(sizeof(struct display_device), GFP_KERNEL);
> +	if (likely(new_dev) && unlikely(driver->probe(new_dev, devdata))) {
> +		dev_set_drvdata(display_device, new_dev);
> +		new_dev->dev = display_device;
> +		new_dev->parent = parent;
> +		new_dev->driver = driver;
> +		mutex_init(&new_dev->lock);
> +		set_bit(idx, inuse);
> +		new_dev->idx = idx;
> +	} else
> +		device_unregister(display_device);
> +	return new_dev;
> +}
> +EXPORT_SYMBOL(display_device_register);

Because I think this function is racy in its handling of inuse?

> +static int __init display_class_init(void)
> +{
> +	display_class = class_create(THIS_MODULE, "display");
> +	if (IS_ERR(display_class)) {
> +		printk(KERN_ERR "Failed to create display class\n");
> +		display_class = NULL;
> +		return -EINVAL;
> +	}
> +	display_class->dev_attrs = display_attrs;
> +	display_class->suspend = display_suspend;
> +	display_class->resume = display_resume;
> +	bitmap_zero(inuse, NUM_OF_DISPLAYS);	
> +	return 0;
> +}
> +
> +#ifdef MODULE
> +module_init(display_class_init);
> +
> +static void __exit display_class_exit(void)
> +{
> +	class_destroy(display_class);
> +}
> +module_exit(display_class_exit);
> +#else
> +subsys_initcall(display_class_init);
> +#endif

Why all the ifdeffery?  I think plain old


static void __exit display_class_exit(void)
{
	class_destroy(display_class);
}
module_exit(display_class_exit);
module_init(display_class_init);


would suit here.

Unless there's some special reason why we need subsys_initcall() here if
it's linked into vmlinux.  If so, please add a comment so the next reader
doesn't get all confused too.

