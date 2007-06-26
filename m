Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXFZQR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXFZQR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbXFZQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:17:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:52779 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbXFZQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JtVMLF3G+9F5O59bUUDpfQbhRi4MXFBPNiXxc83UxNqCDpOQWS5TPPlFTLC+TS0Nr9oDIPsMh6R4hzXqTBEkKOFGDHZiDfL/CqBMIRXEAh4lJoW/DamcLW73FljQcCG4u/P8heCWrNNNXN2QEeM+/y/SmdlpoF192XwPFW5qfoo=
Message-ID: <170fa0d20706260917r77286a54h265119bfaa5d1f45@mail.gmail.com>
Date: Tue, 26 Jun 2007 12:17:17 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul Clements" <paul.clements@steeleye.com>
Subject: Outstanding NBD requests bug? (Was: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues)
Cc: "Rogier Wolff" <R.E.Wolff@bitwizard.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Florin Iucha" <florin@iucha.net>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       "Adrian Bunk" <bunk@stusta.de>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Paul,

The original message (below) didn't get any response.

Could you elaborate on the impact of this NBD issue?  Based on your
description, having requests just sit on the queue would _seem_ to be
quite serious.  Is this purely a bookkeeping issue or is there a more
subtle side-effect of this inaccurate request count?

You stated that your patch fixes this issue "not in the proper way".
If a fix is trully needed what is the proper way?

please advise, thanks.
Mike

On 4/29/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sun, 2007-04-29 at 21:41 +0200, Rogier Wolff wrote:
> > On Tue, Apr 17, 2007 at 10:37:38PM -0700, Andrew Morton wrote:
> > > Florin, can we please see /proc/meminfo as well?
> > >
> > > Also the result of `echo m > /proc/sysrq-trigger'
> >
> > Hi,
> >
> > It's been a while since this thread died out, but maybe I'm
> > having the same problem. Networking, large part of memory is
> > buffering writes.....
> >
> > In my case I'm using NBD.
> >
> > Oh,
> >
> > /sys/block/nbd0/stat gives:
> >      636       88     5353     1700      991    19554   162272    63156       43  1452000 61802352
> > I put some debugging stuff in nbd, and it DOES NOT KNOW about the
> > 43 requests that the io scheduler claims are in flight at the
> > driver....
>
> AFAIK nbd is a tad broken; the following patch used to fix it, although
> not in the proper way. Hence it never got merged.
>
> There is a race where the plug state of the device queue gets confused,
> which causes requests to just sit on the queue, without further action.
>
> ---
>
> Subject: nbd: request_fn fixup
>
> Dropping the queue_lock opens up a nasty race, fix this race by
> plugging the device when we're done.
>
> Also includes a small cleanup.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Daniel Phillips <phillips@google.com>
> CC: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/block/nbd.c |   67 ++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 49 insertions(+), 18 deletions(-)
>
> Index: linux-2.6/drivers/block/nbd.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/nbd.c  2006-09-07 17:20:52.000000000 +0200
> +++ linux-2.6/drivers/block/nbd.c       2006-09-07 17:35:05.000000000 +0200
> @@ -97,20 +97,24 @@ static const char *nbdcmd_to_ascii(int c
>  }
>  #endif /* NDEBUG */
>
> -static void nbd_end_request(struct request *req)
> +static void __nbd_end_request(struct request *req)
>  {
>         int uptodate = (req->errors == 0) ? 1 : 0;
> -       request_queue_t *q = req->q;
> -       unsigned long flags;
>
>         dprintk(DBG_BLKDEV, "%s: request %p: %s\n", req->rq_disk->disk_name,
>                         req, uptodate? "done": "failed");
>
> -       spin_lock_irqsave(q->queue_lock, flags);
> -       if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
> +       if (!end_that_request_first(req, uptodate, req->nr_sectors))
>                 end_that_request_last(req, uptodate);
> -       }
> -       spin_unlock_irqrestore(q->queue_lock, flags);
> +}
> +
> +static void nbd_end_request(struct request *req)
> +{
> +       request_queue_t *q = req->q;
> +
> +       spin_lock_irq(q->queue_lock);
> +       __nbd_end_request(req);
> +       spin_unlock_irq(q->queue_lock);
>  }
>
>  /*
> @@ -435,10 +439,8 @@ static void do_nbd_request(request_queue
>                         mutex_unlock(&lo->tx_lock);
>                         printk(KERN_ERR "%s: Attempted send on closed socket\n",
>                                lo->disk->disk_name);
> -                       req->errors++;
> -                       nbd_end_request(req);
>                         spin_lock_irq(q->queue_lock);
> -                       continue;
> +                       goto error_out;
>                 }
>
>                 lo->active_req = req;
> @@ -463,10 +465,13 @@ static void do_nbd_request(request_queue
>
>  error_out:
>                 req->errors++;
> -               spin_unlock(q->queue_lock);
> -               nbd_end_request(req);
> -               spin_lock(q->queue_lock);
> +               __nbd_end_request(req);
>         }
> +       /*
> +        * q->queue_lock has been dropped, this opens up a race
> +        * plug the device to close it.
> +        */
> +       blk_plug_device(q);
>         return;
>  }
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
