Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYFBKhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYFBKhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYFBKhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:37:02 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:55296 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYFBKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:37:00 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <200806020912.49721.arnd@arndb.de>
References: <200805311737.58991.arnd@arndb.de> <200806012349.29538.arnd@arndb.de> <9785.1212374902@jrobl> <200806020912.49721.arnd@arndb.de>
Date: Mon, 02 Jun 2008 19:36:32 +0900
Message-ID: <9159.1212402992@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann:
> Without reading either again, the top problems in unionfs at the time were:
> * data inconsistency problems when simultaneously accessing the underlying
>   fs and the union.
> * duplication of dentry and inode data structures in the union wastes
>   memory and cpu cycles.
> * whiteouts are in the same namespace as regular files, so conflicts are
>   possible.
> * mounting a large number of aufs on top of each other eventually
>   overflows the kernel stack, e.g. in readdir.
> * allowing multiple writable branches (instead of just stacking
>   one rw copy on a number of ro file systems) is confusing to the user
>   and complicates the implementation a lot.
> 
> With the exception of the last two, I assumed that these were all
> unfixable with a file system based approach (including the hypothetical
> union-tmpfs). If you have addressed them, how?

I will try explain individually.
Here are what I implemented in AUFS.
Any comments are welcome.

> * data inconsistency problems when simultaneously accessing the underlying
>   fs and the union.
Aufs has three levels of detecting the direct-access to the lower
(branch) filesystems (ie. bypassing aufs). I guess the most strict level
is a good answer for your question. It is based on the inotify
feature. Aufs sets inotify-watch to every accessed directories on lower
fs. During those inodes are cached, aufs receives the inotify event for
thier children/files and marks the aufs data for the file is
obsoleted. When the file is accessed later, aufs retrives the latest
inode (or dentry) again.
The inotify-watch will be removed when the aufs dir inode is discarded
from cache.


> * duplication of dentry and inode data structures in the union wastes
>   memory and cpu cycles.

Aufs has its own dentry and inode object as normal fs has. And they have
pointers to the corresponding ones on the lower fs. If you make a union
from two real filesystems, then aufs inode will have (at most) two
pointers as its private data.
Do you mean having pointers is a duplicataion?


> * whiteouts are in the same namespace as regular files, so conflicts are
>   possible.

Yes, that's right.
Aufs reserves ".wh." as a whiteout prefix, and prohibits users to handle
such filename inside aufs. It might be a problem as you wrote, but users
can create/remove them directly on the lower fs and I have never
received request about this reserved prefix.


> * mounting a large number of aufs on top of each other eventually
>   overflows the kernel stack, e.g. in readdir.

Aufs readdir operation consumes memory, but it is not stack. If it was
implemented as a recursive function, it might cause the stack
overflow. But actually it is a loop.
The memory is used for stroing entry names and eliminating whiteout-ed
ones, and the result will be cached for a specified time. So the memory
(other than stack) will be consumed.


> * allowing multiple writable branches (instead of just stacking
>   one rw copy on a number of ro file systems) is confusing to the user
>   and complicates the implementation a lot.

Probably you are right. Initially aufs had only one policy to select the
writable branch. But several users requested another policy such as
round-robin or most-free-spece, and aufs has implemented them.
I don't guess uers will be confused by these policies. While I tried it
should be simple, I guess some people will say it is complex.


Junjiro Okajima


