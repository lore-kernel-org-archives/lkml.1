Return-Path: <linux-kernel-owner+w=401wt.eu-S1422952AbXCGRqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422952AbXCGRqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422787AbXCGRq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:46:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422811AbXCGRpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:45:55 -0500
Date: Wed, 7 Mar 2007 09:45:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <200703071831.36930.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703070934480.5963@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <45EE6125.3010702@cosmosbay.com>
 <Pine.LNX.4.64.0703070859070.5963@woody.linux-foundation.org>
 <200703071831.36930.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Eric Dumazet wrote:
> 
> sockets already uses file->private_data.
> 
> But calls to read()/write() (not send()/recv()) still need to go through the 
> dentry, before entering socket land.

Sure. The dentry and the inode need to *exist*, but they can be one single 
static dentry/inode per "file descriptor type".

We always pass in the "struct file *" to read/write too, since we need it 
anyway for things like file control information (eg "is it a nonblocking 
read or write" kinds of things).

So I'm not suggesting a NULL dentry/inode, I'm suggesting a single static 
one per type.

And yeah, it may be harder than it looks. Some things "know" that all the 
relevant info is in the inode, so they just pass in the inode. In the pipe 
layer, for example, you'd need to change free_pipe_info() and 
alloc_pipe_info() to pass in the file descriptor instead, same goes for 
pipe_release(). But the "struct file *" is always available, it's just 
that since the code was originally written to have all the info in the 
inode, some of the code isn't set up to use it or pass it on..

But your patch is independent of that, and looks fine. Except I don't like 
this part:

-       file->f_path.mnt = mntget(sock_mnt);
+       file->f_path.mnt = NULL;

since I'd be much happer with always having f_path.mnt available, the same 
way we should always have f_path.dentry there.

(Btw, your patch is *not* going to work with the file->f_private_data 
approach, because d_path() is not passed down the "file *" thing. So we'd 
need to do that, and that's more intrusive (it can be NULL, since for 
things like cwd/pwd we don't have a "struct file").

But I like your patch as a totally independent thing. "It just makes 
sense". 

(Apart from the f_path.mnt thing, which I think was something else ;)

			Linus
