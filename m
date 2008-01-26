Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYAZFJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYAZFJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYAZFJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:09:19 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47804 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYAZFJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:09:17 -0500
Date: Sat, 26 Jan 2008 00:08:30 -0500
Message-Id: <200801260508.m0Q58UpV031448@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, hch@infradead.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mhalcrow@us.ibm.com
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2) 
In-reply-to: Your message of "Thu, 17 Jan 2008 06:00:17 GMT."
             <20080117060017.GC27894@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080117060017.GC27894@ZenIV.linux.org.uk>, Al Viro writes:
> After grep for locking-related things:
> 
> 	* lock_parent(): who said that you won't get dentry moved
> before managing to grab i_mutex on parent?  While we are at it,
> who said that you won't get dentry moved between fetching d_parent
> and doing dget()?  In that case parent could've been _freed_ before
> you get to dget().

OK, so looks like I should use dget_parent() in my lock_parent(), as I've
done elsewhere.  I'll also take a look at all instances in which I get
dentry->d_parent and see if a d_lock is needed there.

> 	* in create_parents():
> +                       struct inode *inode = lower_dentry->d_inode;
> +                       /*
> +                        * If we get here, it means that we created a new
> +                        * dentry+inode, but copying permissions failed.
> +                        * Therefore, we should delete this inode and dput
> +                        * the dentry so as not to leave cruft behind.
> +                        */
> +                       if (lower_dentry->d_op && lower_dentry->d_op->d_iput)
> +                               lower_dentry->d_op->d_iput(lower_dentry,
> +                                                          inode);
> +                       else
> +                               iput(inode);
> +                       lower_dentry->d_inode = NULL;
> +                       dput(lower_dentry);
> +                       lower_dentry = ERR_PTR(err);
> +                       goto out;
> Really?  So what happens if it had become positive after your test and
> somebody had looked it up in lower layer and just now happens to be
> in the middle of operations on it?  Will be thucking frilled by that...

Good catch.  That ->d_iput call was an old fix to a bug that has since been
fixed more cleanly and generically in our copyup_permission routine and our
unionfs_d_iput.  I've removed the above ->d_iput "if" and tested to verify
that it's indeed unnecessary.

> 	* __unionfs_rename():
> +       lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
> +       err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
> +                        lower_new_dir_dentry->d_inode, lower_new_dentry);
> +       unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
> 
> Uh-huh...  To start with, what guarantees that your lower_old_dentry
> is still a child of your lower_old_dir_dentry?

We dget/dget_parent the old/new dentry and parents a few lines above
(actually, it looked like I forgot to dget(lower_new_dentry) -- fixed).
This is a generic stackable f/s issue: ecryptfs does the same stuff before
calling vfs_rename() on the lower objects.

> What's more, you are
> not checking the result of lock_rename(), i.e. asking for serious trouble.

OK.  I'm now checking for the return from lock_rename for ancestor/rename
rules.  I'm CC'ing Mike Halcrow so he can do the same for ecryptfs.

> 	* revalidation stuff: err...  how the devil can it work for
> directories, when there's nothing to prevent changes in underlying
> layers between ->d_revalidate() and operation itself?  For the upper
> layer (unionfs itself) everything's more or less fine, but the rest
> of that...

In a stacked f/s, we keep references to the lower dentries/inodes, so they
can't disappear on us (that happens in our interpose function, called from
our ->lookup).  On entry to every f/s method in unionfs, we first perform
lightweight revalidation of our dentry against the lower ones: we check if
m/ctime changed (users modifying lower files) or if the generation# b/t our
super and the our dentries have changed (branch-management took place); if
needed, then we perform a full revalidation of all lower objects (while
holding a lock on the branch configuration).  If we have to do a full reval
upon entry to our ->op, and the reval failed, then we return an appropriate
error; o/w we proceed.  (In certain cases, the VFS re-issues a lookup if the
f/s says that it's dentry is invalid.)

Without changes to the VFS, I don't see how else I can ensure cache
coherency cleanly, while allowing users to modify lower files; this feature
is very useful to some unionfs users, who depend on it (so even if I could
"lock out" the lower directories from being modified, there will be users
who'd still want to be able to modify lower files).

BTW, my sense of the relationship b/t upper and lower objects and their
validity in a stackable f/s, is that it's similar to the relationship b/t
the NFS client and server -- the client can't be sure that a file on the
server doesn't change b/t ->revalidate and ->op (hence nfs's reliance on dir
mtime checks).

Perhaps this general topic is a good one to discuss at more length at LSF?
Suggestions are welcome.

Thanks,
Erez.
