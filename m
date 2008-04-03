Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbYDCCZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbYDCCZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbYDCCZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:25:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48498 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702AbYDCCZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:25:17 -0400
Date: Wed, 2 Apr 2008 22:21:24 -0400
Message-Id: <200804030221.m332LOH6007818@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod() 
In-reply-to: Your message of "Thu, 03 Apr 2008 02:46:22 BST."
             <20080403014622.GW9785@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080403014622.GW9785@ZenIV.linux.org.uk>, Al Viro writes:
> On Wed, Apr 02, 2008 at 09:37:01PM -0400, Erez Zadok wrote:
> > Since you've hinted of major vfs changes post-25, here's my take.
> > 
> > Right now I (and to a similar extent ecryptfs too) needs to keep track of
> > vfsmounts for various reasons:
> > 
> > - to grab a reference so the lower filesystems/mounts won't disappear on me
> 
> Umm...  Strictly speaking that's not true; you can grab an active reference
> to superblock and then superblock will stay.  vfsmount is usually more
> convenient, but that's it.

Yes, I do grab both vfsmount and superblock refs.  I found out that grabbing
vfsmount refs wasn't enough to prevent "umount -l" from detaching the f/s on
which I'm stacked on.  So now at mount time (or branch management time), I
grab those super-refs, as I have them after a successful path_lookup.  And,
since I keep a list of the branches I'm stacked on, I know precisely which
superblocks' references I need to release when unionfs is unmounted.

But what do I do if I descend into another lower superblock while looking up
a lower directory?  How do keep track of the superblock refs now?  I'd
basically have to memorize the hierarchy of mounted superblocks somehow?
How would I know when to release those refs?  (hmm, maybe I can rely on
d_mounted or the like?)

> > - sometimes it's ok to pass NULL for those things, sometimes it's not ok
> 
> See above.  This crap will be gone.  For ->follow_link() nobody is allowed
> to pass NULL as nameidata, period.

There's been talk in the past of splitting nameidata into intent structure
and all the rest.  Is that also part of your plan for 26?  Intents are
indeed very useful in ->lookup; the rest I can do without.

> > In the longer run, is there a way that a stackable f/s could traverse the
> > namespace below it w/o knowing or caring how they are composed (assorted r-w
> > and r-o bind mounts and such)?
> 
> Eh?  Explain, please...

So, in ->lookup, I essentially have to do a lookup on the corresponding
lower objects.  I get a nameidata, I have to create my own nameidata, and
pass it to lower ->lookup calls.  Can the API be changed so I wouldn't need
to get or pass a nameidata? (maybe just intent struct).

Also in ->lookup I call lookup_one_len, which is nice b/c it doesn't involve
vfsmounts or nameidata.  But lookup_one_len doesn't use the same prototype
as ->lookup, so there's some asymmetry here (I often like to see that a
stacked op passed to the lower f/s uses the same API as what was passed to
the op in the first place).

Ironically, since lookup_one_len doesn't involve vfsmounts, but I need them
for other reasons, I'm forced to live with NULL vfsmounts in some cases, or
refer to the lower vfsmounts I already had for my root dentry (that makes
transparently descending into a different vfsmount challenging, if not
inconsistent).

For many fs ops, the prototype of the ->op has a perfectly symmetric vfs_op()
helper.  For example, ->mkdir(inode,dentry,mode) and
vfs_mkdir(inode,dentry,mode).  But nothing as simple for lookup, one of the
most complex ops in unionfs.

BTW, to be honest, some of extra complications in unionfs (and
unionfs_lookup) have to do with .wh.* files (whiteouts).  But I hope that'll
get simpler once we have native WH support in the all the major filesystems.

Cheers,
Erez.
