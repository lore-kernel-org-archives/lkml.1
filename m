Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZHYCFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZHYCFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZHYCFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:05:08 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:48192 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbZHYCFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:05:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=FzUMc/sklSQQGA6oBSdsZugCfuDpKjVEzKymG/AcAHU6iE9TnQIvwbOTu1jQPjeT;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4A9346D2.6040108@earthlink.net>
Date: Mon, 24 Aug 2009 19:05:06 -0700
From: Jeff Shanab <jshanab@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090714 SeaMonkey/1.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early	research
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 41b7b48e67ad7886d780f4a490ca6956abb457f1b4332f520d7dd4f256b55344d90811b9cde4db75350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 75.150.3.226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Mon, Aug 24, 2009 at 04:54:52PM -0700, Jeff Shanab wrote:
>   
>> >     I was thinking that a good way to handle this is that it starts with
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
> Is this something that you want to be stored in the file system, or
> just cached in memory?  If it is going to be stored on disk, which
> seems to be implied by your description, and it is only going to be
> updated once a second, what happens if there is a system crash?  Over
> time, the values will go out of date.  Fsck could fix this, sure, but
> that means you have to do the equivant of running "du -s" on the root
> directory of the filesystem after an unclean shutdown.

Could this could be done low priority in the background long after fsck and the boot process is done?
There will probably be a cutoff point where du -s after a command is better than the file by file, like when we recursively move a directory But I was gonna run tests and see how that went. Mv may be actually easier than cp, it is a tree grafting.

> You could write the size changes in a journal, but that blows up the
> size of information that would need to be stored in a journal.  It
> also slows down the very common operaton of writing to a file, all for
> the sake of speeding up the relatively uncommon "du -s" operation.
> It's not at all clear it's worthwhile tradeoff.
>   
Yeah fsck is an interesting scenario.
Databases have had to deal with this and maybe there are hints like the
two phase commit and
the WAL just for the size updates.
Maybe we set a flag in the directory entry when we update it, cause we
are writing this update to disk anyway.
Then when update completes at the parent, the flag is cleared. Now this
makes two writes for each directory but the process is resumable during fsk
I need to look at the cashing and how we handle changes already.  Do we
write things immediately all the time? Then why must I "sync" before
unmount. hummmm
> In addition, how will you handle hard links?  An inode can have
> multiple hard links in different directories, and there is no way to
> find all of the directories which might contain a hard link to a
> particular inode, short of doing a brute force search.  Hence if you
> have a file living in src/linux/v2.6.29/README, and it is a hard link
> to ~/hacker/linux/README, and a program appends data to the file
> ~/hacker/linux/README, this would also change the result of running du
> -s src/linux/v2.6.29; however, there's no way for your extension to
> know that.
>
>   
>> > title: "User Metadata" aka "pet peeve reduction"
>> >     I would like to maintain a few classifications of metadata, most
>> > optional and configurable.
>>     
>
> Most Linux filesystems already have extended attributes that can be
> used to store your proposed metadata.  Changing user application
> programs to store the keywords, etc., is an exercise in
> application-level programming; the kernel-side support is already
> there.
>
> 						- Ted
>
>   
Cool, a project for next summer
