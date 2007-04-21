Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXDUQXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXDUQXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXDUQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:23:36 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:15395 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752463AbXDUQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:23:35 -0400
Subject: Re: [RFC][PATCH] reiserfs vs BKL
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, reiserfs-list@namesys.com,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Nikita Danilov <nikita@clusterfs.com>
In-Reply-To: <462A3871.3060104@suse.com>
References: <1177170364.7316.17.camel@twins>  <462A3871.3060104@suse.com>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 18:23:31 +0200
Message-Id: <1177172611.7316.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-21 at 12:14 -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Peter Zijlstra wrote:
> > Replace all the lock_kernel() instances with reiserfs_write_lock(sb),
> > and make that use an actual per super-block mutex instead of
> > lock_kernel().
> > 
> > This should make reiserfs safe from PREEMPT_BKL=n, since it seems to
> > rely on being able to schedule. Also, it removes the dependency on the
> > BKL, and thereby is not prone to cause prio inversion with remaining BKL
> > users (notably tty).
> > 
> > Compile tested only, since I didn't dare boot it.
> 
> NACK.

darn, I suspected it would be wrong :-/, it was too easy to be right.

> Believe me, I would *love* to nuke the BKL from reiserfs, but a search
> and replace of this nature is just wrong. reiserfs_write_lock() using
> the BKL isn't an accident - it depends on its nesting properties. If you
> did try to boot this kernel, you'd deadlock pretty quickly.

Right, I see. 

> This one has been on my TODO list for a long time. Interestingly, I've
> been doing reiserfs xattr development recently using 2.6.21-rc7-git2,
> and I'm not seeing any of these messages.

Yeah, that would be pretty close to what I ran.

> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> # CONFIG_PREEMPT_BKL is not set

I have CONFIG_PREEMPT=y, but seeing how one of those points came from a
cond_resched() within a lock_kernel() section, I'm not seeing how you
don't get these.

A well, I really do hope you come up with something some day, for me its
time to go change filesystems - bah, the pain...

