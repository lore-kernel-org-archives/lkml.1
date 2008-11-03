Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYKCTqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYKCTqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYKCTqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:46:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53192 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751016AbYKCTqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:46:39 -0500
Date: Mon, 3 Nov 2008 14:46:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Luciano Rocha <luciano@eurotux.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
In-Reply-To: <20081103155254.GA3368@bit.office.eurotux.com>
Message-ID: <Pine.LNX.4.44L0.0811031444130.2194-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008, Luciano Rocha wrote:

> On Tue, Oct 28, 2008 at 01:38:11PM -0400, Alan Stern wrote:
> > > Do you wish me to test anything else?
> > 
> > Yes.  Please post a usbmon trace for each of the last two tests.  That 
> > is, with the unusual_devs update only, and with the unusual_devs update 
> > plus the invoke_transport update and the scsi_requeue_command update.
> 
> I've updated the bugzilla entry with traces for some combinations of the
> discussed patches:
> http://bugzilla.kernel.org/show_bug.cgi?id=11843

Okay, thanks.  I see the problem.  This whole area is a mess, and it's 
going to be different in 2.6.28.  But for now...

Please rerun the A+B and A+B+C tests, but this time using the B' patch
below instead of B.

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
@@ -690,6 +695,8 @@ static struct scsi_cmnd *scsi_end_reques
 				 * leftovers in the front of the
 				 * queue, and goose the queue again.
 				 */
+				if (bytes > 0)		/* Made progress */
+					++req->retries;
 				scsi_requeue_command(q, cmd);
 				cmd = NULL;
 			}

