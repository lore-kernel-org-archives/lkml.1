Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbXCXJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbXCXJK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 05:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXCXJK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 05:10:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34081 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbXCXJKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 05:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NxhVhDLyMGTgXFqIMKyfFk0jTNUiRRrJoYuo+m+iJu7/RUOu6suhApg1aJaSqRBVGCF2Ap5+ZPfR3rNB3Z5RqWWcxAqoBM9m2EPm6nJVSuIV+n8AjZSdn2cTkoc5WP8OdEjMj9XYfxMKaU4fvrItsuSHi/NJVN74XgCVw1SOkuY=
Message-ID: <4604E975.2010209@gmail.com>
Date: Sat, 24 Mar 2007 11:03:49 +0200
From: Yan Burman <burman.yan@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH 2.6.21-rc4] hwmon: HP Mobile Data Protection System 3D
 ACPI driver
References: <1174661503.5373.16.camel@lapot> <1174685204.1158.255.camel@laptopd505.fenrus.org>
In-Reply-To: <1174685204.1158.255.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Hi,
>
> your code looks very nice and clean, only few comments, see below
>   
Thanks
>   
>> +static int mdps_joystick_kthread(void *data)
>> +{
>> +	int x = 0, y = 0, z = 0;
>> +
>> +	while (!kthread_should_stop()) {
>> +		if (input_3d) {
>> +			mdps_get_xyz(mdps.device->handle, &x, &y, &z);
>> +			input_report_abs(mdps.idev, ABS_Z, z - mdps.zcalib);
>> +		} else
>> +			mdps_get_xy(mdps.device->handle, &x, &y);
>> +
>> +		input_report_abs(mdps.idev, ABS_X, x - mdps.xcalib);
>> +		input_report_abs(mdps.idev, ABS_Y, y - mdps.ycalib);
>> +
>> +		input_sync(mdps.idev);
>> +
>> +		try_to_freeze();
>> +		msleep_interruptible(MDPS_POLL_INTERVAL);
>> +	}
>>     
>
> what if you get a signal? you probably at least want to handle that
> somehow. Also, waking up every 30 miliseconds is going to suck up
> power ... but that might not be avoidable I suppose if you have to poll
> the hardware.
>   
How do I handle signals in kthreads? I looked at quite a few kthreads in 
the drivers sources, but couldn't
find even one example that has any explicit handling of signals.

>> +
>> +	atomic_set(&mdps.count, 0);
>> +
>> +	ret = request_irq(mdps.irq, mdps_irq, 0, "mdps", mdps_irq);
>>     
>
> don't you want to allow shared interrupts?
>   
I had some problems with that before (2.6.19 I think), but in 2.6.21-rc4 
it seems OK, so I will allow shared interrupts in my next version.
>   
>> +	if (ret) {
>> +		printk(KERN_ERR "mdps: IRQ%d allocation failed\n", mdps.irq);
>> +		return -ENODEV;
>> +	}
>>     
>
> wouldn't you want to inc the atomic in this case?
>   
You are right. I missed that after refactoring the code before.
>   
>> +static ssize_t mdps_misc_read(struct file *file, char __user *buf,
>> +                              size_t count, loff_t *pos)
>> +{
>> +	DECLARE_WAITQUEUE(wait, current);
>> +	u32 data;
>> +	ssize_t retval = count;
>> +
>> +	if (count != sizeof(u32))
>> +		return -EINVAL;
>> +
>> +	add_wait_queue(&mdps.misc_wait, &wait);
>> +	for (;;) {
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		data = atomic_xchg(&mdps.count, 0);
>> +		if (data)
>> +			break;
>> +
>> +		if (file->f_flags & O_NONBLOCK) {
>> +			retval = -EAGAIN;
>> +			goto out;
>> +		}
>> +
>> +		if (signal_pending(current)) {
>> +			retval = -ERESTARTSYS;
>> +			goto out;
>> +		}
>> +
>> +		schedule();
>> +	}
>> +
>> +	if (copy_to_user(buf, &data, sizeof(data)))
>>     
>
> I'm not entirely sure you want to go into copy_to_user() with a
> TASK_INTERRUPTIBLE state, I would feel a lot better if you did an
> explicit __set_current_state(TASK_RUNNING) just before this.
>   
Done.
>   
>> +		retval = -EFAULT;
>> +
>> +out:
>> +	set_current_state(TASK_RUNNING);
>>     
>
> .. which you do here anyway
>
>   
>> mdps_get_resource(struct acpi_resource *resource, void *context)
>> +{
>> +	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
>> +		struct acpi_resource_extended_irq *irq;
>> +		u32 *device_irq = context;
>> +
>> +		irq = &resource->data.extended_irq;
>> +		*device_irq = irq->interrupts[0];
>>     
>
>
> eh wait.. if this thing gives you an interrupt.. why do you need to poll
> every 30 msec? am I missing something?
>
>   
The problem is that if I use interrupts for mouse-like behavior, I have 
no way of knowing (unless I do some hacks to remember the last position 
and see if it changed more than
some threshold, or something like that - I'm not sure that at this point 
I can do that reliably)
what was the source of the interrupt - was that motion or free-fall 
event. This means I can't both use it as joystick and detect when
the laptop is falling. That's why I use the interrupts for free-fall 
events (as it was intended for this chip in the laptop context), and use 
polling for mouse like behavior. This is the same approach
as other accelerometer drivers in the kernel (hdaps and ams).

