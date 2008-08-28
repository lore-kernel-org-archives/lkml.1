Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbYH1Ru4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbYH1Ru4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYH1Rus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:50:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYH1Rur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:50:47 -0400
Date: Thu, 28 Aug 2008 10:48:07 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert
	cdev_alloc() to use it
Message-ID: <20080828174807.GA18461@kroah.com>
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com> <48B6E417.5030605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6E417.5030605@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 07:44:55PM +0200, Tejun Heo wrote:
> Greg KH wrote:
> > On Thu, Aug 28, 2008 at 06:56:48PM +0200, Tejun Heo wrote:
> >> Greg KH wrote:
> >>> Ick, I really don't want struct cdev to be used for lifecycle
> >>> management, as it is only for major:minor stuff.  Why do you want to
> >>> make this change?
> >> Well, as cdev can be referenced from userspace, ->release is required
> >> for most purposes.  The reason why devices have been getting by without
> >> it is because most chardevs are created on module load and destroyed on
> >> module unload and in the meantime cdev refcount virtually equals module
> >> refcnt, but I'm fairly sure we have cases where cdev can be destroyed
> >> for other reasons then module unloading and it's very likely those cases
> >> are buggy in the current code (backing structure gone bug cdev still
> >> hanging around).
> > 
> > Hm, I thought Al covered that when he created the cdev interface, I
> > would be a bit supprised if this was the case.
> 
> Hmmm.... I've never actually audited the code so... it could be that no
> chardev is created and destroyed that way, I guess.
> 
> >> As CUSE can create and destroy devices regardless of module reference
> >> count, it falls in the second category and needs cdev->release() to make
> >> sure the backing structure doesn't go away till cdev is released.
> > 
> > But CUSE should be it's own module, right?  And it would "own" the cdev,
> > so the module and cdev count should be fine and matching.  The userspace
> > code could go away but the CUSE code should handle that with a different
> > reference count.  This is the way that hardware drivers handle the
> > issue.
> 
> The problem is not the device to talk to CUSE (/dev/cuse as in
> /dev/fuse), for which module refcount and device refcount match fine.
> But the whole point of CUSE is allowing CUSE clients to create arbitrary
> character devices, so in addition to /dev/cuse which clients use to talk
> to CUSE, CUSE hosts character devices for its clients and they come and
> go dynamically and thus requires proper lifetime management.

That's fine, it's just like a USB device that uses a cdev, right?  Or a
PCI device, or any other type of device that can come and go independant
of the cdev or module lifespan.

So, you tie the cdev lifespan to the module lifespan with the
MODULE_OWNER in the file operations.  As the cuse.ko module will own the
cdev, it can handle that reference, and it can not be removed as long as
userspace has the cdev open, right?

It really isn't any different from any other type of removable device
(i.e. any type of device...)

thanks,

greg k-h
