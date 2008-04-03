Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYDCBhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYDCBhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYDCBhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:37:42 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44849 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbYDCBhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:37:41 -0400
Date: Wed, 2 Apr 2008 21:37:01 -0400
Message-Id: <200804030137.m331b1O8004886@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod() 
In-reply-to: Your message of "Thu, 03 Apr 2008 02:00:16 BST."
             <20080403010016.GU9785@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080403010016.GU9785@ZenIV.linux.org.uk>, Al Viro writes:
> On Wed, Apr 02, 2008 at 08:47:06PM -0400, Erez Zadok wrote:
> > In message <1207183329.20254.49.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> > > 
> > > On Thu, 2008-04-03 at 00:47 +0100, Al Viro wrote:
> > [...]
> > > >  Again, what for?
> > > 
> > > It allows you to get rid of the vfsmount 'argument' when opening a file,
> > > which again lowers the barrier for stacking filesystems.
> > > 
> > > As far as the filesystems themselves are concerned, the effect is to
> > > enforce your assertion that file operations should not depend on the
> > > namespace.
> > 
> > I'd be delighted the day I won't have to deal with vfsmounts AT ALL in
> > any stacked f/s.
> 
> vfsmounts or the fact that any fs may be mounted in many places?

I think the former.  The fact that any f/s can be mounted in many places,
should be fine for a stacked f/s (topology changes as we discussed before
are a different problem).

Since you've hinted of major vfs changes post-25, here's my take.

Right now I (and to a similar extent ecryptfs too) needs to keep track of
vfsmounts for various reasons:

- to grab a reference so the lower filesystems/mounts won't disappear on me
- to pass it to dentry_open (opening the lower file)
- some fs ops pass a vfsmount (umount_begin, show_options)
- some fs ops or vfs helpers require a nameidata or struct path which embed
  a vfsmount inside
- sometimes it's ok to pass NULL for those things, sometimes it's not ok

Often it also appears that a vfsmount and a dentry tuple are needed
together, hence struct path.  So we recently started using struct path in a
few places, and using path_get/put.  The need to deal with <dentry,vfsmount>
pairs by hand can lead to interesting bugs, such as the recent ecryptfs
bugfix which had to swap the order of a dput() and mntput() sequence.

The fact that several vfs ops and helpers take different namespace-related
structures (dentry, nameidata, vfsmount, path), is confusing and hard to
track.  Is there a way to reduce the number of those structures to 1-2 at
most?

For a stackable f/s, it's important the the VFS ops *and* the VFS helpers
(vfs_*, path_*, dentry_open, etc.) use the same namespace structures: then
there's more symmetry b/t the objects passed to a stacked f/s, and the
objects it has to pass to VFS helpers (and FWIW, every such object should
ideally leave a "void *private" field for f/s specific extensibility).

In the longer run, is there a way that a stackable f/s could traverse the
namespace below it w/o knowing or caring how they are composed (assorted r-w
and r-o bind mounts and such)?

Cheers,
Erez.
