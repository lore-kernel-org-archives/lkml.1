Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZEFGbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZEFGbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZEFGbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:31:06 -0400
Received: from [192.16.179.4] ([192.16.179.4]:54656 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbZEFGbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:31:04 -0400
Date: Wed, 06 May 2009 15:28:59 +0900 (JST)
Message-Id: <20090506.152859.91114993.ryusuke@osrg.net>
To: viro@ZenIV.linux.org.uk
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: sget() misuse in nilfs
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <20090505163737.GL8633@ZenIV.linux.org.uk>
References: <20090505081811.GK8633@ZenIV.linux.org.uk>
	<20090506.003729.89601025.ryusuke@osrg.net>
	<20090505163737.GL8633@ZenIV.linux.org.uk>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 May 2009 15:28:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009 17:37:37 +0100, Al Viro wrote:
> On Wed, May 06, 2009 at 12:37:29AM +0900, Ryusuke Konishi wrote:
> > Oh, meaning of the (b) was ambiguous.  How about the following one?
> > 
> >  b) Remounting an ro-mount to read-only is possible only if the
> >     checkpoint number of the target ro-mount is latest and there is no
> >     existent rw-mount.
> > 
> >  c) Remounting a snapshot to a different checkpoint is not allowed.
> >     Remounting a snapshot to an rw-mount is possible only if the
> >     target snapshot equals to the latest checkpoint.
> 
> That's really rather messy...  Let's see if I've got it right:
> 
> * r/w -> r/w.  Allowed.
> * r/w -> r/o.  Allowed.
> * r/w -> snapshot.  Not allowed.
> * snapshot -> r/w.  Allowed if it's the latest one and no r/w is there.
> * snapshot -> r/o.  It remains a snapshot, but says it has succeeded.

Ah, this transition was not assumed.  It needs some fix.

> * snapshot -> snapshot.  Only if it's the same.
> * r/o -> r/w.  Allowed [1]
> * r/o -> r/o.  Allowed.
> * r/o -> snapshot.  Allowed only if the snapshot number is the latest.

Look correct.

> r/w can't coexist with r/o, but can coexist with any snapshots.
> Can't be remounted to a snapshot directly, but can go through
> r/w->r/o->latest snapshot in two mount -o remount.

Hmm, right. It looks half-baked.

The transition "r/w -> latest snapshot" should be allowed to ensure
consistency.

> "r/o" in the above means "read-only, SNAPSHOT flag not set".
> 
> What happens if you mount the thing r/w, remount it r/o and then try to
> mount the latest snapshot?  Will that give two superblocks or will it
> reuse the r/o mount?

It will reuse the r/o mount, which was originally r/w mount.
 
> OTOH, what will happen if you take r/w mount, mount the latest snapshot and
> then remount the r/w one to r/o?

In that case, the latest snapshot and the r/o-mount will coexist as
two different instances.

> [1] there couldn't have been new r/w mount while r/o one existed, snapshot
> number couldn't have changed and the only possible transition *into* r/o is
> from r/w, so another r/w superblock couldn't have survived since before our
> superblock has become r/o.

I'd rather simplify things.

If we treat read-only mount as the latest snapshot at the time (though
we didn't take this interpretation), the transitions can be reduced
to:

 * r/w -> r/w.  Allowed.
 * r/w -> snapshot.  Allowed if no checkpoint number was given (or the
                     latest checkpoint was specified)
 * snapshot -> r/w.  Allowed if it's the latest one and no r/w is there.
 * snapshot -> snapshot.  Only if it's the same.

Right?

But it still needs test_exclusive_mount().

The test_exclusive_mount() may be eliminable by adding rw-mount-exists
flag on the_nilfs struct.  I'll take some thinking.

Regards,
Ryusuke Konishi
