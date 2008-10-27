Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYJ0UK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYJ0UK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYJ0UKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:10:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45988 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753566AbYJ0UKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:10:04 -0400
Date: Mon, 27 Oct 2008 16:10:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Luciano Rocha <luciano@eurotux.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
In-Reply-To: <20081027165306.GA3875@bit.office.eurotux.com>
Message-ID: <Pine.LNX.4.44L0.0810271605190.2190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Luciano Rocha wrote:

> > The patches are here:
> > 
> > 	http://marc.info/?l=linux-scsi&m=122443015406309&w=2
> > 
> > They are based on 2.6.27, not 2.6.28-rc.
> 
> I've tested them (on 2.6.27.4), but I still get the bug. That email mentions:
> "Neither patch addresses the infinite-retry problem; I wanted
> to keep the issues separate."
> 
> So am I missing some other patch?
> 
> 2.6.28-rc2 is also buggy.

Okay, I tried the same sort of experiment in 2.6.27.4 and got the same
result as you did.  I was able to fix it by applying the 8bfa24727
commit mentioned earlier together with the patch below.

Now, I'm pretty sure this is not the ideal solution.  Fixing the block 
core would be better.  Still, it does indicate for sure that there's a 
real problem.

It's worth noting that the test added to scsi_requeue_command() 
succeeds every time, that is, req->retries is always 0.  Clearly more 
work is needed.

Alan Stern



Index: 2.6.27.4/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.27.4.orig/drivers/scsi/scsi_lib.c
+++ 2.6.27.4/drivers/scsi/scsi_lib.c
@@ -611,6 +611,11 @@ static void scsi_requeue_command(struct 
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	if (--req->retries <= 0) {
+		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		scsi_next_command(cmd);
+		return;
+	}
 	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, req);

