Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZHYBqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZHYBqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZHYBqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:46:50 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:46361 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbZHYBqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:46:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=QYK2Q0+WqyzfInSaUWumH7x42gvYwrSpJcBZXPVQ0Y7CfhC+UYt2hyRciU3NHXEl;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4A93428A.4070903@earthlink.net>
Date: Mon, 24 Aug 2009 18:46:50 -0700
From: Jeff Shanab <jshanab@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090714 SeaMonkey/1.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early 	research
 Re: Starting a grad project that may change kernel VFS. Early 	research
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 41b7b48e67ad7886d780f4a490ca6956abb457f1b4332f52c1391cd10feaf2c0172508d4291d7f3c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 75.150.3.226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the prompt replys!
> On Mon, Aug 24, 2009 at 7:54 PM, Jeff Shanab<jshanab@earthlink.net> wrote:
>   
>> > Title: "Pay it forward patch set"
>> > Goal: Desire to change the dentry and inode functionality so commands
>> > like du -s appear to have greatly improved performance.
>> > How: TBD? 2 phase ubdate walking up the tree to root.
>> >
>> >   Prior to actually starting my Grad Project in Computer science, I am
>> > taking 1 semester to do research for it at the recommendation of my
>> > advisory.  I need to of course make sure it doesn't already exist.  It
>> > may be that all the changes end up in a file system and the kernel will
>> > be left alone, just one of the things I want help determining.
>> >
>> > 1) First question, where to put this functionality?
>> >    I originally thought to put my functionality in the VFS so that all
>> > mounted file systems could share it, but after reading fs.h, and
>> > inode.c, it looks like the VFS is purely an abstract interface and
>> > functionality at that level may not be wanted? Also I guess certain file
>> > systems may not have needed on disk structures to save the info (ie
>> > VFAT,NFS, etc)
>>     
>
> VFS has a lot of generic functionality that filesystems can opt into -
> but see below about your specific proposals...
>   
>   
>> > 2) Second Question. The two part idea.
>> >    I was thinking that a good way to handle this is that it starts with
>> > a file change in a directory. The directory entry contains a sum already
>> > for itself and all the subdirs and an adjustment is made immediately to
>> > that, it should be in the cache. Then we queue up the change to be sent
>> > to the parent(s?). These queued up events should be a low priority at a
>> > more human time like 1 second. If a large number of changes come to a
>> > directory, multiple adjustments hit the queue with the same (directory
>> > name, inode #?) and early ones are thrown out. So levels above would see
>> > at most a 1 per second low priority update.
>>     
>
> As I understand it, you want to tag each directory with the total size
> of its contents. There are a few problems with this:
> 1) A metadata change is required for a filesystem to use this. It
> would be prohibitively expensive to cache all directories in memory to
> remember their sizes, and we can't just traverse a directory and all
> of its contents to find its disk space usage just because someone
> touched it. So the size has to be remembered on disk.
>   
Agreed and planned to save on disk.
You never need to look further than the directory you are already in.
> 2) Hard links break this scheme rather badly. Consider if /foo/x is
> hardlinked to /bar/x. Then something modifies /bar/x. The kernel
> cannot find all other hardlinks to /bar/x, so /foo's disk usage
> estimate is not updated. Moreover /'s disk space usage would have
> twice the actual size used by /{foo,bar}/x.
>   
Updates start at the file and only work upwards back to root. How does
the hardlink get traversed?

> You can't just call it a rough estimate to get around 2), as the error
> can build up without bounds, until you have directories apparently
> taking 10x the size of your actual hard disk. That said, for
> filesystems without hardlinks this is doable, but most Linux
> filesystems support hardlinks. Heck, even NTFS supports hardlinks. So
> it's unlikely to be useful in Linux...
>   
I need to look closely at how hard links are done, I think they count as
zero if they can be distinguished.
My thought was that a directory foo has size zero then a file is added
and the directory size is adjusted by the filesize.
Then a subdir is added and no adjustment is made
Then a file is placed in the subdir and it's directory gets updated and
a message to add X to subdir entry is queed and sent to parent.
THe parent directory adjusts the single entry and it's subtotal and
queues it's message to it's parent.
When the parent is root the process stops.
I think the system will have just cached all the inodes for the current
directory you are in and for that matter all the directories you
traversed getting to where you are. 

Since we only update up the tree to root, don't the hard links get ignored?
>   
>> >    I have a second set of changes I am considering and I think would
>> > fit more completely in a file system, but I bring them up here in case
>> > it influences the above.
>> > title: "User Metadata" aka "pet peeve reduction"
>> >    I would like to maintain a few classifications of metadata, most
>> > optional and configurable.
>>     
> [snip details]
>
> This is already supported through user xattrs. It just needs more
> application support (good luck getting flash to use them for temp
> files though  ;) 
>
>   
Cool, seperate project then.

