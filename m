Return-Path: <linux-kernel-owner+w=401wt.eu-S933677AbXLMV7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbXLMV7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbXLMV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:58:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXLMV64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:58:56 -0500
Date: Thu, 13 Dec 2007 13:59:16 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, zaitcev@redhat.com
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
Message-Id: <20071213135916.27ebe3f9.zaitcev@redhat.com>
In-Reply-To: <20071212.153815.39152138.k-ueda@ct.jp.nec.com>
References: <20071211.174647.75757994.k-ueda@ct.jp.nec.com>
	<20071211154803.58beb681.zaitcev@redhat.com>
	<20071212.153815.39152138.k-ueda@ct.jp.nec.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 15:38:15 -0500 (EST), Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> On Tue, 11 Dec 2007 15:48:03 -0800, Pete Zaitcev <zaitcev@redhat.com> wrote:

> > > -	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
> > > -	end_that_request_last(rq, uptodate);
> > > +	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> > > +		BUG();

> > My understanding was, blk_end_request() is the same thing, only
> > takes the queue lock. But then, should I refactor ub so that it
> > calls __blk_end_request if request function ends with an error
> > and blk_end_request if the end-of-IO even is processed?

> I'm using __blk_end_request() here and I think it's sufficient, because:
>   o end_that_request_last() must be called with the queue lock held
>   o ub_end_rq() calls end_that_request_last() without taking
>     the queue lock in itself.
>     So the queue lock must have been taken outside ub_end_rq().

> But, if ub is calling end_that_request_last() without the queue lock,
> it is a bug in the original code and we should use blk_end_request()
> to fix that.

So, I have to rewrite ub to split the paths after all, right?
Let's do this then: I'll wait until your patch gets to Linus and
then update it with the split. The reason is, I need the whole
enchilada applied and I don't want to bother tracking iterations
and all the little segments (of which you already have 30).
Until then, ub will have a race by using your original small patch.

Best wishes,
-- Pete
