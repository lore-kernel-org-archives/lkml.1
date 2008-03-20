Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYCTVnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYCTVnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbYCTVnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:43:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbYCTVnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:43:32 -0400
Date: Thu, 20 Mar 2008 21:43:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080320214319.GS10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 07:37:51PM +0100, Miklos Szeredi wrote:

> > Argh...  OK, I'll try to put something together tonight, after I get some
> > sleep - 31 hours of uptime _suck_ ;-/
> 
> Gosh, yes.

Folks, we have some problems.  I've sat down to write documentation on
locking rules, etc. for struct vfsmount and there are some serious
turds in the area.  Among the other things we have interesting race
between shrink_submounts() and copy_tree() - the former calls
propagate_mount_busy(), which walks ->mnt_share and friends.  The
latter adds elements to those.  Wouldn't be a problem, except that
shrink_submounts() only holds vfsmount_lock while everything else
(including copy_tree()) uses namespace_sem to protect those.

There's another interesting issue with shrink_submounts() - it can
put vfsmounts back on the wrong list.  If e.g. cifs is mounted under
nfs and does an automount, umount of nfs might push cifs expirables
*to* *nfs* *list*.

I'm not sure that I understand Trond's intentions with that stuff;
what exactly are we trying to achieve and why the hell is it fs-specific
to start with?

Another interesting thing is locking in mark_mounts_for_expiry(); we
go to all sorts of convolutions that are, AFAICS, not needed anymore.
We used to need rather interesting logics back when we had per-namespace
semaphores; thus grabbing the namespace, dropping vfsmount_lock, dealing
with races in case if something manages to walk into the potential
victim, etc.

I think that having the damn thing global *and* having umount_tree()
callable under vfsmount_lock (we unhash everything in the subtree and
put it on the kill list, so that nothing can walk into those suckers
via hash lookup; release_mounts() called after we are done (and after
releasing vfsmount_lock *and* namespace_sem) will take care of actual
talking to filesystems) removes the need of all that crap.

IOW, mark_mounts_for_expiry() should do the following:
	grabbing namespace_sem exclusive
	grab vfsmount_lock
	walk the list as it does now, except that it should do the right
check from the very beginning (propagate_mount_busy())
	without dropping the vfsmount_lock, go through the collected list,
calling umount_tree()
	drop the locks
	do release_mounts()
The second pass is needed since umount_tree() might do interesting things
to expiry list, so we make life easier for ourselves by leaving that to
second pass when we just want to drain the resulting list until it's empty.

Does anybody see holes in the above?

shrink_submounts() is _probably_ similar (lock/collect/umount_tree on all/
unlock/release_mounts), but I'm not sure if I understand WTF is really
attempted in there.

Is there any reason why we do that in ->umount_begin() and not *after*
it, unconditionally, straight from do_umount()?  AFAICS, the only reason
why it's done from fs-specific code is figuring out which mount-list
should the stuff go back to, and that's both broken *and* not needed
with sanitized locking as above.  While we are at it, I'd rather return
->umount_begin() to its previous prototype, TYVM - the less filesystem
sees vfsmounts, the better off we all are...

Comments?  If nobody objects, I'm going to do that in vfs-fixes branch
and then push to Linus...
