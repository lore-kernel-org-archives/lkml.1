Return-Path: <linux-kernel-owner+w=401wt.eu-S1763098AbZDAQZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763098AbZDAQZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbZDAQZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:25:01 -0400
Received: from mail.tmr.com ([64.65.253.246]:56028 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbZDAQZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:25:00 -0400
Message-ID: <49D3954A.9010309@tmr.com>
Date: Wed, 01 Apr 2009 12:24:42 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090328 Fedora/1.1.15-3.fc9 pango-text SeaMonkey/1.1.15
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Mon, 30 Mar 2009, Bill Davidsen wrote:
>
>> Andreas T.Auer wrote:
>>> On 30.03.2009 02:39 Theodore Tso wrote:
>>>> All I can do is apologize to all other filesystem developers profusely
>>>> for ext3's data=ordered semantics; at this point, I very much regret
>>>> that we made data=ordered the default for ext3.  But the application
>>>> writers vastly outnumber us, and realistically we're not going to be
>>>> able to easily roll back eight years of application writers being
>>>> trained that fsync() is not necessary, and actually is detrimental for
>>>> ext3.
>>
>>> And still I don't know any reason, why it makes sense to write the
>>> metadata to non-existing data immediately instead of delaying that, 
>>> too.
>>>
>> Here I have the same question, I don't expect or demand that anything 
>> be done in a particular order unless I force it so, and I expect 
>> there to be some corner case where the data is written and the 
>> metadata doesn't reflect that in the event of a failure, but I can't 
>> see that it ever a good idea to have the metadata reflect the future 
>> and describe what things will look like if everything goes as 
>> planned. I have had enough of that BS from financial planners and 
>> politicians, metadata shouldn't try to predict the future just to 
>> save a ms here or there. It's also necessary to have the metadata 
>> match reality after fsync(), of course, or even the well behaved 
>> applications mentioned in this thread haven't a hope of staying 
>> consistent.
>>
>> Feel free to clarify why clairvoyant metadata is ever a good thing...
>
> it's not that it's deliberatly pushing metadata out ahead of file 
> data, but say you have the following sequence
>
> write to file1
> update metadata for file1
> write to file2
> update metadata for file2
>
Understood that it's not deliberate just careless. The two behaviors 
which are reported are (a) updating a record in an existing file and 
having the entire file content vanish, and (b) finding some one else's 
old data in my file - a serious security issue. I haven't seen any 
report of the case where a process unlinks or truncates a file, the disk 
space gets reused, and then the systems fails before the metadata is 
updated, leaving the data written by some other process in the file 
where it can be read - another possible security issue.

> if file1 and file2 are in the same directory your software can finish 
> all four of these steps before _any_ of the data gets pushed to disk.
>
> then when the system goes to write the metadata for file1 it is 
> pushing the then-current copy of that sector to disk, which includes 
> the metadata for file2, even though the data for file2 hasn't been 
> written yet.
>
> if you try to say 'flush all data blocks before metadata blocks' and 
> have a lot of activity going on in a directory, and have to wait until 
> it all stops before you write any of the metadata out, you could be 
> blocked from writing the metadata for a _long_ time.
>
If you mean "write all data for that file" before the metadata, it would 
seem to behave the way an fsync would, and the metadata should go out in 
some reasonable time.
> Also, if somone does a fsync on any of those files you can end up 
> waiting a long time for all that other data to get written out 
> (especially if the files are still being modified while you are trying 
> to do the fsync). As I understand it, this is the fundamental cause of 
> the slow fsync calls on ext3 with data=ordered.

Your analysis sounds right to me,

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


