Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbZEANX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbZEANX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZEANXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:23:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZEANXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:23:46 -0400
Date: Fri, 1 May 2009 15:23:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 6/6] kill-the-BKL/reiserfs: release the write lock on
	flush_commit_list()
Message-ID: <20090501132322.GA30055@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-7-git-send-email-fweisbec@gmail.com> <20090501054247.GD5983@elte.hu> <20090501131340.GB6011@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501131340.GB6011@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, May 01, 2009 at 07:42:47AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > flush_commit_list() uses ll_rw_block() to commit the pending log blocks.
> > > ll_rw_block() might sleep, and the bkl was released at this point. Then
> > > we can also relax the write lock at this point.
> > > 
> > > [ Impact: release the reiserfs write lock when it is not needed ]
> > > 
> > > Cc: Jeff Mahoney <jeffm@suse.com>
> > > Cc: Chris Mason <chris.mason@oracle.com>
> > > Cc: Alexander Beregalov <a.beregalov@gmail.com>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
> > >  fs/reiserfs/journal.c |    7 +++++--
> > >  1 files changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> > > index 373d080..b1ebd5a 100644
> > > --- a/fs/reiserfs/journal.c
> > > +++ b/fs/reiserfs/journal.c
> > > @@ -1120,8 +1120,11 @@ static int flush_commit_list(struct super_block *s,
> > >  		    SB_ONDISK_JOURNAL_SIZE(s);
> > >  		tbh = journal_find_get_block(s, bn);
> > >  		if (tbh) {
> > > -			if (buffer_dirty(tbh))
> > > -			    ll_rw_block(WRITE, 1, &tbh) ;
> > > +			if (buffer_dirty(tbh)) {
> > > +		            reiserfs_write_unlock(s);
> > > +			    ll_rw_block(WRITE, 1, &tbh);
> > > +			    reiserfs_write_lock(s);
> > > +			}
> > >  			put_bh(tbh) ;
> > >  		}
> > >  	}
> > 
> > there's 7 other instances of ll_rw_block():
> > 
> > fs/reiserfs/journal.c-			spin_unlock(lock);
> > fs/reiserfs/journal.c:			ll_rw_block(WRITE, 1, &bh);
> > fs/reiserfs/journal.c-			spin_lock(lock);
> > --
> > fs/reiserfs/journal.c-		            reiserfs_write_unlock(s);
> > fs/reiserfs/journal.c:			    ll_rw_block(WRITE, 1, &tbh);
> > fs/reiserfs/journal.c-			    reiserfs_write_lock(s);
> > --
> > fs/reiserfs/journal.c-	/* read in the log blocks, memcpy to the corresponding real block */
> > fs/reiserfs/journal.c:	ll_rw_block(READ, get_desc_trans_len(desc), log_blocks);
> > fs/reiserfs/journal.c-	for (i = 0; i < get_desc_trans_len(desc); i++) {
> > --
> > fs/reiserfs/journal.c-		set_buffer_dirty(real_blocks[i]);
> > fs/reiserfs/journal.c:		ll_rw_block(SWRITE, 1, real_blocks + i);
> > fs/reiserfs/journal.c-	}
> > --
> > fs/reiserfs/journal.c-	}
> > fs/reiserfs/journal.c:	ll_rw_block(READ, j, bhlist);
> > fs/reiserfs/journal.c-	for (i = 1; i < j; i++)
> > --
> > fs/reiserfs/stree.c-		if (!buffer_uptodate(bh[j]))
> > fs/reiserfs/stree.c:			ll_rw_block(READA, 1, bh + j);
> > fs/reiserfs/stree.c-		brelse(bh[j]);
> > --
> > fs/reiserfs/stree.c-						    reada_blocks, reada_count);
> > fs/reiserfs/stree.c:			ll_rw_block(READ, 1, &bh);
> > fs/reiserfs/stree.c-			reiserfs_write_unlock(sb);
> > --
> > fs/reiserfs/super.c-{
> > fs/reiserfs/super.c:	ll_rw_block(READ, 1, &(SB_BUFFER_WITH_SB(s)));
> > fs/reiserfs/super.c-	reiserfs_write_unlock(s);
> > 
> > in particular the second stree.c one and the super.c has a 
> > write-unlock straight before the lock-drop.
> > 
> > I think the stree.c unlock could be moved to before the 
> > ll_rw_block() call straight away.
> 
> 
> Indeed.
> 
> 
> > 
> > The super.c one needs more care: first put &(SB_BUFFER_WITH_SB(s)) 
> > into a local variable, then unlock the wite-lock, then call 
> > ll_rw_block(). (This is important because &(SB_BUFFER_WITH_SB(s)) is 
> > global filesystem state that has to be read with the lock held.)
> 
> 
> Indeed &(SB_BUFFER_WITH_SB(s)) is a pointer to blocks that
> reflect the state of the filesystem but it was already not
> safe on the old code.
> 
> ll_rw_block() may sleep, and wait_on_buffer() too. And this
> pointer could have changed already during these sleeps.

No, it was safe prior. This was the prior code:

 fs/reiserfs/super.c:	ll_rw_block(READ, 1, &(SB_BUFFER_WITH_SB(s)));

The argument is passed to ll_rw_block _before_ the scheduling. So 
the dereference always happens with the BKL held, and is safe.

It is true that ll_rw_block() can sleep (and will most likely sleep 
for a READ command), but that's not the issue: the issue is the 
former dereference which can now get out from under the lock. (it 
might still be safe in special circumstances - but has to be 
reviewed carefully.)

	Ingo
