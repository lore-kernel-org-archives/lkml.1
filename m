Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZIYFw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZIYFw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 01:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZIYFwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 01:52:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58506 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZIYFwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 01:52:24 -0400
To: Andreas Gruenbacher <agruen@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <200909250223.58664.agruen@suse.de> (message from Andreas
	Gruenbacher on Fri, 25 Sep 2009 02:23:58 +0200)
Subject: Re: [PATCH] vfs: new O_NODE open flag
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de>
Message-Id: <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Sep 2009 07:52:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009, Andreas Gruenbacher wrote:
> On Thursday, 24 September 2009 16:51:58 Miklos Szeredi wrote:
> > This patch adds a new open flag, O_NODE.  This flag means: open just
> > the filesystem node instead of the object referenced by the node.
> 
> What is the intended use for O_NODE?

It lets userspace file descriptors reference a inode without actually
"dereferencing" it to get the underlying object.  This allows for a
couple of new things:

 - opening a special file (device/socket/fifo) without side effects

 - opening a symlink

 - opening any type of file without any permission is also possible
   (of course the resuling file descriptor may not be read or written)

The above allows fstat(), fchmod(), ioctl(), etc to be used for files
previously not possible.  AFS for example wanted a "pioctl()" syscall
for various things, but the same can be done without having to define
a new syscall:

     fd = open(path, O_NODE);
     ioctl(fd, ...);
     close(fd);

Another important use would be opening a directory without read
permission (see O_SEARCH from the POSIX draft for what this is useful
for).  O_NODE is not quite equivalent to O_SEARCH, but similar and
equally useful.

Thanks,
Miklos
