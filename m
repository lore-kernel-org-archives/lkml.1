Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbXFZCQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbXFZCQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbXFZCQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:16:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60055 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961AbXFZCQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:16:44 -0400
Date: Tue, 26 Jun 2007 12:16:17 +1000
From: David Chinner <dgc@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Johannes Weiner <hannes-kernel@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com, David Chinner <dgc@sgi.com>
Subject: Re: [BUG] Lockdep warning with XFS on 2.6.22-rc6
Message-ID: <20070626021617.GK989688@sgi.com>
References: <20070625104956.GA22130@saeurebad.de> <a781481a0706250854p4dad0cb6k20111db0f1c13e55@mail.gmail.com> <20070625210111.GB26725@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625210111.GB26725@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:01:11PM +0200, Ingo Molnar wrote:
> 
> * Satyam Sharma <satyam.sharma@gmail.com> wrote:
> 
> > [ Ok, so we know that XFS wants to lock inodes in ascending inode 
> > number order and not strictly the parent-first-child-second order that 
> > rest of the fs/ code does, so that makes it difficult to teach lockdep 
> > about this kind of lock ordering ... ]

It does both - parent-first/child-second and ascending inode # order,
which is where the problem is. standing alone, these seem fine, but
they don't appear to work when the child has a lower inode number
than the parent.

> hm, there's a recent API addition to lockdep that should help with this: 
> have you looked into the patch below, could it be used to solve the XFS 
> problem? Basically when you are one step deeper into a recursive locking 
> scenario you can use lock_set_subclass() on the held lock to reset it 
> one level higher.

Peter Zijlstra already pointed me at that patch, Ingo ;). I'm looking
into it at the moment. Not being a lockdep expert, it's taking me a
little time to understand exactly what is needed here.

At first I wasn't sure that this would work, but now I've seen the
patch that used it, I suspect that it can be used. That patch
(http://lkml.org/lkml/2007/1/28/88) has three cases enumerated
(prev,cur,next) to match the three node types in the list and that
the "next" got set back to "cur" via lock_set_subclass() when
walking the list so that lockdep always sees cur -> next
transistions when walking the list. Have I read this correctly?
 
Reading this, it seems to me that the xfs_lock_inodes() code needs
to set the lock subclass of the first inode to "parent" (and lock it
as a parent) and then as it walks across the remining inodes it sets
the previous inode to a parent and locks the current inode as a
child.

It seems that I'd also need to make sure that this is done on the
normal parent/child lock ordering as well.

Does this make any sense?  lockdep is not something I've paid much
attention to up to this point (someone else did the current notation
and now on leave for a couple more months), so I'm trying to pick up
the pieces as quickly as possible...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
