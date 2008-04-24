Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbYDXNG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbYDXNG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYDXNGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:06:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54978 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbYDXNGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:06:14 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424124245.GC15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 13:42:46 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 15:05:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 24, 2008 at 01:39:50PM +0200, Miklos Szeredi wrote:
> > Then I did this series, which basically guarantees, that that cannot
> > happen.  Al rejected it, and rather fixed some of the remaining
> > places.  He still missed several, which sort of proves my point.
> 
> Which ones have I missed?

Several calls to nfsd_setattr() for starters.  But I didn't do a full
audit of all vfs_* callers, there might well be others.

> > I think it's totally pointless to continue trying to fix the symptoms
> > instead of getting at the root of the problem.
> > 
> > I know that VFS interfaces are a sensitive question, but it would be
> > nice it we could have some sanity back in this discussion.
> 
> Yes, it would.  How about that, for starters:
> 
> path_create() et.al. are *wrong* for nfsd;

Why are they wrong?  The performance impact is negligible, the code is
not any more complicated.

> if nothing else, I'm not at
> all convinced that even apparmour wants export path + relative there
> _and_ r/o vs. r/w is decision that doesn't clearly map to ex_mnt flags.

I don't care what apparmor wants.  What I care about is consistency of
the thing.  If _anything_ calls into the filesystem, the same security
hooks should be called and the same mount flags should be checked.

Moving these into the callers would just result in a big chaos.

> Moreover, it's not at all obvious that we want to drop write access as
> soon as vfs_...() is over in case of nfsd.  Some of the stuff done
> immeidately afterwards might very well qualify for inclusion into
> protected area; some of the stuff done immediately _prior_ very likely
> needs that as well - look at fh_verify() and tell me why we don't want
> that "I'll hold write access to vfsmount" to span the area including
> that sucker.

I don't see anything in fh_verify() or after which modifies the
filesystem.  The purpose of the r/o checks is to prevent modification,
and nothing more.  Not even fsync() and friends are protected, because
they don't modify the filesystem in the logical sense, even if they do
flush caches to physical media.

> For ecryptfs it's also bogus - at the very least we need to decide what
> should happen when underlying vfsmount is remounted.  Again, I'm less
> than convinced that we want the same way to express r/o vs. r/w policy.

We can add whatever policy we want.  The path_ interface doesn't stop
you from having sane r/o semantics on ecryptfs.  What it does is to
make sure that the r/o rules are _always_ followed, regardless of any
policy or lack thereof in the callers.

Miklos
