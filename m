Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXAaBiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXAaBiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXAaBiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:38:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbXAaBiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:38:02 -0500
Message-ID: <45BFF2D0.4050808@redhat.com>
Date: Tue, 30 Jan 2007 20:37:20 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: akpm@osdl.org, dev@sw.ru, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] pipefs unique inode numbers
References: <Pine.LNX.4.58.0701302314210.2203@be1.lrz> <45BFEE85.30203@redhat.com>
In-Reply-To: <45BFEE85.30203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> Bodo Eggert wrote:
>  > change pipefs to use a unique inode number equal to the memory
>  > address unless it would be truncated.
>  >
>  > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
>  > ---
>  > Tested on i386.
>  >
>  > --- 2.6.19/fs/pipe.c.ori    2007-01-30 22:02:46.000000000 +0100
>  > +++ 2.6.19/fs/pipe.c    2007-01-30 23:22:27.000000000 +0100
>  > @@ -864,6 +864,10 @@ static struct inode * get_pipe_inode(voi
>  >      inode->i_uid = current->fsuid;
>  >      inode->i_gid = current->fsgid;
>  >      inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  > +    /* The address of *inode is unique, so we'll get an unique inode 
> number.
>  > +     * Off cause this will not work for 32 bit inodes on 64 bit 
> systems. */
>  > +    if (sizeof(inode->i_ino) >= sizeof(struct inode*))
>  > +        inode->i_ino = (unsigned int) inode;
>  >
>  >      return inode;
>  >
> 
> Also, that patch would break many 32-bit programs not compiled with large
> offsets when run in compatibility mode on a 64-bit kernel. If they were to
> do a stat on this inode, it would likely generate an EOVERFLOW error since
> the pointer address would probably not fit in a 32 bit field.
> 
> That problem was the whole impetus for this set of patches.
> 

Actually, sorry...I misread the patch. It wouldn't have that problem. My
mistake.

Still though, I considered an approach somewhat similar to this early on.
I was thinking of taking a bit-shifted inode address and hashing it to
give a unique value. If you do the math, you can discard the lower 9 bits
of the pointer, so you end up being able to use the lower 41 bits of the
pointer. So a scheme like that could work if you could guarantee that
all inode addresses wouldn't be > 2^41 apart.

The problem is, you can't guarantee that, especially in a NUMA situation.

See the thread entitled:

[RFC][PATCH] ensure i_ino uniqueness in filesystems without
permanent inode numbers (via pointer conversion)

in linux-fsdevel, ~Nov 17th for more info.

-- Jeff
