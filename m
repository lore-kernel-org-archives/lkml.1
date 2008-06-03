Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYFCTyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYFCTyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYFCTx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:53:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbYFCTxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:53:55 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
References: <20080603104035.GT28946@ZenIV.linux.org.uk>
	<E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	<20080603105258.GV28946@ZenIV.linux.org.uk>
	<1212499623.3025.46.camel@raven.themaw.net>
	<alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	<1212509263.3025.66.camel@raven.themaw.net>
	<alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	<1212513189.3025.101.camel@raven.themaw.net>
	<20080603173029.GD28946@ZenIV.linux.org.uk>
	<x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
	<20080603191859.GG28946@ZenIV.linux.org.uk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 03 Jun 2008 15:53:36 -0400
In-Reply-To: <20080603191859.GG28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 3 Jun 2008 20:18:59 +0100")
Message-ID: <x49abi2jnwf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Jun 03, 2008 at 01:46:41PM -0400, Jeff Moyer wrote:
>
>> Well, let me know what level of dump you'd like.  I can give the 50,000
>> foot view, or I can give you the history of things that happened to get
>> us to where we are today, or anything inbetween.  The more specific
>> your request, the quicker I can respond.  A full brain-dump would take
>> some time!
>
> a) what the hell is going on in autofs4_free_ino()?  It checks for
> ino->dentry, when the only caller has just set it to NULL.

Probably historic.  Ian?

> b) while we are at it, what's ino->inode doing there?  AFAICS, it's
> a write-only field...

Another good point.

> c) what are possible states of autofs4 dentry and what's the supposed
> life cycle of these beasts?

The life cycle of a dentry for an indirect, non-browsable mount goes
something like this:

autofs4_lookup is called on behalf a process trying to walk into an
automounted directory.  That dentry's d_flags is set to
DCACHE_AUTOFS_PENDING but not hashed.  A waitqueue entry is created,
indexed off of the name of the dentry.  A callout is made to the
automount daemon (via autofs4_wait).

The daemon looks up the directory name in its configuration.  If it
finds a valid map entry, it will then create the directory using
sys_mkdir.  The autofs4_lookup call on behalf of the daemon (oz_mode ==
1) will return NULL, and then the mkdir call will be made.  The
autofs4_mkdir function then instantiates the dentry which, by the way,
is different from the original dentry passed to autofs4_lookup.  (This
dentry also does not get the PENDING flag set, which is a bug addressed
by a patch set that Ian and I have been working on;  specifically, the
idea is to reuse the dentry from the original lookup, but I digress).

The daemon then mounts the share on the given directory and issues an
ioctl to wakeup the waiter.  When awakened, the waiter clears the
DCACHE_AUTOFS_PENDING flag, does another lookup of the name in the
dcache and returns that dentry if found.

Later, the dentry gets expired via another ioctl.  That path sets
the AUTOFS_INF_EXPIRING flag in the d_fsdata associated with the dentry.
It then calls out to the daemon to perform the unmount and rmdir.  The
rmdir unhashes the dentry (and places it on the rehash list).

The dentry is removed from the rehash list if there was a racing expire
and mount or if the dentry is released.

This description is valid for the tree as it stands today.  Ian and I
have been working on fixing some other race conditions which will change
the dentry life cycle (for the better, I hope).


> d)
> /* For dentries of directories in the root dir */
> static struct dentry_operations autofs4_root_dentry_operations = {
>         .d_revalidate   = autofs4_revalidate,
>         .d_release      = autofs4_dentry_release,
> };
>
> /* For other dentries */
> static struct dentry_operations autofs4_dentry_operations = {
>         .d_revalidate   = autofs4_revalidate,
>         .d_release      = autofs4_dentry_release,
> };
>
> Just what is the difference?

Nothing.  There used to be, and I'm guessing Ian kept this around for,
umm, clarity?

> e) in autofs4_tree_busy() we do atomic_read() on ino->count and dentry->d_count
> What's going to keep these suckers consistent with each other in any useful
> way?

I'm afraid I'm not familiar enough with that part of the code to give
you a good answer.  Ian?

Cheers,

Jeff
