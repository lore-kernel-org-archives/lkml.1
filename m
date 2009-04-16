Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZDPTjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZDPTjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbZDPTjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:39:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:35103 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZDPTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MYDB9Zmu9c6HyMnw7RsPW7OZZE+fdDPbcmTxHBl9uh56JHZPiWFeXTWfhKM1jmPQFh
         dg9YRxVd78aPLRO6Bib8N48XhLeJL2YF1ZOvW0gDMo4Nt97+GqVPZx9tqLs3uQXHIKE2
         bEqAOcWGVp3V9AFU19NG77Oj9Y7P1Tofg2ogg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: BUG: using rootfstype=ext4 causes oops
Date: Thu, 16 Apr 2009 21:22:30 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
References: <20090415205926.GA28246@sucs.org> <200904161802.21302.bzolnier@gmail.com> <20090416170556.GA24066@sucs.org>
In-Reply-To: <20090416170556.GA24066@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904162122.32452.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009 19:05:56 Andrew Price wrote:
> On Thu, Apr 16, 2009 at 06:02:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Freeing non-slab objects is bad.
> > 
> > Andrew, does this patch help?
> 
> Yes, that seems to fix it. I tested it with gfs2 and ext4 the usual way
> and I couldn't reproduce the panic.
> 
> Thanks Bartlomiej.

Great, I'll queue the following patch for the next round of IDE fixes.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix barriers support

Freeing non-slab objects is bad and results in an oops.  Fix it.

Reported-and-tested-by: Andrew Price <andy@andrewprice.me.uk>
Cc: Theodore Tso <tytso@mit.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
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
