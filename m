Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZD1SXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZD1SXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZD1SWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:22:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45152 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZD1SWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:22:49 -0400
Date: Tue, 28 Apr 2009 20:22:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mmx@riz.pl, rientjes@google.com, cl@linux.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       rjw@sisk.pl, akpm@linux-foundation.org
Subject: Re: [Bug #13112] Oops in drain_array
Message-ID: <20090428182248.GL4593@kernel.dk>
References: <alpine.DEB.2.00.0904271327140.11650@chino.kir.corp.google.com> <20090428171139N.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.64.0904281425040.2455@galaxy.riz.pl> <20090428234512P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428234512P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28 2009, FUJITA Tomonori wrote:
> On Tue, 28 Apr 2009 14:43:37 +0200 (CEST)
> Bart <mmx@riz.pl> wrote:
> 
> > > On Mon, 27 Apr 2009 13:36:46 -0700 (PDT)
> > > David Rientjes <rientjes@google.com> wrote:
> > >
> > >> On Mon, 27 Apr 2009, Bart wrote:
> > >>
> > >>> After turning the suggested debuging options I've got tons of these when
> > >>> trying to stress the tape device like before:
> > >>>
> > >>> Apr 27 16:57:30 fs kernel: [   96.446708] slab error in verify_redzone_free():
> > >>> cache `size-128': memory outside object was overwritten
> > >>> Apr 27 16:57:30 fs kernel: [   96.446713] Pid: 0, comm: swapper Not tainted
> > >>> 2.6.29.1-64 #2
> > >>> Apr 27 16:57:30 fs kernel: [   96.446715] Call Trace:
> > >>> Apr 27 16:57:30 fs kernel: [   96.446717]  <IRQ>  [<ffffffff8029adc5>]
> > >>> __slab_error+0x1f/0x25
> > >>> Apr 27 16:57:30 fs kernel: [   96.446728]  [<ffffffff8029b24b>]
> > >>> cache_free_debugcheck+0x108/0x1d6
> > >>> Apr 27 16:57:30 fs kernel: [   96.446731]  [<ffffffff8029b473>]
> > >>> kfree+0x81/0xc2
> > >>> Apr 27 16:57:30 fs kernel: [   96.446735]  [<ffffffff802bd311>]
> > >>> bio_free_map_data+0xc/0x1e
> > >>
> > >> This appears to be kfree(bmd->iovecs) in bio_free_map_data().  It looks
> > >> like the memcpy size in bio_set_map_data() overrides the kmalloc size; in
> > >> other words, for a redzone error, bio->bi_vcnt > nr_pages in
> > >> bio_copy_user_iov().
> > >
> > > Can you try this?
> > >
> > > diff --git a/fs/bio.c b/fs/bio.c
> > > index 7bbc98f..6a09356 100644
> > > --- a/fs/bio.c
> > > +++ b/fs/bio.c
> > > @@ -817,6 +817,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
> > > 		len += iov[i].iov_len;
> > > 	}
> > >
> > > +	if (offset)
> > > +		nr_pages += 1;
> > > +
> > > 	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
> > > 	if (!bmd)
> > > 		return ERR_PTR(-ENOMEM);
> > >
> > 
> > There are no more errors in the dmesg after applying this patch to 
> > 2.6.29.2.
> > 
> > Without this patch I can reproduce this kind of errors on 
> > 2.6.29.1, 2.6.29.2.
> > 
> > I've not tested this patch with 2.6.29.1 and 2.6.30rc3-git3.
> > I will try to reproduce the error on 2.6.30rc3-git3 as soon as I compile 
> > it.
> 
> Thanks for testing! And very sorry about the bug.
> 
> I'm sure that you hit the same bug with 2.6.30-rc3-git.
> 
> Jens, can you please apply this against 2.6.30-rc (and we need this
> for 2.6.29.x too)?
> 
> I know that bio_copy_user_iov() is hacky. I'll try to clean up the
> mapping API later.

I'll apply it for 2.6.30-rc and CC stable. bio_copy_user_iov() is indeed
not pretty, both the API and the implementation needs looking at...

-- 
Jens Axboe

