Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbYDPW34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbYDPW34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759476AbYDPW2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:28:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:8502 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYDPW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hDh8QUa95UP6l3biND2FUHgMT5Jxtt1hJEqn552ZbFjUHZrqcfoZVQAHPt9AhzGu/fmHCYJU4ZZ5marEOETUBOle2KxDoR8A+nc2/5CBjYObkJRw8+Vm+HiqmKN7qQVkwz/eUXKQo1Tf245vFntkq9zCR1dFGbpCE+oTrSzb7nI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-h8300: add ->{in,out}put_data methods (take 2)
Date: Thu, 17 Apr 2008 00:17:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170017.48201.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2:

* Update ->{in,out}_data methods to take 'struct request *rq' argument.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch for the one in the IDE tree

 drivers/ide/h8300/ide-h8300.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -56,6 +56,18 @@ static void mm_insw(unsigned long addr, 
 		*bp = bswap(*(volatile u16 *)addr);
 }
 
+static void h8300_input_data(ide_drive_t *drive, struct request *rq,
+			     void *buf, unsigned int len)
+{
+	mm_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void h8300_output_data(ide_drive_t *drive, struct request *rq,
+			      void *buf, unsigned int len)
+{
+	mm_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
 #define H8300_IDE_GAP (2)
 
 static inline void hw_setup(hw_regs_t *hw)
@@ -74,6 +86,9 @@ static inline void hwif_setup(ide_hwif_t
 {
 	default_hwif_iops(hwif);
 
+	hwif->input_data  = h8300_input_data;
+	hwif->output_data = h8300_output_data;
+
 	hwif->OUTW  = mm_outw;
 	hwif->OUTSW = mm_outsw;
 	hwif->INW   = mm_inw;
