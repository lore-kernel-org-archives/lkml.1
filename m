Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYCWQvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYCWQvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 12:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYCWQvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 12:51:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbYCWQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:51:24 -0400
Message-ID: <47E68A4D.7010706@zytor.com>
Date: Sun, 23 Mar 2008 09:50:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Michael Tokarev <mjt@tls.msk.ru>, Andreas Schwab <schwab@suse.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /dev/stdin, symlinks & permissions
References: <47DEFE26.80101@msgid.tls.msk.ru> <jeabkwaou7.fsf@sykes.suse.de> <47DF6E13.5050709@msgid.tls.msk.ru> <20080318125445.GS8368@mit.edu> <20080318143222.GF10722@ZenIV.linux.org.uk> <20080318150439.GB27000@mit.edu>
In-Reply-To: <20080318150439.GB27000@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 
> Maybe our mistake was to make /dev/fd a symlink to /proc/self/fd, and
> /dev/stdin a symlink to /proc/self/fd/0, et. al, since we don't get
> the semantics exactly right compard to other operating systems.
> 

No, our mistake was doing broken semantics and thinking they were good 
enough.

>> 1.2 tried to mix both.  I'm not actually sure that it was a good idea wrt
>> security, while we are at it...
> 
> What is the security problem that you are worried about?  That it
> might leak the pathname to someone who had an open file handle to the
> file?  That doesn't seem like a huge deal to me....
> 
>> We could implement Plan 9 style dupfs, but to do that without excessive
>> ugliness we'd need to change prototype of ->open() - it must be able to
>> return a reference to struct file different from anything it got from
>> caller; probably the least painful way would be to make it return
>> 	NULL => success, use struct file passed to ->open()
>> 	ERR_PTR(-err) => error
>> 	pointer to struct file => success, caller should drop the
>> reference to struct file it had passed to ->open() and use the return value.
>> Still a mind-boggling amount of churn - probably too much to bother with.
> 
> Yeah, ouch.  The only other way to do it would be to add a new
> function pointer to the file_operations() field which would only be
> used filled in by procfs inodes, and then have the sys_open() routine
> call that function pointer if open() was zero.  But that would be
> quite ugly....
> 

There is, at least theoretically speaking, another reason to do this: it 
would allow a device driver that makes userspace upcalls a much cleaner 
way to say "you really want this thing over there" by simply opening in 
userspace and passing down the file descriptor.

My suggestion for how to implement this would be to librarize the 
allocation of a new file structure, and make it a new ->alloc_open() 
method.  The default implementation of ->alloc_open() would be (VERY 
VERY simplified, obviously):

alloc_open(inode)
{
	struct file *file = allocate_new_file();
	inode->ops->open(file);
	return file;
}

	-hpa
