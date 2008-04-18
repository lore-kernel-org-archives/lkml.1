Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYDRNWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYDRNWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYDRNWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:22:37 -0400
Received: from rtr.ca ([76.10.145.34]:4159 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbYDRNWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:22:37 -0400
Message-ID: <4808A09B.6090106@rtr.ca>
Date: Fri, 18 Apr 2008 09:22:35 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Seewer Philippe <philippe.seewer@bfh.ch>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch>	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>	 <4805AF93.90209@bfh.ch> <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com> <4807635E.9060101@bfh.ch>
In-Reply-To: <4807635E.9060101@bfh.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seewer Philippe wrote:
> Hi,
> 
> Francis Moreau wrote:
>> Hello Seewer,
>>
>> On Wed, Apr 16, 2008 at 9:49 AM, Seewer Philippe 
>> <philippe.seewer@bfh.ch> wrote:
>>>  Correct. Though be really careful which geometry you are requesting:
>>>
>>>  root@local:/# sfdisk -g /dev/sda
>>>  /dev/sda: 7296 cylinders, 255 heads, 63 sectors/track
>>>  root@local:/# sfdisk -G /dev/sda
>>>  /dev/sda: 116280 cylinders, 16 heads, 63 sectors/track
>>>
>>>  The first one is the kernels idea of a disks geometry which is 
>>> probably as
>>> often correct as it's just plain wrong,
>>
>> Sorry but I don't understand, what do you mean ?
> Take the example above. A disk with 255 heads? Not impossible but 
> improbable. Where's the value from?
> 
> -The physical disks behind the example is an older laptop IDE disk. 
> 'hdparm -I' shows 16 heads and 63 sectors, which is already an 
> approximated value anyway. See Dick Johnson's post about that.
..

That can sound a bit misleading.  The complete story, for ATA/SATA drives,
is that the disk has two geometries:  an internal physical one, with a 
fixed number of heads and cylinders, but variable sectors/track
(which normally varies by cylinder zone).

Software *never* sees or knows about that geometry, so ignore it.

The second geometry, is the one that the drive reports to software
as its "native" geometry.  This is what you see from "hdparm -I"
and friends, and this geometry is what has to be used by software
when using cylinder/head/sector (CHS) addressing for I/O operations.
The hardware interface has a limit of 4-bits for the head value,
so the maximum number of heads can never be more than 16.

Nobody uses CHS addressing for I/O operations, at least not on
any hardware newer than at least ten years old, so this geometry
is also unimportant for most uses.

That's what the drive knows about.

Software, for compatibility with the MS-DOS partition table scheme,
sometimes uses a "logical" geometry, where we "pretend" that a drive
can have up to 255 heads, which then allows more of the disk to be
described within the limitations of the partition table data layout.
That's where one frequently sees "255 heads", even though the drive
underneath uses 16 at the interface level, and probably as only 2
or 4 real heads inside the shell.

Cheers
 
