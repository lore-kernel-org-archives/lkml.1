Return-Path: <linux-kernel-owner+w=401wt.eu-S933838AbXG0TkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbXG0TkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbXG0TkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:40:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215AbXG0TkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:40:05 -0400
Date: Fri, 27 Jul 2007 12:38:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070727123853.d16e875c.akpm@linux-foundation.org>
In-Reply-To: <200707272130.48973.mb@bu3sch.de>
References: <200707271857.24162.mb@bu3sch.de>
	<20070727120318.54d18cfc.akpm@linux-foundation.org>
	<200707272130.48973.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 21:30:48 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> > ERROR: "foo * bar" should be "foo *bar"
> > #4156: FILE: drivers/ssb/ssb_private.h:119:
> > +extern struct ssb_bus * ssb_pci_dev_to_bus(struct pci_dev *pdev);
> > 
> > are worth addressing.
> 
> Well, I intentionally wrote that this way, as in my opinion
> it it easier to read. I only use this additional space for
> functions returning a pointer.
> 
> struct foo * function(int a, int b);
> 
> vs:
> 
> struct foo *function(int a, int b);
> 
> But I can change that, if that's really an issue and a
> style violation.

It's a microissue but yeah, no-space is more conventional.

> > > +static ssize_t ssb_pci_attr_sprom_show(struct device *pcidev,
> > > +				       struct device_attribute *attr,
> > > +				       char *buf)
> > > +{
> > > +	struct pci_dev *pdev = container_of(pcidev, struct pci_dev, dev);
> > > +	struct ssb_bus *bus;
> > > +	u16 *sprom;
> > > +	int err = -ENODEV;
> > > +	ssize_t count = 0;
> > > +
> > > +	bus = ssb_pci_dev_to_bus(pdev);
> > > +	if (!bus)
> > > +		goto out;
> > > +	err = -ENOMEM;
> > > +	sprom = kcalloc(SSB_SPROMSIZE_WORDS, sizeof(u16), GFP_KERNEL);
> > > +	if (!sprom)
> > > +		goto out;
> > > +
> > > +	err = -ERESTARTSYS;
> > > +	if (mutex_lock_interruptible(&bus->pci_sprom_mutex))
> > > +		goto out_kfree;
> > > +	sprom_do_read(bus, sprom);
> > > +	mutex_unlock(&bus->pci_sprom_mutex);
> > > +
> > > +	count = sprom2hex(sprom, buf, PAGE_SIZE);
> > > +	err = 0;
> > > +
> > > +out_kfree:
> > > +	kfree(sprom);
> > > +out:
> > > +	return err ? err : count;
> > > +}
> > 
> > The mutex_lock_interruptible() looks fishy.  Some commented explanation of
> > what it's doing would be good here.  It's quite unobvious to this reader. 
> > Cheesy deadlock avoidance?  Hope not.
> 
> No, it's simply to avoid writing the SPROM concurrently.
> SPROM writing is hairy and we must make sure here that
> we are the only one accessing the whole bus. We do that
> by suspending all devices and taking a lock to protect
> the SPROM from write concurrency.

Sure, but why is the locking interruptible rather than plain old
mutex_lock()?

