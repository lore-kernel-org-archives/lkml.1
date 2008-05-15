Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbYEOT2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbYEOT2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYEOT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:28:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47477 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYEOT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:28:16 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, ajones@riverbed.com, a.p.zijlstra@chello.nl,
       mszeredi@suse.cz, akpm@linux-foundation.org, kay.sievers@vrfy.org,
       greg@kroah.com, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org
In-reply-to: <alpine.LFD.1.10.0805151213430.3019@woody.linux-foundation.org>
	(message from Linus Torvalds on Thu, 15 May 2008 12:18:57 -0700 (PDT))
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
References: <20080513190435.GG23649@ajones-laptop.nbttech.com> <20080514144030.GD6458@ajones-laptop.nbttech.com> <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151213430.3019@woody.linux-foundation.org>
Message-Id: <E1Jwj7G-0007Zs-GB@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 May 2008 21:27:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 15 May 2008, Miklos Szeredi wrote:
> > 
> > This is not meant as a final solution, I'm sure Greg or Kay can help
> > find a better solution.
> 
> Yeah, don't do this:
> 
> > +static struct backing_dev_info *dev_get_bdi(struct device *dev)
> > +{
> > +	mutex_lock(&bdi_dev_mutex);
> > +	mutex_unlock(&bdi_dev_mutex);
> > +
> > +	return dev_get_drvdata(dev);
> > +}
> 
> This kind of serialization can often hide bugs, and in some cases even 
> make them go away (if the caller of the function means that the device is 
> pinned and the tear-down cannot happen, for example), but it's really 
> really bad form.

Yeah, I know.

> In order to use locking in a repeatable manner that is easy to think 
> about, you really need to *keep* the lock until you've stopped using the 
> data (or have dereferenced it into a stable form - eg maybe accessing the 
> pointer itself needs locking, but some individual data read _off_ the 
> pointer does not).
> 
> So the above kind of "get and release the lock" does obviously serialize 
> wrt others that hold the lock, but it's still wrong.
> 
> >  static ssize_t read_ahead_kb_store(struct device *dev,
> >  				  struct device_attribute *attr,
> >  				  const char *buf, size_t count)
> >  {
> > -	struct backing_dev_info *bdi = dev_get_drvdata(dev);
> > +	struct backing_dev_info *bdi = dev_get_bdi(dev);
> >  	char *end;
> >  	unsigned long read_ahead_kb;
> >  	ssize_t ret = -EINVAL;
> 
> You should just get the lock in the routines that acually use this thing.
> 
> Or, if the "struct backing_dev_info *" pointer itself is stable, and it 
> really is just the access from "struct device" that needs protection, then 
> at the very least it should have been

Actually nothing should need protection.  The only problem AFAICS is
that the device_create()/dev_set_drvdata() interface is racy: somebody
can come in after the device has been created but before drvdata has
been set, and then we are in trouble.

I'm quite sure this is not the only place in the kernel where this
would be an issue, that's why I expect the sysfs guys to have some
sort of alternative solution, that doesn't necessarily involve adding
a new mutex.

Miklos
