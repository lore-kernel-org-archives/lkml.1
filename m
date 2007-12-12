Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbXLLUj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbXLLUj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXLLUjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:39:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbXLLUjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:39:10 -0500
Date: Wed, 12 Dec 2007 15:38:15 -0500 (EST)
Message-Id: <20071212.153815.39152138.k-ueda@ct.jp.nec.com>
To: zaitcev@redhat.com
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20071211154803.58beb681.zaitcev@redhat.com>
References: <20071211.174647.75757994.k-ueda@ct.jp.nec.com>
	<20071211154803.58beb681.zaitcev@redhat.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On Tue, 11 Dec 2007 15:48:03 -0800, Pete Zaitcev <zaitcev@redhat.com> wrote:
> >  	if (scsi_status == 0) {
> > -		uptodate = 1;
> > +		error = 0;
> >  	} else {
> > -		uptodate = 0;
> > +		error = -EIO;
> >  		rq->errors = scsi_status;
> >  	}
> > -	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
> > -	end_that_request_last(rq, uptodate);
> > +	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> > +		BUG();
> 
> Acked-by: Pete Zaitcev <zaitcev@redhat.com>
> 
> I follow the discussion, actually, and wanted to ask someone to look
> closer if it's appropriate to use __blk_end_request() here.
> My understanding was, blk_end_request() is the same thing, only
> takes the queue lock. But then, should I refactor ub so that it
> calls __blk_end_request if request function ends with an error
> and blk_end_request if the end-of-IO even is processed? If not,
> and the above is sufficient, why have blk_end_request at all?

The difference between blk_end_request() and __blk_end_request() is
whether the queue lock is held or not when end_that_request_last()
is called.
It's not relevant to the status of the request (error or not).

I'm using __blk_end_request() here and I think it's sufficient, because:
  o end_that_request_last() must be called with the queue lock held
  o ub_end_rq() calls end_that_request_last() without taking
    the queue lock in itself.
    So the queue lock must have been taken outside ub_end_rq().

But, if ub is calling end_that_request_last() without the queue lock,
it is a bug in the original code and we should use blk_end_request()
to fix that.

Does that answer satisfy you?

Thanks,
Kiyoshi Ueda
