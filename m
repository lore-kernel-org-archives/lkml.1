Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYAZIpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYAZIpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 03:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYAZIpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 03:45:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57083 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYAZIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 03:45:40 -0500
Date: Sat, 26 Jan 2008 08:45:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mhalcrow@us.ibm.com
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2)
Message-ID: <20080126084532.GG27894@ZenIV.linux.org.uk>
References: <20080117060017.GC27894@ZenIV.linux.org.uk> <200801260508.m0Q58UpV031448@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801260508.m0Q58UpV031448@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 12:08:30AM -0500, Erez Zadok wrote:

> > 	* lock_parent(): who said that you won't get dentry moved
> > before managing to grab i_mutex on parent?  While we are at it,
> > who said that you won't get dentry moved between fetching d_parent
> > and doing dget()?  In that case parent could've been _freed_ before
> > you get to dget().
> 
> OK, so looks like I should use dget_parent() in my lock_parent(), as I've
> done elsewhere.  I'll also take a look at all instances in which I get
> dentry->d_parent and see if a d_lock is needed there.
 
dget_parent() doesn't deal with the problem of rename() done directly
in that layer while you'd been waiting for i_mutex.

> > +       lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
> > +       err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
> > +                        lower_new_dir_dentry->d_inode, lower_new_dentry);
> > +       unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
> > 
> > Uh-huh...  To start with, what guarantees that your lower_old_dentry
> > is still a child of your lower_old_dir_dentry?
> 
> We dget/dget_parent the old/new dentry and parents a few lines above
> (actually, it looked like I forgot to dget(lower_new_dentry) -- fixed).

And?  Having a reference to dentry does not prevent it being moved
elsewhere by direct rename(2) in that layer.  It will exist, that
much is guaranteed by grabbing a reference.  However, there is no
warranties whatsoever that by the time you get i_mutex on what had
once been its parent, it will still remain the parent of our dentry.

> BTW, my sense of the relationship b/t upper and lower objects and their
> validity in a stackable f/s, is that it's similar to the relationship b/t
> the NFS client and server -- the client can't be sure that a file on the
> server doesn't change b/t ->revalidate and ->op (hence nfs's reliance on dir
> mtime checks).

You are thinking about non-interesting case.  _Files_ are not much
of a problem.  Directory tree is.  The real problems with all unionfs and
stacking implementations I've seen so far, all way back to Heidemann et.al.
start when topology of the underlying layer changes.  If you have clear
semantics for unionfs behaviour in presence of such things, by all means,
publish it - as far as I know *nobody* had done that; not even on the
"what should we see when..." level, nevermind the implementation.
 
> Perhaps this general topic is a good one to discuss at more length at LSF?
> Suggestions are welcome.

It would; I honestly do not know if the problem is solvable with the
(lack of) constraints you apparently want.  Again, the real PITA begins
when you start dealing with pieces of underlying trees getting moved
around, changing parents, etc.  Cross-directory rename() certainly rates
very high on the list of "WTF had they been smoking in UCB?" misfeatures,
but it's there and it has to be dealt with.

BTW, and that's a completely unrelated story, I'd rather see whiteouts
done directly by filesystems involved - it would simplify the life big
way.  How about adding a dir->i_op->whiteout(dir, dentry) and seeing if
your variant could be turned into such a method to be used by really
piss-poor filesystems?  All UFS-related ones (including ext*) can trivially
support whiteouts without any PITA; adding them to tmpfs is also not a big
deal and anything that caches inode type in directory entries should be
easy to extend in the same way as ext*/ufs...
