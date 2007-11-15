Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbXKOCgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbXKOCgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 21:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXKOCfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 21:35:54 -0500
Received: from ozlabs.org ([203.10.76.45]:45122 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXKOCfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 21:35:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Attempt to get eject failures back to ioctl(CDROMEJECT)
Date: Thu, 15 Nov 2007 13:35:52 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200711141739.46960.rusty@rustcorp.com.au> <20071114123931.GF5064@kernel.dk>
In-Reply-To: <20071114123931.GF5064@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151335.53053.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 23:39:31 Jens Axboe wrote:
> On Wed, Nov 14 2007, Rusty Russell wrote:
> > Hi Jens,
> >
> >     As you asked for some time ago.  Of course, it turns out that the
> > eject command ignores the error anyway, but it's nice that it now errors.
> >
> >     Not entirely comfortable with this patch: there's a req->errors but
> > that seems to have some existing semantics I'm not sure of, so I simply
> > added a new way of flagging an error.
>
> It is a bit of a hack, but it's not really your fault. ->errors is
> somewhat messy and has different meaning depending on the request type.
> I'll add your patch and then do a sanitize on top of it, so that we can
> switch things over to a unified ->errno instead.

Thanks!

Oh, I also noticed this in scsi_tgt_lib:

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 9 Nov 2007 20:04:54 +1100
Subject: [PATCH] scsi_tgt_lib: BUG_ON() impossible condition.

If blk_rq_map_sg returns more than was allocated, it's a bug, and something's
already been overwritten.  BUG_ON() is probably the right thing here.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/scsi/scsi_tgt_lib.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a91761c..66266c8 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -367,14 +367,9 @@ static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
 	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
-		return 0;
-	}
-
-	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
-	scsi_free_sgtable(cmd);
-	return -EINVAL;
+	BUG_ON(count > cmd->use_sg);
+	cmd->use_sg = count;
+	return 0;
 }
 
 /* TODO: test this crap and replace bio_map_user with new interface maybe */
-- 
1.5.2.5




