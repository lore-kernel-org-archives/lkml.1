Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZEMJCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZEMJCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZEMJCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:02:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52885 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZEMJB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:01:59 -0400
To: jens.axboe@oracle.com
CC: akpm@linux-foundation.org, miklos@szeredi.hu, max@duempel.org,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20090513063707.GC4140@kernel.dk> (message from Jens Axboe on
	Wed, 13 May 2009 08:37:07 +0200)
Subject: Re: [patch 2/3] splice: implement default splice_read method
References: <20090507133734.450612199@szeredi.hu> <20090507133748.161689790@szeredi.hu> <20090512223500.d7ef4648.akpm@linux-foundation.org> <20090513063707.GC4140@kernel.dk>
Message-Id: <E1M4ALP-0005za-1i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 13 May 2009 11:01:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, Jens Axboe wrote:
> On Tue, May 12 2009, Andrew Morton wrote:
> > On Thu, 07 May 2009 15:37:36 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > +	for (i = 0; i < spd.nr_pages; i++) {
> > > +		kunmap(pages[i]);
> > 
> > It is deadlockable if any thread of control holds more than a single
> > kmap at a time.
> > 
> > Because there are a finite number of kmaps available, and if one is
> > unavailable, kmap() waits for one to become free.  If the number of
> > waiting threads equals the number of available slots, nobody makes any
> > progress.

Ouch.

> 
> Good catch, that will not work reliably. I've applied the below.

Thanks.

The bigger problem is that the default_file_splice_write()
implementation in the other patch does the same (it calls
buf->ops->map() on all buffers).

Hmm.  Simple solution would be to do a write() for each buffer.  But
this only affects HIGHMEM kernels, so it's a bit pointless to do that
on all archs.  Sigh...

Miklos
