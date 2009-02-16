Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZBPANf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZBPANf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZBPAML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:11 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51372 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbZBPAMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SpN7ZiGDh189oMljollX0hfUn01vGpZd4TcIE53nnze3+3AAaZTxL5hgz5BSZLCCx6
         nR7yEVHN3WIvPRWqUFhVsLoadIGkQijfNM3Eu1Vz+556vJ/qqf0B+G/uYt6h7GHZn/cc
         tS7mBKawpISbfuOuzop5zgGjJqbzIrQW/elhU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:13:36 +0100
Message-Id: <20090216001336.27491.67295.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/20] ide-cd: use ide_end_rq() also for failed non-fs requests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: use ide_end_rq() also for failed non-fs requests

Use ide_end_rq() also for failed non-fs requests on completion
of REQUEST SENSE requests + use blk_rq_bytes() while at it.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -260,18 +260,10 @@ static void cdrom_end_request(ide_drive_
 				failed->sense_len = rq->sense_len;
 			}
 			cdrom_analyze_sense_data(drive, failed, sense);
-			/*
-			 * now end the failed request
-			 */
-			if (blk_fs_request(failed)) {
-				if (ide_end_rq(drive, failed, -EIO,
-						failed->hard_nr_sectors << 9))
-					BUG();
-			} else {
-				if (blk_end_request(failed, -EIO,
-						    failed->data_len))
-					BUG();
-			}
+
+			if (ide_end_rq(drive, failed, -EIO,
+				       blk_rq_bytes(failed)))
+				BUG();
 		} else
 			cdrom_analyze_sense_data(drive, NULL, sense);
 	}
