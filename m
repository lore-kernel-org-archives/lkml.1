Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbZDAUP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbZDAUP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZDAUPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:15:46 -0400
Received: from mail.lang.hm ([64.81.33.126]:47452 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249AbZDAUPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:15:45 -0400
Date: Wed, 1 Apr 2009 13:15:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Bill Davidsen <davidsen@tmr.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
In-Reply-To: <49D3954A.9010309@tmr.com>
Message-ID: <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm>
 <49D3954A.9010309@tmr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, Bill Davidsen wrote:

> david@lang.hm wrote:
>> On Mon, 30 Mar 2009, Bill Davidsen wrote:
>> 
>>> Andreas T.Auer wrote:
>>>> On 30.03.2009 02:39 Theodore Tso wrote:
>>>>> All I can do is apologize to all other filesystem developers profusely
>>>>> for ext3's data=ordered semantics; at this point, I very much regret
>>>>> that we made data=ordered the default for ext3.  But the application
>>>>> writers vastly outnumber us, and realistically we're not going to be
>>>>> able to easily roll back eight years of application writers being
>>>>> trained that fsync() is not necessary, and actually is detrimental for
>>>>> ext3.
>>> 
>>>> And still I don't know any reason, why it makes sense to write the
>>>> metadata to non-existing data immediately instead of delaying that, too.
>>>> 
>>> Here I have the same question, I don't expect or demand that anything be 
>>> done in a particular order unless I force it so, and I expect there to be 
>>> some corner case where the data is written and the metadata doesn't 
>>> reflect that in the event of a failure, but I can't see that it ever a 
>>> good idea to have the metadata reflect the future and describe what things 
>>> will look like if everything goes as planned. I have had enough of that BS 
>>> from financial planners and politicians, metadata shouldn't try to predict 
>>> the future just to save a ms here or there. It's also necessary to have 
>>> the metadata match reality after fsync(), of course, or even the well 
>>> behaved applications mentioned in this thread haven't a hope of staying 
>>> consistent.
>>> 
>>> Feel free to clarify why clairvoyant metadata is ever a good thing...
>> 
>> it's not that it's deliberatly pushing metadata out ahead of file data, but 
>> say you have the following sequence
>> 
>> write to file1
>> update metadata for file1
>> write to file2
>> update metadata for file2
>> 
> Understood that it's not deliberate just careless. The two behaviors which 
> are reported are (a) updating a record in an existing file and having the 
> entire file content vanish, and (b) finding some one else's old data in my 
> file - a serious security issue. I haven't seen any report of the case where 
> a process unlinks or truncates a file, the disk space gets reused, and then 
> the systems fails before the metadata is updated, leaving the data written by 
> some other process in the file where it can be read - another possible 
> security issue.

ext3 eliminates this security issue by writing the data before the 
metadata. ext4 (and I thing XFS) eliminate this security issue by not 
allocating the blocks until it goes to write the data out. I don't know 
how other filesystems deal with this.

>> if file1 and file2 are in the same directory your software can finish all 
>> four of these steps before _any_ of the data gets pushed to disk.
>> 
>> then when the system goes to write the metadata for file1 it is pushing the 
>> then-current copy of that sector to disk, which includes the metadata for 
>> file2, even though the data for file2 hasn't been written yet.
>> 
>> if you try to say 'flush all data blocks before metadata blocks' and have a 
>> lot of activity going on in a directory, and have to wait until it all 
>> stops before you write any of the metadata out, you could be blocked from 
>> writing the metadata for a _long_ time.
>> 
> If you mean "write all data for that file" before the metadata, it would seem 
> to behave the way an fsync would, and the metadata should go out in some 
> reasonable time.

except if another file in the directory gets modified while it's writing 
out the first two, that file now would need to get written out as well, 
before the metadata for that directory can be written. if you have a busy 
system (say a database or log server), where files are getting modified 
pretty constantly, it can be a long time before all the file data is 
written out and the system is idle enough to write the metadata.

David Lang

>> Also, if somone does a fsync on any of those files you can end up waiting a 
>> long time for all that other data to get written out (especially if the 
>> files are still being modified while you are trying to do the fsync). As I 
>> understand it, this is the fundamental cause of the slow fsync calls on 
>> ext3 with data=ordered.
>
> Your analysis sounds right to me,
>
>
