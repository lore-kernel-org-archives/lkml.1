Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYKFAB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYKFAB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYKFABs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:01:48 -0500
Received: from sh.osrg.net ([192.16.179.4]:34861 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYKFABr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:01:47 -0500
Date: Thu, 6 Nov 2008 09:01:09 +0900
To: jens.axboe@oracle.com
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with the block-layer timeouts
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081103085247.GO31673@kernel.dk>
References: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org>
	<20081103085247.GO31673@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081106090117U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 09:52:48 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> > In blk_del_timer(), there's no reason to test q->rq_timed_out_fn.  If 
> > the method pointer is NULL then req->deadline would be 0 anyway.  In 
> > addition, req->deadline should be set to 0 and the end of the routine, 
> > just in case req gets requeued.
> > 
> > In blk_add_timer(), the line
> > 
> > 	expiry = round_jiffies(req->deadline);
> > 
> > is not optimal.  round_jiffies() will sometimes round a value _down_ to
> > the nearest second.  But blk_rq_timed_out_timer() tests whether
> > req->deadline is in the past -- and if the deadline was rounded down
> > then this won't be true the first time through.  You wind up getting an
> > unnecessary timer interrupt.  Instead there should be a
> > round_jiffies_up() utility routine, and it should be used in both
> > blk_add_timer() and blk_rq_timed_out_timer().
> 
> Very good point, we do indeed want a round_jiffies_up() for this!

Just out of curiosity, why do we need to use round_jiffies here? We
didn't do that for SCSI, right?
