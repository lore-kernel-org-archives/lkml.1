Return-Path: <linux-kernel-owner+w=401wt.eu-S2992990AbXCIFxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992990AbXCIFxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992989AbXCIFxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:53:10 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:34363 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992990AbXCIFxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:53:09 -0500
Message-ID: <45F0F644.6020705@cosmosbay.com>
Date: Fri, 09 Mar 2007 06:53:08 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>	 <45F09F9C.4030801@cosmosbay.com>	 <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>	 <45F0A71C.2000800@cosmosbay.com> <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
In-Reply-To: <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 09 Mar 2007 06:53:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards a écrit :
> On 3/8/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> Absolutely not. We dont want to slow down kernel 'just in case a fool 
>> might
>> want to do crazy things'
> 
> Actually, I think it would make the kernel (negligibly) faster to bump
> f_pos before the vfs_write() call.  Unless fget_light sets fput_needed
> or the write doesn't complete cleanly, you won't have to touch the
> file table entry again after vfs_write() returns.  You can adjust
> vfs_write to grab f_dentry out of the file before going into
> do_sync_write.  do_sync_write is done with the struct file before it
> goes into the aio_write() loop.  Result: you probably save at least an
> L1 cache miss, unless the aio_write loop is so frugal with L1 cache
> that it doesn't manage to evict the struct file.
> 
> Patch to follow.

Dont even try, you *cannot* do that, without breaking the standards, or 
without a performance drop.

The only safe way would be to lock the file during the whole read()/write() 
syscall, and we dont want this (this would be more expensive than current)
Dont forget 'file' may be some sockets/tty/whatever, not a regular file.

Standards are saying :

If an error occurs, file pointer remains unchanged.

You cannot know for sure how many bytes will be written, since write() can 
returns a count that is different than buflen.

So you cannot update fpos before calling vfs_write()

About your L1 'miss', dont forget that multi-threaded apps are going to 
atomic_dec_and_test(&file->f_count) anyway when fput() is done at the end of 
syscall. And you were concerned about multi-threaded apps, didnt you ?

