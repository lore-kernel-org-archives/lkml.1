Return-Path: <linux-kernel-owner+w=401wt.eu-S1030752AbXD1BLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030752AbXD1BLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030773AbXD1BLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:11:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59518 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030752AbXD1BLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:11:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 03:15:28 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177711666.4737.176.camel@nigel.suspend2.net> <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com>
In-Reply-To: <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280315.29488.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 03:03, Kyle Moffett wrote:
> On Apr 27, 2007, at 18:07:46, Nigel Cunningham wrote:
> > Hi.
> >
> > On Fri, 2007-04-27 at 14:44 -0700, Linus Torvalds wrote:
> >> It makes it harder to debug (wouldn't it be *nice* to just ssh in,  
> >> and do
> >> 	gdb -p <snapshotter>
> >
> > Make the machine being suspended a VM and you can already do that.
> 
> >> when something goes wrong?) but we also *depend* on user space for  
> >> various things (the same way we depend on kernel threads, and why  
> >> it has been such a total disaster to try to freeze the kernel  
> >> threads too!). For example, if you want to do graphical stuff,  
> >> just using X would be quite nice,  wouldn't it?
> >
> > But in doing so you make the contents of the disk inconsistent with  
> > the state you've just snapshotted, leading to filesystem  
> > corruption. Even if you modify filesystems to do checkpointing  
> > (which is what we're really talking about), you still also have the  
> > problem that your snapshot has to be stored somewhere before you  
> > write it to disk, so you also have to either [snip]
> 
> Actually, it's a lot simpler than that.  We can just combine the  
> device-mapper snapshot with a VM+kernel snapshot system call and be  
> almost done:
> 
>    sys_snapshot(dev_t snapblockdev, int __user *snapshotfd);
> 
> When sys_snapshot is run, the kernel does:
> 
> 1)  Sequentially freeze mounted filesystems using blockdev freezing.   
> If it's an fs that doesn't support freezing then either fail or force- 
> remount-ro that fs and downgrade all its filedescriptors to RO.   
> Doesn't need extra locking since process which try to do IO either  
> succeed before the freeze call returns for that blockdev or sleep on  
> the unfreeze of that blockdev.  Filesystems are synchronized and made  
> clean.
> 2)  Iterate over the userspace process list, freezing each process  
> and remapping all of its pages copy-on-write.  Any device-specific  
> pages need to have state saved by that device.

Why do you want to do 2) after 1) and not vice versa?

> 3)  All processes (except kernel threads) are now frozen.
> 4)  Kernel should save internal state corresponding to current  
> userspace state.  The kernel also swaps out excess pages to free up  
> enough RAM and prepares the snapshot file-descriptor with copies of  
> kernel memory and the original (pre-COW) mapped userspace pages.
> 5)  Kernel substitutes filesystems for either a device-mapper  
> snapshot with snapblockdev as backing storage or union with tmpfs and  
> remounts the underlying filesystems as read-only.
> 6)  Kernel unfreezes all userspace processes and returns the snapshot  
> FD to userspace (where it can be read from).

Okay, but how do we do the error recovery if, for example, the image cannot
be saved?

> Then userspace can do whatever it wants.  Any changes to filesystems  
> mounted at the time of snapshot will be discarded at shutdown.   
> Freshly mounted filesystems won't have the union or COW thing done,  
> and so you can write your snapshot to a compressed encrypted file on  
> a USB key if you want to, you just have to unmount it before the  
> snapshot() syscall and remount it right afterwards.

This seems to be a good idea.

Greetings,
Rafael
