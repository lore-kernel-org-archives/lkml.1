Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYEOTTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYEOTTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYEOTTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:19:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYEOTTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:19:23 -0400
Date: Thu, 15 May 2008 12:18:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: ajones@riverbed.com, a.p.zijlstra@chello.nl, mszeredi@suse.cz,
       akpm@linux-foundation.org, kay.sievers@vrfy.org, greg@kroah.com,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
In-Reply-To: <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0805151213430.3019@woody.linux-foundation.org>
References: <20080513190435.GG23649@ajones-laptop.nbttech.com> <20080514144030.GD6458@ajones-laptop.nbttech.com> <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 May 2008, Miklos Szeredi wrote:
> 
> This is not meant as a final solution, I'm sure Greg or Kay can help
> find a better solution.

Yeah, don't do this:

> +static struct backing_dev_info *dev_get_bdi(struct device *dev)
> +{
> +	mutex_lock(&bdi_dev_mutex);
> +	mutex_unlock(&bdi_dev_mutex);
> +
> +	return dev_get_drvdata(dev);
> +}

This kind of serialization can often hide bugs, and in some cases even 
make them go away (if the caller of the function means that the device is 
pinned and the tear-down cannot happen, for example), but it's really 
really bad form.

In order to use locking in a repeatable manner that is easy to think 
about, you really need to *keep* the lock until you've stopped using the 
data (or have dereferenced it into a stable form - eg maybe accessing the 
pointer itself needs locking, but some individual data read _off_ the 
pointer does not).

So the above kind of "get and release the lock" does obviously serialize 
wrt others that hold the lock, but it's still wrong.

>  static ssize_t read_ahead_kb_store(struct device *dev,
>  				  struct device_attribute *attr,
>  				  const char *buf, size_t count)
>  {
> -	struct backing_dev_info *bdi = dev_get_drvdata(dev);
> +	struct backing_dev_info *bdi = dev_get_bdi(dev);
>  	char *end;
>  	unsigned long read_ahead_kb;
>  	ssize_t ret = -EINVAL;

You should just get the lock in the routines that acually use this thing.

Or, if the "struct backing_dev_info *" pointer itself is stable, and it 
really is just the access from "struct device" that needs protection, then 
at the very least it should have been

	static struct backing_dev_info *dev_get_bdi(struct device *dev)
	{
		struct backing_dev_info *bdi;

		mutex_lock(&bdi_dev_mutex);
		bdi = dev_get_drvdata(dev);
		mutex_unlock(&bdi_dev_mutex);
		return bdi;
	}

which makes it clear that it's the "dev_get_drvdata()" that needs the 
locking, not the bdi pointer itself.

		Linus
