Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZHYEXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZHYEXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 00:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZHYEXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 00:23:38 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:60534 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbZHYEXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 00:23:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=jnxtSD6yUC8H+im4kBEPAEXvi4PFXDCWe7tNiyRlQMWXnGW3sgJri6ml9FSS4JmG;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4A936747.3080408@earthlink.net>
Date: Mon, 24 Aug 2009 21:23:35 -0700
From: Jeff Shanab <jshanab@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090714 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: Starting a grad project that may change kernel VFS. Early 	research
References: <4A9346D2.6040108@earthlink.net> <3e8340490908242018m31ccb454x9b42af531b6f09ae@mail.gmail.com>
In-Reply-To: <3e8340490908242018m31ccb454x9b42af531b6f09ae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 41b7b48e67ad7886d780f4a490ca6956abb457f1b4332f52810ba56dec1b710f827df98dee606640350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 75.150.3.226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan wrote:
> On Mon, Aug 24, 2009 at 10:05 PM, Jeff Shanab<jshanab@earthlink.net> wrote:
>   
>>> On Mon, Aug 24, 2009 at 04:54:52PM -0700, Jeff Shanab wrote:
>>>
>>>       
>>>>>     I was thinking that a good way to handle this is that it starts with
>>>>> a file change in a directory. The directory entry contains a sum already
>>>>> for itself and all the subdirs and an adjustment is made immediately to
>>>>> that, it should be in the cache. Then we queue up the change to be sent
>>>>> to the parent(s?). These queued up events should be a low priority at a
>>>>> more human time like 1 second. If a large number of changes come to a
>>>>> directory, multiple adjustments hit the queue with the same (directory
>>>>> name, inode #?) and early ones are thrown out. So levels above would see
>>>>> at most a 1 per second low priority update.
>>>>>           
>>> Is this something that you want to be stored in the file system, or
>>> just cached in memory?  If it is going to be stored on disk, which
>>> seems to be implied by your description, and it is only going to be
>>> updated once a second, what happens if there is a system crash?  Over
>>> time, the values will go out of date.  Fsck could fix this, sure, but
>>> that means you have to do the equivant of running "du -s" on the root
>>> directory of the filesystem after an unclean shutdown.
>>>       
>> Could this could be done low priority in the background long after fsck and the boot process is done?
>> There will probably be a cutoff point where du -s after a command is better than the file by file, like when we recursively move a directory But I was gonna run tests and see how that went. Mv may be actually easier than cp, it is a tree grafting.
>>     
>
> cp is easier than mv - in that it requires no explicit support from
> your layer. 'cp' really just loops doing read() and write() - there
> are some experimental copy-on-write ioctls for btrfs, I think, but
> nothing standard there yet.
>   
Easier was a bad choice of words. I really meant move is less expensive.
> Also, directories aren't 'recursively moved' - if you're moving within
> a mount, you just rename() the directory, and it's moved in what is on
> most filesystems an O(1) operation.
I should of been clear, that is what I meant by tree grafting :-)
>  If you're moving between mounts,
> the kernel gives you no help whatsoever - it's up to the 'mv' program
> to copy the directory, then delete the old one.
>   
Now that is interesting, I am sure I would of realized that eventually,
I have certainly seen it in action. Just hadent thought of that this
time. Thanks.

