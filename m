Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYCYDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYCYDmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYCYDmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 23:42:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbYCYDmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 23:42:05 -0400
From: Neil Brown <neilb@suse.de>
To: "John Z." <md2sf@mail.com>
Date: Tue, 25 Mar 2008 14:41:54 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18408.29826.857813.735627@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: FW: [PATCH 008 of 9] md: Fix possible raid1/raid10 deadlock on
 read error during resync.
In-Reply-To: message from John Z. on Monday March 24
References: <20080324184903.D9213103C6@ws1-3.us4.outblaze.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday March 24, md2sf@mail.com wrote:
> 
> > 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of NeilBrown
> > Sent: Sunday, March 02, 2008 5:18 PM
> > To: Andrew Morton
> > Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org; K.Tanaka
> > Subject: [PATCH 008 of 9] md: Fix possible raid1/raid10 deadlock on read
> > error during resync.
> > 
> 
> > diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
> > --- .prev/drivers/md/raid1.c	2008-03-03 11:03:39.000000000 +1100
> > +++ ./drivers/md/raid1.c	2008-03-03 09:56:52.000000000 +1100
> > @@ -704,13 +704,20 @@ static void freeze_array(conf_t *conf)
> >   	/* stop syncio and normal IO and wait for everything to
> >   	 * go quite.
> >   	 * We increment barrier and nr_waiting, and then
> > -	 * wait until barrier+nr_pending match nr_queued+2
> > +	 * wait until nr_pending match nr_queued+1
> > +	 * This is called in the context of one normal IO request
> > +	 * that has failed. Thus any sync request that might be pending
> > +	 * will be blocked by nr_pending, and we need to wait for
> > +	 * pending IO requests to complete or be queued for re-try.
> > +	 * Thus the number queued (nr_queued) plus this request (1)
> > +	 * must match the number of pending IOs (nr_pending) before
> > +	 * we continue.
> >   	 */
> >   	spin_lock_irq(&conf->resync_lock);
> >   	conf->barrier++;
> >   	conf->nr_waiting++;
> >   	wait_event_lock_irq(conf->wait_barrier,
> > -			    conf->barrier+conf->nr_pending ==
> > conf->nr_queued+2,
> > +			    conf->nr_pending == conf->nr_queued+1,
> >   			    conf->resync_lock,
> >   			    ({ flush_pending_writes(conf);
> >   			       raid1_unplug(conf->mddev->queue); }));
> > --
> 
> When we call freeze_array, it is after reschedule_retry, during which conf->nr_queued is already incremented.
> Should we use conf->nr_pending == conf->nr_pending here?
> 

Can I assume you mean
          conf->nr_pending == conf->nr_queued
??

Yes, it is after reschedule_retry which increments ->nr_queued, but
also after
       conf->nr_queued--;
in raid1d when the request is removed from the queue.

Does that make sense?

NeilBrown
