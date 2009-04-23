Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbZDWAKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbZDWAKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZDWAKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:10:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZDWAKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:10:20 -0400
Message-ID: <49EFB1A9.3060503@kernel.org>
Date: Thu, 23 Apr 2009 09:09:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 00:09:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
> Hello Tejun,
> 
> Sorry for the delay, I was busy reimplementing some of the stuff in
> your patchset.  The current state is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git cuse-test
> 
>   http://git.kernel.org/?p=linux/kernel/git/mszeredi/fuse.git;a=shortlog;h=cuse-test
> 
> What I changed (IIRC):
> 
>  - Don't store pointer to struct inode, struct fuse_inode, and struct
>    file in struct fuse_file.  Instead store nodeid in struct
>    fuse_file, no worries about object lifetimes this way.

Hmm... there really isn't any object lifetime issue with or without
the pointers as both fuse_file and fuse_inode follow VFS lifetime
rules.  I tried several different approaches including adding nodeid
but what pushed me toward adding the pointers was that the parameter
passing and which uses/depends on what becomes a bit too complex with
other approaches.  e.g. How do you discern between needing vfs inode
and fuse inode?

>  - Don't implement fsync and flush in CUSE, they don't really make
>    sense on character devices.  At least I can't think of any use for
>    them.
>  - release() in CUSE can be synchronous.  Asynchronous release causes
>    many headaches in fuse, but is necessary due to the possible DoS
>    that an unprivileged filesystem could do with an unrelated process.
>    Since CUSE servers are always privileged, this should not be an
>    issue.

Cool.

>  - Other cleanups.
> 
> I still think that the INIT sequence in CUSE is way too complicated
> and that the kernel thread is unnecessary.  How about doing the init
> with a single CUSE_INIT message which embeds the fuse_init_in and
> fuse_init_out structures.

I don't see why the kernel thread is such a big problem.  It's just a
kernel thread.  We can surely fold FUSE_INIT inside FUSE_INIT tho but
one way or the other doesn't make whole lot of difference.

> I also don't see the purpose of the CUSE_INIT_DONE message.  Isn't
> it enough not to send any other messages while the initialization is
> not complete?  This is what fuse does.

The difference between FUSE and CUSE in this regard is that the
synchornous part of initialization is much less for CUSE.  ie. For
FUSE, after the mount is complete, all accesses go to FUSE, so it's
all good.  However, for CUSE, the device nodes are setup
asynchronously, so there's no such inherent synchronization point as
mount.  This becomes a problem when CUSE is started from modprobe to
emulate devices on demand because modprobe should not return before
the device nodes are setup.

Thanks.

-- 
tejun
