Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbZHZPJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbZHZPJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZHZPJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:09:21 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:52155 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZHZPJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:09:20 -0400
X-Greylist: delayed 137369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 11:09:20 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KG7lbzKtniD9lVVxh1LQqx/E9BZWcG4DjdtbRFDq3Q4BWNZb4YNaezeLpY1jFHas47
         V94WfqxiRle/cJU3P5HONvKWF1VtvOUWI5m9Nay0Ci/0j79wugdj5KH5KVomNj0GYTZg
         3Hpvqzt+zuD5OMDrFmUtM75tyP30LggbnA8Hg=
MIME-Version: 1.0
In-Reply-To: <4A9549F2.4080504@earthlink.net>
References: <4A93428A.4070903@earthlink.net> <4A941F56.8060502@redhat.com> 
	<4A9427C7.8020009@earthlink.net> <20090826013043.GB17684@mit.edu> 
	<4A94BF9E.2010101@earthlink.net> <20090826130513.GM32712@mit.edu> 
	<4A9549F2.4080504@earthlink.net>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 26 Aug 2009 11:09:01 -0400
Message-ID: <3e8340490908260809q6ad4d535ice24cc29f7985a9a@mail.gmail.com>
Subject: Re: Starting a grad project that may change kernel VFS. Early 
	research Re: Starting a grad project that may change kernel VFS. Early 
	research
To: Jeff Shanab <jshanab@earthlink.net>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:42 AM, Jeff Shanab<jshanab@earthlink.net> wrote:

> Admittedly I need to study up on how recovery works now, especially for
> a journaled file system.
>
> Perhaps there is a 3. A sort of Distributed write Ahead log stored in
> the inode of the directory itself.
> If the process is completed, it is removed adding a second write to the
> dentry's inode. If not, the queued task is found during fsck and started
> again. But this fails if the changes to an dentry's inode are just
> sitting in the cache at time of crash. Is the journal a write through
> cache system? Is there a reference you can recommend?, I have just been
> googeling and reading some source code.

With journalling filesystems, fsck will not be run in a crash, so a
flag as you suggest is insufficient. Moreover, a fsck will traverse
the entire filesystem, so it can (and must) just directly check that
all size fields are correct.

In a typical journalling filesystem such as ext3, prior to making any
changes to the disk, it will write a copy of all changes it will make
to a seperate log. Once these are committed to disk, they will be
copied to their final locations in the real filesystem data and
metadata. Other filesystems such as btrfs use the 'dancing trees'
approach - where the new data is allocated into free space, and commit
is done by changing some root pointers to make this new data be used.

You may want to take a look at
http://olstrans.sourceforge.net/release/OLS2000-ext3/OLS2000-ext3.html
for an overview of how ext3 in particular works.

>>
>> As far as knowing whether or not a copy will succeed, that depends on
>> whether the copy is going to be smart about preseving hard links, and
>> whether or not the copy will be copying symlinked files as real files.
>> So you can only give a very specialized answer assuming only one set
>> of copy options.
>>
>>                                               - Ted
>>
>>
> I have a seemingly dumb question, but I need a good answer for it. What
> good are hardlinks, Do we need them with the advent of symlinks? Are
> they just a vestigial feature or is there a real use case where they are
> preferred? I don't think I have any hard links on this machine, but of
> course, how would I know? ;-) I know i have seen them used in some
> chroot environments at work.

Run: find / -xdev -type f -and -not -links 1

A typical debian installation contains a number of hardlinks,
including some for identical timezones under different names, or for
wine's wrapper scripts, or for gunzip and uncompress, or for various
e2fstools, or many other examples.

> I can see they allow du, for example, to give an accurate size of a
> directory as it would be if copied to another drive, symlinks don't do
> that AFAIK. In fact the copy is missing data. Guess I answered My own
> question?

I have no idea what you mean by this...
Keep in mind du can dereference symlinks to get the size of the target
(-L option).
