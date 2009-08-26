Return-Path: <linux-kernel-owner+w=401wt.eu-S1751051AbZHZOm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbZHZOm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZHZOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:42:59 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:57676 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbZHZOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:42:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=UnATF/HR+HIk/HwbO/9V0YKrejTjYNXP+9+S4YxegTfuY81R+5A8gjOrxkPZ4j8B;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4A9549F2.4080504@earthlink.net>
Date: Wed, 26 Aug 2009 07:42:58 -0700
From: Jeff Shanab <jshanab@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090714 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early	research
 Re: Starting a grad project that may change kernel VFS.	Early  research
References: <4A93428A.4070903@earthlink.net> <4A941F56.8060502@redhat.com> <4A9427C7.8020009@earthlink.net> <20090826013043.GB17684@mit.edu> <4A94BF9E.2010101@earthlink.net> <20090826130513.GM32712@mit.edu>
In-Reply-To: <20090826130513.GM32712@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 41b7b48e67ad7886d780f4a490ca6956abb457f1b4332f52c23e672c9b8bef17e72c2849d2f6a354350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 75.150.3.226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Aug 25, 2009 at 09:52:46PM -0700, Jeff Shanab wrote:
>   
>> True or false
>> When we write a file we already write into it's inode and the
>> directorie's inode.
>>     
>
> False; when we write into a file we need to update the inode's m_time
> field, but we don't have to update the directory's inode.  So updating
> the directory inode when you write into a file is already increasing
> the overhead in terms of the file system metadata that will have to be
> updated on an *extremely* common filesystem operation.
>   
oops, my bad. when I said "write a file" I meant "create the file" ie,
for the first time.
> In the case of hard links, where there are multiple directory entries
> pointing to the same inode, we don't even have an efficient way of
> knowing where the other "parent" directories are, and none of the
> directory entries are "distinguished" in any way; you don't know which
> directory entry was the "first" entry created, and in fact it may have
> already been deleted.
>
>   
Yeah, A Deal breaker at the moment. Maybe a "fix" to this is a
pre-requisite for this idea.
Or maybe a workaround in the accounting side of things.
>   
>> When we update a file we write into the inode and we had to load the
>> dentry to get there.
>>     
>
> While a file is open for writing, the inode and the directory inode
> used to gain access to the file are pinned via the dentry cache,
> correct.
>
> Note however, that we can't change the meaning of i_blocks for
> directories without introducing serious compatibility problems;
I have just gotten started on this and this is the first time i_blocks
has come up.
I need to look into the structures closer, but as I look at the VFS and
web site explinations, it appears to be the c equivilent of the abstract
interface. (not counting all the caching) So there are operation
pointers that are called by the kernel to do things like, get the size.
I thought this system  insulates us from the differences in individual
file systems. It does look more and more that all the changes are going
into the/a file system and not in the VFS.
>  so if
> you want to have a "size of everything under this directory", you will
> need to allocate a new inode field; this means an filesystem-specific
> on-disk change.
>   
Ok, I was afriad of that. While it would have been nice to have it at
the VFS level so it works for all filesystems, it doesn't look like that
is practical or possible.
>   
>> The main addition in this idea is the low prioirity task to walk the
>> tree to root forcing adjustments along the way.
>>     
>
> But it can't be low priority, or else the information will be horribly
> out of date if the system crashes and the filesystem isn't cleanly
> unmounted.  To solve this solution, you only have two choices.  (1)
> Update all of the parent directories at the time of the file write,
> and log these updates in the journal just as with all other metadata
> updates, with the attendent increase in overhead and performance loss,
> OR (2) force a limited fsck after each unclean reboot that walks the
> directory tree to correctly update the subdirectory summary sizes.
> Since you will need to walk the entire inode table to fix any broken
> summary sizes, the time it will take to do this is roughly equivalent
> to fsck Pass 1 and pass2 for ext2/3/4 filesystems (which is about 90%
> of a full fsck).  Furthermore, it either needs to be done via the
> filesystem is unmounted or mounted read-only, or you will need to add
> a huge amount of complexity to deal with the fact that filesystem
> might be getting modified while you are recalculating the summary
> statistics.
>   

Admittedly I need to study up on how recovery works now, especially for
a journaled file system.

Perhaps there is a 3. A sort of Distributed write Ahead log stored in
the inode of the directory itself.
If the process is completed, it is removed adding a second write to the
dentry's inode. If not, the queued task is found during fsck and started
again. But this fails if the changes to an dentry's inode are just
sitting in the cache at time of crash. Is the journal a write through
cache system? Is there a reference you can recommend?, I have just been
googeling and reading some source code.

When recovery is considered, The tasks will probably have to be idempotent.
>
> As far as knowing whether or not a copy will succeed, that depends on
> whether the copy is going to be smart about preseving hard links, and
> whether or not the copy will be copying symlinked files as real files.
> So you can only give a very specialized answer assuming only one set
> of copy options.
>
>    						- Ted
>
>   
I have a seemingly dumb question, but I need a good answer for it. What
good are hardlinks, Do we need them with the advent of symlinks? Are
they just a vestigial feature or is there a real use case where they are
preferred? I don't think I have any hard links on this machine, but of
course, how would I know? ;-) I know i have seen them used in some
chroot environments at work.
I can see they allow du, for example, to give an accurate size of a
directory as it would be if copied to another drive, symlinks don't do
that AFAIK. In fact the copy is missing data. Guess I answered My own
question?
>   

