Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZHYDSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZHYDSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 23:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZHYDSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 23:18:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:47762 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZHYDSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 23:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bYNCyJ4Go49oqV/Aehz2xvFwrS6E/V6t9xPf9lwu7pJqq9ZqRzmvESvEvyrVasDvwY
         5AxDgZyk4W4Xt52v1QyqWVpTLjvIKvNZ+uocqZO/gnv3O40PeZpnDHzLLHNDTexPxpcb
         fFiTZ6diJzJlTf84z/C8DX+Kku+Khon+ZNrAM=
MIME-Version: 1.0
In-Reply-To: <4A9346D2.6040108@earthlink.net>
References: <4A9346D2.6040108@earthlink.net>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 24 Aug 2009 23:18:18 -0400
Message-ID: <3e8340490908242018m31ccb454x9b42af531b6f09ae@mail.gmail.com>
Subject: Re: Starting a grad project that may change kernel VFS. Early 
	research
To: Jeff Shanab <jshanab@earthlink.net>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:05 PM, Jeff Shanab<jshanab@earthlink.net> wrote:
>>
>> On Mon, Aug 24, 2009 at 04:54:52PM -0700, Jeff Shanab wrote:
>>
>>> >     I was thinking that a good way to handle this is that it starts with
>>> > a file change in a directory. The directory entry contains a sum already
>>> > for itself and all the subdirs and an adjustment is made immediately to
>>> > that, it should be in the cache. Then we queue up the change to be sent
>>> > to the parent(s?). These queued up events should be a low priority at a
>>> > more human time like 1 second. If a large number of changes come to a
>>> > directory, multiple adjustments hit the queue with the same (directory
>>> > name, inode #?) and early ones are thrown out. So levels above would see
>>> > at most a 1 per second low priority update.
>>>
>>
>> Is this something that you want to be stored in the file system, or
>> just cached in memory?  If it is going to be stored on disk, which
>> seems to be implied by your description, and it is only going to be
>> updated once a second, what happens if there is a system crash?  Over
>> time, the values will go out of date.  Fsck could fix this, sure, but
>> that means you have to do the equivant of running "du -s" on the root
>> directory of the filesystem after an unclean shutdown.
>
> Could this could be done low priority in the background long after fsck and the boot process is done?
> There will probably be a cutoff point where du -s after a command is better than the file by file, like when we recursively move a directory But I was gonna run tests and see how that went. Mv may be actually easier than cp, it is a tree grafting.

cp is easier than mv - in that it requires no explicit support from
your layer. 'cp' really just loops doing read() and write() - there
are some experimental copy-on-write ioctls for btrfs, I think, but
nothing standard there yet.

Also, directories aren't 'recursively moved' - if you're moving within
a mount, you just rename() the directory, and it's moved in what is on
most filesystems an O(1) operation. If you're moving between mounts,
the kernel gives you no help whatsoever - it's up to the 'mv' program
to copy the directory, then delete the old one.

>> You could write the size changes in a journal, but that blows up the
>> size of information that would need to be stored in a journal.  It
>> also slows down the very common operaton of writing to a file, all for
>> the sake of speeding up the relatively uncommon "du -s" operation.
>> It's not at all clear it's worthwhile tradeoff.
>>
> Yeah fsck is an interesting scenario.
> Databases have had to deal with this and maybe there are hints like the
> two phase commit and
> the WAL just for the size updates.
> Maybe we set a flag in the directory entry when we update it, cause we
> are writing this update to disk anyway.
> Then when update completes at the parent, the flag is cleared. Now this
> makes two writes for each directory but the process is resumable during fsk

No. Updating the size at the same time as the main inode write is far
cheaper than opening a second transaction just for the size update -
unless computing the new size is an expensive operation as well.

> I need to look at the cashing and how we handle changes already.  Do we
> write things immediately all the time? Then why must I "sync" before
> unmount. hummmm

You don't need to sync before umount. umount automatically syncs the
filesystem it's applied on after it's removed from the namespace, but
before the umount completes. Additionally, dirty buffers and pages are
written back automatically based on memory pressure and timeouts - see
/proc/sys/vm/dirty_* for the knobs for this.

>> In addition, how will you handle hard links?  An inode can have
>> multiple hard links in different directories, and there is no way to
>> find all of the directories which might contain a hard link to a
>> particular inode, short of doing a brute force search.  Hence if you
>> have a file living in src/linux/v2.6.29/README, and it is a hard link
>> to ~/hacker/linux/README, and a program appends data to the file
>> ~/hacker/linux/README, this would also change the result of running du
>> -s src/linux/v2.6.29; however, there's no way for your extension to
>> know that.

^^^ don't skip this part, it's absolutely critical, the biggest
problem with your proposal, and you can't just handwave it away.

One thing you may want to look into is the new fanotify API[1] - it
allows a userspace program to monitor and/or block certain filesystem
events of interest. You may be able to implement a prototype of your
space-usage-caching system in userspace this way without needing to
modify the kernel. Or implement it as a FUSE layered filesystem. In
the latter case you may be able to make a reverse index of sorts for
hardlink handling - but this carries with it quite a bit of overhead.

PS - it's normal to keep all CCs when replying to messages on lkml
(that is, use reply to all), as some people may not be subscribed, or
may prefer to get extra copies in their inbox. I personally don't mind
either way, but there are some who are very adamant about this point.

[1] - http://lwn.net/Articles/339399/
