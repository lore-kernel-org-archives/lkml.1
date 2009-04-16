Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbZDPP7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbZDPP7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZDPP7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:59:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:1128 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZDPP7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=J3bx35NAjq+FAhHb5OiOxl83R4nbzoEpx141O+qCfECL/AfSqlDlUnVuHLjbxR7RIH
         3hXjgpRmHAuvfeXtFDVbhoDruiPVOliVn2z+nsQG4EON00O/SeaWwUYAFcWOdN7MigLK
         +RwpCeoWf8gD75vYRPmFLP7fUpPmgKpHj0PbQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: BUG: using rootfstype=ext4 causes oops
Date: Thu, 16 Apr 2009 18:02:21 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Andrew Price <andy@andrewprice.me.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
References: <20090415205926.GA28246@sucs.org> <20090416104758.GA433@sucs.org> <20090416145357.GM21586@mit.edu>
In-Reply-To: <20090416145357.GM21586@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904161802.21302.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009 16:53:57 Theodore Tso wrote:
> On Thu, Apr 16, 2009 at 11:47:58AM +0100, Andrew Price wrote:
> > On Thu, Apr 16, 2009 at 12:19:45AM -0400, Theodore Tso wrote:
> > > The stack traces are in the IDE interrupt
> > > handler, so it seems surprising that ext4 would trigger it but ext3
> > > would not.  Have you tried ext4 on any earlier kernel?
> > 
> > It happened with linux-2.6.git kernels earlier in the week when I
> > started trying rootfstype=ext4 but I haven't tried properly bisecting it
> > yet.
> > 
> > > The main difference I can think of is that ext4 enables barriers by
> > > default; maybe that's the case of the IDE breakage?  Can you try
> > > booting with the boot command option "rootfsflags=barrier=0" as well
> > > as "rootfstype=ext4", and see if that helps?
> > 
> > I added rootflags=barrier=0 ...
> > 
> > ... and it doesn't panic.
> > 
> > > If so, it's a bug in the IDE code in that it's not handling barriers
> > > correctly.
> > 
> > Bingo.

Freeing non-slab objects is bad.

Andrew, does this patch help?

---
 drivers/ide/ide-io.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -102,11 +102,14 @@ void ide_complete_cmd(ide_drive_t *drive
 			drive->dev_flags |= IDE_DFLAG_PARKED;
 	}
 
-	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
-		memcpy(rq->special, cmd, sizeof(*cmd));
+	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+		struct ide_cmd *orig_cmd = rq->special;
 
-	if (cmd->tf_flags & IDE_TFLAG_DYN)
-		kfree(cmd);
+		if (cmd->tf_flags & IDE_TFLAG_DYN)
+			kfree(orig_cmd);
+		else
+			memcpy(orig_cmd, cmd, sizeof(*cmd));
+	}
 }
 
 /* obsolete, blk_rq_bytes() should be used instead */

