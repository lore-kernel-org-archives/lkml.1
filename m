Return-Path: <linux-kernel-owner+w=401wt.eu-S1030818AbXD1B1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818AbXD1B1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXD1B1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:27:12 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:57475 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1030818AbXD1B1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:27:10 -0400
Date: Fri, 27 Apr 2007 17:51:14 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kyle Moffett <mrmacman_g4@mac.com>, nigel@nigel.suspend2.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280315.29488.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0704271748320.10565@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <1177711666.4737.176.camel@nigel.suspend2.net>  <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com>
 <200704280315.29488.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:

> On Saturday, 28 April 2007 03:03, Kyle Moffett wrote:
>> On Apr 27, 2007, at 18:07:46, Nigel Cunningham wrote:
>>> Hi.
>>>
>>> On Fri, 2007-04-27 at 14:44 -0700, Linus Torvalds wrote:
>>>> It makes it harder to debug (wouldn't it be *nice* to just ssh in,
>>>> and do
>>>> 	gdb -p <snapshotter>
>>>
>>> Make the machine being suspended a VM and you can already do that.
>>
>>>> when something goes wrong?) but we also *depend* on user space for
>>>> various things (the same way we depend on kernel threads, and why
>>>> it has been such a total disaster to try to freeze the kernel
>>>> threads too!). For example, if you want to do graphical stuff,
>>>> just using X would be quite nice,  wouldn't it?
>>>
>>> But in doing so you make the contents of the disk inconsistent with
>>> the state you've just snapshotted, leading to filesystem
>>> corruption. Even if you modify filesystems to do checkpointing
>>> (which is what we're really talking about), you still also have the
>>> problem that your snapshot has to be stored somewhere before you
>>> write it to disk, so you also have to either [snip]
>>
>> Actually, it's a lot simpler than that.  We can just combine the
>> device-mapper snapshot with a VM+kernel snapshot system call and be
>> almost done:
>>
>>    sys_snapshot(dev_t snapblockdev, int __user *snapshotfd);
>>
>> When sys_snapshot is run, the kernel does:
>>
>> 1)  Sequentially freeze mounted filesystems using blockdev freezing.
>> If it's an fs that doesn't support freezing then either fail or force-
>> remount-ro that fs and downgrade all its filedescriptors to RO.
>> Doesn't need extra locking since process which try to do IO either
>> succeed before the freeze call returns for that blockdev or sleep on
>> the unfreeze of that blockdev.  Filesystems are synchronized and made
>> clean.
>> 2)  Iterate over the userspace process list, freezing each process
>> and remapping all of its pages copy-on-write.  Any device-specific
>> pages need to have state saved by that device.
>
> Why do you want to do 2) after 1) and not vice versa?

it doesn't really need to matter. if you care, just arrange to not schedule user 
processes while you are doing both steps.

>> 3)  All processes (except kernel threads) are now frozen.
>> 4)  Kernel should save internal state corresponding to current
>> userspace state.  The kernel also swaps out excess pages to free up
>> enough RAM and prepares the snapshot file-descriptor with copies of
>> kernel memory and the original (pre-COW) mapped userspace pages.
>> 5)  Kernel substitutes filesystems for either a device-mapper
>> snapshot with snapblockdev as backing storage or union with tmpfs and
>> remounts the underlying filesystems as read-only.
>> 6)  Kernel unfreezes all userspace processes and returns the snapshot
>> FD to userspace (where it can be read from).
>
> Okay, but how do we do the error recovery if, for example, the image cannot
> be saved?

give the user an error message telling him this, wait for confirmation, and then 
jump directly to the restore step. revert everything to the snapshot image(s), 
restart it.

David Lang
