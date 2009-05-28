Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZE1T1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZE1T1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZE1T1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:27:35 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:51952 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbZE1T1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:27:34 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Chris Worley <worleys@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual  machine environment
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
	<20090524101551.57b706e9@infradead.org>
	<20090524173933.GD24753@cip.informatik.uni-erlangen.de>
	<20090525120320.GA25908@mit.edu>
	<20090525123430.GA5534@cip.informatik.uni-erlangen.de>
	<87ab51qq91.fsf@frosties.localdomain>
	<f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
	<87ab50p3ip.fsf@frosties.localdomain>
	<f3177b9e0905260952x2e382d9ana02dcd10a5bcc63d@mail.gmail.com>
Date: Thu, 28 May 2009 21:27:33 +0200
In-Reply-To: <f3177b9e0905260952x2e382d9ana02dcd10a5bcc63d@mail.gmail.com>
	(Chris Worley's message of "Tue, 26 May 2009 10:52:21 -0600")
Message-ID: <87d49tyqmy.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/4Oh/3tqj9ZIAJiB/zuXhXXiXZm06VbK7SVni0
	Dq2P2MaUAtW8acZYyaxkEmiQ5FoTxN06beyKmDzZUfUsaW3apt
	gOD3ugy3A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Worley <worleys@gmail.com> writes:

> On Tue, May 26, 2009 at 4:22 AM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>> Chris Worley <worleys@gmail.com> writes:
>>
>>> On Mon, May 25, 2009 at 7:14 AM, Goswin von Brederlow <goswin-v-b@web.de>
>>> wrote:
>>>
>>>
>>>                Thomas Glanzmann <thomas@glanzmann.de> writes:
>>>
>>>      > Hello Ted,
>>>      >
>>>      >> Yes, it does, sb_issue_discard().  So if you wanted to hook into
>>>      this
>>>      >> routine with a function which issued calls to zero out blocks, it
>>>      >> would be easy to create a private patch.
>>>      >
>>>      > that sounds good because it wouldn't only target the most used
>>>      > filesystem but every other filesystem that uses the interface as
>>>      well.
>>>      > Do you think that a tunable or configurable patch has a chance to
>>>      hit
>>>      > upstream as well?
>>>      >
>>>      >         Thomas
>>>
>>>
>>>
>>>
>>>      I could imagine a device mapper target that eats TRIM commands and
>>>      writes out zeroes instead. That should be easy to maintain outside
>>>      or
>>>      inside the upstream kernel source.
>>>
>>>
>>> Why bother with a time-consuming performance-draining operation?  There are
>>> devices that already support TRIM/discard commands today, and once you discard
>>> a block, it's completely irretrievable (you'll just get back zeros if you try
>>> to read that block w/o writing it after the discard).
>>> Chris
>>
>
> I do enjoy a good argument... and don't mean this as a flame (I'm told
> I obliviously write curtly)...
>
> Old man's observation: I've found that the people you would think
> would readily embrace a new technology are as terrified of change as a
> Windows user, and always find so many excuses for "why change won't
> work for them" ;)
>
>> Because you have one of the billions of devices that don't.
>
> You have devices that _do_ work now, that should be your selection if
> you want both this functionality and high performance.  If you don't
> want performance, write zeros to rotating media.
>
> The time frame given in this thread is two years.  In 2-5 years,
> rotating media will be history.  The tip of the Linux kernel should
> not be focused on defunct technology.

I certainly have disks in use that are a lot older than that. And for
sure Thomas also has disks that do not natively support TRIM or he
wouldn't want to zero fill blocks instead. So the fact that someone
else might have a "working" disk is of no help.

>> Because, iirc, the specs say nothing about getting back zeros.
>>
>
> But all a Solid State Storage controller can do is give you garbage
> when asked for an unwritten or discarded block; it doesn't know where
> the data is, which is all that is needed for the functionality desired
> (there's no need to specify exactly what a controller should return
> when asked to read a block it knows nothing about).  Once the
> controller is no longer managing a block, there is no way for it to
> retrieve that block.  That's what TRIM is all about: get greatest
> performance by allowing the SSS controller to manage as few blocks as
> absolutely necessary.  Not being able to retrieve valid data for an
> unwritten or discarded block is a side-effect of TRIM, that fits well
> for this desired functionality.

Are you sure? From what other people said some disks don't seem to
forget where the data is. They just don't preserve it anymore. So as
long as the block is not overwritten by the wear leveling you do get
the original data back. Security wise not acceptable.

>>From drives I've tested so far, the de-facto standard is "zero" when
> reading unmanaged blocks.
>
>> Because someone could read the raw data from disk and recover your
>> state secrets.
>
> Water-boarding won't help... the controller simply doesn't know the
> information you demand.

You assume that you have a controler that works right.

> This isn't your grandfathers rotating media...

It is for me.

> You would have to read at the Erase Block level, and know the specific
> vendor implementation's EB layout and block-level
> mapping/metadata/wear-leveling strategy (i.e. very tightly held IP).
> Controllers don't provide the functionality to request raw EB's; there
> is no way to read raw EB's.  There is no spec for it in existence for
> reading EB's from a SCSI/SAS/SATA/block device.  Your only recourse
> would be to pull the NAND chips physically off the drive and weld them
> to another piece of hardware specifically designed to blindly read all
> the erase blocks, then try to infer the manufacturers chip
> organization as well as block-level metatdata, and then you'd only
> know all the active blocks (which you would have known those blocks
> anyway, before you pulled the chips off) and would have to come up
> with some strategy for trying to figure out the original LBA's for all
> the inactive data... so there _is_ a very small chance of recovery,
> lacking physical security... there are worse issues too, when physical
> security is not available on site (i.e. all your active data would be
> vulnerable as with any mechanical drive).
>
> Of concern to those handling state secrets: there is no guarantee in
> SSS that writing whatever pattern over and over again will physically
> overwrite the targeted LBA.  New methods of "declassifying" SSS drives
> will be necessary (i.e. a Secure Erase where the controller is told to
> erase all EB's... so your NAND EB reading device will read all ones no
> matter what EB is read).  These methods are simple enough to develop,
> but those who care about this should be aware that the old rotating
> media methods no longer apply.

Again you assume you have an SSD. Think what happens on your average
rotating disk.

>> Because loopback don't support TRIM and compression of the image file
>> is much better with zeroes.
>
> Wouldn't it be best if the block is not in existence after the
> discard?  Then there would be nothing to compress, which I believe
> "nothing" compresses very compactly.

That would require erasing blocks from the middle of files, something
not yet possible in the VFS layer nor supported by any filesystem.
Itcertainly would be great if discarding a block on a loop mounted
filesystem image would free up the space on the underlying file. But
it doesn't work that way yet.

>> Because on a crypted device TRIM would show how much of the device is
>> in used while zeroing out (before crypting) would result in random
>> data.
>
> TRIM doesn't tell you how much of the drive is used?

Read the drive without decrypting. Any block that is all zeroes (you
claim above TRIMed blocks return zeroes) is unused. On the other hand
if you catch the TRIM commands above the crypt layer and write zeros
those zeroes get encrypted into random bits.

>> Because it is fun?
>
> You've got me there.  To each his own.
>
>>
>> So many reasons.
>
> ...to switch from the old rotating media to SSS ;)

Sure, if I had a SSD disk with TRIM support I certainly would not want
to circumvent it with zeroing blocks and decrease the live time. The
use for this would be for the other cases.

> Chris
>>
>> MfG
>>        Goswin
>>

MfG
        Goswin
