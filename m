Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbXG0TqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbXG0TqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbXG0Tpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:45:52 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46523
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbXG0Tpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:45:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Date: Fri, 27 Jul 2007 21:43:59 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
References: <200707271857.24162.mb@bu3sch.de> <200707272130.48973.mb@bu3sch.de> <20070727123853.d16e875c.akpm@linux-foundation.org>
In-Reply-To: <20070727123853.d16e875c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707272143.59551.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 21:38:53 Andrew Morton wrote:
> > > > +static ssize_t ssb_pci_attr_sprom_show(struct device *pcidev,
> > > > +				       struct device_attribute *attr,
> > > > +				       char *buf)
> > > > +{
> > > > +	struct pci_dev *pdev = container_of(pcidev, struct pci_dev, dev);
> > > > +	struct ssb_bus *bus;
> > > > +	u16 *sprom;
> > > > +	int err = -ENODEV;
> > > > +	ssize_t count = 0;
> > > > +
> > > > +	bus = ssb_pci_dev_to_bus(pdev);
> > > > +	if (!bus)
> > > > +		goto out;
> > > > +	err = -ENOMEM;
> > > > +	sprom = kcalloc(SSB_SPROMSIZE_WORDS, sizeof(u16), GFP_KERNEL);
> > > > +	if (!sprom)
> > > > +		goto out;
> > > > +
> > > > +	err = -ERESTARTSYS;
> > > > +	if (mutex_lock_interruptible(&bus->pci_sprom_mutex))
> > > > +		goto out_kfree;
> > > > +	sprom_do_read(bus, sprom);
> > > > +	mutex_unlock(&bus->pci_sprom_mutex);
> > > > +
> > > > +	count = sprom2hex(sprom, buf, PAGE_SIZE);
> > > > +	err = 0;
> > > > +
> > > > +out_kfree:
> > > > +	kfree(sprom);
> > > > +out:
> > > > +	return err ? err : count;
> > > > +}
> > > 
> > > The mutex_lock_interruptible() looks fishy.  Some commented explanation of
> > > what it's doing would be good here.  It's quite unobvious to this reader. 
> > > Cheesy deadlock avoidance?  Hope not.
> > 
> > No, it's simply to avoid writing the SPROM concurrently.
> > SPROM writing is hairy and we must make sure here that
> > we are the only one accessing the whole bus. We do that
> > by suspending all devices and taking a lock to protect
> > the SPROM from write concurrency.
> 
> Sure, but why is the locking interruptible rather than plain old
> mutex_lock()?

Hm, well. We hold this mutex for several seconds, as writing takes
this long. So I simply thought it was worth allowing the waiter
to interrupt here. If you say that's not an issue, I'll be happy
to use mutex_lock() and reduce code complexity in this area.

-- 
Greetings Michael.
