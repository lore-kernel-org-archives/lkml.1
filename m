Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXAaBTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXAaBTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932111AbXAaBTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:19:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbXAaBTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:19:44 -0500
Message-ID: <45BFEE85.30203@redhat.com>
Date: Tue, 30 Jan 2007 20:19:01 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: akpm@osdl.org, Jeff Layton <jlayton@redhat.com>, dev@sw.ru,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] pipefs unique inode numbers
References: <Pine.LNX.4.58.0701302314210.2203@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0701302314210.2203@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
 > change pipefs to use a unique inode number equal to the memory
 > address unless it would be truncated.
 >
 > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
 > ---
 > Tested on i386.
 >
 > --- 2.6.19/fs/pipe.c.ori	2007-01-30 22:02:46.000000000 +0100
 > +++ 2.6.19/fs/pipe.c	2007-01-30 23:22:27.000000000 +0100
 > @@ -864,6 +864,10 @@ static struct inode * get_pipe_inode(voi
 >  	inode->i_uid = current->fsuid;
 >  	inode->i_gid = current->fsgid;
 >  	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 > +	/* The address of *inode is unique, so we'll get an unique inode number.
 > +	 * Off cause this will not work for 32 bit inodes on 64 bit systems. */
 > +	if (sizeof(inode->i_ino) >= sizeof(struct inode*))
 > +		inode->i_ino = (unsigned int) inode;
 >
 >  	return inode;
 >

Also, that patch would break many 32-bit programs not compiled with large
offsets when run in compatibility mode on a 64-bit kernel. If they were to
do a stat on this inode, it would likely generate an EOVERFLOW error since
the pointer address would probably not fit in a 32 bit field.

That problem was the whole impetus for this set of patches.

-- Jeff
