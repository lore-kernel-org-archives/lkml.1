Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYCYCxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYCYCxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYCYCwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:52:50 -0400
Received: from ns1.suse.de ([195.135.220.2]:42007 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCYCws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:52:48 -0400
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 25 Mar 2008 13:52:31 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18408.26863.617591.836548@notabene.brown>
Cc: viro@ZenIV.linux.org.uk, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       neilb@suse.de, akpm@linux-foundation.org, hch@infradead.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: Re: r-o bind in nfsd
In-Reply-To: message from Miklos Szeredi on Friday March 21
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu>
	<20080321155451.GU10722@ZenIV.linux.org.uk>
	<E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
	<20080321163520.GV10722@ZenIV.linux.org.uk>
	<E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday March 21, miklos@szeredi.hu wrote:
> 
> Nobody wants to send vfsmounts to the filesystem.  But vfs_...() are
> still part of the "upper layer", not the filesystem, so I'm not
> convinced yet.  For example:

The layers within the VFS are probably not very clearly defined, but I
think one can fairly clearly see a difference between a "filesystem"
layer and a "namespace" layer.

The vfs_XX function are (in my mind) the top of the filesystem layer.
They primarily call the relevant xxx_operation and just add minimal
support code to enforce standard policy, callouts, etc.

vfsmnts are very much part of the "namespace" layer.  The heart of
this layer is probably link_path_walk.  It allows mounts to tie
filesystems together in all sorts of interesting knots :-)

The readonly-bind-mount concept adds new functionality in the
namespace layer.
The filesystem layer already has a concept of readonly mounts, and
this doesn't change (I hope).  The superblock still has a readonly
flag and the vfs_XXX operations must (possibly indirectly) still test
this flag.

readonly-bind-mounts adds a new 'readonly' flag in the namespace
layer.

So if you want to centralise the code for implementing this
functionality (which seems like a good idea), it should probably
go in link_path_walk, or one of it's friends, rather than in vfs_XXX.

Maybe a new LOOKUP_WRITEACCESS flag which arranges that mnt_want_write
gets called as appropriate, and that path_put will call mnt_drop_write
if needed.

Maybe some enhancement to the 'intent' structure with a similar
effect could be done instead.

Then you could, presumably, put a security hook somewhere in
link_path_walk for those modules (like AppArmor) which want to do
checks based on the namespace.

=========

I just had a look at the places where mnt_want_write is currently
called.  There are quite a few of them.

Two that surprised me were touch_atime and file_update_time.

It is not clear to me that we should avoid updating 'atime' if the
bindmount is marked readonly.  The file is still being accessed, so
updating the atime could still be appropriate.
Possibly a "noatime" per-vfsmnt flag would be appropriate.  But I'm
not convinced that interpreting per-vfsmnt 'readonly' as "don't update
atime" is correct.

And the mnt_want_write call in file_update_time seems superfluous.
This only gets called on files that were already opened for write
..... except for named pipes.  We don't call mnt_want_write when we
open those, but we do call file_update_time whenever we write to them.
That is an awkward asymmetry.  I suspect that mnt_want_write *Should*
be called when a named pipe is opened for write.

I think all other calls to mnt_want_write could be avoided by passing
an appropriate flag to the relevant lookup routine, but I haven't
checked thoroughly.

NeilBrown


(for those who are interested, the places I found that call
 mnt_want_write are:

   update atime
   update mtime
   create file
   mknod/mkdir/rmdir/unlink/symlink/link/rename
   truncate/fchmod/chown
   get_file_write_access
   utimes
   setxattr
   'init_file'  (which is only used for sockets and shared mem
                 segments.  As the comment near init_file says, it
                 doesn't really need mnt_want_write, it is just there
                 for balance).

)


