Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYADVPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYADVPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYADVNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:13:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYADVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gt0qLEATMCMmem1gSa1mTWnUHLtPDEPQVg/nuF1qM06FgzoWhEL7CKDI4ttsO/iIPxfKH/+k2AkjM4qxxa8EHcUC4S+p2TYW+VQ2RKLPTYNWQXTHD7xjglqq+YuOjN+3SAz+WkqKaC8+lQDW+FKPLLAcodgHJ2Hkqd71ZHwXWG4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:25:08 +0100
Message-Id: <20080104212508.6978.62680.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/15] ide: remove needless zeroing of hwgroup fields from init_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kmalloc_node() is called with __GFP_ZERO flag there is no need to
explicitly zero hwgroup fields.

While at it:

* Use 'hwif' instead of 'hwif->drives[0].hwif' for kmalloc_node() call.

* Fix whitespace damage.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-27 bytes
 drivers/ide/ide-probe.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -998,19 +998,14 @@ static int init_irq (ide_hwif_t *hwif)
 		hwgroup->hwif->next = hwif;
 		spin_unlock_irq(&ide_lock);
 	} else {
-		hwgroup = kmalloc_node(sizeof(ide_hwgroup_t),
-					GFP_KERNEL | __GFP_ZERO,
-					hwif_to_node(hwif->drives[0].hwif));
-		if (!hwgroup)
-	       		goto out_up;
+		hwgroup = kmalloc_node(sizeof(*hwgroup), GFP_KERNEL|__GFP_ZERO,
+				       hwif_to_node(hwif));
+		if (hwgroup == NULL)
+			goto out_up;
 
 		hwif->hwgroup = hwgroup;
+		hwgroup->hwif = hwif->next = hwif;
 
-		hwgroup->hwif     = hwif->next = hwif;
-		hwgroup->rq       = NULL;
-		hwgroup->handler  = NULL;
-		hwgroup->drive    = NULL;
-		hwgroup->busy     = 0;
 		init_timer(&hwgroup->timer);
 		hwgroup->timer.function = &ide_timer_expiry;
 		hwgroup->timer.data = (unsigned long) hwgroup;
