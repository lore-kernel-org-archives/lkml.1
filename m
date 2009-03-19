Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZCSQb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZCSQb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZCSQbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:31:03 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:15834 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbZCSQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:31:01 -0400
Date: Thu, 19 Mar 2009 10:30:58 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v4 08/12] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-ID: <20090319163058.GB8074@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224006.887.91805.stgit@bob.kio> <20090319024334.59e9e9bc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319024334.59e9e9bc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 18 Mar 2009 16:40:06 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
> > This patch adds an attribute named "remove" to a PCI device's sysfs
> > directory.  Writing a non-zero value to this attribute will remove the PCI
> > device and any children of it.
> > 
> > Trent Piepho wrote the original implementation and documentation.
> > 
> > Thanks to Vegard Nossum for testing under kmemcheck and finding locking
> > issues with the sysfs interface.
> > 
> > ...
> >
> > --- a/drivers/pci/pci-sysfs.c
> > +++ b/drivers/pci/pci-sysfs.c
> > @@ -246,6 +246,47 @@ struct bus_attribute pci_bus_attrs[] = {
> >  	__ATTR(rescan, S_IWUSR, NULL, bus_rescan_store),
> >  	__ATTR_NULL
> >  };
> > +
> > +static void remove_callback(struct device *dev)
> > +{
> > +	int bridge = 0;
> > +	struct pci_dev *pdev = to_pci_dev(dev);
> > +
> > +	mutex_lock(&pci_remove_rescan_mutex);
> > +
> > +	if (pdev->subordinate)
> > +		bridge = 1;
> > +
> > +	pci_remove_bus_device(pdev);
> > +	if (bridge && list_empty(&pdev->bus->devices))
> > +		pci_remove_bus(pdev->bus);
> > +
> > +	mutex_unlock(&pci_remove_rescan_mutex);
> > +}
> > +
> > +static ssize_t
> > +remove_store(struct device *dev, struct device_attribute *dummy,
> > +	     const char *buf, size_t count)
> > +{
> > +	int ret = 0;
> > +	unsigned long val;
> > +	struct pci_dev *pdev = to_pci_dev(dev);
> > +
> > +	if (strict_strtoul(buf, 0, &val) < 0)
> > +		return -EINVAL;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	if (pdev->subordinate && pci_is_root_bus(pdev->bus))
> > +		return -EBUSY;
> > +
> > +	if (val)
> > +		ret = device_schedule_callback(dev, remove_callback);
> > +	if (ret)
> > +		count = ret;
> > +	return count;
> > +}
> >  #endif
> 
> It is very hard for the reader (this one at least) to work out why
> device_schedule_callback() is used here, instead of simply doing the work
> directly.
> 
> The way to solve that problem is to add a code comment.

Hm, I thought it was well-known that a sysfs attribute cannot
remove itself without deadlocking. Thus, we need to use this
callback mechanism.

This thread has the most recent discussion:

	http://thread.gmane.org/gmane.linux.kernel/805033

I will add a comment to the code.

> Given that we're in a sysfs write() handler where no relevant locks at all
> are held, it seems rather weird that we cannot perform this operation
> synchronously, but no doubt the comment will explain all of this.
> 
> Do we need the CAP_SYS_ADMIN check if the sysfs file permissions are
> correct?  (I keep on asking this then forgetting the answer).

I will remove this (as per Greg's advice in a later mail).

> The device_schedule_callback() thing exposes us to (I assume) a pile of
> races, the most obvious of which is "what locking or refcounting keeps
> *dev alive?".  It would be nice to see an analysis/description of the
> lifetime issues here.  Perhaps in the changelog, preferably in code
> comments.

No races; device_schedule_callback() takes a ref on dev, pinning
it until the callback handler returns, after which it releases
the ref. You can see this in sysfs_schedule_callback.

Thanks for the review.

/ac

