Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZCKEi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZCKEi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZCKEhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:37:53 -0400
Received: from kroah.org ([198.145.64.141]:57798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751659AbZCKEhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:37:51 -0400
Date: Tue, 10 Mar 2009 21:34:31 -0700
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 4/7] PCI: add SR-IOV API for Physical Function
	driver
Message-ID: <20090311043431.GB25746@kroah.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-5-git-send-email-yu.zhao@intel.com> <20090306203717.GG25995@parisc-linux.org> <20090309082505.GC4638@yzhao-otc.sh.intel.com> <20090309193901.GA15011@kroah.com> <20090310013753.GC5063@yzhao-otc.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310013753.GC5063@yzhao-otc.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 09:37:53AM +0800, Yu Zhao wrote:
> On Tue, Mar 10, 2009 at 03:39:01AM +0800, Greg KH wrote:
> > On Mon, Mar 09, 2009 at 04:25:05PM +0800, Yu Zhao wrote:
> > > > > +	pci_device_add(virtfn, virtfn->bus);
> > > > 
> > > > Greg is probably going to ding you here for adding the device, then
> > > > creating the symlinks.  I believe it's now best practice to create the
> > > > symlinks first, so there's no window where userspace can get confused.
> > > 
> > > Yes, but unfortunately we can't create links before adding a device.
> > > I double checked device_add(), there is no place for those links to be
> > > created before it sends uevent. So for now, we have to trigger another
> > > uevent for those links.
> > 
> > What exactly are you trying to do with a symlink here that you need to
> > do it this way?  I vaguely remember you mentioning this in the past, but
> > I thought you had dropped the symlinks after our conversation about this
> > very problem.
> 
> I'd like to create some symlinks to reflect the relationship between
> Physical Function and its associated Virtual Functions. The Physical
> Function is like a master device that controls the allocation of its
> Virtual Functions and owns the device physical resource. The Virtual
> Functions are like slave devices of the Physical Function. For example,
> if 01:00.0 is a Physical Function and 02:00.0 is a Virtual Function
> associated with 01:00.0. Then the symlinks (virtfnN and physfn) would
> look like:
> 
>   $ ls -l /sys/bus/pci/devices/0000:01:00.0/
>   ...
>   ...  virtfn0 -> ../0000:02:00.0
>   ...  virtfn1 -> ../0000:02:00.1
>   ...  virtfn2 -> ../0000:02:00.2
>   ...
> 
>   $ ls -l /sys/bus/pci/devices/0000:02:00.0/
>   ...
>   ... physfn -> ../0000:01:00.0
>   ...
> 
> This is very useful for userspace applications, both KVM and Xen need
> to know this kind of relationship so they can request the permission
> from a Physical Function before using its associated Virtual Functions.

Ok, but then make sure you never rely on a udev rule or notifier to see
these symlinks when the device is added to the kernel, as there will be
a nice race condition there :)

thanks,

greg k-h
