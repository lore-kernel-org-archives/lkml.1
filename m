Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbZJFW2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbZJFW2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933468AbZJFW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:28:09 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61350 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbZJFW2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=i4Q5SNZs3zs/ySRmdT4dp6t3rZIneuKypRQF24TGA7g3m7dtUmzFf9EAVflN+H6Eyp
         ksM5x4m82l7GETlYiLJR9KgFxnTDV00yS95uovJ+1p+hi8J5EQEhKcbbtonGP8aa3Pk4
         hA3qH57x6KlBcoEwTp6DCggXy1C4SC5nLYWkc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] Revert "Revert "ide: try to use PIO Mode 0 during probe if possible""
Date: Wed, 7 Oct 2009 00:27:45 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>, Joao Ramos <joao.ramos@inov.pt>,
       David Fries <david@fries.net>, d.stussy@yahoo.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200910070027.45678.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Revert "Revert "ide: try to use PIO Mode 0 during probe if possible""

This reverts commit 24df31acaff8465d797f0006437b45ad0f2a5cb1.

The root cause of reported system hangs was (now fixed) sis5513 bug
and not "ide: try to use PIO Mode 0 during probe if possible" change
(commit 6029336426a2b43e4bc6f4a84be8789a047d139e) so the revert was
incorrect (it simply replaced one regression with the other one).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Joao Ramos <joao.ramos@inov.pt>
Cc: David Fries <david@fries.net>
Cc: d.stussy@yahoo.com
---
 drivers/ide/ide-probe.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 4d76ba4..63c53d6 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1046,6 +1046,15 @@ static void ide_port_init_devices(ide_hwif_t *hwif)
 		if (port_ops && port_ops->init_dev)
 			port_ops->init_dev(drive);
 	}
+
+	ide_port_for_each_dev(i, drive, hwif) {
+		/*
+		 * default to PIO Mode 0 before we figure out
+		 * the most suited mode for the attached device
+		 */
+		if (port_ops && port_ops->set_pio_mode)
+			port_ops->set_pio_mode(drive, 0);
+	}
 }
 
 static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
-- 
1.6.5.rc2

