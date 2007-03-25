Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXCYLv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXCYLv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXCYLv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:51:28 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:35723 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXCYLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:51:28 -0400
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, dgc@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <E1HVQzy-0007jO-00@dorka.pomaz.szeredi.hu>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	 <1174816995.5149.4.camel@lappy> <E1HVQe9-0007ga-00@dorka.pomaz.szeredi.hu>
	 <E1HVQzy-0007jO-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 13:50:54 +0200
Message-Id: <1174823454.5149.13.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 13:34 +0200, Miklos Szeredi wrote:
> > > 
> > > Please have a look at this:
> > >   http://lkml.org/lkml/2007/3/19/220
> > 
> > 
> > 
> > > +			if (bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) <=
> > > +			     	bdi_thresh)
> > > +				break;
> > > 
> > 
> > Yes, this will resolve the deadlock as well, where balance_dirty_pages()
> > is currently looping forever with:
> 
> Almost.
> 
> This
> 
> > -		if (nr_reclaimable) {
> > +		if (bdi_nr_reclaimable) {
> >  			writeback_inodes(&wbc);
> 
> still makes it loop forever if bdi_nr_reclaimable == 0, since the exit
> condition is not checked. 
> 
> Shouldn't it break out of the loop if bdi_stat(bdi, BDI_WRITEBACK) <=
> bdi_thresh in this case?

        for (;;) {
                struct writeback_control wbc = {
                        .bdi            = bdi,
                        .sync_mode      = WB_SYNC_NONE,
                        .older_than_this = NULL,
                        .nr_to_write    = write_chunk,
                        .range_cyclic   = 1,
                };

                get_dirty_limits(&background_thresh, &dirty_thresh,
                                &bdi_thresh, bdi);
                bdi_nr_reclaimable = bdi_stat(bdi, BDI_DIRTY) +
                                        bdi_stat(bdi, BDI_UNSTABLE);
(A)             if (bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) <=
                        bdi_thresh)
                                break;

                /* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
                 * Unstable writes are a feature of certain networked
                 * filesystems (i.e. NFS) in which data may have been
                 * written to the server's write cache, but has not yet
                 * been flushed to permanent storage.
                 */
(B)              if (bdi_nr_reclaimable) {
                        writeback_inodes(&wbc);

                        get_dirty_limits(&background_thresh, &dirty_thresh,
                                       &bdi_thresh, bdi);
                        bdi_nr_reclaimable = bdi_stat(bdi, BDI_DIRTY) +
                                                bdi_stat(bdi, BDI_UNSTABLE);
(C)                     if (bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) <=
                                bdi_thresh)
                                break;

                        pages_written += write_chunk - wbc.nr_to_write;
                        if (pages_written >= write_chunk)
                                break;          /* We've done our duty */
                }
                congestion_wait(WRITE, HZ/10);
        }

I'm thinking that if bdi_nr_reclaimable == 0, A reduces to
bdi_stat(bdi, BDI_WRITEBACK) <= bdi_thresh and we're still out of the
loop, no?

