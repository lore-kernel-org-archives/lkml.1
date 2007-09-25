Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbXIYWRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbXIYWRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXIYWRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:17:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36032 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXIYWRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:17:45 -0400
Date: Tue, 25 Sep 2007 15:17:36 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
	model
Message-ID: <20070925221736.GA3566@kroah.com>
References: <11902755392688-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 05:05:39PM +0900, Tejun Heo wrote:
> Subject: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver model
> 
> Hello, all.
> 
> This is the third patchset of four sysfs update patchset series[1] and
> to be applied on top of the second patchset[2].
> 
> Currently, sysfs interface is based on kobj.  This made more sense
> before because lifetime of sysfs nodes were tracked using kobj
> reference counts.  However, this is no longer true.  sysfs nodes are
> represented with a sysfs_dirent and external reference is severed
> immediately on node removal.  The internal implementation reflects
> that too and mostly handles sysfs_dirents.
> 
> This patchset divorces sysfs from kobject and driver model by
> implementing sysfs_dirent based interface.  This has the following
> advantages.
> 
> * sysfs becomes a separate module and driver model becomes a user of
>   sysfs.  Those two are not entangled anymore.  Things are easier to
>   understand and test this way.

This is good, I like this.

> * Non-driver model users of sysfs (modules, blkdev, etc...) don't have
>   to jump through hoops to use sysfs.  kobj based interface requires
>   attribute wrapping and is awkward to use directly.  Also, the user
>   is required to create a dummy kobj which doesn't serve much purpose
>   than being a token for sysfs reference.  New sysfs-dirent based
>   interface is straight forward proc-fs like interface and should be
>   easier and more intuitive for those users.

This is not good, I don't like this :(

As we spoke a few weeks ago, the non-driver model users of sysfs are ok.
Yes, it's not trivial to use sysfs in this manner, and it should be made
easier, but we still need to keep our tree of objects.  Using a kobject
for sysfs access is a good thing as it provides a tiny grasp on keeping
the usage of sysfs under control.

So while I like the separation of sysfs and kobjects from an
architectural and conceptual level for testing and understanding, I do
not want to allow the use of sysfs without creating a backing kobject
like we do today.

I'm all for making the "raw" kobject access easier, cleaning up the
attribute "mess" that you need to go through.  The cleanups that Kay and
I have been doing in the kset and subsystem area are steps in that
direction and I have more I want to do there to help make it easier to
use and understand.

So, I'll try to pick and choose from this patchset what I feel is ok for
now.

Or does it depend on the second set of patches that are yet to be
applied due to disagreements about module lifetimes?

thanks,

greg k-h
