Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYDNMId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYDNMId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYDNMI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:08:26 -0400
Received: from minx.mdc-dayton.com ([70.62.41.4]:40139 "EHLO daetwyler-rd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753802AbYDNMI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:08:26 -0400
From: "Kathy Frazier" <kfrazier@daetwyler-rd.com>
To: <linux-kernel@vger.kernel.org>
Subject: Talking to parallel port in 2.6 kernel without using parport
Date: Mon, 14 Apr 2008 08:08:24 -0400
Organization: Max Daetwyler Corp - Dayton Division
Message-ID: <009501c89e28$3d7530f0$b85f92d0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcieKD0CJqZljGOPSi6lYrFtPKyC3A==
Content-Language: en-us
X-MyHeader: SpamAssassin Check skipped due to Authenication or Internal MDC-Dayton Address
X-MyHeader: Clam AV Check skipped due to Authenication or Internal MDC-Dayton Address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I have an existing 2.4 linux driver which talks directly to a parallel port
to send commands to some propriatary
hardware.  I am attemping to convert this to a 2.6 driver (kernel version
2.6.18), but am experiencing problems.

My 2.4 driver's init routine looked something like what is below.  Our
proprietary application uses this driver to talk
to our proprietary hardware across the parallel port without using the
parport layers.


int __init pp_init()
{
    mdcmajor = register_chrdev(mdcmajor,"pp", &pp_fops);
    if (mdcmajor < 0)
    {
       printk(KERN_ERR "pp:  unable to get major %d\n", mdcmajor);
       return - EIO;
    }
    else
       printk(KERN_INFO "pp:  major number= %d\n", mdcmajor);

// Set the pins on the parallel port
                outb(0x04, CONTROL);
                  outb(0xFF, STATUS);
                x = inb(STATUS);
                  outb(0x04, CONTROL);
                outb(0xFF, STATUS);

return 0;
}


I modified my init routine for 2.6 as below.  The driver loads correctly and
I see evidence of it in 
/proc/modules and /proc/devices.  However, I can not open it.  

static int __init pp_init(void)
{
   int status;
   dev_t dev;

    dev = MKDEV(mdcmajor, 0);
    status = register_chrdev_region(dev, 1, "pp");
    if (status < 0)
    {
       printk(KERN_ERR "pp:  unable to get major %d\n", mdcmajor);
       return - EIO;
    }
    else
       printk(KERN_INFO "pp:  major number= %d\n", mdcmajor);
   cdev_init(&chrdev, &pp_fops);
   chrdev.owner = THIS_MODULE;
   chrdev.ops = &pp_fops;
   status = cdev_add (&chrdev, dev, 1);
   if (status < 0)
   {
      printk(KERN_ERR "pp:  unable to add device %d to system.  status =
%d\n", mdcmajor, status);
      return -ENODEV;
   }

                  // Set the pins on the parallel port
                outb(0x04, CONTROL);
                  outb(0xFF, STATUS);
                x = inb(STATUS);
                  outb(0x04, CONTROL);
                outb(0xFF, STATUS);

****************

I have some other 2.6 PCI drivers that work correctly.  It's init module
does a pci_register_driver followed by 
a register_chrdev_region, cdev_init and cdev_add.  I've been reading the
Documentation directories included 
with the kernel concerning the Driver Model.  I am assuming there is some
"glue" I am missing because I am not
going through a "bus" layer like I am with my PCI drivers.  It seemed that I
should use the Platform devices, so I
tried what you see below.  

static struct platform_device *pp_platform_device;
static struct platform_driver drv = {
   .probe = pp_probe,
   .remove = pp_remove,
   .driver = {
      .name = "pp",
      .owner = THIS_MODULE,
   },
};

static int __init pp_init(void)
{
   int status;
   dev_t dev;

    status = platform_driver_register(&drv);
    if (status < 0)
    {
       printk(KERN_ERR "pp:  unable to register with platform, error = %d",
status);
//       platform_device_unregister(pp_platform_device);
       status = -ENODEV;
       return status;
    }
    printk(KERN_INFO "pp: registerd with platform\n");
    // I read on LKML that platform_device_register_simple is going away.
    // Instead, implement probe and remove so manual binding and unbinding
    // will work.
    pp_platform_device = platform_device_register_simple("pp", -1, NULL, 0);
    if (pp_platform_device < 0)
    {
       printk(KERN_ERR "pp: unable to register device, error = %d\n",
pp_platform_device);
       platform_driver_unregister(&drv);
       status = -ENODEV;
       return status;
    }
    
    dev = MKDEV(MDC_MAJOR, 0);
    status = register_chrdev_region(dev, 1, "pp");
    if (status < 0)
    {
       printk(KERN_ERR "pp:  unable to get major %d\n", mdcmajor);
       return - EIO;
    }
    else
       printk(KERN_INFO "pp:  major number= %d\n", mdcmajor);


   cdev_init(&chrdev, &pp_fops);
   chrdev.owner = THIS_MODULE;
   chrdev.ops = &pp_fops;
   status = cdev_add (&chrdev, dev, 1);
   if (status < 0)
   {
      printk(KERN_ERR "pp:  unable to add device %d to system.  status =
%d\n", mdcmajor, status);
      return -ENODEV;
   }



                  // Set the pins on the parallel port
                outb(0x04, CONTROL);
                  outb(0xFF, STATUS);
                x = inb(STATUS);
                  outb(0x04, CONTROL);
                outb(0xFF, STATUS);

   for (i=0; i<256; i++)
      memory_array[i] = 0;


   printk (KERN_INFO "pp: Initialized OK.\n");
   return 0;
}

***** However, I am still unable to open my device.  Can someone tell me
what I am missing?  
What do I need to do to talk to the parallel port myself and NOT go through
parport?

Thanks in advance for your help!

Kathy Frazier

