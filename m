Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYKTMmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYKTMmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYKTMmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:42:24 -0500
Received: from mail.agmk.net ([91.192.224.71]:28883 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbYKTMmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:42:23 -0500
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [2.6.27.6] jfs on raid1 => attempt to access beyond end of device.
Date: Thu, 20 Nov 2008 14:42:16 +0200
X-Mailer: IlohaMail/0.8.13 (On: agmk.net)
Message-ID: <5rbJChma.1227184936.9802590.pluto@agmk.net>
In-Reply-To: <18725.19330.33584.355723@notabene.brown>
From: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
Bounce-To: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
CC: linux-kernel@vger.kernel.org
MIME-Version: 1.0 
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20/11/2008, "Neil Brown" <neilb@suse.de> napisa³/a:

>Hi.
> I sent this reply, but I bounced.  I don't know why but I'm sending
> it again a different way.  Hopefully it will get through.
> Please Cc any followup to linux-kernel@vger.kernel.org.  I think the
> email got through to the list.
>NeilBrown
>
>
>
>On Thu, November 20, 2008 8:03 pm, Pawe³ Sikora wrote:
>> hi,
>>
>> few hours ago i've set up jfs filesystems on raid1 and raid0.
>> during restoring backup i've got an errors in dmesg.
>> the testcase on my system is easy and 100% reproducible:
>> just do the following command on jfs/raid1 device:
>....
>
>> /dev/sda2   *         748        2206    11719417+  fd  Linux raid
>                                           ^^^^^^^^^
>size of sda2 is Kilobytes - 23438835 sectors.
>
>
>>
>> md0 : active raid1 sda2[0] sdb2[1]
>>       11719296 blocks [2/2] [UU]
>        ^^^^^^^^
>
>size of md0 in kilobytes - 23438592 sectors.
>
>
>> [ 5583.796222] attempt to access beyond end of device
>> [ 5583.796227] md0: rw=1, want=23438832, limit=23438592
>Largest 'want' value.
>
>'want' is just less than size of sda2
>'limit' is exactly size of md0 (no surprise there).
>
>> any ideas what's wrong?
>
>I suspect you created the filesystem on /dev/sda2, not realising
>that when you created a raid1 from sda2 and sdb2 it would be slightly
>smaller than sda2 (as md used up to 120K for metadata storage).

thanks for the quick reply!
afair i've ran mkfs.jfs on /dev/md/0.
quick test...

working raid0 device:

# fsck.jfs -f -n /dev/md/1
fsck.jfs version 1.1.13, 17-Jul-2008
processing started: 11/20/2008 13.38.32
Filesystem is currently mounted.
WARNING: Checking a mounted filesystem does not produce dependable
results.
The current device is:  /dev/md/1
Block size in bytes:  4096
Filesystem size in blocks:  51757376
**Phase 0 - Replay Journal Log
**Phase 1 - Check Blocks, Files/Directories, and  Directory Entries
**Phase 2 - Count links
(...)

failing raid1 device:

# fsck.jfs -f -n -v /dev/md/0
fsck.jfs version 1.1.13, 17-Jul-2008
processing started: 11/20/2008 13.34.54

/dev/md/0 is mounted and the file system is not type JFS.
(...)

and the raw sda2 device:

# fsck.jfs -f -n -v /dev/sda2
fsck.jfs version 1.1.13, 17-Jul-2008
processing started: 11/20/2008 13.34.50
The current device is:  /dev/sda2
Open(...READ/WRITE EXCLUSIVE...) returned rc = 0
Invalid magic number in the superblock (P).
Invalid magic number in the superblock (S).

The superblock does not describe a correct jfs file system.
(...)
