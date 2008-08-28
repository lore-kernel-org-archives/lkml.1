Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYH1SXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYH1SXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbYH1SW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:22:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYH1SW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:22:56 -0400
Date: Thu, 28 Aug 2008 11:17:20 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert
	cdev_alloc() to use it
Message-ID: <20080828181720.GB23898@kroah.com>
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com> <48B6E417.5030605@kernel.org> <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6E69B.1090800@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 07:55:39PM +0200, Tejun Heo wrote:
> Greg KH wrote:
> >> The problem is not the device to talk to CUSE (/dev/cuse as in
> >> /dev/fuse), for which module refcount and device refcount match fine.
> >> But the whole point of CUSE is allowing CUSE clients to create arbitrary
> >> character devices, so in addition to /dev/cuse which clients use to talk
> >> to CUSE, CUSE hosts character devices for its clients and they come and
> >> go dynamically and thus requires proper lifetime management.
> > 
> > That's fine, it's just like a USB device that uses a cdev, right?  Or a
> > PCI device, or any other type of device that can come and go independant
> > of the cdev or module lifespan.
> > 
> > So, you tie the cdev lifespan to the module lifespan with the
> > MODULE_OWNER in the file operations.  As the cuse.ko module will own the
> > cdev, it can handle that reference, and it can not be removed as long as
> > userspace has the cdev open, right?
> > 
> > It really isn't any different from any other type of removable device
> > (i.e. any type of device...)
> 
> Ah.. right, but taking cdev refcount out of the picture requires adding
> 'severing' operation on cdev f_ops, which certainly is doable but isn't
> it just cleaner to make cdev follow the usual lifetime management rules?
>  An object which is referenced counted requires ->release if it's gonna
> be used in any non-simplistic way.

Yes, but as you "normally" tie the cdev to the module itself, that
handles the lifetime rules.

Now I really dont' like the current cdev interface, it's a bit too
complex as it needed to support the old-style interfaces without any
build time changes, but I think your change isn't needed as somehow all
the current drivers that support dynamic devices don't need it.

Actually, the kobject in cdev shouldn't be an kobject, it's not used for
registering with sysfs at all, it should just be a kref.  I sweep the
tree for code that sets the name of the cdev every few months as people
don't seem to realize this :)

thanks,

greg k-h
