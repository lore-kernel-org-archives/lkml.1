Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbYAaATk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbYAaATk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYAaATb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:19:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312AbYAaATa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:19:30 -0500
Date: Wed, 30 Jan 2008 16:08:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, a.p.zijlstra@chello.nl
Subject: Re: [patch] vfs: create /proc/<pid>/mountinfo
Message-Id: <20080130160839.828c4363.akpm@linux-foundation.org>
In-Reply-To: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
References: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 14:57:29 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Ram Pai <linuxram@us.ibm.com>
> 
> /proc/mounts in its current state fails to disambiguate bind mounts,
> especially when the bind mount is subrooted.  Also it does not capture
> propagation state of the mounts(shared-subtree).  The following patch
> addresses the problem.
> 
> The patch adds '/proc/<pid>/mountinfo' which contains a superset of
> information in '/proc/<pid>/mounts'. The following fields are added:
> 
> mntid -- is a unique identifier of the mount
> parent -- the id of the parent mount
> major:minor -- value of st_dev for files on that filesystem
> dir -- the subdir in the filesystem which forms the root of this mount
> propagation-type in the form of <propagation_flag>[:<mntid>][,...]
> 	note: 'shared' flag is followed by the mntid of its peer mount
> 	      'slave' flag is followed by the mntid of its master mount
> 	      'private' flag stands by itself
> 	      'unbindable' flag stands by itself
> 
> Also mount options are split into two fileds, the first containing the
> per mount flags, the second the per super block options.
> 
> Here is a sample cat /proc/mounts after execution the following commands:

                       ^^^^^^^^^^^^  /proc/<pid>/mountinfo?
> 
> mount --bind /mnt /mnt
> mount --make-shared /mnt
> mount --bind /mnt/1 /var
> mount --make-slave /var
> mount --make-shared /var
> mount --bind /var/abc /tmp
> mount --make-unbindable /proc
> 
> 2 2 0:1 rootfs rootfs / / rw rw private
> 16 2 98:0 ext2 /dev/root / / rw rw private
> 17 16 0:3 proc /proc / /proc rw rw unbindable
> 18 16 0:10 devpts devpts /dev/pts / rw rw private
> 19 16 98:0 ext2 /dev/root /mnt /mnt rw rw shared:19
> 20 16 98:0 ext2 /dev/root /mnt/1 /var rw rw shared:21,slave:19
> 21 16 98:0 ext2 /dev/root /mnt/1/abc /tmp rw rw shared:20,slave:19
> 
> For example, the last line indicates that :
> 
> 1) The mount is a shared mount.
> 2) Its peer mount of mount with id 20
> 3) It is also a slave mount of the master-mount with the id  19
> 4) The filesystem on device with major/minor number 98:0 and subdirectory
> 	mnt/1/abc makes the root directory of this mount.
> 5) And finally the mount with id 16 is its parent.

Boy, that's complex.  It'd be nicer to have a name:value\n format, like
/proc/meminfo.  But that would really imply one /proc file per mount under
/proc/<pid>/mountinfo/...

If history teaches us anything, it is that we should make this thing
extensible in ways in which we can be confident will not break existing
parsers.

Does this format ensure that?  It's hard to see how.

> 
> [mszeredi@suse.cz]
> 
> - new file, rearrange fields
> - for mount ID's use IDA (from the IDR library) instead of a 32bit
>   counter, which could overflow
> - print canonical ID's (smallest one within the peer group) for peers
>   and master, this is more useful, than a random ID within the same namespace
> - fix a couple of small bugs
> - remove inlines
> - style fixes
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

The patch adds a new concept of an "id" for each vfsmount (correct?). 
Perhaps the semantics of that identifier should be captured in code
comments, probably in pnode.c.  Things like:

- They're always unique
- They are allocated on a first-fit-from-zero basis (correct?)
- They are used for... ?

They are also signed, which seems inappropriate.

The new exported-to-everyone dentry_path() probably could do with a bit
more documentation - it's the sort of thing which people keep on wanting
and using.

How does dentry_path() differ from d_path() and why do we need both and can
we get some sharing/consolidation happening here?

Why do d_path() and dentry_path() have differing conventions for displaying
a deleted file and can we fix that?

This patch adds a lot of code which is, I guess, unused if
CONFIG_PROC_FS=n.  Fixable?


