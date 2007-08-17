Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbXHQSGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbXHQSGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXHQSGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:06:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:57742 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbXHQSF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:05:59 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Adding a security parameter to VFS functions
Date: Fri, 17 Aug 2007 20:05:06 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <29015.1187178055@redhat.com> <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org> <20070816233412.GO21089@ftp.linux.org.uk>
In-Reply-To: <20070816233412.GO21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 4682
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708172005.06731.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007 01:34, Al Viro wrote:
> On Thu, Aug 16, 2007 at 03:57:24PM -0700, Linus Torvalds wrote:
> > I personally consider this an affront to everythign that is decent.
> > 
> > Why the *hell* would mkdir() be so magical as to need something like that?
> > 
> > Make it something sane, like a "struct nameidata" instead, and make it at 
> > least try to look like the path creation that is done by "open()".  Or 
> > create a "struct file *" or something.
> 
> No.  I agree that mkdir/mknod/etc. should all take the same thing.
> *However*, it should not be nameidata or file.  Why?  Because it
> should not contain vfsmount.  Object creation should not *care*
> where fs is mounted.  At all. The same goes for open(), BTW - letting it see
> the reference to vfsmount via nameidata is bloody wrong and I really
> couldn't care less what kinds of perversions apparmour crowd might like -
> pathnames simply do not belong there.

At the filesystem layer I mostly agree with you -- ordinary filesystems don't 
have a real business with vfsmounts. At the vfs / lsm layer it's a different 
story though. The vfs is not only about physical object creation alone, but 
also about lookups and security checks (lookup related or not). Consider an 
example:

The same filesystem is bind mounted at /foo/mnt and /bar/mnt. A process tries 
to create /foo/mnt/file or /bar/mnt/file. Depending on the permissions 
of /foo and /bar, the operations may succeed or fail independently. Both 
paths point at the same file, but they may grant different permissions (and 
nobody in their right mind would require them to be equivalent).

The checks we are doing in LSM hooks like security_inode_mknod are pretty 
similar -- we are taking the entire paths to objects into account, and so 
different paths to the same object may result in different permissions. The 
major difference is this:

 * The vfs performs lookups in forward direction, and incrementally. Arbitrary
   amounts of time can pass from when a lookup starts at the root to when it
   reaches a final object. (Think of things like mkdirat, but also the pwd,
   which is basically the same as a directory file handle). The vfs doesn't
   care when directories above the current lookup position become
   inaccessible, renamed, or moved.

 * We need to determine whether an object may be accessed at the time of the
   access, based on the location of the object in the filesystem namespace
   (i.e., dentry and vfsmount). And *this* is why we need the vfsmounts
   in the LSM hooks (and also in the vfs_* functions which are calling the
   hooks) [*].

We are not arguing to pass the vfsmount down the inode operations. At least
some of the LSM hooks are already being passed the vfsmounts, so we are not
even asking for something entirely new and unheard of.

By not letting the LSM hooks know about the vfsmounts you are effectively 
making pathname-based access control impossible. I would expect arguments 
more technically sound than "bloody wrong" and "couldn't care less" for 
killing an entire category of LSMs that lots of people find rather useful.


Thanks,
Andreas


[*] In the current implementation we are computing the entire paths to objects
    with d_path(). We cannot do this incrementally during lookups because
   directories along the path to an object can be renamed or moved around
   any time before the actual access. It doesn't seem hard to add caching so
   that we'll have to do this much less frequently, and maybe we can sometimes
   determine that the pwd hasn't changed and start checking from there, but
   all of this wouldn't change the fundamental model or the slow path / worst
   case.

-- 
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE Linux Products GmbH
