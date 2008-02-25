Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYBYXTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYBYXTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbYBYXTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:19:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47067 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYBYXTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:19:20 -0500
Message-ID: <47C34CEA.7060307@pobox.com>
Date: Mon, 25 Feb 2008 18:19:06 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Bj=F6rn_S?= =?ISO-8859-1?Q?teinbrink?= 
	<B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080225195924.GA23176@atjola.homenet> <47C32043.6090809@pobox.com> <20080225124054.9b69e9f0.akpm@linux-foundation.org> <alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de>
Content-Type: multipart/mixed;
 boundary="------------020900040208060002000600"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020900040208060002000600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Welcome to test this... (attached, not tested nor even compiled, really)

	Jeff




--------------020900040208060002000600
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0562b0a..7b1f1ee 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1694,12 +1694,17 @@ void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 	u8 *rbuf;
 	unsigned int buflen, rc;
 	struct scsi_cmnd *cmd = args->cmd;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	buflen = ata_scsi_rbuf_get(cmd, &rbuf);
 	memset(rbuf, 0, buflen);
 	rc = actor(args, rbuf, buflen);
 	ata_scsi_rbuf_put(cmd, rbuf);
 
+	local_irq_restore(flags);
+
 	if (rc == 0)
 		cmd->result = SAM_STAT_GOOD;
 	args->done(cmd);
@@ -2473,6 +2478,9 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		if ((scsicmd[0] == INQUIRY) && ((scsicmd[1] & 0x03) == 0)) {
 			u8 *buf = NULL;
 			unsigned int buflen;
+			unsigned long flags;
+
+			local_irq_save(flags);
 
 			buflen = ata_scsi_rbuf_get(cmd, &buf);
 
@@ -2490,6 +2498,8 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 			}
 
 			ata_scsi_rbuf_put(cmd, buf);
+
+			local_irq_restore(flags);
 		}
 
 		cmd->result = SAM_STAT_GOOD;

--------------020900040208060002000600--
