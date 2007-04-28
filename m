Return-Path: <linux-kernel-owner+w=401wt.eu-S1030636AbXD1BEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030636AbXD1BEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXD1BEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:04:39 -0400
Received: from smtpout.mac.com ([17.250.248.171]:57516 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030636AbXD1BEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:04:38 -0400
In-Reply-To: <1177711666.4737.176.camel@nigel.suspend2.net>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <1177711666.4737.176.camel@nigel.suspend2.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 21:03:26 -0400
To: nigel@nigel.suspend2.net
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 27, 2007, at 18:07:46, Nigel Cunningham wrote:
> Hi.
>
> On Fri, 2007-04-27 at 14:44 -0700, Linus Torvalds wrote:
>> It makes it harder to debug (wouldn't it be *nice* to just ssh in,  
>> and do
>> 	gdb -p <snapshotter>
>
> Make the machine being suspended a VM and you can already do that.

>> when something goes wrong?) but we also *depend* on user space for  
>> various things (the same way we depend on kernel threads, and why  
>> it has been such a total disaster to try to freeze the kernel  
>> threads too!). For example, if you want to do graphical stuff,  
>> just using X would be quite nice,  wouldn't it?
>
> But in doing so you make the contents of the disk inconsistent with  
> the state you've just snapshotted, leading to filesystem  
> corruption. Even if you modify filesystems to do checkpointing  
> (which is what we're really talking about), you still also have the  
> problem that your snapshot has to be stored somewhere before you  
> write it to disk, so you also have to either [snip]

Actually, it's a lot simpler than that.  We can just combine the  
device-mapper snapshot with a VM+kernel snapshot system call and be  
almost done:

   sys_snapshot(dev_t snapblockdev, int __user *snapshotfd);

When sys_snapshot is run, the kernel does:

1)  Sequentially freeze mounted filesystems using blockdev freezing.   
If it's an fs that doesn't support freezing then either fail or force- 
remount-ro that fs and downgrade all its filedescriptors to RO.   
Doesn't need extra locking since process which try to do IO either  
succeed before the freeze call returns for that blockdev or sleep on  
the unfreeze of that blockdev.  Filesystems are synchronized and made  
clean.
2)  Iterate over the userspace process list, freezing each process  
and remapping all of its pages copy-on-write.  Any device-specific  
pages need to have state saved by that device.
3)  All processes (except kernel threads) are now frozen.
4)  Kernel should save internal state corresponding to current  
userspace state.  The kernel also swaps out excess pages to free up  
enough RAM and prepares the snapshot file-descriptor with copies of  
kernel memory and the original (pre-COW) mapped userspace pages.
5)  Kernel substitutes filesystems for either a device-mapper  
snapshot with snapblockdev as backing storage or union with tmpfs and  
remounts the underlying filesystems as read-only.
6)  Kernel unfreezes all userspace processes and returns the snapshot  
FD to userspace (where it can be read from).

Then userspace can do whatever it wants.  Any changes to filesystems  
mounted at the time of snapshot will be discarded at shutdown.   
Freshly mounted filesystems won't have the union or COW thing done,  
and so you can write your snapshot to a compressed encrypted file on  
a USB key if you want to, you just have to unmount it before the  
snapshot() syscall and remount it right afterwards.

Cheers,
Kyle Moffett

