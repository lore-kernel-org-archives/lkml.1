Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYCVDuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYCVDuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYCVDuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:50:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41775 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYCVDuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:50:03 -0400
Date: Sat, 22 Mar 2008 03:49:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080322034950.GY10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080320214319.GS10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320214319.GS10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 09:43:19PM +0000, Al Viro wrote:
> shrink_submounts() is _probably_ similar (lock/collect/umount_tree on all/
> unlock/release_mounts), but I'm not sure if I understand WTF is really
> attempted in there.

Argh...  Doing release_mounts() after collection phase won't work ;-/
It would leave references to parents until the very end, leaving us
with false-busy shrinkable vfsmounts if we had shrinkable automounted
on top of shrinkable...

It does work for mark_mounts_for_expiry(), but not here.  We could do
the same kind of loops as now, releasing namespace_sem after each
portion of candidates, doing release_mounts() and regaining namespace_sem,
but that leaves us with indefinitely long stalls if somebody keeps
doing lookups triggering automounts.  OTOH, we probably could get away
with separate counter covering only that kind of references...  That
would be bumped in umount_tree() (at the same point where we decrement
d_mounted) and dropped in release_mounts() when we reset ->mnt_parent
and do mntput() on it.

Then we would simply make do_refcount_check() in pnode.c do
        int mycount = atomic_read(&mnt->mnt_count) - mnt->mnt_ghosts;
        return (mycount > count);
instead of what it does now, and everything would work fine...

So, let's define mnt->mnt_ghosts by requiring that outside of vfsmount_lock
it would be equal to number of vfsmounts with ->mnt_parent == mnt that are
_not_ on child list of mnt.

	We'd need to decrement it in release_mounts(), increment in
mnt_set_mountpoint(), decrement again in attach_mnt() (which strongly
suggests that increment should happen in _callers_ of mnt_set_mountpoint(),
so that attach_mnt() wouldn't modify it at all), decrement in commit_tree(),
and increment in umount_tree() at the same point where we play with d_mounted.
AFAICS, that's all.

	Shifting increment from mnt_set_mountpoint() and commit_tree()
to theirs callers and collapsing where possible, we get the following:
	* decrement in release_mounts() when resetting ->mnt_parent
	* increment in propagate_mnt() after call of mnt_set_mountpoint()
	* decrement in attach_recursive_mnt() in the loop calling
commit_tree() for clones (on mountpoint of each clone).
	* increment in umount_tree() at the point where we update d_mounted.

All these places are under vfsmount_lock, so we are fine with plain int; no
atomics needed.

So...  Attack plan: introduce mnt_ghosts+use it in propagate_mnt_busy()
(that gets rid of false-busy stuff), then switch shrink_submounts() and
mark_mounts_for_expiry() to the scheme from the previous posting, then
call shrink_submounts() from do_umount() unconditionally, removing it from
->umount_begin() instances, then restore sane prototype for shrink_submounts().
Four patches...

Comments?  Ram, Miklos, Trond?
