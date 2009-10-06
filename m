Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbZJFW21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbZJFW21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbZJFW20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:28:26 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:50524 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601AbZJFW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=FOLVw24P9W+sMRakYaXXP2wXdDi/vVrKiE26gS1mhuOWkT2n8sixSPBQkOxXyoQS6o
         94Fv5qmMOSIe7+9g1ITJ6asi9NFy/2XRLMRSJcD0PZlkDqy4w8HfHS+4SMt8SM5ZqhX2
         EXWdVhhaRQTxLEzqqvnHzsiPy/eEf8Umma5kI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] sis5513: fix PIO setup for ATAPI devices
Date: Wed, 7 Oct 2009 00:27:35 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>, Joao Ramos <joao.ramos@inov.pt>,
       David Fries <david@fries.net>, d.stussy@yahoo.com, stable@kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200910070027.35193.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sis5513: fix PIO setup for ATAPI devices

Clear prefetch setting before potentially (re-)enabling it in
config_drive_art_rwp() so the transition of the device type on
the port from ATA to ATAPI (i.e. during warm-plug operation)
is handled correctly.

This is a really old bug (it probably goes back to very early
days of the driver) but it was only affecting warm-plug operation
until the recent "ide: try to use PIO Mode 0 during probe if
possible" change (commit 6029336426a2b43e4bc6f4a84be8789a047d139e).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Joao Ramos <joao.ramos@inov.pt>
Cc: David Fries <david@fries.net>
Cc: d.stussy@yahoo.com
Cc: stable@kernel.org
---
Oh, if you're curious pata_sis doesn't have the bug but the fix
was never backported for some unknown reasons..

 drivers/ide/sis5513.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -2,7 +2,7 @@
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
  * Copyright (C) 2003		Vojtech Pavlik <vojtech@suse.cz>
- * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2009	Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public License
  *
@@ -281,6 +281,8 @@ static void config_drive_art_rwp(ide_dri
 
 	pci_read_config_byte(dev, 0x4b, &reg4bh);
 
+	reg4bh &= ~(0x11 << drive->dn);
+
 	if (drive->media == ide_disk)
 		rw_prefetch = 0x11 << drive->dn;
 