So does mv essentially become copy when between mounts?
>   
>>> You could write the size changes in a journal, but that blows up the
>>> size of information that would need to be stored in a journal.  It
>>> also slows down the very common operaton of writing to a file, all for
>>> the sake of speeding up the relatively uncommon "du -s" operation.
>>> It's not at all clear it's worthwhile tradeoff.
>>>
>>>       
>> Yeah fsck is an interesting scenario.
>> Databases have had to deal with this and maybe there are hints like the
>> two phase commit and
>> the WAL just for the size updates.
>> Maybe we set a flag in the directory entry when we update it, cause we
>> are writing this update to disk anyway.
>> Then when update completes at the parent, the flag is cleared. Now this
>> makes two writes for each directory but the process is resumable during fsk
>>     
>
> No. Updating the size at the same time as the main inode write is far
> cheaper than opening a second transaction just for the size update -
> unless computing the new size is an expensive operation as well.
>   
But the size of a subdirectory is not stored in the inode in this
scenario, it is stored in the directory entry.
Or is it? Their is an inode for the directory file, maybe just adjust
the inode and return the subdir size if type is direntry.
Maybe this is on a flag and the directory can look like this ...
...
-rw-r--r--   1 root root          14347 Jan 24  2009 thickbox.js~
-rw-r--r--   1 root root          18545 Jun 10 18:56 unofficalTranscript.txt
-rw-r--r--   1 root root      322183635 Aug 11 20:20 uw_mm_inflamm_ipodv.m4v
drwxr-xr-x   2 root root     440(56093) Nov 23  2007 varicaddemo
drwxr-xr-x   2 root root     144(10298) Oct 23  2007 varicaddemos

                   TOTAL 322217111 (322282918) 

Where the number in parenthesis is the subdir total.

The Total at the end of the dir command, just like du or anything using
the stat command is now practical. (ever used filelight?)



>   
>> I need to look at the cashing and how we handle changes already.  Do we
>> write things immediately all the time? Then why must I "sync" before
>> unmount. hummmm
>>     
>
> You don't need to sync before umount. umount automatically syncs the
> filesystem it's applied on after it's removed from the namespace, but
> before the umount completes. Additionally, dirty buffers and pages are
> written back automatically based on memory pressure and timeouts - see
> /proc/sys/vm/dirty_* for the knobs for this.
>   
I know it now does the sync for you, but the fact a sync must be done
indicates there are buffers not written, correct?
>>> In addition, how will you handle hard links?  An inode can have
>>> multiple hard links in different directories, and there is no way to
>>> find all of the directories which might contain a hard link to a
>>> particular inode, short of doing a brute force search.  Hence if you
>>> have a file living in src/linux/v2.6.29/README, and it is a hard link
>>> to ~/hacker/linux/README, and a program appends data to the file
>>> ~/hacker/linux/README, this would also change the result of running du
>>> -s src/linux/v2.6.29; however, there's no way for your extension to
>>> know that.
>>>       
>
> ^^^ don't skip this part, it's absolutely critical, the biggest
> problem with your proposal, and you can't just handwave it away.
>   
I will sleep on the hard link issue. There must be an answer as DU must
handle this.
I can see where if I can't distinquish between which is the hard link
and which is not becasue they are implemented the same.

First think is to run an experiment in the morning

    test/foo/bar/file
    test/bar/foo/file
    where file is the same file close to the disk block size.
    does 'du -s in foo' + 'du -s in bar'  = 'du -s' in test?

> One thing you may want to look into is the new fanotify API[1] - it
> allows a userspace program to monitor and/or block certain filesystem
> events of interest. You may be able to implement a prototype of your
> space-usage-caching system in userspace this way without needing to
> modify the kernel. Or implement it as a FUSE layered filesystem. In
> the latter case you may be able to make a reverse index of sorts for
> hardlink handling - but this carries with it quite a bit of overhead.
>   
FUSE is an option I was keeping open.
Since I can dedicate a mountpoint to a file system and mount and umount
it and load and unload a kernel module FUSE, seemed like extra work with
little benefit. 
That does sound like a lot of overhead.
> PS - it's normal to keep all CCs when replying to messages on lkml
> (that is, use reply to all), as some people may not be subscribed, or
> may prefer to get extra copies in their inbox. I personally don't mind
> either way, but there are some who are very adamant about this point.
>   
ok, The other lists I am on are insistent that I only send to the list
address.
> [1] - http://lwn.net/Articles/339399/
>
>   

