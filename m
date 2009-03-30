Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZC3RTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZC3RTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZC3RTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:19:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45592 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbZC3RTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:19:34 -0400
Message-ID: <49D0FF1E.3010804@redhat.com>
Date: Mon, 30 Mar 2009 13:19:26 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <20090329124959.GD15492@elf.ucw.cz>
In-Reply-To: <20090329124959.GD15492@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>>> We have a problem that user-space people do not want to
>>>> use 'fsync()', even when they are pointed to their code
>>>> which is doing create/write/rename/close without fsync().
>>>>         
>>> Well... they really don't want to spin the disk up for the
>>> fsync(). I'm not sure if fsync() is really sensible operation to use
>>> there.
>>>       
>> I'm personally concerned about hand-held, and in case of UBIFS
>> fsync is not too expensive - we work on flash and on fsync() we
>> write back only the stuff belonging to inode in question, and
>> nothing else.
>>     
>
> Well, I'm more concerned about spinning disks, having one even in my
> zaurus. And I do believe that fsync() will write more data than
> neccessary even in flash case.
>
>   
>>>> 1. truncate/write/close leads to empty files
>>>>         
>>> this is buggy.
>>>       
>> In FS, or in application?
>>     
>
> Application is buggy; no way kernel can help there.
>
>   
>>>> 2. create/write/rename leads to empty files
>>>>         
>>> ..but this should not be. If we want to make that explicit, we should
>>> provide "replace()" operation; where replace is rename that makes sure
>>> that source file is completely on media before commiting the rename.
>>>       
>> Well, OK, we can fsync() before rename, we just need clean rules
>> for this, so that all Linux FSes would follow them. Would be nice
>> to have final agreement on all this stuff.
>>     
>
> My proposal is 
>
> rename() stays.
>
> replace(src, bar) is rename that ensures that bar will contain valid
> data after powerfail.
>   

Surely the only way to "insure" this is to spin up the drive, write the 
meta-data and data back and make sure that it is not held in volatile 
write cache?

Why would calling this replace be better or more power efficient than 
what you need to do today?

ric

>   
>>> It is somehow similar to fsync()/rename(), but does not force disk
>>> spin up immediately -- it only inserts "barrier" between data blocks
>>> and rename. (And yes, it should be implemented as fsync()+rename() for
>>> filesystems like xfs. It can be implemented as plain rename for ext3
>>> and ext4 after the fixes...)
>>>       
>> Right. But I guess only few file-systems would really implement
>> this, because this is complex.
>>     
>
> Complex yes, but at least ext3+ext4+btrfs should, and they really have
> 90% of "market share" :-). ext3 and ext4 implementations are already
> done :-).
> 								Pavel
>   

