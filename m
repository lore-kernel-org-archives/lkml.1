Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXEKQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXEKQA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbXEKP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:59:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:45384 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758870AbXEKP7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:59:52 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [nameidata 1/2] Don't pass NULL nameidata to vfs_create
Date: Fri, 11 May 2007 17:59:34 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200704161811.30364.agruen@suse.de> <20070416162146.GA8029@infradead.org>
In-Reply-To: <20070416162146.GA8029@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705111759.36069.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 18:21, Christoph Hellwig wrote:
> On Mon, Apr 16, 2007 at 06:11:30PM +0200, Andreas Gruenbacher wrote:
> > On Thursday 12 April 2007 12:06, Christoph Hellwig wrote:
> > > Once again very strong NACK.  Every conditional passing of vfsmounts get 
> > > my veto.  As mentioned last time if you really want this send a patch
> > > series first that passed the vfsmount consistantly.
> > 
> > I don't consider it fair to NACK this patch just because some other part
> > of the kernel uses vfs_create() in the wrong way -- those are really
> > independent issues. The bug is not that hard to fix though; here is a
> > proposed patch on top of the other AppArmor patches.
> 
> Note that it's not just this particular hunk, all these kinds of conditional
> passing are wrong.

Yes, the vfs uses or passes through a NULL nameidata or vfsmount pointer and 
no intent information in several places:

 (1) vfs_create() is called with a NULL nameidata in two places,

 (2) lookup_one_len() and lookup_one_len_kern() pass a NULL nameidata to
     permission(), d_op->d_revalidate(), and i_op->lookup(),

 (3) file_permission() passes a NULL nameidata to permission().

 (4) permission() is directly called with NULL nameidata in some places, and

In general it is incorrect to use NULL nameidata or vfsmounts because then the
vfsmount->mnt_flags cannot be checked, and no intent information is available. 
Intents are an optional optimization for remote filesystems; we can simply 
ignore them for local filesystems. There are some cases where we are passing 
NULL which are real bugs, but there are also other cases in which the 
operations are not mount related: for example, filesystems like pipefs have 
the MS_NOUSER flag set which indicates that they cannot be mounted at all. On 
filesystems like sysfs, files are created and removed whether or not that 
filesystem is mounted.

The places where we should pass a proper nameidata / vfsmount but don't should 
be fixed. Those are long-standing issues in the vfs though, and at least some 
are not easy to correct. AppArmor is affected by some of the NULL vfsmount 
passing, and we found a few more problems when looking into this more 
closely, but most of that NULL passing doesn't affect AppArmor:

 * In some places, vfs functions are called without nameidata / vfsmount,
   followed by calling lsm hooks with a vfsmount. In those cases, the vfs
   functions cannot check the vfsmount flags, but the lsm hooks will still
   do the appropriate checks.

 * In the AppArmor security model, directory searching is always allowed, and
   the access check are done once the leaf dentry + vfsmount has been looked
   up. For example, granting write access to /var/tmp/foo in a profile is
   sufficient to allow that access; search access to /var and /var/tmp does
   not need to be specified. (The regular inode permission checks are of
   course still performed.)

 * For filesystems like nfsd, the concept of pathname based access control
   doesn't make sense because of properties of the protocol: there is no
   reliable mapping from an nfs file handle to a particular file; aliases
   to the same file cannot be distinguished. (The AppArmor techdoc [1]
   describes this in more detail.)

   Not allowing to confine nfsd by AppArmor doesn't hurt much: nfsd provides
   its own export access control mechanisms. Also, nfsd cannot really be
   confined in a secure way because of how it is implemented in the kernel.
   Gfs2 may have similar properties; I didn't actually look into the protocol.

So I propose to separate the vfs NULL nameidata / vfsmount passing discussion 
from the AppArmor discussion. I have no problem working on the vfs fixes -- 
we could some nice cleanups there -- but that really is independent of 
AppArmor.

We almost have the revised AppArmor patches ready. We'll include all the fixes 
that are truly necessary, and everything beyond that will be posted 
separately.

> But anyway, creating fake nameidata structures is not really helpful.
> If there is a nameidata passed people expect it to be complete, and
> if you pass them to an LSM people will e.g. try to look into lookup
> intents.

Splitting up nameidata helps somewhat here. In cases where we don't have 
intent information available we can zero out the intent flags, and so in the 
worst case, we won't get the intent optimizations.

Thanks,
Andreas
