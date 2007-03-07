Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbXCGRXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbXCGRXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXCGRW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:22:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965398AbXCGRWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:22:38 -0500
Date: Wed, 7 Mar 2007 09:21:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <45EE66BE.8020003@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703070903420.5963@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org>
 <45EE6125.3010702@cosmosbay.com> <45EE66BE.8020003@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Eric Dumazet wrote:
> 
> Crazy ideas : (some readers are going to kill me)

First off, as noted earlier, you don't need crazy ideas. 

But:

> 1) Use the low order bit of f_path.dentry to say : this pointer is not a
> pointer to a dentry but the inode pointer (with the low order bit set to 1)

No, we don't want to do that. There's a lot of code that wants to just 
follow the dentry/inode chain unconditionally, and we want to have people 
able to just do

	i_size_read(file->f_path.dentry->d_inode);

kind of thing, without having to check anything in between. It's costly 
enough that we have a chain of pointers, it's much *worse* if we then have 
to make conditionals etc (and forgetting is an oops).

> 2) file->f_path.dentry set to NULL for this special files (so that we dont
> need to dput() and cache line ping pong the common dentry each time we
> __fput() a pipe/socket.

I agree abot the ping pong, but I suspect it's a lot less than the current 
pingpong on dcache_lock, which is a lot hotter than a pipe-dentry counter 
would be.

If it becomes a big issue, we could just have a fixed number of dentries, 
and hash them out some way (to dilute the ping-ponging). So making things 
NULL would just be horrible for everybody, since we have lots of generic 
code that just looks up the dentry and inode, and we don't want to make 
that worse.

(I'm sure using "filp->f_private_data" has some downsides too, but it 
seems fairly simple at least for pipes. The biggest problem is likely that 
we currently use the mutex in the inode in "filp->f_dentry->d_inode" as a 
way to protect the inode->i_pipe pointer itself, and there is no 
equivalent locking at the "struct file *" level at all. We might have to 
make the "f_ep_lock" spinlock be unconditional)

		Linus
