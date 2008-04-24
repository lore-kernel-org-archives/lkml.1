Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYDXOKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYDXOKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYDXOKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:10:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44966 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYDXOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:10:12 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424134826.GD15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 14:48:26 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 16:09:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Several calls to nfsd_setattr() for starters.  But I didn't do a full
> > audit of all vfs_* callers, there might well be others.
> > 
> > > > I think it's totally pointless to continue trying to fix the symptoms
> > > > instead of getting at the root of the problem.
> > > > 
> > > > I know that VFS interfaces are a sensitive question, but it would be
> > > > nice it we could have some sanity back in this discussion.
> > > 
> > > Yes, it would.  How about that, for starters:
> > > 
> > > path_create() et.al. are *wrong* for nfsd;
> > 
> > Why are they wrong?  The performance impact is negligible, the code is
> > not any more complicated.
> 
> Because you are mixing the "this sucker will be used for write access for
> this interval" and "do what is needed to create a file".  The latter is
> not guaranteed to coincide with the former and that in itself is enough.

I lost you there, sorry.  Can you please rephrase a bit less
abstractedly?

> 
> > > if nothing else, I'm not at
> > > all convinced that even apparmour wants export path + relative there
> > > _and_ r/o vs. r/w is decision that doesn't clearly map to ex_mnt flags.
> > 
> > I don't care what apparmor wants.  What I care about is consistency of
> > the thing.  If _anything_ calls into the filesystem, the same security
> > hooks should be called and the same mount flags should be checked.
> 
> _IF_ they make sense for call in question.  At the level where they
> are applied.

They do.  Specific counterexamples please.

> > > soon as vfs_...() is over in case of nfsd.  Some of the stuff done
> > > immeidately afterwards might very well qualify for inclusion into
> > > protected area; some of the stuff done immediately _prior_ very likely
> > > needs that as well - look at fh_verify() and tell me why we don't want
> > > that "I'll hold write access to vfsmount" to span the area including
> > > that sucker.
> > 
> > I don't see anything in fh_verify() or after which modifies the
> > filesystem.  The purpose of the r/o checks is to prevent modification,
> > and nothing more. 
> 
> Bullshit.  It's not just "prevent modification".  It's "make sure that
> no remount r/o happens while we do that".

Sure.

>  fh_verify() doesn't modify.
> It does check, though, and later we have that check duplicated by
> will_write/wont_write pair bracketing a part of sequence.

So what?  All the other checks are also duplicated within
vfs_create()->may_create()->permission().

> Please, realize that spot checks like that are inherently racy and that's
> the problem we had all along with r/o remounts et.al.

I do very much realize that.

> And that's why they got split in will/wont pairs and stretched to cover
> relevant areas.  Areas that depend on specific callers.

Specifics please.  I don't see any reason why the brackets would need
to be stretched (except to make make multiple vfs calls atomic wrt r/o
remount).

> And yes, we need the counterpart for superblock-level stuff, to deal with
> remaining races (look at fs_may_remount_ro() and puke - it's still racy
> as hell).  E.g. unlink should do sb-level "will write" when it drops
> i_nlink to 0 and final removal of inode should do "won't write".

Sure.

> > > For ecryptfs it's also bogus - at the very least we need to decide what
> > > should happen when underlying vfsmount is remounted.  Again, I'm less
> > > than convinced that we want the same way to express r/o vs. r/w policy.
> > 
> > We can add whatever policy we want.  The path_ interface doesn't stop
> > you from having sane r/o semantics on ecryptfs.  What it does is to
> > make sure that the r/o rules are _always_ followed, regardless of any
> > policy or lack thereof in the callers.
> 
> ecryptfs should not use the bloody vfsmount, for fuck sake!  You are
> confusing access to fs with access to fs via specific vfsmount.  And
> pretending that the latter is fundamental operation.

Umm, isn't it?  Want to redo open() without a vfsmount?

Miklos
