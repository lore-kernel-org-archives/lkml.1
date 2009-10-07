Return-Path: <linux-kernel-owner+w=401wt.eu-S933850AbZJGAtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850AbZJGAtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbZJGAtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:49:06 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63527 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505AbZJGAtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Tr47hZtksh6ZMtv0smJkd1CjQL8aO3JJ4vgfVh9oODcGNACe5pPiz6mKaJIDLDQbkG
         N1ZqjXZ6pXDdU9rzr+X3u4r9rwpz99hfcrmBA84n+d/anombTg3vMYXiQ7LjacMheQeu
         dXhdYAnj1St3ZeHRp/O4YIE7leRDZD40Jvw2Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] two ide fixes for -rc4
Date: Wed, 7 Oct 2009 02:46:05 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>, Joao Ramos <joao.ramos@inov.pt>,
       David Fries <david@fries.net>, d.stussy@yahoo.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200910070027.30377.bzolnier@gmail.com> <alpine.LFD.2.01.0910061534040.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910061534040.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910070246.05283.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009 00:35:24 Linus Torvalds wrote:
> 
> David, can you test these on the sis5513 system that had problems with the 
> original pio0 mode setting?
> 
> 	Thanks,
> 		Linus
> 
> On Wed, 7 Oct 2009, Bartlomiej Zolnierkiewicz wrote:
> > 
> > patch #1 fixes old bug in sis5513 (uncovered by 2.6.30 device probing
> > changes but it could be also triggered in earlier kernels on warm-plug
> > operation)

patch #1 contained a stupid mistake preventing it from working (thanks to
David Fries for letting me know quickly), I guess that is what one gets for
the late night hacking..

The corrected version below, David please try it instead:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH take 2] sis5513: fix PIO setup for ATAPI devices

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
 drivers/ide/sis5513.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

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
@@ -281,11 +281,13 @@ static void config_drive_art_rwp(ide_dri
 
 	pci_read_config_byte(dev, 0x4b, &reg4bh);
 
+	rw_prefetch = reg4bh & ~(0x11 << drive->dn);
+
 	if (drive->media == ide_disk)
-		rw_prefetch = 0x11 << drive->dn;
+		rw_prefetch |= 0x11 << drive->dn;
 
-	if ((reg4bh & (0x11 << drive->dn)) != rw_prefetch)
-		pci_write_config_byte(dev, 0x4b, reg4bh|rw_prefetch);
+	if (reg4bh != rw_prefetch)
+		pci_write_config_byte(dev, 0x4b, rw_prefetch);
 }
 
 static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
