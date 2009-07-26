Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZGYO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZGYO0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZGYO0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:26:21 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60242 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZGYO0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=T1aZhFPaKchChF2BPbZpDmVOzxh7/+CWujBkq77EMF8EsKPea95j7/vu5e92nltMsk
         blGIfXuwMUEAwRryMRykb201Hmd9okmiv0Zpdm92LTMr2mYTcbR7isKR4sHG4US6qegu
         2+NzSsGPixmBw4HL7dzbeI8awj2h4Z2VWCtFM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: jgarzik@pobox.com
Subject: [PATCH] libata: add missing NULL pointer check to ata_eh_reset()
Date: Sun, 26 Jul 2009 16:21:01 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907261621.01893.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: add missing NULL pointer check to ata_eh_reset()

>From Dan's list:

drivers/ata/libata-eh.c +2403 ata_eh_reset(80) warning: variable derefenced before check 'slave'

Please note that this is _not_ a real bug at the moment since ata_eh_context
structure is embedded into ata_list structure and the code alwas checks for
'slave' before accessing 'sehc'.

Anyway lets add missing check and always have a valid 'sehc' pointer (which
makes code easier to understand and prevents introducing some possible bugs
in the future).

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/libata-eh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/libata-eh.c
===================================================================
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2329,7 +2329,7 @@ int ata_eh_reset(struct ata_link *link, 
 	struct ata_port *ap = link->ap;
 	struct ata_link *slave = ap->slave_link;
 	struct ata_eh_context *ehc = &link->eh_context;
-	struct ata_eh_context *sehc = &slave->eh_context;
+	struct ata_eh_context *sehc = slave ? &slave->eh_context : NULL;
 	unsigned int *classes = ehc->classes;
 	unsigned int lflags = link->flags;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
