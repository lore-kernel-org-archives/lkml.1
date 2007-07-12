Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbXGLGu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbXGLGu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXGLGuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:50:16 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20989 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbXGLGuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:50:14 -0400
Date: Thu, 12 Jul 2007 08:50:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Kirill Korotaev <dev@openvz.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: Lost JBD fix
Message-ID: <20070712065009.GM4587@kernel.dk>
References: <20070709181443.GF30433@duck.suse.cz> <46951992.8040700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46951992.8040700@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11 2007, Chuck Ebbert wrote:
> On 07/09/2007 02:14 PM, Jan Kara wrote:
> >   Hi Andrew,
> > 
> >   it seems we've accidentally lost one JBD fix (probably it was my mistake
> > when rediffing some checkpointing changes) as Kirill has noted. A transaction
> > can currently be released when there are still some buffers on one of its
> > checkpointing lists. Attached patch should fix it (it still seems to apply
> > fine). Please apply it. Thanks.
> > 
> > 								Honza
> > 
> > 
> > ------------------------------------------------------------------------
> > 
> > We have to check that also the second checkpoint list is non-empty before
> > dropping the transaction.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > diff -rupX /home/jack/.kerndiffexclude linux-2.6.16-rc1/fs/jbd/commit.c linux-2.6.16-rc1-1-checkpoint-fix/fs/jbd/commit.c
> > --- linux-2.6.16-rc1/fs/jbd/commit.c	2006-01-15 00:20:12.000000000 +0100
> > +++ linux-2.6.16-rc1-1-checkpoint-fix/fs/jbd/commit.c	2006-01-17 23:35:19.000000000 +0100
> > @@ -829,7 +829,8 @@ restart_loop:
> >  	journal->j_committing_transaction = NULL;
> >  	spin_unlock(&journal->j_state_lock);
> >  
> > -	if (commit_transaction->t_checkpoint_list == NULL) {
> > +	if (commit_transaction->t_checkpoint_list == NULL &&
> > +	    commit_transaction->t_checkpoint_io_list == NULL) {
> >  		__journal_drop_transaction(journal, commit_transaction);
> >  	} else {
> >  		if (journal->j_checkpoint_transactions == NULL) {
> 
> Critical bugfix -- 2.6.22-stable (no earlier versions) should get
> this too, right?

And don't forget that we have a jbd2/ clone as well, for the hugely
succesful ext4 project as well.

-- 
Jens Axboe

