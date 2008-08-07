Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYHGW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYHGW2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYHGW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:28:08 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60389 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYHGW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:28:04 -0400
Date: Thu, 7 Aug 2008 17:27:51 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: unprivileged mounts git tree
Message-ID: <20080807222751.GA28412@us.ibm.com>
References: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> Here's a git tree of the unprivileged mounts patchset:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git unprivileged-mounts
> 
> Could this be added to -mm (and dropped if it's in the way of
> something) for some testing and added visibility until it's reviewed
> by Christoph/Al?
> 
> I'm not reposting the whole patchset, since it's essentially the same
> as the last submission, only updated to the latest git.  But if
> somebody wants it I can post them.
> 
> Thanks,
> Miklos
> 
> 
>  Documentation/filesystems/fuse.txt |   88 ++++++++-
>  Documentation/filesystems/proc.txt |   40 ++++
>  fs/filesystems.c                   |   60 ++++++
>  fs/fuse/inode.c                    |   21 ++
>  fs/internal.h                      |    3 +-
>  fs/namespace.c                     |  366 +++++++++++++++++++++++++++---------
>  fs/pnode.c                         |   22 ++-
>  fs/pnode.h                         |    2 +
>  fs/super.c                         |   26 ---
>  include/linux/fs.h                 |    7 +
>  include/linux/mount.h              |    4 +
>  kernel/sysctl.c                    |   16 ++
>  12 files changed, 527 insertions(+), 128 deletions(-)
> 
> Miklos Szeredi (10):
>       unprivileged mounts: add user mounts to the kernel
>       unprivileged mounts: allow unprivileged umount
>       unprivileged mounts: propagate error values from clone_mnt
>       unprivileged mounts: account user mounts
>       unprivileged mounts: allow unprivileged bind mounts
>       unprivileged mounts: allow unprivileged mounts
>       unprivileged mounts: add sysctl tunable for "safe" property
>       unprivileged mounts: make fuse safe
>       unprivileged mounts: propagation: inherit owner from parent
>       unprivileged mounts: add "no submounts" flag

Hi Miklos,

so on the bright side I pulled this tree today and it compiled and
passed ltp with no problems.

But then I played around a bit and found I could do the following:

(hmm, i'm trying to remember the exact order :)

as root:
	mmount --bind -o user=500 /home/hallyn/etc/ /home/hallyn/etc/
	mount --bind /mnt /mnt
	mount --make-rshared /mnt
	mount --bind /dev /mnt/dev

as hallyn:
	mmount --bind /mnt /home/hallyn/etc/mnt
	/usr/src/mmount-0.3/mmount --bind mnt/dev mnt/src

Now /mnt/src contained /dev.

Is this what we want?  Do we want to tell the admin it's his fault for
not somehow forcing a slave relationship between /mnt and
/home/hallyn/etc/mnt?  Except I don't think he can do that preemptively,
it has to be done after hallyn does the mmount.

So does that mean that if non-root user X does:

	mount a b

where b is user=X but a is not, then if a is shared we should force it
to be mounted as slave at b?

-serge
