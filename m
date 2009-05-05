Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZEEPjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZEEPjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZEEPjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:39:33 -0400
Received: from [192.16.179.4] ([192.16.179.4]:38526 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZEEPjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:39:32 -0400
Date: Wed, 06 May 2009 00:37:29 +0900 (JST)
Message-Id: <20090506.003729.89601025.ryusuke@osrg.net>
To: viro@ZenIV.linux.org.uk
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: sget() misuse in nilfs
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <20090505081811.GK8633@ZenIV.linux.org.uk>
References: <20090503225136.GC8633@ZenIV.linux.org.uk>
	<20090505.021129.103520156.ryusuke@osrg.net>
	<20090505081811.GK8633@ZenIV.linux.org.uk>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 May 2009 00:37:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009 09:18:11 +0100, Al Viro wrote:
> On Tue, May 05, 2009 at 02:11:29AM +0900, Ryusuke Konishi wrote:
> > Hi,
> > On Sun, 3 May 2009 23:51:36 +0100, Al Viro wrote:
> > > OK, I give up; what _is_ get_sb/remount code supposed to implement?
> > 
> > Oh, these functions lack spec comments.
> > 
> > I first explain some specs. (I think part of them should be added on
> > the code, later)
> > 
> > The nilfs_get_sb() allocates a new super_block struct (sb) or assigns
> > an existing sb to the mount point through sget().  For newly allocated
> > sb it calls nilfs_fill_super() for initialization.
> > 
> > The following things are supposed here:
> 
> >  1) Every rw-mount on a device shares the same sb (as usual).
> 
> OK.  That's the first kind of sb; no MS_RDONLY, no SNAPSHOT, snapshot_cno is 0.
> 
> >  2) Every sb of snapshot is independent with that of rw-mount or other
> >     snapshots if their checkpoint numbers differ.  On the other hand,
> >     two or more snapshots having the same checkpoint number share a sb
> >     wherever possible.
> 
> Umm...  That's what, MS_RDONLY, SNAPSHOT, snapshot_cno > 0?

Yes, exactly.
 
> >  3) Snapshots are mountable concurrently with a rw-mount, but a
> >     ro-mount is not so because the ro-mount cannot follow changes
> >     brought by the rw-mount.
> 
> And ro-mount would be MS_RDONLY, no SNAPSHOT, snapshot_cno equal to the
> nilfs_last_cno()?

Yes.
  
> >  b) ro->rw remount is possible only if there is no rw-mount on the
> >     device and the checkpoint number of the ro-mount is latest.
> 
> Er...  How could there be an rw-mount while we have ro one?  Your
> (3) above would seem to prohibit that situation...

Oh, meaning of the (b) was ambiguous.  How about the following one?

 b) Remounting an ro-mount to read-only is possible only if the
    checkpoint number of the target ro-mount is latest and there is no
    existent rw-mount.

> >     device and the checkpoint number of the ro-mount is latest.
 
> >  c) Remounting snapshot to different checkpoints or rw-mount is not
> >     allowed.
> 
> Where is the second part checked in the current code?

Ah, the second part was wrong.  The snapshot with latest checkpoint
number can be remounted into an rw-mount.  So it should be:

 c) Remounting a snapshot to a different checkpoint is not allowed.
    Remounting a snapshot to an rw-mount is possible only if the
    target snapshot equals to the latest checkpoint.
  
> > > Can SNAPSHOT even be there unless you have MS_RDONLY?
> > 
> > Yes, it can.  Nilfs snapshots can exist concurrently with rw-mount.
> 
> On the same superblock, that is...  And AFAICS the answer's "no, it can't"
> (we can have rw superblock and snapshot superblock at the same time, but
> those will be different instances of struct superblock).

You are right. It's my misunderstanding.

You meant SNAPSHOT for the NILFS_MOUNT_SNAPSHOT flag on
sb->s_mount_opt (it does appear as SNAPSHOT on the code).  So, the
answer is "no, it can't".

Regards,
Ryusuke Konishi
