Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYJGIQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYJGIQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 04:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYJGIQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 04:16:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47163 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYJGIQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 04:16:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Benjamin Thery <benjamin.thery@bull.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
Date: Tue, 07 Oct 2008 01:08:08 -0700
In-Reply-To: <20081003101331.GH28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 3 Oct 2008 11:13:31 +0100")
Message-ID: <m1hc7oddzr.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Sep 23, 2008 at 11:23:57AM -0700, Eric W. Biederman wrote:
>> Benjamin Thery <benjamin.thery@bull.net> writes:
>> >
>> > Oh.
>> > It's a pity Al couldn't re-review them before. We've already lost a lot
>> > of time with this patchset and it's blocking easier testing of network
>> > namespaces (right now, with a mainline kernel, we have to disable sysfs
>> > to build network namespaces).
>> 
>> I am confident that we have a good base with these patches and the rest of
>> the work can be done incrementally on top of them if any issues turn up.
>> 
>> Al recent rework of sysctl has a very similar structure.

Al thank you for taking a fresh look at sysfs. 

For the rest of the readers.  Most of the bugs and what seem to
me to be the most significant bugs that Al is seeing existing
without my sysfs tagged directory patchset.

> No, it does not.  My apologies for delay, but here are more printable parts
> of review.

The concept of a single directory tree in the basic data structure
where only some parts show up depending upon the namespace you are in
conceptually the same, and that is what I was referring to.


I'm going to attempt to step back a bit and see if I can convert this into 
a constructive exchange.  Picking on the nasty details without discussing
the reasons for those details won't get us anywhere.

>From the point of view of the VFS sysfs is a distributed filesystem.  

As a distributed filesystem we don't always go through the VFS sanity
checks when a filesystem change occurs, and only update the VFS caches
to the state of the change.

As a distributed filesystem sysfs internally needs to provide all of
the locking necessary to ensure the sysfs data structures are consistent.

Currently there are two basic paths into sysfs:
- Directly to the kernel internal state to the internal sysfs state.
  This is where all mutation happens.
- Read-only through the VFS.

In the case of directory structure mutation, the mutation has happened
and the VFS simply must be told about it.

Which means that in a sane and simple design of a global filesystem
the locking would work was follows:

o Obtain filesystem lock
o Modify filesystem internal state.
o For each mounted instance
o   Obtain VFS locks
o   Update the mounted instance.
o   Release VFS locks
o Release filesystem lock.

The above is simple and allows the same locking ordering for all accesses.

Unfortunately the VFS does not give us the opportunity to takes the locks
in the proper order.  And it insists on grabbing a VFS lock before we can
grab a global lock.

Which in my case leads to weirdness like:

> a) You do *not* share struct inode between the superblocks, for fsck sake!

I can't currently use separate inodes because of the current locking of sysfs,
because by the current VFS limitations.  In particular:

The currently locking order is:
    mutex_lock(&inode->i_mutex);
    mutex_lock(&sysfs_mutex);

If I use separate inodes that locking order can not be maintained.  Frankly I would
love to change this.

> d) You REALLY, REALLY do not unhash busy dentries of directories.

Quiet frankly if the VFS requires the dcache to be out of sync
with the filesystem that is a VFS bug.

If the filesystem deletes the directory then it should be unhashed
so it can not be looked up.

Currently I know unhashing a busy directory potentially causes
mount leaks.  Are you thinking of anything else?

> * may I politely suggest that
> again:
> 	mutex_lock(&A);
> 	if (!mutex_trylock(&B)) {
> 		mutex_unlock(&A);
> 		goto again;
> 	}
>
> is somewhat, er, deficient way to deal with buggered locking hierarchy?

Nah.  In this case just a silly oversight.  It is a trivial fix.

> Not to mention anything else, that's obviously FUBAR on UP box - if we
> have B contended, we've just killed the box dead since we'll never give
> the CPU back to whoever happens to hold B.  See sysfs_mv_dir() for a lovely
> example.

Good point about UP deadlocks.

It shouldn't be hard to do the equivalent of lock_rename() and unlock_rename().

> c) You do *not* change dentry tree topology without s_vfs_rename_mutex on
> affected superblock.  That, BTW, is broken in mainline sysfs as well.

Hardly.    sb->s_vfs_rename_mutex only serializes against renames in the VFS.
As such it isn't useful to protect the sysfs data structures.  That is
the job of sysfs_rename_mutex.  At which point sb->s_vfs_rename_mutex
is redundant.

The only places I can see where s_vfs_rename_mutex is taken is in
lock_rename(), unlock_rename() and d_materialise_unique().
d_materialise_unique() only gets called by NFS.  lock_rename() and
unlock_rename() only get called from renameat which always fails in the
case of sysfs and we aren't doing anything silly like hard links to
directories so I don't see a way to support that path.

> b) You do *not* grab i_mutex on ancestors after having grabbed it on
> file, as sysfs_chmod_file() does.

Ouch!  Good point.  That is simple enough to solve by reordering the
operations.

> In addition to that, there are interesting internal problems:
> * inumbers are released by final sysfs_put(); that can happen before the
> final iput() on corresponding inode.  Guess what happens if new entry is
> created in the meanwhile, reuses the same inumber and lookup gets to
> sysfs_get_inode() on it?

Cute.  Sounds like we need to put a reference to the sysfs_dirent into the inode.

> * sysfs_count_nlink() is called from sysfs_fill_super() without sysfs_mutex;
> now this sucker can get called at any moment.


> * just what is protecting ->s_tag?

sd->s_tag can only be changed by sysfs_mv_dir so it should share the same locking
as anything else that can be renamed.

> * __sysfs_remove_dir() appears to assume that subdirectories are possible;
> AFAICS, if we *do* get them, we get very screwed after remove_dir().

I haven't touched that one, and I am tired tonight.  Are you thinking
of something in addition to an early sysfs_put and a 

> * everything else aside, the internal locking is extremely heavy.  For
> fsck sake, guys, a single system-wide mutex that can be grabbed for the
> duration of readdir on any directory and block just about anything
> in the filesystem?  Just mmap() something over NFS on a slow link and
> do getdents() to such buffer.  Watch a *lot* of stuff getting buggered.
> Hell, you can't even do ifconfig up while that sucker is held...

I don't see where we come anywhere close to sysfs for running ifconfig up.

Certainly ifconfig up works fine with sysfs compiled out and I haven't
spotted the path from the networking code to sysfs in that instance.
sysfs really only shows up in adding and removing network interfaces
in my experience.

> Seriously, people, it's getting worse than devfs had ever been ;-/

I haven't looked at devfs so I wouldn't know.  I just know it feels
futile a lot of time to try and improve sysfs.

Eric
