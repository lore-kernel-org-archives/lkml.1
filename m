Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbZBVUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbZBVUxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZBVUxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:53:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZBVUxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:53:08 -0500
Message-ID: <49A1BAEC.7080504@redhat.com>
Date: Sun, 22 Feb 2009 14:51:56 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz> <499494E2.3060006@redhat.com> <20090213022336.GH6922@mini-me.lan> <20090222141532.GC1586@ucw.cz>
In-Reply-To: <20090222141532.GC1586@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2009-02-12 21:23:36, Theodore Tso wrote:
>> On Thu, Feb 12, 2009 at 03:30:10PM -0600, Eric Sandeen wrote:
>>>>   Yes, but OTOH we should give sysadmin a possibility to enable / disable
>>>> it on just some partitions. I don't see a reasonable use for that but people
>>>> tend to do strange things ;) and here isn't probably a strong reason to not
>>>> allow them.
>>>>
>>> But nobody has asked for that, have they?  So why offer it up a this point?
>>>
>>> They could use LD_PRELOAD to make fsync a no-op if they really don't
>>> care for it, I guess... though that's not easily per-fs either.
>> Actually, Bart Samwel at FOSDEM talked to me and asked for something
>> similar --- what we came up which meant his request while still being
>> standards-compliant was a per-process personality flag which had three
>> options:
>>
>>      *)  Always honor fsync() calls (the default)
>>      *)  Never honor fsync() calls
>>      *)  Only honor fsync() calls if a global "honor fsync" flag
>>            (which would be manipulated by the laptop mode scripts)
>> 	   is set.
>>
>> The flag would be reset to the default across a setuid exec, but would
>> otherwise be inherited across fork()'s.  It might be possible to
>> set/get the flag via a /proc interface.
>>
>> The basic idea is that laptop systems where the system administrator
>> wants longer battery life (and trusts the battery not to suddenly give
>> out) more than they care about fsync() guarantees can set up a pam
>> library which sets the flag for at login time so that all of the
>> user's processes can be set up not to honor fsync() calls; however,
>> all of the system daemons would still function normally.   
> 
> Sounds like posix violation to
> me... '/sys/fsync_does_not_really_sync'?
> 
> Perhaps it is better done at glibc level? Environment variables
> already mostly have semantics you want.....
> 
> 									Pavel

One other thing that may be worth bringing up (just to muddy the waters
more) is OSX's handling of this stuff.

>From the fsync(2) manpage:

>      Note that while fsync() will flush all data from the host to the
>      drive (i.e. the "permanent storage device"), the drive itself may not
>      physically write the data to the platters for quite some time and it
>      may be written in an out-of-order sequence.
> 
>      Specifically, if the drive loses power or the OS crashes, the appli-
>      cation may find that only some or none of their data was written.
>      The disk drive may also re-order the data so that later writes may be
>      present, while earlier writes are not.
> 
>      This is not a theoretical edge case.  This scenario is easily repro-
>      duced with real world workloads and drive power failures.
> 
>      For applications that require tighter guarantees about the integrity
>      of their data, Mac OS X provides the F_FULLFSYNC fcntl.  The F_FULLF-
>      SYNC fcntl asks the drive to flush all buffered data to permanent
>      storage.  Applications, such as databases, that require a strict
>      ordering of writes should use F_FULLFSYNC to ensure that their data
>      is written in the order they expect.  Please see fcntl(2) for more
>      detail.

and from fcntl(2)

>      F_FULLFSYNC    Does the same thing as fsync(2) then asks the drive to
>                     flush all buffered data to the permanent storage
>                     device (arg is ignored).  This is currently imple-
>                     mented on HFS, MS-DOS (FAT), and Universal Disk Format
>                     (UDF) file systems.  The operation may take quite a
>                     while to complete.  Certain FireWire drives have also
>                     been known to ignore the request to flush their
>                     buffered data.

-Eric
