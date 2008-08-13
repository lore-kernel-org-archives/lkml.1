Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYHMHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYHMHGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYHMHGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:06:06 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59486 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYHMHGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:06:05 -0400
Subject: Re: request->ioprio
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?iso-2022-jp?Q?=1B=24B5H=40n=1B=28B_=1B=24BBs=3AH=1B=28B?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
In-Reply-To: <200808070633.06112.rusty@rustcorp.com.au>
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <200808070633.06112.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 13 Aug 2008 16:06:03 +0900
Message-Id: <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 06:33 +1000, Rusty Russell wrote: 
> > Trying to implement i/o tracking all the way up to the page cache (so
> > that cfq and the future cgroup-based I/O controllers can schedule
> > buffered I/O properly) I noticed that struct request's ioprio is
> > initialized but never used for I/O scheduling purposes. Indeed there
> > seems to be one single user of this member: virtio_blk.
> 
> Hey, do I win a prize? :)
I think you should! :)

> > Virtio uses 
> > struct request's ioprio in the request() function of the virtio block
> > driver, which just copies the ioprio value to the output header of
> > virtblk_req.
> 
> Yes, we pass it through to the host, in the assumption they might want to use 
> it to schedule our I/Os relative to each other.
The reason I asked is that the the value of struct request's ioprio is
never user which means it does not contain useful information.
Schedulers such as CFQ that try to keep track of the io context of io
requests (including ioprio) use struct request's elevator_private for
that. For example, CFQ embeds the cfq_io_context there, which in turn
contains struct io_context where the request's ioprio is actually
stored. In other words, we have two ioprios per request: one which is a
member of struct request and another is accessible through struct
request's elavator_private. Unfortunately only the latter is used, which
means that virtio_blk is not passing useful information to the backend
driver.

> I'm a little surprised noone else uses it, but I'm sure they will...
> Rusty.
I am not that sure unless we clean things up. Currently bios do not hold
io context information which is the reason why struct request's ioprio
does not contain useful information. To solve this issue it is necessary
to track IO all the way up to the pagecache layer, which is precisely
what the IO tracking project that has just started is attempting to
achieve.

Besides, I guess that accessing the io context information (such as
ioprio) of a request through elevator-specific private structures is not
something we want virtio_blk (or future users) to do. I think that we
could replace struct request's ioprio with a pointer to io_context so
that IO context information could be accessed in a consistent
elevator-agnostic way. Another possible approach could be to keep
struct request's ioprio synchronized with the IO context information in
the private structures. We could even extend the elevator API to provide
IO context information, but my feeling is that the first is the cleanest
approach.

What is your take on this?

