Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYDCXZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYDCXZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYDCXZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:25:26 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36055 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYDCXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:25:24 -0400
Date: Thu, 3 Apr 2008 19:24:47 -0400
Message-Id: <200804032324.m33NOlqa030835@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod() 
In-reply-to: Your message of "Thu, 03 Apr 2008 03:32:39 BST."
             <20080403023239.GY9785@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080403023239.GY9785@ZenIV.linux.org.uk>, Al Viro writes:
> On Wed, Apr 02, 2008 at 10:21:24PM -0400, Erez Zadok wrote:
> > Yes, I do grab both vfsmount and superblock refs.  I found out that grabbing
> > vfsmount refs wasn't enough to prevent "umount -l" from detaching the f/s on
> > which I'm stacked on.  So now at mount time (or branch management time), I
> > grab those super-refs, as I have them after a successful path_lookup.  And,
> > since I keep a list of the branches I'm stacked on, I know precisely which
> > superblocks' references I need to release when unionfs is unmounted.
> 
> How the devil would holding a superblock prevent umount -l?

It doesn't prevent umount -l; but it prevents the lower superblock from
being kfree()d if there were no references left to it, so I don't try to
accessed freed memory (and get 6b6b6b6b oopses :-)

> > But what do I do if I descend into another lower superblock while looking up
> > a lower directory?  How do keep track of the superblock refs now?  I'd
> > basically have to memorize the hierarchy of mounted superblocks somehow?
> > How would I know when to release those refs?  (hmm, maybe I can rely on
> > d_mounted or the like?)
> >
> > > > - sometimes it's ok to pass NULL for those things, sometimes it's not ok
> > > 
> > > See above.  This crap will be gone.  For ->follow_link() nobody is allowed
> > > to pass NULL as nameidata, period.
> > 
> > There's been talk in the past of splitting nameidata into intent structure
> > and all the rest.  Is that also part of your plan for 26?  Intents are
> > indeed very useful in ->lookup; the rest I can do without.
> 
> intents will die.  There'll be a method for final step of lookup + open,
> but that's it (and it'll take preallocated struct file as one of the
> arguments).

How much of nameidata will still need to be passed to f/s ops?  How many vfs
helpers will still require a nameidata?  Hopefully as few as possible.

Is this preallocated struct file a replacement to the nd->intent.open.file
that could have returned an allocated struct file?  (I could never really
tell what's the right thing to do with that field.)

> Please, explain what you want to do with intents, because
> as far as I'm concerned these had been a mistake for a lot of reasons.

I said above "intents are indeed very useful" only because they were:

1. required to be passed to vfs_* methods, which made it hard if the ->op I
   was in didn't have an intent (I have to create temp intents for those).

2. apparently heavily used in nfs4, to a point where if I stacked on nfs4
   and didn't pass a correctly formatted nameidata, I'd get an oops deep
   inside nfs4 code.  (I think some of those nfs4 requirements went away,
   not sure what's left.).

> > Ironically, since lookup_one_len doesn't involve vfsmounts, but I need them
> > for other reasons, I'm forced to live with NULL vfsmounts in some cases, or
> > refer to the lower vfsmounts I already had for my root dentry (that makes
> > transparently descending into a different vfsmount challenging, if not
> > inconsistent).
> 
> Details, please.  If you just want a snapshot of vfsmount tree, then by
> all means take a bloody snapshot.  collect_mounts() is there for purpose.
> If you want mount/umount/etc. changes affect what you have, then I really
> would like to see the semantics you want.  Some variation on shared-subtree
> might be close to that...

I'll have to take a closer look at vfsmount tree snapshotting and
collect_mounts() before I can say how useful they'd be.  But if you recall
my questions at LSF, I asked whether it was possible for me to create a
readonly directory tree (e.g., r-o bind mounts) or some form of an immutable
namespace that no one can modify underneath me.  You said that r-o bind
mounts were not intended for that.

Right now I'm allowing users to modify lower branches, with all the pros and
cons that it has.  But even if I wanted to prevent users from touching any
lower files below a certain directory, while allowing only unionfs to modify
those files, it doesn't appear that there's something available I could use.


I have two other questions/requests:

1. The less I have to use or know about vfsmounts and nameidata/intents, the
   better.  But whatever API changes you make, please consider the symmetry
   between the f/s ->op I'm called with, and the vfs helpers I might use in
   the ->op to pass through to the lower f/s.  Ideally the prototypes of the
   ->op and vfs helpers be identical, so I don't have to work too hard to
   locate the lower objects, or worse, having to make them up temporarily.

2. You mentioned that all this work is scheduled for 26.  25 is nearing
   release.  Do you have code already that I can experiment with?  A preview
   of things to come?  Maybe an example or two of how a filesystem
   (stackable, nfsd, or otherwise) should lookup and open arbitrary files?
   What you mentioned in this discussion thread sounds promising and
   exciting, but may take me a while to apply to my tree (longer than the
   usual merge window, which reportedly will shrink even further, now that
   we have linux-next :-).  So the more lead time, the better, please.

Thanks,
Erez.
