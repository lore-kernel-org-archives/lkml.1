Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYADVP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYADVP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYADVNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:13:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbYADVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kfGuh/IraMZ9O3iL7ezTTlov3WCxQz2vnsoXC4GNjdwPBThhfG+IRvtdDKu8airvQE4SaWxO4o/2e9idI1Q9Z1kFWiocl+FTfxlyEk5PJQS+0xGtbAi0YvrJFkfEae1EBPkX9B19w+LlFShav6wv8zAHy3iSACGjPiWGrwDhxGk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:25:24 +0100
Message-Id: <20080104212524.6978.64718.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/15] ide: I/O resources are released too early in ide_unregister()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release I/O resources after releasing DMA.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -529,13 +529,6 @@ void ide_unregister(unsigned int index)
 
 	spin_lock_irq(&ide_lock);
 	/*
-	 * Note that we only release the standard ports,
-	 * and do not even try to handle any extra ports
-	 * allocated for weird IDE interface chipsets.
-	 */
-	ide_hwif_release_regions(hwif);
-
-	/*
 	 * Remove us from the hwgroup, and free
 	 * the hwgroup if we were the only member
 	 */
@@ -589,6 +582,13 @@ void ide_unregister(unsigned int index)
 		hwif->extra_ports = 0;
 	}
 
+	/*
+	 * Note that we only release the standard ports,
+	 * and do not even try to handle any extra ports
+	 * allocated for weird IDE interface chipsets.
+	 */
+	ide_hwif_release_regions(hwif);
+
 	/* copy original settings */
 	tmp_hwif = *hwif;
 
