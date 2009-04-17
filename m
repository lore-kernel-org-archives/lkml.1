Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbZDQSI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbZDQSI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZDQSIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:08:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47911 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbZDQSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:08:50 -0400
Date: Fri, 17 Apr 2009 19:08:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417180832.GL26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu> <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu> <1239987885.23397.4817.camel@laptop> <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:21:06AM -0700, Linus Torvalds wrote:

> Of course, right now we do hold the BKL over _multiple_ downcalls, so in 
> that sense it's not actually totally 100% correct and straightforward to 
> just move it down. Eg in the generic_shutdown_super() case we do
> 
> 	lock_kernel();
> 	  ->write_super();
> 	  ->put_super();
> 	invalidate_inodes();
> 	unlock_kernel();
> 
> and obviously if we split it up so that we push a lock_kernel() into both, 
> we end up unlocking in between. I doubt anything cares, but it's still a 
> technical difference.

No, that's OK.  Anything that would expect on lack of blocking between
the callers of ->write_super() and ->put_super() is simply insane.  Not
that other callers of ->write_super() had been under BKL, while we are
at it...

> There are similar issues with 'remount' holding the BKL over longer 
> sequences.
> 
> Btw, the superblock code really does seem to depend on lock_kernel. Those 
> "sb->s_flags" accesses are literally not protected by anything else afaik.

Modifications in there *should* be protected by ->s_umount.  Except that
emergency_remount() does down_read() instead of down_write(), for some
reason.  And that fs going r/o on error very likely will not hold any
locks at all, BKL included.

Note that most of the readers really couldn't care less about protection.
Single-shot tests for one bit like "is this fs mounted noatime right now?" 
are OK as is - we don't *care* if it races with remount and no way to
do anything about such race anyway.

Read-only is the main exception; we should be mostly OK since the per-vfsmount
r/o rework, but "I have an error and I'll go r/o now" stuff is still messy.

> That said, I think that fs/locks.c is likely a much bigger issue. Very few 
> people care about any realtimeness of mount/unmount/remount. But file 
> locking? That is much more likely to be an issue.

That is much more likely to require really non-trivial work, BTW.  That code
is a *mess* and inventing sane locking for it will be painful.
