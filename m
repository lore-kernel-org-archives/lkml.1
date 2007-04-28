Return-Path: <linux-kernel-owner+w=401wt.eu-S1030823AbXD1B0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823AbXD1B0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030844AbXD1B0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:26:19 -0400
Received: from smtpout.mac.com ([17.250.248.178]:51412 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030823AbXD1B0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:26:16 -0400
In-Reply-To: <200704280315.29488.rjw@sisk.pl>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177711666.4737.176.camel@nigel.suspend2.net> <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com> <200704280315.29488.rjw@sisk.pl>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <24BD6BB3-46E5-4F00-9FF2-F0A856B8E2EB@mac.com>
Cc: nigel@nigel.suspend2.net, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 21:25:26 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 27, 2007, at 21:15:28, Rafael J. Wysocki wrote:
> On Saturday, 28 April 2007 03:03, Kyle Moffett wrote:
>> On Apr 27, 2007, at 18:07:46, Nigel Cunningham wrote:
>>> But in doing so you make the contents of the disk inconsistent  
>>> with the state you've just snapshotted, leading to filesystem  
>>> corruption. Even if you modify filesystems to do checkpointing  
>>> (which is what we're really talking about), you still also have  
>>> the problem that your snapshot has to be stored somewhere before  
>>> you write it to disk, so you also have to either [snip]
>>
>> When sys_snapshot is run, the kernel does:
>>
>> 1)  Sequentially freeze mounted filesystems using blockdev  
>> freezing.  If it's an fs that doesn't support freezing then either  
>> fail or force-remount-ro that fs and downgrade all its  
>> filedescriptors to RO. Doesn't need extra locking since process  
>> which try to do IO either succeed before the freeze call returns  
>> for that blockdev or sleep on the unfreeze of that blockdev.   
>> Filesystems are synchronized and made clean.
>> 2)  Iterate over the userspace process list, freezing each process  
>> and remapping all of its pages copy-on-write.  Any device-specific  
>> pages need to have state saved by that device.
>
> Why do you want to do 2) after 1) and not vice versa?

(1) can be done without extra locking.  Device-mapper already has  
code to freeze filesystems and that makes a natural process-stopping  
point.  Any threads doing IO will very quickly put themselves to  
sleep at (1) and save us some effort during step 2.

>> 6)  Kernel unfreezes all userspace processes and returns the  
>> snapshot FD to userspace (where it can be read from).
>
> Okay, but how do we do the error recovery if, for example, the  
> image cannot be saved?

If the image can't be saved then there are 2 options:
   (1)  Call sys_restore() with the image
   (2)  Pass your snapshot file-descriptor to sys_unsnapshot()

In the former case, the system will be restored to the state it was  
at a few seconds earlier, right as it took the snapshot.  In the  
latter case the modified-in-memory snapshot pages will be synced back  
to the disk filesystems, the copy-on-write data-structures torn down  
(think of merging an LVM snapshot back into its base device), and the  
memory allocated for the snapshot will be freed.  Either way the  
system is properly in sync with disk again, the only difference is  
whether you want to preserve the userspace state from during the  
attempted snapshot (IE: any error status).  You could also save the  
error state in case (1) by just auto-posting a bug-report on http:// 
bugs.$VENDOR.com/ of course :-D.

Cheers,
Kyle Moffett

