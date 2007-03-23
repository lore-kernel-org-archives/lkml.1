Return-Path: <linux-kernel-owner+w=401wt.eu-S934319AbXCWV05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319AbXCWV05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXCWV05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:26:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44391 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319AbXCWV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:26:55 -0400
Subject: Re: [PATCH 2.6.21-rc4] hwmon: HP Mobile Data Protection System 3D
	ACPI driver
From: Arjan van de Ven <arjan@infradead.org>
To: Yan Burman <burman.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org
In-Reply-To: <1174661503.5373.16.camel@lapot>
References: <1174661503.5373.16.camel@lapot>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 23 Mar 2007 22:26:44 +0100
Message-Id: <1174685204.1158.255.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

your code looks very nice and clean, only few comments, see below

> +static int mdps_joystick_kthread(void *data)
> +{
> +	int x = 0, y = 0, z = 0;
> +
> +	while (!kthread_should_stop()) {
> +		if (input_3d) {
> +			mdps_get_xyz(mdps.device->handle, &x, &y, &z);
> +			input_report_abs(mdps.idev, ABS_Z, z - mdps.zcalib);
> +		} else
> +			mdps_get_xy(mdps.device->handle, &x, &y);
> +
> +		input_report_abs(mdps.idev, ABS_X, x - mdps.xcalib);
> +		input_report_abs(mdps.idev, ABS_Y, y - mdps.ycalib);
> +
> +		input_sync(mdps.idev);
> +
> +		try_to_freeze();
> +		msleep_interruptible(MDPS_POLL_INTERVAL);
> +	}

what if you get a signal? you probably at least want to handle that
somehow. Also, waking up every 30 miliseconds is going to suck up
power ... but that might not be avoidable I suppose if you have to poll
the hardware.

> +static int mdps_misc_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +
> +	if (!atomic_dec_and_test(&mdps.available)) {
> +		atomic_inc(&mdps.available);
> +		return -EBUSY; /* already open */
> +	}
I often get a bit nervous at seeing such "open me once" code, but it
might well be ok ... I'll let others comment

> +
> +	atomic_set(&mdps.count, 0);
> +
> +	ret = request_irq(mdps.irq, mdps_irq, 0, "mdps", mdps_irq);

don't you want to allow shared interrupts?

> +	if (ret) {
> +		printk(KERN_ERR "mdps: IRQ%d allocation failed\n", mdps.irq);
> +		return -ENODEV;
> +	}

wouldn't you want to inc the atomic in this case?



> +static ssize_t mdps_misc_read(struct file *file, char __user *buf,
> +                              size_t count, loff_t *pos)
> +{
> +	DECLARE_WAITQUEUE(wait, current);
> +	u32 data;
> +	ssize_t retval = count;
> +
> +	if (count != sizeof(u32))
> +		return -EINVAL;
> +
> +	add_wait_queue(&mdps.misc_wait, &wait);
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		data = atomic_xchg(&mdps.count, 0);
> +		if (data)
> +			break;
> +
> +		if (file->f_flags & O_NONBLOCK) {
> +			retval = -EAGAIN;
> +			goto out;
> +		}
> +
> +		if (signal_pending(current)) {
> +			retval = -ERESTARTSYS;
> +			goto out;
> +		}
> +
> +		schedule();
> +	}
> +
> +	if (copy_to_user(buf, &data, sizeof(data)))

I'm not entirely sure you want to go into copy_to_user() with a
TASK_INTERRUPTIBLE state, I would feel a lot better if you did an
explicit __set_current_state(TASK_RUNNING) just before this.

> +		retval = -EFAULT;
> +
> +out:
> +	set_current_state(TASK_RUNNING);

.. which you do here anyway

> mdps_get_resource(struct acpi_resource *resource, void *context)
> +{
> +	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
> +		struct acpi_resource_extended_irq *irq;
> +		u32 *device_irq = context;
> +
> +		irq = &resource->data.extended_irq;
> +		*device_irq = irq->interrupts[0];


eh wait.. if this thing gives you an interrupt.. why do you need to poll
every 30 msec? am I missing something?


