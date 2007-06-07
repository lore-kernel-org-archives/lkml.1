Return-Path: <linux-kernel-owner+w=401wt.eu-S933292AbXFGQCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbXFGQCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933015AbXFGQBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:01:46 -0400
Received: from rtr.ca ([64.26.128.89]:3147 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857AbXFGQBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:01:45 -0400
Message-ID: <46682BE7.6080802@rtr.ca>
Date: Thu, 07 Jun 2007 12:01:43 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org>
In-Reply-To: <20070607084142.42583639.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 07 Jun 2007 09:44:24 -0400 Mark Lord <lkml@rtr.ca> wrote:
..
>> 2. When I trigger the shutdown whilst this is happening, Myth gets
>> killed off, and so the unlinked file is automatically closed.
>> and the kernel (filesystem) code begins finishing the delete operation.
>>
>> 3. The shutdown scripts do their thing quickly, so the delete is
>> *still* underway when the umount commands are issued.
>> On this system, I use this sequence:
>>
>>   ## /var/lib/mythtv is the recording's ext3fs, on /dev/md0 (RAID0):
> 
> I assume the applikcaton has already been killed at this stage, and it is
> blocked in the kernel running the truncate?

Yes, I believe I saw that once.

>>    mount /var/lib/mythtv -oremount,ro
>>    sync
>>    umount /var/lib/mythtv
> 
> Did this succeed?  If the application is still truncating that file, the
> umount should have failed.

Actually, what I expect to happen is for the remount,ro
to block  until the file deletion completes.  But it doesn't.

Once a f/s is read-only, there should be NO writing to it.  Right?

I don't know if the umount worked or not, but the f/s ought to be
read-only at this point, so why is it still writing to the device?

I'll instrument the shutdown more for next time, to see if the remount
and umount really do succeed or not.  Mmm.. do they log anything on failure?

>>    sync
>>    mount / -oremount,ro
>>    sync
>>    sleep 1
>>    hdparm -W0 /dev/sda /dev/sdb
>>    sync
>>    sleep 2
>>    halt -f -p
>>
>> 4. The hard drive light is on solid throughout, including at the point
>> when the power goes out.
>>
>> 5. On the next reboot, there is a LONG pause (20-30 seconds) at the
>> point where /var/lib/mythtv is remounted --> indicating unfinished business
>> from the journal file that needs to be replayed (eg. the file deletion).
> 
> That opened-but-deleted file's inode is on the orphan list.
> 
> See, the unlink-then-slowly-truncate trick is done in this fashion so that
> if the box crashes during the slow unlink, the orhpan list handling on the
> reboot will finish off the truncate for us.

Yes, absolutely.

>> So.. how can I guarantee a quiescent filesystem before doing "halt -f -p" ??
>> This looks pretty dangerous as-is.
> 
> Wait for the killed-off applicaiton to actually exit, perhaps?  But
> that unmount should have failed.

But some applications just "hang" regardless, and so this cannot wait forever.
There must be *some* way to know when a filesystem is really quiescent
and therefore safe to power off?

Cheers

