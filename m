Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYJCKNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYJCKNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYJCKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:13:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33457 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYJCKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:13:43 -0400
Date: Fri, 3 Oct 2008 11:13:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20081003101331.GH28946@ZenIV.linux.org.uk>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5d2oh4y.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:23:57AM -0700, Eric W. Biederman wrote:
> Benjamin Thery <benjamin.thery@bull.net> writes:
> >
> > Oh.
> > It's a pity Al couldn't re-review them before. We've already lost a lot
> > of time with this patchset and it's blocking easier testing of network
> > namespaces (right now, with a mainline kernel, we have to disable sysfs
> > to build network namespaces).
> 
> I am confident that we have a good base with these patches and the rest of
> the work can be done incrementally on top of them if any issues turn up.
> 
> Al recent rework of sysctl has a very similar structure.

No, it does not.  My apologies for delay, but here are more printable parts
of review.

First of all, this stuff breaks just about every damn integrity constraint VFS
knows of.  It tries to tiptoe through the resulting minefield - without
success.  So the first group of comments will be of "you *really* don't
do $FOO" variety.  I'm very far from being convinced that we want to
special-case in VFS every kind of weirdness sysfs happens to do; in effect,
that would require adding a FS_IS_SYSFS_SO_BEND_OVER fs type flag and making
a lot of locking conditional on that.

a) You do *not* share struct inode between the superblocks, for fsck sake!
b) You do *not* grab i_mutex on ancestors after having grabbed it on
file, as sysfs_chmod_file() does.
c) You do *not* change dentry tree topology without s_vfs_rename_mutex on
affected superblock.  That, BTW, is broken in mainline sysfs as well.
d) You REALLY, REALLY do not unhash busy dentries of directories.

In addition to that, there are interesting internal problems:
* inumbers are released by final sysfs_put(); that can happen before the
final iput() on corresponding inode.  Guess what happens if new entry is
created in the meanwhile, reuses the same inumber and lookup gets to
sysfs_get_inode() on it?
* may I politely suggest that
again:
	mutex_lock(&A);
	if (!mutex_trylock(&B)) {
		mutex_unlock(&A);
		goto again;
	}
is somewhat, er, deficient way to deal with buggered locking hierarchy?
Not to mention anything else, that's obviously FUBAR on UP box - if we
have B contended, we've just killed the box dead since we'll never give
the CPU back to whoever happens to hold B.  See sysfs_mv_dir() for a lovely
example.
* sysfs_count_nlink() is called from sysfs_fill_super() without sysfs_mutex;
now this sucker can get called at any moment.
* just what is protecting ->s_tag?
* __sysfs_remove_dir() appears to assume that subdirectories are possible;
AFAICS, if we *do* get them, we get very screwed after remove_dir().
* everything else aside, the internal locking is extremely heavy.  For
fsck sake, guys, a single system-wide mutex that can be grabbed for the
duration of readdir on any directory and block just about anything
in the filesystem?  Just mmap() something over NFS on a slow link and
do getdents() to such buffer.  Watch a *lot* of stuff getting buggered.
Hell, you can't even do ifconfig up while that sucker is held...

Seriously, people, it's getting worse than devfs had ever been ;-/
