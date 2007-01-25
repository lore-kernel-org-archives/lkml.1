Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXAYNLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXAYNLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965299AbXAYNLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:11:19 -0500
Received: from burp.tkv.asdf.org ([212.16.99.49]:46119 "EHLO moth.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965152AbXAYNLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:11:18 -0500
Date: Thu, 25 Jan 2007 15:11:15 +0200
Message-Id: <200701251311.l0PDBFD0025319@moth.iki.fi>
From: Markku Savela <msa@moth.iki.fi>
To: greg@kroah.com
CC: linux-kernel@vger.kernel.org
In-reply-to: <20070125082544.GA16300@kroah.com> (message from Greg KH on Thu,
	25 Jan 2007 00:25:44 -0800)
Subject: Re: How to get /dev entry created automaticly for dynamic major number?
References: <200701250735.l0P7Z7aN018630@moth.iki.fi> <20070125082544.GA16300@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Solution found!

> On Thu, Jan 25, 2007 at 09:35:07AM +0200, Markku Savela wrote:
> > If want to write a loadable module which "implements" a char device
> > ("virtual", no real device present). How do I get the correct
> > "/dev/foo" to appear automaticly?

> From: Greg KH <greg@kroah.com>

> If you look in the book, Linux Device Drivers, third edition, free
> online, there's a section on what is needed for udev to work properly.
> 
> The ideas are still the same, but the way to do it has changed since the
> book was written.  Just use a struct device and a class, and you will be
> fine.  Look at the misc device core or the mem code in
> drivers/char/mem.c for examples of what you need to do.

Thanks! The solution seems to work. The final *obstacle* was, that
class_* symbols were not available until I added the
LICENSE("GPL"). Here is the resulting template, maybe useful for
someone, and just for verification, that I got it right.

...
static int foo_major = 0;
static struct class *foo_class;
static struct class_device *foo_device;
...

static int __init foo_init(void)
  {
    foo_major = 0;
    foo_class = NULL;
    foo_device = NULL;

    foo_major = register_chrdev(foo_major, "foo", &foo_fops);
    if (foo_major <= 0)
        return -EIO;
    foo_class = class_create(THIS_MODULE, "foo");
    if (IS_ERR(foo_class))
       {
       return PTR_ERR(foo_class);
       }
    foo_device = class_device_create(foo_class, NULL, MKDEV(foo_major, 0), NULL, "foo0");
    if (IS_ERR(foo_device))
       {
       return PTR_ERR(foo_device);
       }
    return 0;
    }

static void __exit foo_exit(void)
    {
    if (foo_device && !IS_ERR(foo_device))
       class_device_del(foo_device);
    if (foo_class && !IS_ERR(foo_class))
       class_destroy(foo_class);
    if (foo_major > 0)
       unregister_chrdev(foo_major, "foo");
    }

module_init(foo_init);
module_exit(foo_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Markku Savela");
MODULE_DESCRIPTION("Just fooling around");
