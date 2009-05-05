Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZEEQh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZEEQh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbZEEQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:37:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54891 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665AbZEEQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:37:41 -0400
Date: Tue, 5 May 2009 17:37:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ryusuke Konishi <ryusuke@osrg.net>
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: sget() misuse in nilfs
Message-ID: <20090505163737.GL8633@ZenIV.linux.org.uk>
References: <20090503225136.GC8633@ZenIV.linux.org.uk> <20090505.021129.103520156.ryusuke@osrg.net> <20090505081811.GK8633@ZenIV.linux.org.uk> <20090506.003729.89601025.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506.003729.89601025.ryusuke@osrg.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 12:37:29AM +0900, Ryusuke Konishi wrote:
> Oh, meaning of the (b) was ambiguous.  How about the following one?
> 
>  b) Remounting an ro-mount to read-only is possible only if the
>     checkpoint number of the target ro-mount is latest and there is no
>     existent rw-mount.
> 
>  c) Remounting a snapshot to a different checkpoint is not allowed.
>     Remounting a snapshot to an rw-mount is possible only if the
>     target snapshot equals to the latest checkpoint.

That's really rather messy...  Let's see if I've got it right:

* r/w -> r/w.  Allowed.
* r/w -> r/o.  Allowed.
* r/w -> snapshot.  Not allowed.
* snapshot -> r/w.  Allowed if it's the latest one and no r/w is there.
* snapshot -> r/o.  It remains a snapshot, but says it has succeeded.
* snapshot -> snapshot.  Only if it's the same.
* r/o -> r/w.  Allowed [1]
* r/o -> r/o.  Allowed.
* r/o -> snapshot.  Allowed only if the snapshot number is the latest.

r/w can't coexist with r/o, but can coexist with any snapshots.  Can't be
remounted to a snapshot directly, but can go through r/w->r/o->latest snapshot
in two mount -o remount.

"r/o" in the above means "read-only, SNAPSHOT flag not set".

What happens if you mount the thing r/w, remount it r/o and then try to
mount the latest snapshot?  Will that give two superblocks or will it
reuse the r/o mount?

OTOH, what will happen if you take r/w mount, mount the latest snapshot and
then remount the r/w one to r/o?

[1] there couldn't have been new r/w mount while r/o one existed, snapshot
number couldn't have changed and the only possible transition *into* r/o is
from r/w, so another r/w superblock couldn't have survived since before our
superblock has become r/o.
