Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYJXHOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYJXHOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYJXHOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:14:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45724 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYJXHO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:14:29 -0400
Date: Fri, 24 Oct 2008 09:13:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: tj@kernel.org, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       lethal@linux-sh.org
Subject: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
Message-ID: <20081024071329.GO22217@kernel.dk>
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com> <20081024070955.GN22217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024070955.GN22217@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24 2008, Jens Axboe wrote:
> On Fri, Oct 24 2008, Alexander Beregalov wrote:
> > Hi
> > 
> > commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e
> > Author: Jens Axboe <jens.axboe@oracle.com>
> > Date:   Wed Oct 22 09:34:49 2008 +0200
> > 
> >     libata: switch to using block layer tagging support
> > 
> > 
> > This kernel can not read even 0 sector on disk with rootfs. It
> > initialized disk, but cant read it at all.
> >  CMD646 on Sparc
> > 
> > Rverting helped.
> 
> Doh, how annoying! What driver does that controller use? PATA doesn't
> even use NCQ, so it's a bit of an oddity that it makes a difference at
> all.
> 
> Can you provide the boot messages?

Darn, this smells like a train wreck. I'm assuming this fixes it?

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d5b9b72..461ef5e 100644
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
Jens Axboe

