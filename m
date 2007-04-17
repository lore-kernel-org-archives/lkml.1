Return-Path: <linux-kernel-owner+w=401wt.eu-S1161289AbXDQUaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161289AbXDQUaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161334AbXDQUaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:30:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:1482 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161289AbXDQUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PEVmwC/NBbh2DnNxPX4cVizSqZGabgr9dXik2VClN7RqrqQgcVcZW67EkXlfSIjALUVKX7lPl9/NPHJFccRvNqakFOLPWHY2SqHfrKF7zqhDPSApncV+q+qEjnP5vO1gxbDdQo8wmwUvmum/fA1o1/ynd7UBNY58PpPlRgu4Z8o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Neil Brown <neilb@suse.de>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Date: Tue, 17 Apr 2007 22:39:50 +0200
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>, Brad Campbell <brad@wasp.net.au>,
       Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>
References: <4621FAF0.7000705@wasp.net.au> <4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown>
In-Reply-To: <17956.22235.574867.179016@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704172239.50519.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 17 April 2007, Neil Brown wrote:
> On Monday April 16, cebbert@redhat.com wrote:
> > 
> > cfq_dispatch_insert() was called with rq == 0. This one is getting really
> > annoying... and md is involved again (RAID0 this time.)
> 
> Yeah... weird.
> RAID0 is so light-weight and so different from RAID1 or RAID5 that I
> feel fairly safe concluding that the problem isn't in or near md.
> But that doesn't help you.
> 
> This really feels like a locking problem.
> 
> The problem occurs when ->next_rq is NULL, but ->sort_list.rb_node is
> not NULL.  That happens plenty of times in the code (particularly as
> the first request is inserted) but always under ->queue_lock so it
> should never be visible to cfq_dispatch_insert..
> 
> Except that drivers/scsi/ide-scsi.c:idescsi_eh_reset calls
> elv_next_request which could ultimately call __cfq_dispatch_requests
> without taking ->queue_lock (that I can see).  But you probably aren't
> using ide-scsi (does anyone?).

ide-scsi is holding ide_lock while calling elv_next_request()
(for ide ide_lock == ->queue_lock)

Also from the original report:

On Sunday 15 April 2007, Brad Campbell wrote:
> 
> The box is booted with PXE and runs an nfsroot. It's Debian 3.1. It has 2 SIL 3112 controllers in it 
> with 4 WD 200GB ATA drives all on PATA->SATA bridges.

and you can even see libata functions in the OOPS...

Bart
