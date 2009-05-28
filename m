Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZE1N6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZE1N6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbZE1N6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:58:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZE1N6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:58:01 -0400
Date: Thu, 28 May 2009 15:58:00 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 07/11] writeback: support > 1 flusher thread per bdi
Message-ID: <20090528135800.GN29199@duck.suse.cz>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <1243417312-7444-8-git-send-email-jens.axboe@oracle.com> <20090528092743.GD29199@duck.suse.cz> <20090528104022.GZ11363@kernel.dk> <20090528124339.GJ29199@duck.suse.cz> <20090528125308.GA11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528125308.GA11363@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28-05-09 14:53:08, Jens Axboe wrote:
> On Thu, May 28 2009, Jan Kara wrote:
> > > >   Looking into this, it seems a bit complex with all that on_stack, sync /
> > > > nosync thing. Wouldn't a simple refcounting scheme be more clear? Alloc /
> > > > init_work_on_stack gets a reference from bdi_work, queue_work gets another
> > > > reference passed later to flusher thread. We drop the reference when we
> > > > leave bdi_start_writeback() and when flusher thread is done with the work.
> > > > When refcount hits zero, work struct is freed (when work is on stack, we
> > > > just never drop the last reference)...
> > > 
> > > It wouldn't change the complexity of the stack vs non-stack at all,
> > > since you have to do the same checks for when it's safe to proceed. And
> > > having the single bit there with the hash bit wait queues makes that bit
> > > easier.
> >   I think it would be simpler. Look:
> > static void bdi_work_free(struct rcu_head *head)
> > {
> > 	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
> > 
> > 	kfree(work);
> > }
> > 
> > static void bdi_put_work(struct bdi_work *work)
> > {
> > 	if (!atomic_dec_and_test(&work->count, 1))
> > 		call_rcu(&work->rcu_head, bdi_work_free);
> > }
> > 
> > static void wb_work_complete(struct bdi_work *work)
> > {
> > 	bdi_work_clear(work);
> > 	bdi_put_work(work);
> > }
> > 
> > void bdi_start_writeback(...)
> > {
> > 	...
> > 	if (must_wait || work == &work_stack)
> > 		bdi_wait_on_work_clear(work);
> > 	if (work != &work_stack)
> > 		bdi_put_work(work);
> > }
> > 
> >   IMO much easier to read...
> 
> And doesn't work, since you cannot exit after clearing the on-stack work
> before before rcu is quisced. The bdi_work could be browseable by other
> threads under rcu_read_lock(), just like you defer the kfree(), you have
> to defer the bdi_work_clear() for on-stack work.
  Right. My fault. Sorry for the noise.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
