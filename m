Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZGWC1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZGWC1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZGWC1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:27:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35457 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZGWC1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:27:43 -0400
Subject: Re: Memory leak issues in drm
From: Dave Airlie <airlied@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, catalin.marinas@arm.com,
       airlied@gmail.com, linux-kernel@vger.kernel.org, eric@anholt.net
In-Reply-To: <20090722170226.c5becf38.akpm@linux-foundation.org>
References: <1247720877.2532.4.camel@ht.satnam>
	 <1247728158.2543.4.camel@ht.satnam>
	 <20090722170226.c5becf38.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 12:15:14 +1000
Message-Id: <1248315314.8960.5.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 17:02 -0700, Andrew Morton wrote:
> On Thu, 16 Jul 2009 12:39:18 +0530
> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Thu, 2009-07-16 at 10:37 +0530, Jaswinder Singh Rajput wrote:
> > > On linus tree, while investigating kmemleak issues in drm :
> > > 
> > > unreferenced object 0xf571dea0 (size 32):
> > >   comm "Xorg", pid 1992, jiffies 4294703188
> > >   backtrace:
> > >     [<c1096655>] create_object+0x140/0x210
> > >     [<c10967f2>] kmemleak_alloc+0x25/0x4b
> > >     [<c1093b63>] __kmalloc+0xcb/0x153
> > >     [<c11ae939>] drm_setversion+0x154/0x1f6
> > >     [<c11ad0b1>] drm_ioctl+0x211/0x296
> > >     [<c10a2dc9>] vfs_ioctl+0x50/0x69
> > >     [<c10a3321>] do_vfs_ioctl+0x49b/0x4d5
> > >     [<c10a3387>] sys_ioctl+0x2c/0x45
> > >     [<c1002988>] sysenter_do_call+0x12/0x36
> > >     [<ffffffff>] 0xffffffff
> > > 
> > 
> > This fixes above memory leak in drm because it was allocating again on
> > dev->devname without freeing previous instance and more memory related
> > issues, hope this will be helpful:
> > 
> > diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> > index 9b9ff46..b39ab86 100644
> > --- a/drivers/gpu/drm/drm_ioctl.c
> > +++ b/drivers/gpu/drm/drm_ioctl.c
> > @@ -96,25 +96,36 @@ int drm_setunique(struct drm_device *dev, void *data,
> 
> drm_setunique() is pretty crappy.  It has a number of places where it
> does some resource freeing and then a `return' and other places where
> it does the usual `goto out_free' thing.

Generally I try to avoid doing things to this function as it has great 
potential for breaking the X server badly, this definitely won't be a
fix I'd put in for this release.

I'll get some time to clean it up for drm-next.

Dave

> 
> I do think that converting this function to the usual
> single-return-statement model would simplify it and would reduce the
> chances of additional resource leaks being added in the future.
> 
> The basic pattern (which is applicable here) is:
> 
> foo()
> {
> 	if (!simple test)
> 		return -EFOO;
> 	if (!simple_test_2)
> 		return -EBAR;
> 
> 	foo = allocate_something();
> 
> 	if (test3)
> 		goto fail_foo;
> 
> 	bar = allocate_something_else();
> 
> 	if (test4)
> 		goto fail_bar;
> 
> 	...
> 
> 	return 0;		/* success */
> 
> fail_bar:
> 	deallocate(bar);
> fail_foo:
> 	deallocate(foo);
> 
> 	return err;
> }
> 
> >  	master->unique = kmalloc(master->unique_size, GFP_KERNEL);
> >  	if (!master->unique)
> >  		return -ENOMEM;
> > -	if (copy_from_user(master->unique, u->unique, master->unique_len))
> > +	if (copy_from_user(master->unique, u->unique, master->unique_len)) {
> > +		kfree(master->unique);
> > +		master->unique_len = 0;
> >  		return -EFAULT;
> > +	}
> >  
> >  	master->unique[master->unique_len] = '\0';
> >  
> > +	/* Free previous dev->devname, if exists */
> > +	if (dev->devname)
> > +		kfree(dev->devname);
> 
> kfree(NULL) is legal and will simplify and shorten the code here.
> 
> >  	dev->devname = kmalloc(strlen(dev->driver->pci_driver.name) +
> >  			       strlen(master->unique) + 2, GFP_KERNEL);
> > -	if (!dev->devname)
> > +	if (!dev->devname) {
> > +		kfree(master->unique);
> > +		master->unique_len = 0;
> >  		return -ENOMEM;
> > +	}
> >  
> >  	sprintf(dev->devname, "%s@%s", dev->driver->pci_driver.name,
> >  		master->unique);
> >  
> > -	/* Return error if the busid submitted doesn't match the device's actual
> > +	/*
> > +	 * Return error if the busid submitted doesn't match the device's actual
> >  	 * busid.
> >  	 */
> >  	ret = sscanf(master->unique, "PCI:%d:%d:%d", &bus, &slot, &func);
> >  	if (ret != 3)
> > -		return -EINVAL;
> > +		goto error;
> > +
> >  	domain = bus >> 8;
> >  	bus &= 0xff;
> >  
> > @@ -122,9 +133,15 @@ int drm_setunique(struct drm_device *dev, void *data,
> >  	    (bus != dev->pdev->bus->number) ||
> >  	    (slot != PCI_SLOT(dev->pdev->devfn)) ||
> >  	    (func != PCI_FUNC(dev->pdev->devfn)))
> > -		return -EINVAL;
> > +		goto error;
> >  
> >  	return 0;
> > +
> > +error:
> > +	kfree(dev->devname);
> > +	kfree(master->unique);
> > +
> > +	return -EINVAL;
> >  }
> >  
> >  static int drm_set_busid(struct drm_device *dev, struct drm_file *file_priv)
> > @@ -136,25 +153,35 @@ static int drm_set_busid(struct drm_device *dev, struct drm_file *file_priv)
> >  		return -EBUSY;
> >  
> >  	master->unique_len = 40;
> > -	master->unique_size = master->unique_len;
> > +	master->unique_size = master->unique_len + 1;
> >  	master->unique = kmalloc(master->unique_size, GFP_KERNEL);
> >  	if (master->unique == NULL)
> >  		return -ENOMEM;
> >  
> > -	len = snprintf(master->unique, master->unique_len, "pci:%04x:%02x:%02x.%d",
> > +	/*
> > +	 * Using sprintf as it will return number of characters
> > +	 * (not including the trailing '\0')
> > +	 */
> > +	len = sprintf(master->unique, "pci:%04x:%02x:%02x.%d",
> >  		       drm_get_pci_domain(dev),
> >  		       dev->pdev->bus->number,
> >  		       PCI_SLOT(dev->pdev->devfn),
> >  		       PCI_FUNC(dev->pdev->devfn));
> > -	if (len >= master->unique_len)
> > +	if (len > master->unique_len)
> >  		DRM_ERROR("buffer overflow");
> >  	else
> >  		master->unique_len = len;
> >  
> > +	/* Free previous dev->devname, if exists */
> > +	if (dev->devname)
> > +		kfree(dev->devname);
> 
> and here.
> 
> >  	dev->devname = kmalloc(strlen(dev->driver->pci_driver.name) +
> >  			       master->unique_len + 2, GFP_KERNEL);
> > -	if (dev->devname == NULL)
> > +	if (dev->devname == NULL) {
> > +		kfree(master->unique);
> > +		master->unique_len = 0;
> >  		return -ENOMEM;
> > +	}
> >  
> >  	sprintf(dev->devname, "%s@%s", dev->driver->pci_driver.name,
> >  		master->unique);
> > 

