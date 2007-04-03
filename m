Return-Path: <linux-kernel-owner+w=401wt.eu-S965964AbXDCOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965964AbXDCOdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965965AbXDCOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:33:17 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36734 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965964AbXDCOdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:33:16 -0400
Date: Tue, 3 Apr 2007 17:33:14 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Rene Herman <rene.herman@gmail.com>
cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
In-Reply-To: <461256C1.4020906@gmail.com>
Message-ID: <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
 <4610481D.8000102@gmail.com> <46104954.50608@gmail.com>
 <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
 <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI>
 <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI>
 <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI>
 <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI> <461256C1.4020906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2007 08:57 AM, Pekka J Enberg wrote:
> > Does this change the dd case?
> > 
> > diff --git a/drivers/cdrom/mcdx.c b/drivers/cdrom/mcdx.c
> > index f574962..6c613d0 100644
> > --- a/drivers/cdrom/mcdx.c
> > +++ b/drivers/cdrom/mcdx.c
> > @@ -1248,6 +1248,7 @@ #endif
> >   disk->private_data = stuffp;
> >   disk->queue = mcdx_queue;
> >   add_disk(disk);
> > +	blk_queue_hardsect_size(mcdx_queue, MCDX_CDBLK);
> >   printk(msg);
> >   return 0;
> >  }

On Tue, 3 Apr 2007, Rene Herman wrote:
> No, I'm afraid not. It's still the same effect:
> 
> root@5va2:~# dmesg -c >/dev/null
> root@5va2:~# strace -o dd.strace dd if=/dev/mcdx0 of=/dev/null
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00438956 seconds, 0.0 kB/s
> root@5va2:~# dmesg >dd.xtrace

Looking at the dd strace:

> close(0)                                = 0
> open("/dev/mcdx0", O_RDONLY|O_LARGEFILE) = 0
> _llseek(0, 0, [0], SEEK_CUR)            = 0

The block device is open, dd has the current offset.

> close(1)                                = 0
> open("/dev/null", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 1

[snip]

> read(0, "", 512)                        = 0

We start to read but get nothing!

> close(0)                                = 0
> close(1)                                = 0

Now looking at the driver debug trace:

> mcdx open() Single Session disk found
> mcdx mcdx_media_changed called for device mcdx0
> mcdx:: talk() 1 / 5000 tries, res.size 1, command 0x40<7>mcdx:: 

We do mcdx_getstatus() here...

> mcdx:: talk() command sent
> mcdx:: *** delay: sleepq
> mcdx:: delay awoken
> mcdx:: *** delay: sleepq
> mcdx:: delay awoken
> mcdx:: talk() got status 0x50
> mcdx:: talk() done with 0x50

...and the status bits seem to be MCDX_RBIT_CHECK and MCDX_RBIT_CHECK.

> mcdx:: close()

However, we never hit do_mcdx_request(). Jens, do we need to do 
set_capacity() somewhere? I don't see other cdrom drivers doing it but 
they could be broken too...

				Pekka
