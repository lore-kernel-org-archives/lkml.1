Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYJBPEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYJBPEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYJBPEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:04:06 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41586 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085AbYJBPEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:04:05 -0400
Subject: Re: [PATCH] BUG: nr_phys_segments cannot be less than
	nr_hw_segments
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200810021959.33616.knikanth@suse.de>
References: <200810021959.33616.knikanth@suse.de>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 10:03:33 -0500
Message-Id: <1222959814.3222.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 19:59 +0530, Nikanth Karthikesan wrote:
> This is a follow-up to my earlier mail http://lkml.org/lkml/2008/9/23/294 
> ([PATCH] BUG: ll_merge_requests_fn() updates req->nr_phys_segments wrongly)
> 
> It is possible for the merging code to create lesser no of phys segments than 
> hw segments, but every hw segment needs atleast one new phys segment. This 
> triggers the BUG() on scsi_init_sgtable() as blk_rq_map_sg() returns more no 
> of segments than rq->nr_phys_segments
> 
> The following blktrace shows a sequence of bio's to trigger such condition on 
> my machine with max_sectors_kb=512 & max_hw_sectors_kb=32767.

Um, don't you mean this the other way around?  I can see this problem
occurring if the block layer gets tricked into doing a physical merge
where sector limits forbid a virtual merge.

The bug would appear to be that we sometimes only look at q->max_sectors
when deciding on mergability.  Either we have to insist on max_sectors
<= hw_max_sectors, or we have to start using min(q->max_sectors,
q->max_hw_sectors) for this.

James


