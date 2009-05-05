Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZEEOJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZEEOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZEEOJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:09:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52259 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbZEEOJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:09:47 -0400
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: david@lang.hm, Willy Tarreau <w@1wt.eu>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
In-Reply-To: <200905051021.33461.philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <200905041028.13865.philipp.reisner@linbit.com>
	 <1241457851.3315.41.camel@mulgrave.int.hansenpartnership.com>
	 <200905051021.33461.philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 14:09:45 +0000
Message-Id: <1241532585.3312.13.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 10:21 +0200, Philipp Reisner wrote:
> > > When you do asynchronous replication, how do you ensure that implicit
> > > write-after-write dependencies in the stream of writes you get from
> > > the file system above, are not violated on the secondary ?
> >
> > Are you telling me drbd doesn't currently do this?
> >
> 
> No I am not. DRBD does exactly this!
> But I am wondering how that is achieved in the MD/NBD stack when running 
> in async mode.

The explanation is below.

> The issue is covered since the early days in DRBD, (back in 2000).
> The issue, and the solution we have in DRBD is described in this paper:
> 
> http://www.drbd.org/fileadmin/drbd/publications/drbd_paper_for_NLUUG_2001.pdf
> 
> > The way nbd does it (in the updated tools is to use DIRECT_IO and
> > fsync).
> 
> Is that available in the existing tools ? -- Are the updated tools
> something that will be available in the future ?

It's in the existing.

> Are you telling me md/ndb (async) doesn't currently do this ?

I just described how it doe this ... I don't quite see how that
translates into telling you it doesn't do this.

> > > There might be a disk scheduler on the secondary.
> >
> > There usually is a disk scheduler ... you just have to take the required
> > action to persuade it to preserve ordering ... a simplistic way of doing
> > this is to switch to the noop scheduler.
> 
> The issue actually goes further down the stack. Not only the in kernel
> disk scheduler might reorder something, also the driver and finally the
> drive might do so.
> 
> What we have in DRBD boils down to:
> 
> * We obey all possible write after write dependencies in the stream of
>   writes we get from the upper layers. And generate DRBD internal
>   reorder barriers for the packet stream.
> * On the secondary node we impose these barriers onto the stream of writes
>   submitted to the stack below us by either:
> 
>    - Let previously submitted write-IO drain before we submit write-IO after
>      such an DRBD barrier. (That we have since 2000 or so)
> 
>    - Additionally issue a blkdev_issue_flush()
> 
>    - Use write requests with BIO_RW_BARRIER. This method has two advantages:
>      We can continue to submit writes after the DRBD internal barrier
>      immediately, and the number of requests with BIO_RW_BARRIER can be
>      further reduced. 
>      See section 6 of
>      http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf
>      for more details, and nice illustrations.

THere's a slight error in there ... we don't use ordered tags for
barriers (yet).  I don't think it will really matter because the main
domain of ordering problems is the scheduler, which REQ_BARRIER does
cope with, it just means the queue drains for a barrier.

>      Unfortunately only high end SAN devices seem to benefit from this
>      method. For most in-machine-disk controlers this method does not
>      achieve the highest throughput.
> 
> Expressed in other words: 
> We allow reordering on the secondary node to an extend so that we can
> guarantee that no implicit write-after-write dependencies are violated.
> 
> Coming back to the idea of disabling the in Linux IO scheduler. It might
> solve the issue for some devices, but it does not guarantee to solve it.

I think you'll find the dio/fsync method above actually does solve all
of these issues (mainly because it enforces the semantics from top to
bottom in the stack).  I agree one could use more elaborate semantics
like you do for drbd, but since the simple ones worked efficiently for
md/nbd, there didn't seem to be much point.

James


