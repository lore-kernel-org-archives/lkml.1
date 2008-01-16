Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYAPXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYAPXWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYAPXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbYAPXPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XsA8P9KWsSV5RDf0vUtinlFiQKRwpGiwwvSb3dxzXjBmPgfO7TYiq6Qu1Mc9nWc+P5cxUkyYX9mvv0qtaT7UMp6J/OKLFvcq0kfTl3YICZc0F28IfFiXyUh9q9qdayq9K9aaPUwucEZhT7DmlNWHqN13/sS3ZPJV0C1tHj+KYIc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:28:32 +0100
Message-Id: <20080116232832.9166.29628.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 21/22] ide: move hwif->present check out from ide_proc_register_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move hwif->present check out from ide_proc_register_port() to
ide_device_add_all().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    9 +++++++--
 drivers/ide/ide-proc.c  |    3 ---
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1448,8 +1448,13 @@ int ide_device_add_all(u8 idx[MAX_HWIFS]
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		if (idx[i] != 0xff)
-			ide_proc_register_port(&ide_hwifs[idx[i]]);
+		if (idx[i] == 0xff)
+			continue;
+
+		hwif = &ide_hwifs[idx[i]];
+
+		if (hwif->present)
+			ide_proc_register_port(hwif);
 	}
 
 	return rc;
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -793,9 +793,6 @@ static ide_proc_entry_t hwif_entries[] =
 
 void ide_proc_register_port(ide_hwif_t *hwif)
 {
-	if (!hwif->present)
-		return;
-
 	if (!hwif->proc) {
 		hwif->proc = proc_mkdir(hwif->name, proc_ide_root);
 
