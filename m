Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYDXO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYDXO3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYDXO3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:29:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33777 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYDXO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:29:08 -0400
Date: Thu, 24 Apr 2008 15:28:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424142857.GF15214@ZenIV.linux.org.uk>
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:09:18PM +0200, Miklos Szeredi wrote:
> > Because you are mixing the "this sucker will be used for write access for
> > this interval" and "do what is needed to create a file".  The latter is
> > not guaranteed to coincide with the former and that in itself is enough.
> 
> I lost you there, sorry.  Can you please rephrase a bit less
> abstractedly?

The area to be protected against remount is not guaranteed to coincide with
vfs_...() or to contain nothing specific to this caller.

> > Bullshit.  It's not just "prevent modification".  It's "make sure that
> > no remount r/o happens while we do that".
> 
> Sure.
> 
> >  fh_verify() doesn't modify.
> > It does check, though, and later we have that check duplicated by
> > will_write/wont_write pair bracketing a part of sequence.
> 
> So what?  All the other checks are also duplicated within
> vfs_create()->may_create()->permission().

RTFS.  permission() doesn't do "is that vfsmount read-only" checks, exactly
because it's 100% bogus - either you cover it with entire area where we
are guaranteed to stay r/w, or it's by definition racy.

> > ecryptfs should not use the bloody vfsmount, for fuck sake!  You are
> > confusing access to fs with access to fs via specific vfsmount.  And
> > pretending that the latter is fundamental operation.
> 
> Umm, isn't it?  Want to redo open() without a vfsmount?

FWIW, I'm not all that happy about the way ecryptfs_interpose() is done,
while we are at it.  We get the sucker opened by whoever steps on given
place in the tree first, with subsequent operations done using the resulting
struct file.  With fallback to r/o open.  What happens to somebody who
tries to open it with enough permissions to do r/w?
