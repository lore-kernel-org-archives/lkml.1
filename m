Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbYB0HH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbYB0HH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYB0HHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:07:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:35456 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754414AbYB0HHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:07:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19tHrtOjBFtgvR55IhYwWwRrlZUIp58TxqZjgYwM5
	GmDTcOyjmhXYHL
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <1204092010.9934.31.camel@homer.simson.net>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
	 <1203839683.17463.9.camel@homer.simson.net>
	 <1204019283.8731.11.camel@homer.simson.net>
	 <1204033003.11828.22.camel@homer.simson.net>
	 <20080226150845.2196bc1a.akpm@linux-foundation.org>
	 <1204079075.26640.8.camel@homer.simson.net>
	 <1204092010.9934.31.camel@homer.simson.net>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 08:07:04 +0100
Message-Id: <1204096025.1623.9.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 07:00 +0100, Mike Galbraith wrote:

> (patchlet takes wing, and... goes splat?)

Bugger, went splat... forgot preformat for patchlet insert.  <quiltuple
checks>
 
Fix CD burning regression introduced by
6b00769fe1502b4ad97bb327ef7ac971b208bfb5.  raw_data_len must be updated
to reflect residual data upon IO completion because it is used by
blk_complete_sghdr_rq() to set hdr->resid which eventually becomes
visible to userland.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..7a6f784 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -871,7 +871,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_end_bidi_request(cmd);
 			return;
 		}
-		req->data_len = scsi_get_resid(cmd);
+		req->data_len = req->raw_data_len = scsi_get_resid(cmd);
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */


