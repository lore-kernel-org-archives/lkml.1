Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYAPIUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYAPIUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYAPIUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:20:25 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:60664 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbYAPIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:20:24 -0500
Date: Wed, 16 Jan 2008 09:20:11 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.24-rc7 2/2] sysfs: fix bugs in
 sysfs_rename/move_dir()
Message-ID: <20080116092011.115c3f0e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <478DA86F.10905@gmail.com>
References: <478D74A6.7000206@gmail.com>
	<478D75BD.1010805@gmail.com>
	<alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org>
	<478DA86F.10905@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 15:47:11 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Linus Torvalds wrote:
> > 
> > On Wed, 16 Jan 2008, Tejun Heo wrote:
> >> * sysfs_move_dir() has an extra dput() on success path.
> > 
> > Are you sure? How did this ever work?
> 
> I'm pretty sure.  I've seen dentry blowing up due to early release &&
> compared it with older code.  It was my mistake during restructuring
> error path.  The only user of sysfs_move_dir() was S390 Cornelia works
> on (cc'd).  Cornelia is usually very good at spotting and debugging
> sysfs bugs.  Dunno how it got slipped this time.

Hm, don't know either. It never blew for my tests (and I did extensive
moving around of ccw devices...)

> 
> > Also, looking at this, I think the "how did this ever work" question is 
> > answered by "it didn't",
> 
> Before dput() bug was introduced, it worked although error handling path
> was broken.
> 
> > but I also think there are still serious problems 
> > there. Look at
> > 
> > 	again:
> > 	        mutex_lock(&old_parent->d_inode->i_mutex);
> > 	        if (!mutex_trylock(&new_parent->d_inode->i_mutex)) {
> > 	                mutex_unlock(&old_parent->d_inode->i_mutex);
> > 	                goto again;
> > 	        }
> > 
> > and wonder what happen sif old_parent == new_parent. Is that trying to 
> > avoid an ABBA deadlock?
> 
> It will fall in infinite loop if old_parent == new_parent and for the
> question, I suppose so.  Cornelia, right?

Yes. But we jump out early if old_parent == new_parent.

> 
> > Normally you'd do it by ordering the locks, or by 
> > taking a third lock to guarantee serialization at a higher level (ie the 
> > "s_vfs_rename_mutex" on the VFS layer)
> 
> sysfs currently doesn't depend on VFS locking.  VFS locking is done just
> to keep VFS layer happy.  sysfs_dirent hierarchy is protected by
> sysfs_mutex and renaming/moving are protected by sysfs_rename_mutex.  As
> both ops are under rename_mutex, I think the above code just can grab
> both mutexes in any order.  It's probably a remnant of the days when
> sysfs used VFS locking to protect internal structures.

Yes, I think so.

> 
> s390 was the only user of the move interface till now and through all
> the recent sysfs change, it didn't receive enough attention other than
> Cornelia's testing. 

I just wonder why I never hit it since I regularily do some testing of
the moving stuff (on Greg's tree and on mainline). But bluetooth has
been using this interface for some time as well (and they were the ones
with the problems triggering this patch).

> Eventually, I think sysfs_rename_dir() and
> sysfs_move_dir() should be merged into sysfs_move() but for the current
> two users, I don't see anything wrong with the locking.

Me too. But maybe I'm just too familiar with the code...
