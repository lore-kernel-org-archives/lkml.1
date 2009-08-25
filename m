Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZHYOhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZHYOhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZHYOhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:37:23 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39301 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbZHYOhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uqAM+Hl0lwIAGYOyuHzrPzfGW5+vmCu2hHB1pWD34hhe/8GSrCoRC8CUEN00/miD5s
         /fPNR658YuHKX86AWwhQ8YuFtOenrNdkwscmSanyt2mwMWevtuqTtX57nnXTK64JBa0J
         3mIDbsl0DX+TAT6YLeeIxZltKEoc3yIaa1Lic=
MIME-Version: 1.0
In-Reply-To: <4A936747.3080408@earthlink.net>
References: <4A9346D2.6040108@earthlink.net> <3e8340490908242018m31ccb454x9b42af531b6f09ae@mail.gmail.com> 
	<4A936747.3080408@earthlink.net>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 25 Aug 2009 10:37:03 -0400
Message-ID: <3e8340490908250737l45940e35jdff514c6216fc8af@mail.gmail.com>
Subject: Re: Starting a grad project that may change kernel VFS. Early 
	research
To: Jeff Shanab <jshanab@earthlink.net>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 12:23 AM, Jeff Shanab<jshanab@earthlink.net> wrote:
> So does mv essentially become copy when between mounts?

Yes, essentially.

>>
>>> I need to look at the cashing and how we handle changes already.  Do we
>>> write things immediately all the time? Then why must I "sync" before
>>> unmount. hummmm
>>>
>>
>> You don't need to sync before umount. umount automatically syncs the
>> filesystem it's applied on after it's removed from the namespace, but
>> before the umount completes. Additionally, dirty buffers and pages are
>> written back automatically based on memory pressure and timeouts - see
>> /proc/sys/vm/dirty_* for the knobs for this.
>>
> I know it now does the sync for you, but the fact a sync must be done
> indicates there are buffers not written, correct?

Generally speaking the umount will actually make some buffers dirty
when, eg, setting a 'filesystem is clean' flag. There may also be
dirty buffers left over from prior activity.

>>>> In addition, how will you handle hard links?  An inode can have
>>>> multiple hard links in different directories, and there is no way to
>>>> find all of the directories which might contain a hard link to a
>>>> particular inode, short of doing a brute force search.  Hence if you
>>>> have a file living in src/linux/v2.6.29/README, and it is a hard link
>>>> to ~/hacker/linux/README, and a program appends data to the file
>>>> ~/hacker/linux/README, this would also change the result of running du
>>>> -s src/linux/v2.6.29; however, there's no way for your extension to
>>>> know that.
>>>>
>>
>> ^^^ don't skip this part, it's absolutely critical, the biggest
>> problem with your proposal, and you can't just handwave it away.
>>
> I will sleep on the hard link issue. There must be an answer as DU must
> handle this.
> I can see where if I can't distinquish between which is the hard link
> and which is not becasue they are implemented the same.
>
> First think is to run an experiment in the morning
>
>    test/foo/bar/file
>    test/bar/foo/file
>    where file is the same file close to the disk block size.
>    does 'du -s in foo' + 'du -s in bar'  = 'du -s' in test?

No. du -s in test will count 'file' only once, unless -l is passed.

>
>> One thing you may want to look into is the new fanotify API[1] - it
>> allows a userspace program to monitor and/or block certain filesystem
>> events of interest. You may be able to implement a prototype of your
>> space-usage-caching system in userspace this way without needing to
>> modify the kernel. Or implement it as a FUSE layered filesystem. In
>> the latter case you may be able to make a reverse index of sorts for
>> hardlink handling - but this carries with it quite a bit of overhead.
>>
> FUSE is an option I was keeping open.
> Since I can dedicate a mountpoint to a file system and mount and umount
> it and load and unload a kernel module FUSE, seemed like extra work with
> little benefit.
> That does sound like a lot of overhead.

It is additional overhead, but writing code for userspace is a lot
easier as you do not need to deal with kernel locking and low-memory
deadlock issues, and can use any userspace libraries you want. You
also won't have to worry about crashing the system and having to
reboot if you make a mistake. It's a good way to prove the concept is
sound before proposing it in a more concrete form to filesystem
developers.
