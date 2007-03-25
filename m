Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXCYUmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXCYUmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 16:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXCYUmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 16:42:10 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42644 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXCYUmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 16:42:09 -0400
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <1174823454.5149.13.camel@lappy> (message from Peter Zijlstra on
	Sun, 25 Mar 2007 13:50:54 +0200)
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	 <1174816995.5149.4.camel@lappy> <E1HVQe9-0007ga-00@dorka.pomaz.szeredi.hu>
	 <E1HVQzy-0007jO-00@dorka.pomaz.szeredi.hu> <1174823454.5149.13.camel@lappy>
Message-Id: <E1HVZX5-0008QB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 25 Mar 2007 22:41:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>         for (;;) {
>                 struct writeback_control wbc = {
>                         .bdi            = bdi,
>                         .sync_mode      = WB_SYNC_NONE,
>                         .older_than_this = NULL,
>                         .nr_to_write    = write_chunk,
>                         .range_cyclic   = 1,
>                 };
> 
>                 get_dirty_limits(&background_thresh, &dirty_thresh,
>                                 &bdi_thresh, bdi);
>                 bdi_nr_reclaimable = bdi_stat(bdi, BDI_DIRTY) +
>                                         bdi_stat(bdi, BDI_UNSTABLE);
> (A)             if (bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) <=
>                         bdi_thresh)
>                                 break;
> 
>                 /* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
>                  * Unstable writes are a feature of certain networked
>                  * filesystems (i.e. NFS) in which data may have been
>                  * written to the server's write cache, but has not yet
>                  * been flushed to permanent storage.
>                  */
> (B)              if (bdi_nr_reclaimable) {
>                         writeback_inodes(&wbc);
> 
>                         get_dirty_limits(&background_thresh, &dirty_thresh,
>                                        &bdi_thresh, bdi);
>                         bdi_nr_reclaimable = bdi_stat(bdi, BDI_DIRTY) +
>                                                 bdi_stat(bdi, BDI_UNSTABLE);
> (C)                     if (bdi_nr_reclaimable + bdi_stat(bdi, BDI_WRITEBACK) <=
>                                 bdi_thresh)
>                                 break;
> 
>                         pages_written += write_chunk - wbc.nr_to_write;
>                         if (pages_written >= write_chunk)
>                                 break;          /* We've done our duty */
>                 }
>                 congestion_wait(WRITE, HZ/10);
>         }
> 
> I'm thinking that if bdi_nr_reclaimable == 0, A reduces to
> bdi_stat(bdi, BDI_WRITEBACK) <= bdi_thresh and we're still out of the
> loop, no?
> 

Yep, sorry.

I'll review this patch, there seem to be odd things, like calculating
dirty_thresh, then not ever using it...

Btw, would you mind measuring the performance of my patch with the
slow/fast device mix, to see how it compares to your patchset and the
vanila kernel?

Thanks,
Miklos
