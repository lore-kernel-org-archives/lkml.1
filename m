Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbYDVSfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbYDVSfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYDVSes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:34:48 -0400
Received: from minx.mdc-dayton.com ([70.62.41.4]:38212 "EHLO daetwyler-rd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763850AbYDVSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:34:47 -0400
From: "Kathy Frazier" <kfrazier@daetwyler-rd.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Kathy Frazier'" <kfrazier@daetwyler-rd.com>
Cc: <linux-kernel@vger.kernel.org>
References: <009501c89e28$3d7530f0$b85f92d0$@com> <20080414133937.7080d30d@core>
In-Reply-To: <20080414133937.7080d30d@core>
Subject: RE: Talking to parallel port in 2.6 kernel without using parport
Date: Tue, 22 Apr 2008 14:34:33 -0400
Message-ID: <006f01c8a4a7$82e37ea0$88aa7be0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcieLVb5QyNqpctMQ06EZp22soPFnQGdRAFQ
Content-Language: en-us
X-MyHeader: SpamAssassin Check skipped due to Authenication or Internal MDC-Dayton Address
X-MyHeader: Clam AV Check skipped due to Authenication or Internal MDC-Dayton Address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Thanks for your response.  I had some shifting priorities, but I finally had
a chance to try your suggestion.  Unfortunately I am still having trouble.
In my init routine, I do:


    dev = MKDEV(MY_MAJOR, 0);
    status = register_chrdev_region(dev, 1, MY_DEVNAME);
    if (status < 0)
    {
       printk(KERN_ERR "pp:  unable to get major %d\n", MY_MAJOR);
       return - EIO;
    }
    else
       printk(KERN_INFO "pp:  major number= %d\n", MY_MAJOR);

   printk(KERN_INFO "pp: Adding character device\n");
   cdev_init(&chrdev, &pp_fops);
   chrdev.owner = THIS_MODULE;
   chrdev.ops = &pp_fops;
   status = cdev_add (&chrdev, dev, 1);
   if (status < 0)
   {
      printk(KERN_ERR "pp:  unable to add device %d to system.  status =
%d\n", MY_MAJOR, status);
      return -ENODEV;
   }
    printk(KERN_INFO "pp:  registering with parport\n");
    if (parport_register_driver(&ppdrv))
    {
       printk(KERN_ERR "pp:  unable to register driver with parport\n");
       unregister_chrdev(mymajor, MY_DEVNAME);
       return -EIO;
    }

   my_parport = parport_find_base(DATA);
   if (!my_parport)
   {
      printk(KERN_WARNING "pp:  no associated port!");
      return -ENXIO;
   }
   else
   {
      printk(KERN_INFO "pp:  Found base 0x%x for parport device %s number %d
module state = %d ref count=%d flags = 0x%x\n",
           DATA, my_parport->name, my_parport->number, 
           my_parport->ops->owner->state, 
           my_parport->ops->owner->ref[0].count, 
           my_parport->physport->flags);
   }
   table[0].dev = parport_register_device(my_parport, MY_DEVNAME, NULL,
NULL, NULL, PARPORT_FLAG_EXCL, (void *) &table[0]);
   if (table[0].dev == NULL)
   {
      printk(KERN_ERR "pp:  Error registering device\n");
      return;
   }
   else
      printk(KERN_INFO "pp:  Registered device with parport\n");


Everthing happens as expected, except that the parport_register_device fails
returning NULL.  

One of our engineers downloaded source code a while back from
linux-2.6.18-rc7, but I am not sure how close that is to what is installed
on my system (uname -r returns 2.6.18-1.2798.fc6.  When I set my printk to 8
(echo 8 > /proc/sys/kernel/printk), there are no messages shown on the
failure.  According to the source code I have, the only silent failure in
parport_register_device is:

If (!try_module_get(port->ops->owner)) {
   return NULL;
}

The printk debug I have following the parport_find_base gives the following
result:

pp:  Found base 0x378 for parport device parport0 number 0, module state = 0
ref count=1 flags=0x0
pp:  Error registering device

When I change the flags from PARPORT_FLAG_EXCL to 0 in the call to
parport_register_device, the call returns a non-zero to indicate success.

Can you tell me what I am missing?  Where can I get the actual source code
that goes with this version to further unravel this?

Thanks in advance for your help!  Please CC me.

Kathy Frazier

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Alan Cox
Sent: Monday, April 14, 2008 8:40 AM
To: Kathy Frazier
Cc: linux-kernel@vger.kernel.org
Subject: Re: Talking to parallel port in 2.6 kernel without using parport

> ***** However, I am still unable to open my device.  Can someone tell 
> me what I am missing?
> What do I need to do to talk to the parallel port myself and NOT go 
> through parport?

You should go through parport. The parport layer is there for a reason.
You drive on the road not through fields (even if shorter distances) please
show the same respect for the kernel and your users (plus it'll make your
job easier).

If you need to hog the device because it doesn't follow 1284 or other
sharing standards the parport_register_device can be called with
PARPORT_DEV_EXCL in flags, which means you want to sit on it.

So for something like a standard PC built in port (for the little time they
have left before they go away in hardware..)

	struct parport *p = parport_find_base(0x378 /* etc */);
	
	parport_register_device(p, "mywidget", NULL,
		my_irq_handler, PARPORT_DEV_EXCL, &mystruct)
	parport_enable_irq(p);

where mystruct is a private object that will be passed back to you in the
callbacks. If you don't use the IRQ then don't call parport_enable_irq and
my_irq_handler can also be NULL.

Alan

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

