Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZEBR3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZEBR3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZEBR3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:29:35 -0400
Received: from [212.69.161.110] ([212.69.161.110]:34022 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZEBR3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:29:34 -0400
Date: Sat, 2 May 2009 19:28:38 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 04/16] DRBD: bitmap
Message-ID: <20090502172838.GC6466@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com> <1241278918.3639.46.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241278918.3639.46.camel@mulgrave.int.hansenpartnership.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 10:41:58AM -0500, James Bottomley wrote:
> On Thu, 2009-04-30 at 13:26 +0200, Philipp Reisner wrote:
> > DRBD maintains a dirty bitmap in case it has to run without peer node or
> > without local disk. Writes to the on disk dirty bitmap are minimized by the
> > activity log (=AL). Each time an extent is evicted from the AL the part of
> > the bitmap no longer covered by the AL is written to disk.
> > 
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> The way the bitmap and activity log work are very similar to the way the
> md bitmap works (and are implemented for almost exactly the same
> reason).  Is there any way we could combine them?

in principle yes.
the DRBD bitmap has a granularity of 4 kB per bit,
and the "activity log" covers 4 MB per what we call "al extent".

though there is a very important difference.

in MD, when the bitmap is in use, I think the approach is:

  for each write queued to the lower level devices,
     dirty bits in memory
     for every newly dirtied bitmap page,
	flush bitmap pages to disk
	wait for these bitmap writes to complete
  then unplug the lowe level devices

  in background: periodically try to clean some pages,
	and write them to disk

the DRBD approach is:
  if target "al extent" of this write request
  is NOT in the in-memory "lru_cache" already,
	get it into the cache,
		if that means we have to kick an
		old element from the cache, and
		the associated bitmap is dirty
			write that part of the bitmap
        write an "al transaction" (synchonous single sector write)
  else
  	FAST PATH, no additional "meta data" write needed.
  
  submit to lower level device.


MD most of the time just _needs_ the additional "meta data" writes.
DRBD most of the time does not (unless you have completely random
writes, always requesting an extent not yet/anymore in the activity log.

I'm in the process of generalizing DRBDs approach to allow more than one
"al extent" to change during a "prepare" step, and cover several such changes
in one "al transaction", so the number of meta data updates can be
reduced even further.

adopting this "activity log" approach would make MD even better, IMO.

Thanks,

	Lars
