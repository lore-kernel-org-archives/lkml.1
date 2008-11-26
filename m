Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYKZPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYKZPDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKZPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:03:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:59843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYKZPDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:03:03 -0500
Subject: Re: Lockdep warning for iprune_mutex at shrink_icache_memory
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dan =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20081126072625.GH6291@disturbed>
References: <20081125064357.5a4f1420@tuna> <20081126072625.GH6291@disturbed>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Nov 2008 16:02:59 +0100
Message-Id: <1227711779.4454.184.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 18:26 +1100, Dave Chinner wrote:
> On Tue, Nov 25, 2008 at 06:43:57AM -0500, Dan Noé wrote:
> > I have experienced the following lockdep warning on 2.6.28-rc6.  I
> > would be happy to help debug, but I don't know this section of code at
> > all.
> > 
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.28-rc6git #1
> > -------------------------------------------------------
> > rsync/21485 is trying to acquire lock:
> >  (iprune_mutex){--..}, at: [<ffffffff80310b14>]
> > shrink_icache_memory+0x84/0x290
> > 
> > but task is already holding lock:
> >  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffffa01fcae5>]
> > xfs_ilock+0x75/0xb0 [xfs]
> 
> False positive. memory reclaim can be invoked while we
> are holding an inode lock, which means we go:
> 
> 	xfs_ilock -> iprune_mutex
> 
> And when the inode shrinker reclaims a dirty xfs inode,
> we go:
> 
> 	iprune_mutex -> xfs_ilock
> 
> However, this cannot deadlock as the first case can
> only occur with a referenced inode, and the second case
> can only occur with an unreferenced inode. Hence we can
> never get a situation where the inode being locked on
> either side of the iprune_mutex is the same inode so
> deadlock is impossible.
> 
> To avoid this false positive, either we need to turn off
> lockdep checking on xfs inodes (not going to happen), or memory
> reclaim needs to be able to tell lockdep that recursion on
> filesystem lock classes may occur. Perhaps we can add a
> simple annotation to the iprune mutex initialisation as well as
> the xfs ilock initialisation to indicate that such recursion
> is possible and allowed...

This is that: an inode has multiple stages in its life-cycle, thing
again, right?

Last time I talked to Christoph about that, he said it would be possible
to get (v)fs hooks for when the inode changes data structures as its not
really too FS specific or was fully filesystem specific, I can't
remember.

The thing to do is re-annotate the inode locks whenever the inode
changes data-structure, much like we do in unlock_new_inode().

So for each stage in the inode's life-cycle you need to create a key for
each lock, such as:

struct lock_class_key xfs_active_inode_ilock;
struct lock_class_key xfs_deleted_inode_ilock;
...

and on state change do something like:

  BUG_ON(rwsem_is_locked(&xfs_ilock->mrlock));

  init_rwsem(&xfs_ilock->mrlock);
  lockdep_set_class(&xfs_ilock->mrlock, &xfs_deleted_inode_ilock);


hth
