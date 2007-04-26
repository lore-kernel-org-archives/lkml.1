Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXDZGfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXDZGfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXDZGfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:35:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11288 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbXDZGfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:35:19 -0400
Date: Thu, 26 Apr 2007 08:33:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: William Heimbigner <icxcnika@mar.tar.cc>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, linux-ide@vger.kernel.org
Subject: Re: BUG: Null pointer dereference in fs/open.c
Message-ID: <20070426063356.GA3640@kernel.dk>
References: <Pine.LNX.4.64.0704231356480.25153@server.thyself> <Pine.LNX.4.64.0704231633210.25153@server.thyself> <Pine.LNX.4.64.0704240347470.25153@server.thyself> <20070423215810.5a24ed9a.akpm@linux-foundation.org> <Pine.LNX.4.64.0704240507110.25153@server.thyself> <20070423221726.ccfa982c.akpm@linux-foundation.org> <Pine.LNX.4.64.0704240527030.25153@server.thyself> <20070425004816.bd0c240a.akpm@linux-foundation.org> <Pine.LNX.4.64.0704251701290.25153@server.thyself> <20070425160534.00c3a3d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425160534.00c3a3d4.akpm@linux-foundation.org>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Andrew Morton wrote:
> > # pktsetup 2 /dev/sr0
> > [19982.934793] drivers/scsi/scsi_lib.c:838: setting error to 134217730
> > [19982.941070]  [<c010521a>] show_trace_log_lvl+0x1a/0x30
> > [19982.946256]  [<c0105952>] show_trace+0x12/0x20
> > [19982.950744]  [<c0105a46>] dump_stack+0x16/0x20
> > [19982.955232]  [<c034543a>] scsi_io_completion+0x28a/0x3a0
> > [19982.960586]  [<c034556b>] scsi_blk_pc_done+0x1b/0x30
> > [19982.965594]  [<c0340d0c>] scsi_finish_command+0x4c/0x60
> > [19982.970861]  [<c0345c07>] scsi_softirq_done+0x77/0xe0
> > [19982.975955]  [<c0257f8b>] blk_done_softirq+0x6b/0x80
> > [19982.980962]  [<c01243a2>] __do_softirq+0x62/0xc0
> > [19982.985624]  [<c0124455>] do_softirq+0x55/0x60
> > [19982.990112]  [<c0124be5>] ksoftirqd+0x65/0x100
> > [19982.994599]  [<c0132963>] kthread+0xa3/0xd0
> > [19982.998827]  [<c0104e17>] kernel_thread_helper+0x7/0x10
> > [19983.004095]  =======================
> > [19983.009065] cdrom: This disc doesn't have any tracks I recognize!
> 
> So what has happened here is that this code, in ide-cd.c's
> cdrom_decode_status() is now triggering:
> 
> 	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
> 		/* All other functions, except for READ. */
> 		unsigned long flags;
> 
> 		/*
> 		 * if we have an error, pass back CHECK_CONDITION as the
> 		 * scsi status byte
> 		 */
> 		if (blk_pc_request(rq) && !rq->errors)
> 			rq->errors = SAM_STAT_CHECK_CONDITION;
> 
> 
> I suspect this is a bug introduced by
> 406c9b605cbc45151c03ac9a3f95e9acf050808c (in which case it'll be the third
> bug so far).
> 
> Perhaps the IDE driver was previously not considering these requests to be
> of type blk_pc_request(), and after
> 406c9b605cbc45151c03ac9a3f95e9acf050808c it _is_ treating them as
> blk_pc_request() and is incorrectly reporting an error.  Or something like
> that.

But it IS a block pc request. We've been setting the sam stats on
->errors for block pc request for a long time.

> Guys: help!

I'm not sure what your question is, if someone can some up what the what
goes wrong and what the expected result is, I can try and help.

-- 
Jens Axboe

