Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab0COFWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:22:00 -0400
Received: from mail.lang.hm ([64.81.33.126]:50561 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620Ab0COFV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:21:59 -0400
Date: Sun, 14 Mar 2010 22:20:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
In-Reply-To: <201003150326.22262.vda.linux@googlemail.com>
Message-ID: <alpine.DEB.2.00.1003142216380.15263@asgard.lang.hm>
References: <4B947393.2050002@kernel.org> <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com> <4B9D8BB2.1010507@zytor.com> <201003150326.22262.vda.linux@googlemail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010, Denys Vlasenko wrote:

> On Monday 15 March 2010 02:21, H. Peter Anvin wrote:
>> On 03/10/2010 01:14 AM, Denys Vlasenko wrote:
>>>
>>> 63s/255h is more or less "standard" now.
>>>
>>> Alignment issues can be solved by picking a good multiple of
>>> _heads_ or _cylinders_:
>>>
>>> For first partition, pick the start at 8th head:
>>>
>>> cyl 0 head 1 sector 1: LBA sector 63) - bad
>>> cyl 0 head 8 sector 1: LBA sector 8*63) - good (4k aligned)
>>>
>>> For any other partition, pick start cylinder which is a multiple of 8:
>>>
>>> cyl 8*x head 0 sector 1: LBA sector 8*x*255*63 - good (4k aligned)
>>>
>>> This will actually work well for *any* geometry, not only for 63s/255h.
>>
>> Yes, but it does squat for a flash disk that wants, say, 256K alignment.
>
> 4K makes sense. 256K not so much.
>
> 256K alignment is hard to swallow for a lot of reasons anyway.
> Unless the filesystem packs small files into blocks a-la reiserfs,
> 256K block filesystems will be very inefficient for a typical
> storage scenarios.

the thing is, if the OS can learn that it's more efficiant to write in 
256K aligned chunks, then it can batch up things so that the drive doesn't 
have to do a read-modify-write cycle and can instead just replace the 
entire chunk.

raid arrays can benifit from this as well as SSDs.

the OS can do this when writing things to swap, flushing dirty buffers, 
mmaped files, etc (in fact, if the OS knows the full contents of the 
chunk, it may be more efficiant for the OS to write the entire thing then 
to write part of it and have the drive/array do the read-modify-write 
cycle)

David Lang

> It looks like flash storage manufacturers just have to bite
> the bullet and develop smarter algorithms that combine wear
> leveling, block remapping and such and make their internal
> preference for huge continuous aligned writes nearly invisible
> from the outside - just like hard disks which do not expose
> their zoned recording, variable sector counts etc.
>
> Such algorithms aren't trivial, but they are possible.
> Whoever will incorporate them in their products,
> delivers a significantly better user experience.
>
> I just played with ubuntu installation on an usb stick.
> Yes, it works. Soft of. Write performance is abysmal.
> I would pay x2 or x3 for the same sized stick if it
> would perform better.
>
>
