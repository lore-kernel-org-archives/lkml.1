Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbZBSVtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbZBSVtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbZBSVtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:49:00 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33494 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757453AbZBSVs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:48:59 -0500
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org
In-Reply-To: <56979.43325.qm@web110612.mail.gq1.yahoo.com>
References: <56979.43325.qm@web110612.mail.gq1.yahoo.com>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 21:48:54 +0000
Message-Id: <1235080134.12500.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 13:11 -0800, Sitsofe Wheeler wrote:
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> >
> > Can you try this patch ... it was something I meant to get into 2.6.29
> > but forgot about.  The key problem that you seem to be hitting is that
> > the requeue evades the timeout check.  Moving the timeout check to block
> > should fix that.
> 
> Even by itself this patch works although the behaviour is now different
> to that of 2.6.28.  Whereas in 2.6.28 it would timeout very quickly
> (after about 1 or 2 seconds) it now times out after 30 seconds
> (initially I hadn't realised that it would be so much longer). The
> other difference is that the failure becomes cached - trying to reread
> the same area using dd instantly fails from now on without any more disk
> IO/kernel error messages until echo 1 > /proc/sys/vm/drop_caches is
> issued. Before it would always go straight to the disk for the unread
> section and the kernel spew would be repeated before the failure.

Well, the block patch is more of a catch all:  without it apparently the
scsi_io_completion() rewrite has several cases where it will apparently
loop forever.

Your specific behaviour change seems to be a bug in the way the rewrite
is handling ABORTED_COMMAND.  Could you try the patch below (with or
without the block patch, it shouldn't matter) and see if it gets you
back to 2.6.28 behaviour?

Thanks,

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c034841..4b13e36 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -850,12 +850,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				action = ACTION_FAIL;
 			break;
 		case ABORTED_COMMAND:
+			action = ACTION_FAIL;
 			if (sshdr.asc == 0x10) { /* DIF */
 				description = "Target Data Integrity Failure";
-				action = ACTION_FAIL;
 				error = -EILSEQ;
-			} else
-				action = ACTION_RETRY;
+			}
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming


