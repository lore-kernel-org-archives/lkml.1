Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYJXIt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYJXIt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYJXItU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:49:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56074 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYJXItT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:49:19 -0400
Date: Fri, 24 Oct 2008 10:48:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, tj@kernel.org,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
Message-ID: <20081024084818.GB22217@kernel.dk>
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com> <20081024070955.GN22217@kernel.dk> <20081024071329.GO22217@kernel.dk> <20081024071608.GA3879@linux-sh.org> <20081024072428.GP22217@kernel.dk> <873aimv0v8.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873aimv0v8.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24 2008, Elias Oltmanns wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Fri, 24 Oct 2008 09:22:42 +0200
> > Subject: [PATCH] libata: fix bug with non-ncq devices
> >
> > The recent commit 201f1b98822078c808b5e2d379a6ddbfc0a06ee1 to enable
> 
> Wouldn't that be commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e?

Yes that is correct, the other commit is actually a private one in my
tree for other libata changes. Updated patch below, thanks for checking!

>From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 24 Oct 2008 09:22:42 +0200
Subject: [PATCH] libata: fix bug with non-ncq devices

The recent commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e to enable
support for block layer tagging in libata was broken for non-NCQ
devices. The block layer initializes the tag field to -1 to detect
invalid uses of a tag, and if the libata devices does NOT support
NCQ, we just used that field to index the internal command list.
So we need to check for -1 first and only use the tag field if
it's valid.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/libata-scsi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d5b9b72..4b95c43 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -708,7 +708,11 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new_init(dev, cmd->request->tag);
+	if (cmd->request->tag != -1)
+		qc = ata_qc_new_init(dev, cmd->request->tag);
+	else
+		qc = ata_qc_new_init(dev, 0);
+
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = done;
-- 
1.6.0.2.588.g3102


-- 
Jens Axboe

