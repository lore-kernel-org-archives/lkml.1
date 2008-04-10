Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYDJLL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYDJLL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 07:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYDJLLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 07:11:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36345 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYDJLLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:11:17 -0400
To: ezk@cs.sunysb.edu
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200804090053.m390rE9k007085@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Tue, 8 Apr 2008 20:53:14 -0400)
Subject: Re: [PATCH] Unionfs: use the new path_* VFS helpers
References: <200804090053.m390rE9k007085@agora.fsl.cs.sunysb.edu>
Message-Id: <E1Jjug8-0006a2-Vs@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 10 Apr 2008 13:10:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As promised, here is a patch for Unionfs to use the new path_* VFS helpers
> which now take a struct path *.  I've used Al's vfs git tree plus all 12
> patches you've outlined (ten path_* patches + 2 others).  I've run Unionfs
> through my basic regression suite; I haven't done more extensive testing
> yet.  This patch can be used in -mm if/when your path_* patches make it
> there (this patch will be a standalone one to be used on top of my
> unionfs.git tree).

Thanks.

> Al, I'm not too pleased with the resulting additional code complexity to
> Unionfs, due to these new helpers.  See the diffstat below.  These VFS
> helpers have widened the gap between the f/s API and the VFS helpers': the
> helpers now need a struct path/vfsmount, but the most ->ops that a
> filesystem is being called with, don't have a path/vfsmount passed.

I'm not too pleased either ;)

What I think would be much cleaner if for example you had functions
like this:

void unionfs_lower_path_index(struct dentry *dentry, int bindex,
				struct path *path_out);

Etc.  If you are dealing with paths, you should not be handling
vfsmounts separately.  That part is ugly and just invitation for bugs.

> You've said before that a filesystems has no business dealing with vfsmounts
> (with the exception of follow_link).  Fine.  But the irony now is that the
> new vfs helpers that a filesystems is likely to use, FORCE you to know a lot
> more about vfsmounts!  If indeed a filesystem shouldn't have to know or deal
> with vfsmounts, then none of the VFS helpers should require a struct
> vfsmount (or a struct path, or a nameidata, which embed a vfsmount+dentry
> pair).  Otherwise, let's admit that some filesystems have to know about
> vfsmounts and hence let's pass them to all appropriate fs ->ops.

How would that help?  AFAICS the vfsmounts on the lower layers should
have _absolutetly nothing_ to do with the vfsmount on the top layer.

So no, passing down vfsmounts to the filesystem is wrong (with the
exception of follow_link, and even in that case only very specialized
filesystems like proc will ever have a valid use for it).

>  (BTW, if
> that's done, then it'd also be helpful for a struct vfsmount to have a "void
> *private" into which a stacked f/s can store "lower objects").

Oh, please!  I think you are confused about the role that vfsmounts
play in stacking.  Vfsmounts place filesystems in the global and
private mount namespaces.  But each and every instance of that
placement should behave exactly the same (modulo such flags as
per-mount r/o, etc), and so stacking filesystems, just like any other
filesystem, should have no need for the knowledge about where they are
placed in the namespace.

On the other hand, they _should_ have knowledge of the placement of
the filesystems they are operating on.  So when accessing the lower
layers, they can conform to the same rules as anything else accessing
the filesystems.  I.e. they shouldn't meddle directly with the
filesystem, without going through the namespace layer first.

This is already enforced for dentry_open(), and I don't see the big
issue with enfocing it for the rest of the vfs_* operations.

Miklos
