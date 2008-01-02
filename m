Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYABUM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYABUM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbYABUL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:11:59 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:57547 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbYABUL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:11:57 -0500
Message-ID: <477BEF8D.8090307@tlinx.org>
Date: Wed, 02 Jan 2008 12:09:49 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
CC: Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>	<4777E08C.4000603@shaw.ca>	<4779870E.5070507@tlinx.org> <20080101015812.59e9ebf0@the-village.bc.nu>
In-Reply-To: <20080101015812.59e9ebf0@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> rate began falling; at 128k block-reads-at-a-time or larger, it drops below
>> 20MB/s (only on buffered SATA).
>
> Try disabling NCQ - see if you've got a drive with the 'NCQ = no
> readahead' flaw.
---
   I'm not aware, off hand, how to disable NCQ.  I haven't had any
NCQ- or SATA- capable disks before a few weeks ago.

>>     The only way I could tell before was using hdparm to read the 
>> parameters. Since that doesn't work, it's hard to tell if they
>> are set correctly...
>
> hdparm supports identify to read modes on drives with libata. The one
> thing you cannot do is force modes right now.
>
>>     More importantly, how does one set parameters for acoustic and power
>> saving parameters?  Some of my disks are used as 'backup' devices for my
>
> hdparm or blktool
----

  I have hdparm-v7.7. 
There are some areas where it shows information, but areas where it
does not work jump out and lead me to suspect whether or not areas
that don't give explicit "ERROR" messages are presenting valid info.

Problem areas (using hdparm, disk=Seagate Barracuda 16MB cache, model=
ST3750640AS):
1) The drives current 'multicount' setting isn't readable or settable.
param "-i" shows "?16?" (with question marks around 16) and "-I" simply
shows "?" for the current setting.  Attempting to <read|set> it:
 "HDIO_<GET|SET>_MULTCOUNT failed: Inappropriate ioctl for device"
2) Drive Advanced Power Management setting("-B") (write-only):
 "HDIO_DRIVE_CMD failed: Input/output error"
3) Drive Acoustic ("-M"), read = " acoustic      = not supported",
write = " HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error"
   Note: drive detailed info from "-I" says:
        "Recommended acoustic management value: 254, current value: 0"
   (i.e. - there seems to be no way to set recommended value)
4) 32-bit IO setting ("-c") (don't know if this important given the disk's
raw-read speed, it may be meaningless for SATA)
 "IO_support    =  0 (default 16-bit)"*
*
FWIW -- the spindown/standby timeout ("S") does seem to work.

>> other computers.  With the ATA disks, they were kept "spun down" when not
>> being used (only used, 'normally', in early AM hours).
>
> Well for backup devices you can use the fact SATA is hot/warm plug.
---
    I don't follow. It is an internal drive.  Are their software "logically
unplug" commands that automatically re-"plug-in" the drive on access
and spin it back up like the spindown/standby timeout does?  Or were
you referring to SATA's general hot/warm plug ability (if my hardware
setup, drive-slots, etc, permitted removability)?
>
>>     Another new "problem" (not as important) -- even though SATA disks are
>> called with "sdX", my ATA disks that *were* at hda-hdc are now at hde-hdg.
>
> NOTABUG - your BIOS has decided to move them from the legacy addresses so
> they move from hda-d to e-g.
Sorry for my unclear usage -- by "problem" I meant that it was(is) an 
"unexpected behavior".  I'm sure the kernel is following the BIOS's
directions, I'm just not sure why a (supposedly), SATA-only card would
cause my BIOS to reserve 4 "[P]ATA-drives" after installing the
card.  It may be symptomatic of some "cost-cutting" measure by the
card manufacurer.  I just don't know why it's happening right now.

*however* -- it is "annoying" -- if the kernel reserves hda-hdd at the
request of the BIOS, it _might_ be useful if "udev" also populated
/dev/ with devices for hda-hdd.  I.e. -- "something" on the linux-kernel
software-side of things knows that hda-hdd aren't really their as
the devices are not created in the udev-managed filesystem upon boot.

It may not be a kernel-bug insomuch as the kernel is intended to work,
but it doesn't seem that it is a "valuable feature".  My reasoning:
"Hd" drive letters are "unstable" because plugging/unplugging HD
controllers and/or drives can change the HD lettering.  Consequently,
it is considered "best practice" to mount disks by label instead of
by drive letter under linux.  If it is acknowledged that the drive
letters are not stable, then why not have udev assign "hd" letters
only to drives that 'exist'? 

Conversely, if udev had 'reserved' (created) hda-hdd devices because
the BIOS said they were 'reserved', then I can see it might have some
usefulness.  This may be a 'udev'-specific concern or configuration
issue as well.  I ran into it as I was going to try to use LILO's
"drive=" and "bios=" params to move the disks back to start with 'hda',
but lilo refused, saying 'hda' didn't exist (which it doesn't, as
indicated in the /dev-mounted udev 'filesystem').  It's not something
impossible to workaround or fix, just seemed odd to move the working
drives up to hde-g, when they could have been mapped to hda-c with
no apparent conflicts. 

I know, it's a subtlety, but one not inconsistent with (wincing at
the admission of even knowing this, let along the comparison) WinXP's
feature set.

  If a disk was mounted and associated with a specific letter, then
later another controller or disk is added that would cause 're-lettering'
under linux, it won't necessarily cause re-lettering under WinXP (as
it used to under Win98).  This 'threw me' the first time it happened,
as I expected Win to 're-letter' my drives and it didn't.  It seems
to associate drive-UUID's with the last letter they were mounted at
(or tries to, barring conflicts).


