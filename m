Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYAFQsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYAFQsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbYAFQsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:48:00 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53500 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754239AbYAFQr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:47:59 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Osterlund <petero2@telia.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <4780FF85.4020501@panasas.com>
References: <20080102162534.GA4041@elte.hu>
	 <1199292381.3258.32.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	 <1199316785.3258.85.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	 <m3ir27oe7f.fsf@telia.com>
	 <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
	 <4780FF85.4020501@panasas.com>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 10:47:51 -0600
Message-Id: <1199638071.5205.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 18:19 +0200, Boaz Harrosh wrote:
> On Sun, Jan 06 2008 at 5:43 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > 
> > This all still leaves the question unanswered why that commit 
> > 6f5391c283d7fdcf24bf40786ea79061919d1e1d changed any behaviour at all. 
> > Because the thing that Peter is describing has nothing to do with any 
> > low-level drivers what-so-ever.
> > 
> > 		Linus
> > 
> 
> James Matthew.
> I have a (very) wild guess at what maybe have changed with the cmnd->done
> patch:
> 
> Do you remember the effective loop in scsi_lib:scsi_end_request() where
> if bufflen was smaller then original request size, do to truncation
> of bufflen by ULD, then the remaining of the request is re-queued again
> as a new scsi-command. Well I think that the old system would call
> cmnd->done for every iteration, and the new system, since the done is
> called by the block-Q, does not see the resubmit of the new command.

Actually, this is cmnd->done, not req->done we're removing.
cmnd->done() isn't seen by the block layer; all its uses are in the SCSI
mid-layer.

> I have not followed all code path of the matter, but I know that sr does
> alters bufflen in some cases. 
> All this is not a bug in itself, but it is a change in behavior that might 
> cause the current sr hack to fail.

It's a good thought.  You're right, the old code calls done for every
iteration.  However, it calls it in scsi_finish_completion.  The new
code will actually call drv->done() in that same spot for every
iteration as well.

The requeue is done via scsi_requeue_request which calls
blk_requeue_request, which resets the START flag and sends the command
right back through the system (including the prep function because
scsi_requeue_request unpreps the command), so even with the new code
we'll go back through all the same done paths.

James


