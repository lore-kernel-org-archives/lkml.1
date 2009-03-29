Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZC2MnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZC2MnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZC2MnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:43:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:23313 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZC2MnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:43:10 -0400
Message-ID: <49CF6CBB.7070907@yandex.ru>
Date: Sun, 29 Mar 2009 15:42:35 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz>
In-Reply-To: <20090329122600.GA13737@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2009 12:42:36.0568 (UTC) FILETIME=[D6A1B180:01C9B06B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2009-03-27 14:48:10, Artem Bityutskiy wrote:
>> UBIFS has exactly the same properties like ext4 - in case
>> of power cuts:
>>
>> 1. truncate/write/close leads to empty files
>> 2. create/write/rename leads to empty files
>>
>> UBIFS is used in hand-held and and power-cuts are very
>> often there, because users just remove battery often.
>>
>> I realize the "reality is different" argument, and already
>> concluded that we need a similar changes as Theo has done
>> for ext4:
>> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=bf1b69c0db7f9b9d8f02e94d40b19fca8336b991
>> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=f32b730a69bd56c5c9d704d8b75f03e90e290971
>> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=8411e347c3306ed36b8ca88611bf5fbf4d27d705
>>
>> We have a problem that user-space people do not want to
>> use 'fsync()', even when they are pointed to their code
>> which is doing create/write/rename/close without fsync().
> 
> Well... they really don't want to spin the disk up for the
> fsync(). I'm not sure if fsync() is really sensible operation to use
> there.

I'm personally concerned about hand-held, and in case of UBIFS
fsync is not too expensive - we work on flash and on fsync() we
write back only the stuff belonging to inode in question, and
nothing else.

>> 1. truncate/write/close leads to empty files
> 
> this is buggy.

In FS, or in application?

>> 2. create/write/rename leads to empty files
> 
> ..but this should not be. If we want to make that explicit, we should
> provide "replace()" operation; where replace is rename that makes sure
> that source file is completely on media before commiting the rename.

Well, OK, we can fsync() before rename, we just need clean rules
for this, so that all Linux FSes would follow them. Would be nice
to have final agreement on all this stuff.

> It is somehow similar to fsync()/rename(), but does not force disk
> spin up immediately -- it only inserts "barrier" between data blocks
> and rename. (And yes, it should be implemented as fsync()+rename() for
> filesystems like xfs. It can be implemented as plain rename for ext3
> and ext4 after the fixes...)

Right. But I guess only few file-systems would really implement
this, because this is complex.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
