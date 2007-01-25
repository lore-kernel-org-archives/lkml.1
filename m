Return-Path: <linux-kernel-owner+w=401wt.eu-S1030234AbXAYPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234AbXAYPwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030245AbXAYPwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:52:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:53940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030234AbXAYPwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:52:34 -0500
Date: Thu, 25 Jan 2007 07:51:39 -0800
From: Greg KH <greg@kroah.com>
To: Markku Savela <msa@moth.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to get /dev entry created automaticly for dynamic major number?
Message-ID: <20070125155139.GA24945@kroah.com>
References: <200701250735.l0P7Z7aN018630@moth.iki.fi> <20070125082544.GA16300@kroah.com> <200701251311.l0PDBFD0025319@moth.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701251311.l0PDBFD0025319@moth.iki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 03:11:15PM +0200, Markku Savela wrote:
> Solution found!
> 
> > On Thu, Jan 25, 2007 at 09:35:07AM +0200, Markku Savela wrote:
> > > If want to write a loadable module which "implements" a char device
> > > ("virtual", no real device present). How do I get the correct
> > > "/dev/foo" to appear automaticly?
> 
> > From: Greg KH <greg@kroah.com>
> 
> > If you look in the book, Linux Device Drivers, third edition, free
> > online, there's a section on what is needed for udev to work properly.
> > 
> > The ideas are still the same, but the way to do it has changed since the
> > book was written.  Just use a struct device and a class, and you will be
> > fine.  Look at the misc device core or the mem code in
> > drivers/char/mem.c for examples of what you need to do.
> 
> Thanks! The solution seems to work. The final *obstacle* was, that
> class_* symbols were not available until I added the
> LICENSE("GPL"). Here is the resulting template, maybe useful for
> someone, and just for verification, that I got it right.

Your code _is_ licensed under the GPL, right?

> ...
> static int foo_major = 0;
> static struct class *foo_class;
> static struct class_device *foo_device;
> ...
> 
> static int __init foo_init(void)
>   {
>     foo_major = 0;
>     foo_class = NULL;
>     foo_device = NULL;
> 
>     foo_major = register_chrdev(foo_major, "foo", &foo_fops);
>     if (foo_major <= 0)
>         return -EIO;
>     foo_class = class_create(THIS_MODULE, "foo");
>     if (IS_ERR(foo_class))
>        {
>        return PTR_ERR(foo_class);
>        }
>     foo_device = class_device_create(foo_class, NULL, MKDEV(foo_major, 0), NULL, "foo0");
>     if (IS_ERR(foo_device))
>        {
>        return PTR_ERR(foo_device);
>        }
>     return 0;
>     }
> 
> static void __exit foo_exit(void)
>     {
>     if (foo_device && !IS_ERR(foo_device))
>        class_device_del(foo_device);
>     if (foo_class && !IS_ERR(foo_class))
>        class_destroy(foo_class);
>     if (foo_major > 0)
>        unregister_chrdev(foo_major, "foo");
>     }

Yes, this should work just fine.  But as others said, try just using
'device_create' instead, so I don't have to go changing your code in the
next few months when 'struct class_device' finally goes away (it is
being replaced.)

thanks,

greg k-h
