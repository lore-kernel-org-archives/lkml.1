Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbZEANy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbZEANy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZEANys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:54:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:16738 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbZEANyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:54:47 -0400
Subject: Re: [PATCH 6/6] kill-the-BKL/reiserfs: release the write lock on
 flush_commit_list()
From: Chris Mason <chris.mason@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20090501132923.GA30663@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
	 <1241145862-21700-7-git-send-email-fweisbec@gmail.com>
	 <20090501054247.GD5983@elte.hu> <20090501131340.GB6011@nowhere>
	 <1241184385.13084.11.camel@think.oraclecorp.com>
	 <20090501132923.GA30663@elte.hu>
Content-Type: text/plain
Date: Fri, 01 May 2009 09:54:17 -0400
Message-Id: <1241186057.13084.34.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49FAFF0C.03D9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 15:29 +0200, Ingo Molnar wrote:
> * Chris Mason <chris.mason@oracle.com> wrote:
> 
> > On Fri, 2009-05-01 at 15:13 +0200, Frederic Weisbecker wrote:
> > > On Fri, May 01, 2009 at 07:42:47AM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > 
> > > > > flush_commit_list() uses ll_rw_block() to commit the pending log blocks.
> > > > > ll_rw_block() might sleep, and the bkl was released at this point. Then
> > > > > we can also relax the write lock at this point.
> > > > > 
> > > > > [ Impact: release the reiserfs write lock when it is not needed ]
> > > > > 
> > > > > Cc: Jeff Mahoney <jeffm@suse.com>
> > > > > Cc: Chris Mason <chris.mason@oracle.com>
> > > > > Cc: Alexander Beregalov <a.beregalov@gmail.com>
> > > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > > ---
> > > > >  fs/reiserfs/journal.c |    7 +++++--
> > > > >  1 files changed, 5 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> > > > > index 373d080..b1ebd5a 100644
> > > > > --- a/fs/reiserfs/journal.c
> > > > > +++ b/fs/reiserfs/journal.c
> > > > > @@ -1120,8 +1120,11 @@ static int flush_commit_list(struct super_block *s,
> > > > >  		    SB_ONDISK_JOURNAL_SIZE(s);
> > > > >  		tbh = journal_find_get_block(s, bn);
> > > > >  		if (tbh) {
> > > > > -			if (buffer_dirty(tbh))
> > > > > -			    ll_rw_block(WRITE, 1, &tbh) ;
> > > > > +			if (buffer_dirty(tbh)) {
> > > > > +		            reiserfs_write_unlock(s);
> > > > > +			    ll_rw_block(WRITE, 1, &tbh);
> > > > > +			    reiserfs_write_lock(s);
> > > > > +			}
> > > > >  			put_bh(tbh) ;
> > > > >  		}
> > > > >  	}
> > > > 
> > > > there's 7 other instances of ll_rw_block():
> > > > 
> > > > fs/reiserfs/journal.c-			spin_unlock(lock);
> > > > fs/reiserfs/journal.c:			ll_rw_block(WRITE, 1, &bh);
> > > > fs/reiserfs/journal.c-			spin_lock(lock);
> > > > --
> > > > fs/reiserfs/journal.c-		            reiserfs_write_unlock(s);
> > > > fs/reiserfs/journal.c:			    ll_rw_block(WRITE, 1, &tbh);
> > > > fs/reiserfs/journal.c-			    reiserfs_write_lock(s);
> > > > --
> > > > fs/reiserfs/journal.c-	/* read in the log blocks, memcpy to the corresponding real block */
> > > > fs/reiserfs/journal.c:	ll_rw_block(READ, get_desc_trans_len(desc), log_blocks);
> > > > fs/reiserfs/journal.c-	for (i = 0; i < get_desc_trans_len(desc); i++) {
> > > > --
> > > > fs/reiserfs/journal.c-		set_buffer_dirty(real_blocks[i]);
> > > > fs/reiserfs/journal.c:		ll_rw_block(SWRITE, 1, real_blocks + i);
> > > > fs/reiserfs/journal.c-	}
> > > > --
> > > > fs/reiserfs/journal.c-	}
> > > > fs/reiserfs/journal.c:	ll_rw_block(READ, j, bhlist);
> > > > fs/reiserfs/journal.c-	for (i = 1; i < j; i++)
> > > > --
> > > > fs/reiserfs/stree.c-		if (!buffer_uptodate(bh[j]))
> > > > fs/reiserfs/stree.c:			ll_rw_block(READA, 1, bh + j);
> > > > fs/reiserfs/stree.c-		brelse(bh[j]);
> > > > --
> > > > fs/reiserfs/stree.c-						    reada_blocks, reada_count);
> > > > fs/reiserfs/stree.c:			ll_rw_block(READ, 1, &bh);
> > > > fs/reiserfs/stree.c-			reiserfs_write_unlock(sb);
> > > > --
> > > > fs/reiserfs/super.c-{
> > > > fs/reiserfs/super.c:	ll_rw_block(READ, 1, &(SB_BUFFER_WITH_SB(s)));
> > > > fs/reiserfs/super.c-	reiserfs_write_unlock(s);
> > > > 
> > > > in particular the second stree.c one and the super.c has a 
> > > > write-unlock straight before the lock-drop.
> > > > 
> > > > I think the stree.c unlock could be moved to before the 
> > > > ll_rw_block() call straight away.
> > > 
> > > 
> > > Indeed.
> > > 
> > > 
> > > > 
> > > > The super.c one needs more care: first put &(SB_BUFFER_WITH_SB(s)) 
> > > > into a local variable, then unlock the wite-lock, then call 
> > > > ll_rw_block(). (This is important because &(SB_BUFFER_WITH_SB(s)) is 
> > > > global filesystem state that has to be read with the lock held.)
> > > 
> > > 
> > > Indeed &(SB_BUFFER_WITH_SB(s)) is a pointer to blocks that
> > > reflect the state of the filesystem but it was already not
> > > safe on the old code.
> > > 
> > 
> > SB_BUFFER_WITH_SB isn't going to change.  It gets set once during 
> > mount and will return the same buffer from then on.
> 
> Are we holding a permanent reference to it after the first read? If 
> yes then any bread done on an uptodate bh will return immediately 
> without scheduling

Yes, it is pinned the whole time the FS is mounted.  It looks to me like
the reread_meta_blocks() function can go away.  The log replay should be
updating the same caches that the super block bh is in.

But, this isn't very performance critical stuff, it only happens in
reiserfs_fill_super().  I'd leave it.

-chris




