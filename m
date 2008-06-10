Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYFJRhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYFJRhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYFJRhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:37:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31628 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYFJRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:37:31 -0400
Date: Tue, 10 Jun 2008 10:36:54 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] deadlock between configfs_rmdir() and sys_rename() (WAS
	Re: [RFC][PATCH 4/4] configfs: Make multiple default_group)
	destructions lockdep friendly
Message-ID: <20080610173654.GA23829@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20080522114048.265996107@kerlabs.com> <20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com> <20080602230721.GD19500@mail.oracle.com> <20080603160034.GA17308@localhost> <20080606230154.GK29740@mail.oracle.com> <20080609110353.GK18153@localhost> <20080609125443.GL18153@localhost> <20080610015800.GD14820@mail.oracle.com> <20080610101427.GA4048@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610101427.GA4048@localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:14:27PM +0200, Louis Rilling wrote:
> On Mon, Jun 09, 2008 at 06:58:00PM -0700, Joel Becker wrote:
> > 	I'm not against the latter AT ALL.  I just haven't come up with
> > it yet - we can't remove parts of the tree, it must be all or none.
> > Hence, we lock them all speculatively.
> 
> I'm slowly thinking about a solution, but I don't know the VFS enough
> yet, especially regarding dentry invalidation and locking. Would it be possible
> to start an rmdir() by moving the group to some unreachable place? We could
> probably use the mutex of the configfs subsystem and enlarge its scope to
> protect against concurrent mkdir(), check for user-created items under the
> group (and descendent default groups) to remove, invalidate all dentries and
> actually remove the group. Do you think that something is feasible in this way?

	Nope, because you may have live objects below you - the rmdir
should fail, and nothing should change.  Sure, you could put it back,
but in the middle there is a period where another process tries to look
at the tree and gets ENOENT.  That's not right.
	But blocking lookup another way might work.  If we keep that
rename process out of looking up its targets (blocked on a lock we hold)
it might work.
	Note, btw, that the create side (populate_groups) is safe,
because we hold the creating parent's i_mutex throughout the entire
process.
	Hey, can we use d_revalidate?  Here's the issue.  rename, when
going to lookup the objects it wants to lock, is getting them out of
cached_lookup - there dcache locking is all that protects it.  I was
first thinking we could take the dentry locks to block this out.  But
rather, why not fail d_revalidate and force a locked lookup?  So, when
we go to lock one of these groups for detaching, we also set a flag on
the configfs_dirent.  We add a configfs_d_revalidate function that
returns based on that flag - if set, revalidation is needed.  Thus, when
another process comes in to look at the object we've already locked, it
blocks waiting to find it.
	See, in do_rename, it does do_path_lookup() before actually
calling lock_rename().  It would block there waiting for our speculative
removal.  We'd either fail rmdir, and those lookups would succeed, or
we'd succeed rmdir, and the lookup fails.
	The only concern is, can the reverse happen?  We get past the
lookups in do_rename(), and then another process comes into rmdir() -
will they deadlock there?

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
