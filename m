Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZHXMgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZHXMgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 08:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZHXMgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 08:36:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:51683 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZHXMgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:36:12 -0400
Date: Mon, 24 Aug 2009 14:36:11 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 5/9] writeback: support > 1 flusher thread per bdi
Message-ID: <20090824123611.GE10080@duck.novell.com>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-6-git-send-email-jens.axboe@oracle.com> <20090805195504.GD27505@duck.suse.cz> <20090806070546.GH12579@kernel.dk> <20090806205621.GB8177@duck.suse.cz> <20090824114326.GK12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824114326.GK12579@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 24-08-09 13:43:26, Jens Axboe wrote:
> On Thu, Aug 06 2009, Jan Kara wrote:
> >   Actually, looking again that the work struct "state" field has lots of
> > free bits. I think the code looks nicer with the attached patch, what do
> > you think?
> > 
> > > >   2) I'd introduce a flag with the meaning: free the work when you are
> > > > done. Obviusly this flag makes sence only with dynamically allocated work
> > > > structure. There would be no "on stack" flag.
> > > >   3) I'd create a function:
> > > > bdi_wait_work_submitted()
> > > >   which you'd have to call whenever you didn't set the flag and want to
> > > > free the work (either explicitely, or via returning from a function which
> > > > has the structure on stack).
> > > >   It would do:
> > > > bdi_wait_on_work_clear(work);
> > > > call_rcu(&work->rcu_head, bdi_work_free);
> > > > 
> > > >   wb_work_complete() would just depending on the flag setting either
> > > > completely do away with the work struct or just do bdi_work_clear().
> > > > 
> > > >   IMO that would make the code easier to check and also less prone to
> > > > errors (currently you have to think twice when you have to wait for the rcu
> > > > period, call bdi_work_free, etc.).
> > > 
> > > Didn't we go over all that last time, too?
> >   Well, probably about something similar. But this time I have a patch ;-)
> > Compile tested only... IMO it looks nicer this way as it wraps up all the
> > details of work freeing into one function.
> 
> The first patch looks nice and obvious, I'll fold that in with the
> original patch if you don't mind. It's definitely cleaner, instead of
> overloading the pointer.
  Yes, that's fine.

> The second one I'd rather hold off on, I've run over the existing code
> many times and tested it heavily threaded and know it's safe. So I'd
> rather not introduce any drastic changes there so close to 2.6.32, but
> I'd be happy to revisit this soon after merge. OK?
  Fine with me, I'm just not sure about the merging in 2.6.32 - the
umount_sem and sb->s_count problems (http://lkml.org/lkml/2009/8/5/322 -
BTW I didn't see a response from you) should get sorted out before the
merge. To be honest, I'm not much in favor of merging your patches before
having resolved that and I think Christoph Hellwig or Al Viro will express
their opinion even more strongly ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
