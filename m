Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZFTQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZFTQhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 12:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZFTQhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 12:37:39 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9392 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZFTQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 12:37:38 -0400
Message-ID: <4A3D104E.9060105@hp.com>
Date: Sat, 20 Jun 2009 12:37:34 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Martin Knoblauch <knobi@knobisoft.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, matthew@wil.cx, mike.miller@hp.com
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> <971371.70253.qm@web32604.mail.mud.yahoo.com>
In-Reply-To: <971371.70253.qm@web32604.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
> ----- Original Message ----
> 
>> From: Jesse Barnes <jbarnes@virtuousgeek.org>
>> To: Martin Knoblauch <knobi@knobisoft.de>
>> Cc: Kay Sievers <kay.sievers@vrfy.org>; Andrew Morton <akpm@linux-foundation.org>; efault@gmx.de; viro@zeniv.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; shemminger@vyatta.com; matthew@wil.cx; mike.miller@hp.com
>> Sent: Tuesday, June 16, 2009 9:25:47 PM
>> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
>>
>> On Thu, 28 May 2009 02:14:46 -0700 (PDT)
>> Martin Knoblauch wrote:
>>>> I expect the duplicate comes from a left-over mount in initramfs
>>>> which isn't a duplicate in the sense of a bug in vfs or mount or
>>>> anything. I guess, it is just still mounted in the initial kernel
>>>> rootfs, below the root from the disk. It could be that a umount
>>>> from initramfs did go wrong because of a changed timing.
>>>>
>>>  This is what I suspect as well. I know for sure that the first
>>> sysfs-line in /proc/mounts
>>>
>>> | none /sys sysfs rw 0 0
>>>
>>> is already there (2.6.29-rc1 and up) when entering startup-skripts.
>>> It is supposed to be unmounted before, but something seems to prevent
>>> it. I have idea how to capture debug output from the initrd/init
>>> script :-(
>> What's the latest here Martin?  It sounded like this was a userspace
>> issue, with something reading the VPD over and over?  Or was it just a
>> longer timeout that caused a specific driver to slow everything down?
>>
> 
>  Not sure about the VPD thing. Anyway, no real news. Still happens in 2.6.30. But it only happens on a certain HW platform (HP/DL380G4). The folks at HP try to reproduce in their environment.
> 
> Cheers
> Martin

I reproduced this and verified Martin's analysis.  Conclusions:

    - >>> | none /sys sysfs rw 0 0

is because the initrd "umount /sys" fails with EBUSY

    |commit 1120f8b8169fb2cb51219d326892d963e762edb6
    |Author: Stephen Hemminger <shemminger@vyatta.com>
    |Date:   Thu Dec 18 09:17:16 2008 -0800
    |
    |    PCI: handle long delays in VPD access

does not have a bug.  The longer timeout makes the problem visible.

/sys is busy because udev is trying to read the vpd and the
cciss pci device always fails the vpd with ETIMEOUT.  If all
timeouts are before or after the umount, no firmware load problem.

IMO there is either a vpd read bug on this platform or it is
unsupported and ETIMEOUT is the wrong error.

... now I punt this to the HP platform/driver people.

jim

