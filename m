Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYEVU0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYEVU0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYEVU0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:26:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:32357 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYEVU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oSbVZ8YPCMjYEPSR2QPTCgwC3T7AT548MG+ijWIlznU1MhQYsiAnRaZbkUCk0oIlVMVEHiIjVEVYQHw1eIOTsp31FBGfJP/BQRzCWEBVK4WVvd6nyXWFfaHpdLMPR+B+BRy1TFUy+eY4nkOwmdRd2byC3agFgGqOpGkj8n82XcY=
Message-ID: <7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
Date: Thu, 22 May 2008 21:26:28 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "=?ISO-8859-1?Q?Uwe_Kleine-K=C3=B6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <20080522200814.GD3226@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
	 <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
	 <20080522200814.GD3226@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/22 Hans J. Koch <hjk@linutronix.de>:
> On Thu, May 22, 2008 at 08:47:16PM +0100, Tom Spink wrote:
>
> Hi Tom,
>
>> 2008/5/22 Hans J. Koch <hjk@linutronix.de>:
>> > Sometimes it is necessary to enable/disable the interrupt of a UIO device
>> > from the userspace part of the driver. With this patch, the UIO kernel driver
>> > can implement an "irqcontrol()" function that does this. Userspace can write
>> > an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
>> > UIO core will then call the driver's irqcontrol function.
>> >
>> > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
>>
>> <snip>
>>
>> Hi,
>>
>> I wonder if it would be better to implement this as an ioctl,
>
> No way. We don't want to introduce new ioctls.

Why not?  A typical usage scenario would then be:

fd = open("/dev/uio0", O_RDONLY);
...
ioctl(fd, UIO_IOC_SETIRQ, 0);
...
ioctl(fd, UIO_IOC_SETIRQ, 1);
...
close(fd);

The added benefit is that the code becomes less complex, as you don't
have to check buffer sizes and copy the integer from userspace.  You
just implement an ioctl handle on the uio char device, reducing the
code to something like this (not compiled or tested in any way, and
missing the definition of UIO_IOC_SETIRQ):

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 55cc7b8..9edc7c0 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -534,11 +534,31 @@ static int uio_mmap(struct file *filep, struct
vm_area_struct *vma)
        }
 }

+static int uio_ioctl(struct inode *inode, struct file *filp, unsigned
int cmd, unsigned long arg)
+{
+       struct uio_listener *listener = filp->private_data;
+       struct uio_device *idev = listener->dev;
+
+       switch (cmd) {
+       case UIO_IOC_SETIRQ:
+               if (idev->info->irq == UIO_IRQ_NONE)
+                       return -EIO;
+
+               if (idev->info->irqcontrol)
+                       return idev->info->irqcontrol(idev->info, arg);
+               else
+                       return -ENOSYS;
+       }
+
+       return -ENOTTY;
+}
+
 static const struct file_operations uio_fops = {
        .owner          = THIS_MODULE,
        .open           = uio_open,
        .release        = uio_release,
        .read           = uio_read,
+       .ioctl          = uio_ioctl,
        .mmap           = uio_mmap,
        .poll           = uio_poll,
        .fasync         = uio_fasync,

>
>> rather
>> than a write to the device.  Writing to a device is a pretty generic
>> thing, and this patch would tie that up to specifically controlling
>> interrupts.
>
> UIO userspace drivers do their whole work by accessing the device's
> memory directly. The purpose of the kernel part is mainly
>
> 1) allow this memory to be mapped
> 2) handle interrupts
>
> We have an mmap() implementation for 1) and a read() implementation to
> wait for interrupts. Now we add write to enable/disable interrupts,
> which completes 2). Looks clean to me.

Okay, I understand that.  Fair point, but what happens if later write
needs to do something else?

>
>> An ioctl would be more appropriate, IMO, as you are
>> issuing a controlling command, i.e. disable or enable interrupts.
>>
>> By the way, I have absolutely no idea how the UIO driver works, other
>> than reading http://lwn.net/Articles/232575/
>
> You could read the docs that come with the kernel sources:
> Documentation/DocBook/uio_howto

Thanks!  That document certainly helps.

> Thanks,
> Hans

-- 
Tom Spink
