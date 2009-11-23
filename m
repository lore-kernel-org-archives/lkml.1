Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZKWWg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZKWWg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZKWWg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:36:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZKWWg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:36:27 -0500
Date: Mon, 23 Nov 2009 17:36:16 -0500
From: Jeff Layton <jlayton@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@ucw.cz,
       miklos@szeredi.hu, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
 and file bind mounts (try #5)
Message-ID: <20091123173616.75c3f600@tlielax.poochiereds.net>
In-Reply-To: <m1my2cdhi3.fsf@fess.ebiederm.org>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
	<m1my2cdhi3.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 14:05:24 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Jeff Layton <jlayton@redhat.com> writes:
> 
> > There are a few situations where a lookup can end up returning a dentry
> > without revalidating it, and without checking whether the calling
> > process has permissions to access it. Two situations identified so far
> > are:
> >
> > 1) LAST_BIND symlinks (such as those under /proc/<pid>)
> >
> > 2) file bind mounts
> >
> > This patchset is intended to fix this by forcing revalidation of the
> > returned dentries at appropriate locations.
> >
> > In the case of LAST_BIND symlinks it also adds a check to verify that
> > the target of the symlink is accessible by the current process by
> > walking mounts and dentries back up to the root and checking permission
> > on each inode.
> >
> > This set fixes the reproducers I have (including the reproducer that
> > Pavel provided for the permissions bypass). It's still pretty rough
> > though and I expect that it'll need revision. At this point, I'm mainly
> > looking to get these questions answered:
> >
> > 1) what should we do if these dentries are found to be invalid? Is it ok
> > to d_invalidate them? Or is that likely to break something (particularly
> > in the case of file bind mounts)?
> 
> The normal sequence in do_revalidate should be safe.  In practice what we
> should see is d_drop().  If we access the dentries via another path today
> we already go through d_revalidate.  It is only the reference count on
> the dentry that keeps them alive and working.  The cases I have looked
> at for distributed filesystems have to call d_drop themselves so I don't
> know if it would add anything if the vfs called d_revalidate.  Especially
> since FS_REVAL_DOT doesn't have that logic.
> 
> > 2) I'm using FS_REVAL_DOT as an indicator of whether to force a
> > d_revalidate. I think that it's appropriate to key off of that flag, but
> > we may want to rename it (maybe FS_FORCE_D_REVAL ?).
> 
> Perhaps FS_ALWAYS_REVAL.    I don't think it makes much of
> a difference either way.  I expect a rename should come after we fix
> nfsv4 so there is a chance at pushing the fixes back to stable.
> 
> > 3) is check_path_accessible racy? It seems to work, but something
> > doesn't seem quite right with this approach. Is this defeatable somehow?
> > Could a rename of one of the intermediate path components cause
> > problems?
> 
> check_path_accessible seems pretty horrible.   If a process is running
> inside of a subdirectory it doesn't have permissions to access, say
> a chroot, /proc/self/fd/XXX becomes completely unusable.
> 

Hmm...I have this in there:

+		/* are we at global root or root of namespace? */
+		if ((tdentry == root.dentry && vfsmnt == root.mnt) ||
+		    vfsmnt->mnt_parent == vfsmnt)
+			break;

...In the case of a chroot, wouldn't "current->fs->root" point to the
root of the process' namespace? Or am I misunderstanding what
current->fs actually represents?

-- 
Jeff Layton <jlayton@redhat.com>
