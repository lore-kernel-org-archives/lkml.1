Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbYBZNg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbYBZNg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYBZNgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:36:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:56276 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752756AbYBZNgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:36:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/8RD9bu/f8GPLCHSdYoCglxgvGQ/vnvqAmQalE1J
	M24jMyx4xQqcIY
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <1204019283.8731.11.camel@homer.simson.net>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
	 <1203839683.17463.9.camel@homer.simson.net>
	 <1204019283.8731.11.camel@homer.simson.net>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 14:36:43 +0100
Message-Id: <1204033003.11828.22.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-26 at 10:48 +0100, Mike Galbraith wrote:
> Greetings,
> 
> I straced both a good and a bad kernel (good being .git with attached
> revert patch applied) and filtered/diffed/merged the output.  Scroll
> down to "HERE" to see the problem (resid).
> 
> I'm poking around, but not having much luck.

Seems the problem is data_len changes, but raw_data_len doesn't.  I've
not the foggiest IO-land clue, but k3b works again, so the below may
have some diagnostic value.

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

	-Mike

