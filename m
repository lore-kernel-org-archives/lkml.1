Return-Path: <linux-kernel-owner+w=401wt.eu-S934334AbXLNRFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334AbXLNRFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXLNRFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:05:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXLNRFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:05:41 -0500
Date: Fri, 14 Dec 2007 12:04:54 -0500 (EST)
Message-Id: <20071214.120454.39153297.k-ueda@ct.jp.nec.com>
To: zaitcev@redhat.com
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20071213135916.27ebe3f9.zaitcev@redhat.com>
References: <20071211154803.58beb681.zaitcev@redhat.com>
	<20071212.153815.39152138.k-ueda@ct.jp.nec.com>
	<20071213135916.27ebe3f9.zaitcev@redhat.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On Thu, 13 Dec 2007 13:59:16 -0800, Pete Zaitcev <zaitcev@redhat.com> wrote:
> > > > -	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
> > > > -	end_that_request_last(rq, uptodate);
> > > > +	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> > > > +		BUG();
> > >
> > > My understanding was, blk_end_request() is the same thing, only
> > > takes the queue lock. But then, should I refactor ub so that it
> > > calls __blk_end_request if request function ends with an error
> > > and blk_end_request if the end-of-IO even is processed?
> >
> > I'm using __blk_end_request() here and I think it's sufficient, because:
> >   o end_that_request_last() must be called with the queue lock held
> >   o ub_end_rq() calls end_that_request_last() without taking
> >     the queue lock in itself.
> >     So the queue lock must have been taken outside ub_end_rq().
> >
> > But, if ub is calling end_that_request_last() without the queue lock,
> > it is a bug in the original code and we should use blk_end_request()
> > to fix that.
> 
> So, I have to rewrite ub to split the paths after all, right?
> Let's do this then: I'll wait until your patch gets to Linus and
> then update it with the split. The reason is, I need the whole
> enchilada applied and I don't want to bother tracking iterations
> and all the little segments (of which you already have 30).
> Until then, ub will have a race by using your original small patch.

No.
Are you doubting that the current ub code has the problem, aren't you?
My patch shouldn't introduce a NEW problem to ub.

I have investigated all code paths which call ub_end_rq() in ub.c,
and confirmed that ub_end_rq() is always called with the queue lock
held.  (sc->lock is registered as a queue lock.)

So there is no such race in the current ub code.
You don't need to rewrite ub.

Thanks,
Kiyoshi Ueda
