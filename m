Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYB0GAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYB0GAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYB0GAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:00:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:50185 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752714AbYB0GAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:00:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19lYw81O/BlT6v/BfwEL2qele8G2oCR0tdtaOgUwa
	Keo2L103Cxw5V4
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <1204079075.26640.8.camel@homer.simson.net>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
	 <1203839683.17463.9.camel@homer.simson.net>
	 <1204019283.8731.11.camel@homer.simson.net>
	 <1204033003.11828.22.camel@homer.simson.net>
	 <20080226150845.2196bc1a.akpm@linux-foundation.org>
	 <1204079075.26640.8.camel@homer.simson.net>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 07:00:10 +0100
Message-Id: <1204092010.9934.31.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 03:24 +0100, Mike Galbraith wrote:
> On Tue, 2008-02-26 at 15:08 -0800, Andrew Morton wrote:
 
> > So this change fixes a bug?  Can we have a recap of how it does this?
> 
> Yeah, it fixes the problem.  (wrt recap, if I could write it, it would
> be a changelog;)

Hm.  After rummaging around some more in both kernel and userland, I
think this patchlet is not only functional, but  (random accident)
technically correct.  What the heck, let's see if it flies...

snippet from userland:
/*
 * Return the residual DMA count for last command.
 * If this count is < 0, then a DMA overrun occured.
 */
EXPORT int
scg_getresid(scgp)
	SCSI	*scgp;
{
	return (scgp->scmd->resid);
}

This function is used all over the place in cdrecord to determine
transfer size.

(patchlet takes wing, and... goes splat?)
 
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
@@ -871,7 +871,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
unsigned int good_bytes)
 			scsi_end_bidi_request(cmd);
 			return;
 		}
-		req->data_len = scsi_get_resid(cmd);
+		req->data_len = req->raw_data_len = scsi_get_resid(cmd);
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet
*/


	-Mike

