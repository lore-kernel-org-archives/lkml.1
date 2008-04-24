Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYDXRI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYDXRI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYDXRIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:08:17 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36170 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYDXRIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:08:16 -0400
Date: Thu, 24 Apr 2008 13:04:53 -0400
Message-Id: <200804241704.m3OH4rl7013887@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 13:42:46 BST."
             <20080424124245.GC15214@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424124245.GC15214@ZenIV.linux.org.uk>, Al Viro writes:
> On Thu, Apr 24, 2008 at 01:39:50PM +0200, Miklos Szeredi wrote:
> > Then I did this series, which basically guarantees, that that cannot
> > happen.  Al rejected it, and rather fixed some of the remaining
> > places.  He still missed several, which sort of proves my point.
> 
> Which ones have I missed?
>  
> > I think it's totally pointless to continue trying to fix the symptoms
> > instead of getting at the root of the problem.
> > 
> > I know that VFS interfaces are a sensitive question, but it would be
> > nice it we could have some sanity back in this discussion.
> 
> Yes, it would.  How about that, for starters:
> 
> path_create() et.al. are *wrong* for nfsd; if nothing else, I'm not at
> all convinced that even apparmour wants export path + relative there
> _and_ r/o vs. r/w is decision that doesn't clearly map to ex_mnt flags.
> 
> Moreover, it's not at all obvious that we want to drop write access as
> soon as vfs_...() is over in case of nfsd.  Some of the stuff done
> immeidately afterwards might very well qualify for inclusion into
> protected area; some of the stuff done immediately _prior_ very likely
> needs that as well - look at fh_verify() and tell me why we don't want
> that "I'll hold write access to vfsmount" to span the area including
> that sucker.  If we want the r/o vs r/w policy directly vfsmount-based
> for nfsd, that is.
> 
> For ecryptfs it's also bogus - at the very least we need to decide what
> should happen when underlying vfsmount is remounted.  Again, I'm less
> than convinced that we want the same way to express r/o vs. r/w policy.

I tend to agree that the mnt_want* bracketing may need to encompass more
than one vfs_* method.  When copyup is involved, the problem is only
exacerbated.  A copyup may want to perform several actions "atomically", for
example:

1. vfs_mkdir /a
2. vfs_mkdir /a/b
3. vfs_mkdir /a/b/c
4. vfs_create /a/b/c/f
5. vfs_read(source file) -> vfs_write(/a/b/c/f)

These actions are often done in close proximity in unionfs, and in such a
case, it'd be nice if I could want_write only once around this sequence.

However, I'm not sure that for copyup (or ecryptfs), that an vfsmount-level
want/drop write is the right interface.  As you pointed out before, Al, some
other mechanism might be needed, perhaps at the superblock level, to declare
one's desire to write the f/s "atomically" (to avoid concurrent topology
changes).

Thanks,
Erez.
