Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYFSWDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYFSWDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYFSWDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:03:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49297 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYFSWDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:03:38 -0400
Date: Thu, 19 Jun 2008 15:03:03 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH 3/3] configfs: Fix failing symlink() making
	rmdir() fail
Message-ID: <20080619220303.GB10888@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com> <1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com> <20080617221528.GA29091@mail.oracle.com> <20080618114043.GB30804@localhost> <20080618201107.GF16780@ca-server1.us.oracle.com> <20080619092842.GK30804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619092842.GK30804@localhost>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:28:42AM +0200, Louis Rilling wrote:
> On Wed, Jun 18, 2008 at 01:11:07PM -0700, Joel Becker wrote:
> > On Wed, Jun 18, 2008 at 01:40:43PM +0200, Louis Rilling wrote:
> > > The problem is rmdir() of the target item (see below). ATTACHING only protects
> > > us from rmdir() of the parent. This is the exact reason why I attach the link to
> > > the target in last place, where we know that we won't have to rollback.
> > 
> > 	Why wouldn't it protect the target, given that detach_prep()
> > will be called against the target if it's being rmdir'd?
> 
> Because
> 1/ setting and clearing ATTACHING could badly interact with mkdir()/symlink()
> inside the target item (for instance clear the flag before mkdir() has finished
> attaching a new item); to avoid this we could use a different flag, but

	Ok, true, we don't have a lock to protect mkdir.

> 2/ rmdir() of the target cannot lock the inode of the new symlink's parent like
> it does for mkdir(), otherwise we would risk a deadlock with other symlink() and
> sys_rename(). This means that rmdir() should retry aggressively, in a busy
> waiting loop, or replacing mutex_lock()/mutex_unlock() with yield().

	Yup, we'd have to have some other form of retry - note that this
is all spinlock territory.  Thus, it should be fast.  By the time
rmdir() gets back out to the toplevel, symlink/mkdir should be done
creating whatever they needed and waiting on the dirnet_lock.  Then
rmdir waits again on the lock.  It "should" be bang-bang.
	Yes, I know, assumptions all around.

> > 	We *can* do that, but we try to isolate it - hand-building VFS
> > objects is complex and error prone, and I try to isolate that to
> > specific cases.  I'd rather avoid it when not necessary.
> 
> In the case of symlink(), building a new inode is what all filesystems must do.
> The only "bad" side-effect I can figure out of having to rollback is that the
> new entry will be visible for a short time until it is removed.

	It won't be visible, because we hold i_mutex until we're done.

> Anyway, do you think that the "solutions" above are more acceptable?

	The code for create then destroy was quite ugly.  Maybe it
struck me because of that.

Joel

-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
