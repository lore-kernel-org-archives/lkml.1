Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbZENR3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbZENR3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZENR3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:29:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51537 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZENR3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:29:34 -0400
Date: Thu, 14 May 2009 19:29:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, max@duempel.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] splice: implement default splice_read method
Message-ID: <20090514172935.GR4140@kernel.dk>
References: <20090507133734.450612199@szeredi.hu> <20090507133748.161689790@szeredi.hu> <20090512223500.d7ef4648.akpm@linux-foundation.org> <20090513063707.GC4140@kernel.dk> <E1M4ALP-0005za-1i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M4ALP-0005za-1i@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13 2009, Miklos Szeredi wrote:
> On Wed, 13 May 2009, Jens Axboe wrote:
> > On Tue, May 12 2009, Andrew Morton wrote:
> > > On Thu, 07 May 2009 15:37:36 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > 
> > > > +	for (i = 0; i < spd.nr_pages; i++) {
> > > > +		kunmap(pages[i]);
> > > 
> > > It is deadlockable if any thread of control holds more than a single
> > > kmap at a time.
> > > 
> > > Because there are a finite number of kmaps available, and if one is
> > > unavailable, kmap() waits for one to become free.  If the number of
> > > waiting threads equals the number of available slots, nobody makes any
> > > progress.
> 
> Ouch.
> 
> > 
> > Good catch, that will not work reliably. I've applied the below.
> 
> Thanks.
> 
> The bigger problem is that the default_file_splice_write()
> implementation in the other patch does the same (it calls
> buf->ops->map() on all buffers).

Yep that's even worse, as that should go BUG() pretty much immediately
when the KM_USER0 slot is reused!

> Hmm.  Simple solution would be to do a write() for each buffer.  But
> this only affects HIGHMEM kernels, so it's a bit pointless to do that
> on all archs.  Sigh...

It is unfortunate, we are going to be stuck with that for some time
still...

-- 
Jens Axboe

