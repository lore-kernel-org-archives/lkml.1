Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbZDAW2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbZDAW2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZDAW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:28:14 -0400
Received: from mail.lang.hm ([64.81.33.126]:51137 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbZDAW2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:28:13 -0400
Date: Wed, 1 Apr 2009 15:28:03 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Harald Arnesen <skogtun.harald@gmail.com>
cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
In-Reply-To: <87hc183uhn.fsf@basilikum.skogtun.org>
Message-ID: <alpine.DEB.1.10.0904011507590.28893@asgard.lang.hm>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm>
 <49D3954A.9010309@tmr.com> <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm> <87hc183uhn.fsf@basilikum.skogtun.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Harald Arnesen wrote:

> david@lang.hm writes:
>
>>> Understood that it's not deliberate just careless. The two behaviors
>>> which are reported are (a) updating a record in an existing file and
>>> having the entire file content vanish, and (b) finding some one
>>> else's old data in my file - a serious security issue. I haven't
>>> seen any report of the case where a process unlinks or truncates a
>>> file, the disk space gets reused, and then the systems fails before
>>> the metadata is updated, leaving the data written by some other
>>> process in the file where it can be read - another possible security
>>> issue.
>>
>> ext3 eliminates this security issue by writing the data before the
>> metadata. ext4 (and I thing XFS) eliminate this security issue by not
>> allocating the blocks until it goes to write the data out. I don't
>> know how other filesystems deal with this.
>
> I've been wondering about that during the last days. How abut JFS and
> data loss (files containing zeroes after a crash), as compared to ext3,
> ext4, ordered and writeback journal modes? Is is safe?

if you don't do a fsync you can (and will) loose data if there is a crash

period, end of statement, with all filesystems

for all filesystems except ext3 in data=ordered or data=journaled modes 
journaling does _not_ mean that your files will have valid data in them. 
all it means is that your metadata will not be inconsistant (things like 
one block on disk showing up as being part of two different files)

this guarantee means that a crash is not likely to scramble your entire 
disk, but any data written shortly before the crash may not have made it 
to disk (and the files may contain garbage in the space that was allocated 
but not written). as such it is not nessasary to do a fsck after every 
crash (it's still a good idea to do so every once in a while)

that's _ALL_ that journaling is protecting you from.

delayed allocateion and data=ordered are ways to address the security 
problem that the garbage data that could end up as part of the file could 
contain sensitive data that had been part of other files in the past.

data=ordered and data=journaled address this security risk by writing the 
data before they write the metadata (at the cost of long delays in writing 
the metadata out, and therefor long fsync times)

XFS and ext4 solve the problem by not allocating the data blocks until 
they are actually ready to write the data.

David Lang

