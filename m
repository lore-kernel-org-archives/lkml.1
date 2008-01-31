Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbYAaJSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbYAaJSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYAaJRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:17:47 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43760 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYAaJRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:17:44 -0500
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, a.p.zijlstra@chello.nl
In-reply-to: <20080130160839.828c4363.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 30 Jan 2008 16:08:39 -0800)
Subject: Re: [patch] vfs: create /proc/<pid>/mountinfo
References: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu> <20080130160839.828c4363.akpm@linux-foundation.org>
Message-Id: <E1JKVY6-0001wd-BE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 31 Jan 2008 10:17:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Ram Pai <linuxram@us.ibm.com>
> > 
> > /proc/mounts in its current state fails to disambiguate bind mounts,
> > especially when the bind mount is subrooted.  Also it does not capture
> > propagation state of the mounts(shared-subtree).  The following patch
> > addresses the problem.
> > 
> > The patch adds '/proc/<pid>/mountinfo' which contains a superset of
> > information in '/proc/<pid>/mounts'. The following fields are added:
> > 
> > mntid -- is a unique identifier of the mount
> > parent -- the id of the parent mount
> > major:minor -- value of st_dev for files on that filesystem
> > dir -- the subdir in the filesystem which forms the root of this mount
> > propagation-type in the form of <propagation_flag>[:<mntid>][,...]
> > 	note: 'shared' flag is followed by the mntid of its peer mount
> > 	      'slave' flag is followed by the mntid of its master mount
> > 	      'private' flag stands by itself
> > 	      'unbindable' flag stands by itself
> > 
> > Also mount options are split into two fileds, the first containing the
> > per mount flags, the second the per super block options.
> > 
> > Here is a sample cat /proc/mounts after execution the following commands:
> 
>                        ^^^^^^^^^^^^  /proc/<pid>/mountinfo?
> > 
> > mount --bind /mnt /mnt
> > mount --make-shared /mnt
> > mount --bind /mnt/1 /var
> > mount --make-slave /var
> > mount --make-shared /var
> > mount --bind /var/abc /tmp
> > mount --make-unbindable /proc
> > 
> > 2 2 0:1 rootfs rootfs / / rw rw private
> > 16 2 98:0 ext2 /dev/root / / rw rw private
> > 17 16 0:3 proc /proc / /proc rw rw unbindable
> > 18 16 0:10 devpts devpts /dev/pts / rw rw private
> > 19 16 98:0 ext2 /dev/root /mnt /mnt rw rw shared:19
> > 20 16 98:0 ext2 /dev/root /mnt/1 /var rw rw shared:21,slave:19
> > 21 16 98:0 ext2 /dev/root /mnt/1/abc /tmp rw rw shared:20,slave:19
> > 
> > For example, the last line indicates that :
> > 
> > 1) The mount is a shared mount.
> > 2) Its peer mount of mount with id 20
> > 3) It is also a slave mount of the master-mount with the id  19
> > 4) The filesystem on device with major/minor number 98:0 and subdirectory
> > 	mnt/1/abc makes the root directory of this mount.
> > 5) And finally the mount with id 16 is its parent.
> 
> Boy, that's complex.  It'd be nicer to have a name:value\n format, like
> /proc/meminfo.  But that would really imply one /proc file per mount under
> /proc/<pid>/mountinfo/...

One disadvantage of doing it in separate files, is no good way of
indexing the mounts.  The mount ID could be used, but it's not a very
meaningful thing outside the context of mount propagation.

And one advantage of doing it in a single file, is that namespace_sem
is held during the read, so that content is self-consistent (no mounts
are removed/added/moved in between).

IMO, the /proc/mounts format is quite readable, and this one doesn't
differ all that much.  Maybe we could add a header line like
/proc/slabinfo.  Or do the "name:value\n" thing but put all mounts
into a single file, like /proc/cpuinfo.

I don't have any strong preference, I'm OK, with the current format,
but if there are good reasons for another one, I'm willing to change
it around.

> If history teaches us anything, it is that we should make this thing
> extensible in ways in which we can be confident will not break existing
> parsers.
> 
> Does this format ensure that?  It's hard to see how.

Explicitly document, that adding fields at the end is OK.  But I think
this is implicit in all of the multi-fields-per-line formats, and I'm
quite confident all sane parsers already ignore unknown junk at the
end of a line.

> 
> > 
> > [mszeredi@suse.cz]
> > 
> > - new file, rearrange fields
> > - for mount ID's use IDA (from the IDR library) instead of a 32bit
> >   counter, which could overflow
> > - print canonical ID's (smallest one within the peer group) for peers
> >   and master, this is more useful, than a random ID within the same namespace
> > - fix a couple of small bugs
> > - remove inlines
> > - style fixes
> > 
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> The patch adds a new concept of an "id" for each vfsmount (correct?). 
> Perhaps the semantics of that identifier should be captured in code
> comments, probably in pnode.c.  Things like:
> 
> - They're always unique
> - They are allocated on a first-fit-from-zero basis (correct?)

Yes.

> - They are used for... ?

Just to identify mount propagation relations in this file.  The
vfsmount pointer would be just as good, but we don't like to expose
things like that to userspace (and it would be hard to parse for
humans anyway).

> They are also signed, which seems inappropriate.

IDR ids are 'int' but they are always positive (AFAICT), but yeah,
maybe this is confusing.

> The new exported-to-everyone dentry_path() probably could do with a bit
> more documentation - it's the sort of thing which people keep on wanting
> and using.

OK.

> How does dentry_path() differ from d_path() and why do we need both and can
> we get some sharing/consolidation happening here?

Tried that but not easy, without removing some of the
microoptimizations in d_path(), which I'm not sure are really
important, but...

> Why do d_path() and dentry_path() have differing conventions for displaying
> a deleted file and can we fix that?

I think Ram chose a different convention in dentry_path() in order to
make sure, there was no space in the resulting path.  But spaces would
be escaped anyway, so this isn't really important.  So yes, this could
be fixed.

> This patch adds a lot of code which is, I guess, unused if
> CONFIG_PROC_FS=n.  Fixable?

Possibly yes.  A good chunk of namespace.c could be surrounded by an
#ifdef, which would save even more, than was added by this particular
patch.

Thanks,
Miklos
